import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/db/app_database.dart';
import '../models/word_status.dart';
import '../supabase/supabase_providers.dart';

/// The cloud `profiles` row, as fetched from Supabase.
class RemoteProfile {
  const RemoteProfile({
    required this.nickname,
    required this.avatarId,
    required this.languagePair,
    required this.memorizedCount,
    required this.currentLevel,
    required this.streak,
  });

  factory RemoteProfile.fromJson(Map<String, dynamic> json) => RemoteProfile(
        nickname: json['nickname'] as String,
        avatarId: json['avatar_id'] as int,
        languagePair: json['language_pair'] as String,
        memorizedCount: json['memorized_count'] as int,
        currentLevel: json['current_level'] as int,
        streak: json['streak'] as int,
      );

  final String nickname;
  final int avatarId;

  /// The active pair's stable pairId (e.g. `it_hu`). Free-form text, so an
  /// id from a language file this build doesn't ship degrades gracefully
  /// (the profile still adopts it; the UI falls back to showing the raw id).
  final String languagePair;

  final int memorizedCount;
  final int currentLevel;
  final int streak;
}

/// One cloud `memorized_words` row (keyed by user + pair + word).
class RemoteWord {
  const RemoteWord({
    required this.pairId,
    required this.wordId,
    required this.memorizedAt,
  });

  factory RemoteWord.fromJson(Map<String, dynamic> json) => RemoteWord(
        pairId: json['pair_id'] as String,
        wordId: json['word_id'] as int,
        memorizedAt: DateTime.parse(json['memorized_at'] as String).toLocal(),
      );

  final String pairId;
  final int wordId;
  final DateTime memorizedAt;
}

/// Mirrors local progress to Supabase and restores it on sign-in.
///
/// Local Drift stays the source of truth for the user's own data; the cloud
/// is a mirror/backup. "Memorized" only grows, so merging is a safe union of
/// word ids plus recomputed counters — no deletes ever.
///
/// Offline behaviour: every requested push first records a pending flag in
/// `app_meta`; the flag is only cleared after a fully successful push. A
/// failed push starts a retry timer, and on the next app start
/// [resumePendingPush] picks the flag up again — so progress made offline is
/// uploaded once connectivity returns, with no separate op-queue needed
/// (the push is an idempotent upsert of current state).
class SyncService {
  SyncService(this._db, this._client);

  final AppDatabase _db;
  final SupabaseClient? _client;

  /// '1' while local changes may not have reached Supabase yet.
  static const pendingKey = 'sync_pending';

  /// ISO-8601 cutoff: memorized rows at/before this instant are known to be
  /// on Supabase already, so pushes only send newer rows.
  static const lastPushedKey = 'sync_last_pushed_at';

  static const _debounceDelay = Duration(seconds: 3);
  static const _retryDelay = Duration(seconds: 60);
  static const _pushChunkSize = 500;

  Timer? _debounce;
  Timer? _retry;

  void dispose() {
    _debounce?.cancel();
    _retry?.cancel();
  }

  bool get _hasSession => _client?.auth.currentSession != null;

  /// Requests a push soon (debounced). Called after every progress change;
  /// cheap no-op when signed out or Supabase is unconfigured.
  void schedulePush() {
    if (!_hasSession) return;
    // Record intent *before* the push runs, so a kill during the debounce
    // window still gets retried by resumePendingPush on next start.
    unawaited(_setMeta(pendingKey, '1'));
    _debounce?.cancel();
    _debounce = Timer(_debounceDelay, () => unawaited(pushNow()));
  }

  /// Called once a session is (re)stored on startup: finishes any push a
  /// previous run left pending (e.g. progress made offline).
  Future<void> resumePendingPush() async {
    if (!_hasSession) return;
    if (await _getMeta(pendingKey) == '1') schedulePush();
  }

  /// Forgets the push cutoff so the next push uploads the full memorized
  /// set. Used right after linking an account.
  Future<void> resetPushCursor() => _clearMeta(lastPushedKey);

  /// Called on sign-out. Local data stays; only sync bookkeeping is reset.
  Future<void> clearSyncState() async {
    _debounce?.cancel();
    _retry?.cancel();
    _retry = null;
    await _clearMeta(pendingKey);
    await _clearMeta(lastPushedKey);
  }

  /// Pushes the profile row and any not-yet-uploaded memorized words.
  /// Returns true on success; on failure keeps the pending flag and retries
  /// every [_retryDelay] while the app runs.
  Future<bool> pushNow() async {
    final client = _client;
    if (client == null || !_hasSession) return false;
    final profile = await _db.select(_db.profiles).getSingleOrNull();
    // Not linked yet (nickname not claimed): pushing would bypass the claim.
    if (profile == null || profile.remoteUserId == null) return false;

    final userId = profile.remoteUserId!;
    await _setMeta(pendingKey, '1');
    final cutoffRaw = await _getMeta(lastPushedKey);
    final cutoff = cutoffRaw == null ? null : DateTime.tryParse(cutoffRaw);
    // memorizedAt has second precision; back the new cutoff off by a couple
    // of seconds so a row written during the push is re-sent next time
    // (harmless: uploads are ignore-duplicate upserts).
    final newCutoff = DateTime.now().subtract(const Duration(seconds: 2));

    try {
      final rows = await (_db.select(_db.wordProgress)
            ..where((r) => r.status.equalsValue(WordStatus.memorized)))
          .get();
      final delta = cutoff == null
          ? rows
          : rows
              .where((r) =>
                  r.memorizedAt != null && r.memorizedAt!.isAfter(cutoff))
              .toList();

      for (var i = 0; i < delta.length; i += _pushChunkSize) {
        final chunk = delta.skip(i).take(_pushChunkSize);
        await client.from('memorized_words').upsert(
          [
            for (final row in chunk)
              {
                'user_id': userId,
                'pair_id': row.pairId,
                'word_id': row.wordId,
                'memorized_at': (row.memorizedAt ?? DateTime.now())
                    .toUtc()
                    .toIso8601String(),
              },
          ],
          onConflict: 'user_id,pair_id,word_id',
          // Keep the original memorized_at if the row is already there.
          ignoreDuplicates: true,
        );
      }

      await client.from('profiles').upsert({
        'id': userId,
        'nickname': profile.nickname,
        'avatar_id': profile.avatarId,
        'language_pair': profile.languagePair,
        'memorized_count': profile.memorizedCount,
        'current_level': profile.currentLevel,
        'streak': profile.streak,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });

      await _setMeta(lastPushedKey, newCutoff.toIso8601String());
      await _clearMeta(pendingKey);
      _retry?.cancel();
      _retry = null;
      return true;
    } catch (error) {
      // Typically offline. The pending flag is still set; retry while the
      // app runs, and resumePendingPush covers the next start.
      debugPrint('Sync push failed (will retry): $error');
      _retry?.cancel();
      _retry = Timer(_retryDelay, () => unawaited(pushNow()));
      return false;
    }
  }

  /// Fetches this user's cloud profile + memorized words and merges them
  /// into the local database. Called on sign-in (restore on fresh install).
  Future<void> pullAndMergeRemote() async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) return;

    final profileJson = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    final wordsJson = await client
        .from('memorized_words')
        .select('pair_id, word_id, memorized_at');

    await applyRemoteSnapshot(
      profile: profileJson == null ? null : RemoteProfile.fromJson(profileJson),
      words: [
        for (final json in wordsJson) RemoteWord.fromJson(json),
      ],
    );
  }

  /// Merges a fetched cloud snapshot into local Drift. Pure local logic,
  /// exposed for unit tests.
  ///
  /// Merge rules ("memorized" only grows):
  /// - every remote word id becomes memorized locally (keeping the remote
  ///   memorizedAt), via direct upserts — deliberately NOT markMemorized, so
  ///   restoring history does not inflate today's goal or the streak;
  /// - memorizedCount is recomputed for the ACTIVE pair (the one the profile
  ///   ends up on) from the merged set;
  /// - streak and currentLevel take the larger of local/remote;
  /// - nickname / avatar / language pair adopt the cloud identity when a
  ///   cloud profile exists (it is the account's identity).
  @visibleForTesting
  Future<void> applyRemoteSnapshot({
    required RemoteProfile? profile,
    required List<RemoteWord> words,
  }) {
    return _db.transaction(() async {
      final local = await _db.select(_db.profiles).getSingleOrNull();
      if (local == null) return;

      final memorizedRows = await (_db.select(_db.wordProgress)
            ..where((r) => r.status.equalsValue(WordStatus.memorized)))
          .get();
      String key(String pairId, int wordId) => '$pairId $wordId';
      final localKeys = {
        for (final row in memorizedRows) key(row.pairId, row.wordId),
      };
      final toRestore = words
          .where((w) => !localKeys.contains(key(w.pairId, w.wordId)))
          .toList();

      if (toRestore.isNotEmpty) {
        await _db.batch(
          (batch) => batch.insertAllOnConflictUpdate(_db.wordProgress, [
            for (final word in toRestore)
              WordProgressCompanion(
                pairId: Value(word.pairId),
                wordId: Value(word.wordId),
                status: const Value(WordStatus.memorized),
                memorizedAt: Value(word.memorizedAt),
              ),
          ]),
        );
      }

      // The pair the profile ends up on (cloud identity wins when present).
      final activePairId = profile?.languagePair ?? local.languagePair;
      final countExp = _db.wordProgress.wordId.count();
      final countQuery = _db.selectOnly(_db.wordProgress)
        ..addColumns([countExp])
        ..where(_db.wordProgress.status.equalsValue(WordStatus.memorized) &
            _db.wordProgress.pairId.equals(activePairId));
      final activeCount =
          await countQuery.map((r) => r.read(countExp)!).getSingle();

      await (_db.update(_db.profiles)
            ..where((r) => r.id.equals(local.id)))
          .write(ProfilesCompanion(
        memorizedCount: Value(activeCount),
        streak: profile == null
            ? const Value.absent()
            : Value(profile.streak > local.streak
                ? profile.streak
                : local.streak),
        currentLevel: profile == null
            ? const Value.absent()
            : Value(profile.currentLevel > local.currentLevel
                ? profile.currentLevel
                : local.currentLevel),
        nickname:
            profile == null ? const Value.absent() : Value(profile.nickname),
        avatarId:
            profile == null ? const Value.absent() : Value(profile.avatarId),
        languagePair: profile == null
            ? const Value.absent()
            : Value(profile.languagePair),
      ));
    });
  }

  Future<String?> _getMeta(String key) async {
    final row = await (_db.select(_db.appMeta)
          ..where((r) => r.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> _setMeta(String key, String value) =>
      _db.into(_db.appMeta).insertOnConflictUpdate(
            AppMetaCompanion(key: Value(key), value: Value(value)),
          );

  Future<void> _clearMeta(String key) =>
      (_db.delete(_db.appMeta)..where((r) => r.key.equals(key))).go();
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService(
    ref.watch(appDatabaseProvider),
    ref.watch(supabaseClientProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

/// Watched once from the app root. When a session is (re)stored, finishes
/// any push a previous run left pending — this is what uploads progress that
/// was made offline once the app runs with connectivity again.
final syncBootstrapProvider = Provider<void>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return;
  final sync = ref.watch(syncServiceProvider);
  ref.listen(authStateProvider, (previous, next) {
    final event = next.valueOrNull?.event;
    if (event == AuthChangeEvent.initialSession ||
        event == AuthChangeEvent.signedIn ||
        event == AuthChangeEvent.tokenRefreshed) {
      unawaited(sync.resumePendingPush());
    }
  }, fireImmediately: true);
});
