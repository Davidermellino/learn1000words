import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/db/app_database.dart';
import '../../data/sync/sync_service.dart';
import '../../data/supabase/supabase_providers.dart';
import '../profile/profile_repository.dart';
import 'auth_service.dart';

/// Outcome of linking the freshly signed-in Supabase user to the local
/// profile.
enum LinkResult {
  /// First sign-in of this account: the nickname was claimed and the local
  /// progress pushed to the cloud.
  linkedNew,

  /// The account already has a cloud profile: it was pulled and merged into
  /// the local one (restore), then pushed back.
  linkedExisting,

  /// The nickname is already taken globally — ask the user for another and
  /// call [AccountLinker.claimNickname].
  nicknameTaken,
}

/// Runs after a successful sign-in: claims the nickname (first time) or
/// restores the cloud profile (returning account), links the local profile
/// row via remoteUserId, and triggers the initial full sync.
///
/// remoteUserId is only set after a successful claim/restore, and the sync
/// service refuses to push while it is null — so an interrupted flow can
/// never bypass the nickname-uniqueness claim.
class AccountLinker {
  AccountLinker(
    this._client,
    this._authService,
    this._profiles,
    this._sync,
    this._db,
  );

  final SupabaseClient _client;
  final AuthService _authService;
  final ProfileRepository _profiles;
  final SyncService _sync;
  final AppDatabase _db;

  Future<LinkResult> linkSignedInUser() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('linkSignedInUser called without a session');
    }
    final local = await _profiles.watchProfile().first;
    if (local == null) {
      // Unreachable: the auth screen sits behind the onboarding gate.
      throw StateError('No local profile to link');
    }

    final remote = await _client
        .from('profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (remote != null) {
      // Returning account (e.g. fresh install): restore before pushing.
      await _profiles.linkRemoteUser(user.id);
      await _sync.pullAndMergeRemote();
      await _finishLink();
      return LinkResult.linkedExisting;
    }

    return _claim(user.id, local.nickname, updateLocalNickname: false);
  }

  /// Retries the claim with a different nickname after [LinkResult
  /// .nicknameTaken]; the local profile adopts it on success.
  Future<LinkResult> claimNickname(String nickname) {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('claimNickname called without a session');
    }
    return _claim(user.id, nickname.trim(), updateLocalNickname: true);
  }

  /// Restores a returning account straight after sign-in, without going
  /// through onboarding: if the account already has a cloud profile, it is
  /// pulled into a fresh local profile (or an existing local row is re-linked),
  /// so the router can send the user directly home. Does nothing when the
  /// account has no cloud profile yet — that is a brand-new sign-up, which the
  /// router routes to onboarding so [linkSignedInUser] can claim the nickname.
  ///
  /// Returns true when a returning account was restored/linked (→ home), false
  /// when there is nothing to restore (→ onboarding).
  Future<bool> restoreIfReturning() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    final local = await _profiles.watchProfile().first;
    // Already linked to this account: nothing to restore.
    if (local?.remoteUserId == user.id) return true;

    final remote = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    // No cloud profile: a new account. Leave the local profile untouched so
    // the router routes to onboarding, which claims the nickname.
    if (remote == null) return false;

    // Returning account (e.g. login on a fresh install): seed the local
    // profile from the cloud identity when missing, link it, then restore the
    // memorized words. dailyGoal / reminder are device-local (not stored in
    // the cloud profile), so they keep their defaults.
    if (local == null) {
      final remoteProfile = RemoteProfile.fromJson(remote);
      await _profiles.createProfile(
        nickname: remoteProfile.nickname,
        avatarId: remoteProfile.avatarId,
        languagePairId: remoteProfile.languagePair,
        dailyGoal: 10,
      );
    }
    await _profiles.linkRemoteUser(user.id);
    await _sync.pullAndMergeRemote();
    // Push back any local-only progress (e.g. words earned before a re-login).
    await _sync.resetPushCursor();
    unawaited(_sync.pushNow());
    return true;
  }

  /// Cancels an unfinished nickname claim: signs out so the app never sits
  /// in a signed-in-but-unclaimed state.
  Future<void> abortLink() => _authService.signOut();

  /// Signs out and wipes all on-device user data, so the next account starts
  /// fresh (from onboarding) rather than inheriting this profile. The user's
  /// own data is safe in the cloud and restored on their next login (see
  /// [restoreIfReturning]).
  Future<void> signOutAndUnlink() async {
    await _authService.signOut();
    await _sync.clearSyncState();
    await _db.clearLocalData();
  }

  Future<LinkResult> _claim(
    String userId,
    String nickname, {
    required bool updateLocalNickname,
  }) async {
    try {
      // Plain insert (not upsert): a unique violation on the nickname index
      // must surface instead of overwriting anything.
      await _client.from('profiles').insert({
        'id': userId,
        'nickname': nickname,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } on PostgrestException catch (error) {
      // 23505 = unique_violation. No profiles row exists for this user id
      // (checked above), so the collision is the nickname index.
      if (error.code == '23505') return LinkResult.nicknameTaken;
      rethrow;
    }

    if (updateLocalNickname) await _profiles.updateNickname(nickname);
    await _profiles.linkRemoteUser(userId);
    await _finishLink();
    return LinkResult.linkedNew;
  }

  /// Full push after linking: uploads the whole memorized set plus the
  /// profile fields. A failure here is fine — the pending flag makes the
  /// sync service retry.
  Future<void> _finishLink() async {
    await _sync.resetPushCursor();
    await _sync.pushNow();
  }
}

/// `null` while Supabase is not configured.
final accountLinkerProvider = Provider<AccountLinker?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final authService = ref.watch(authServiceProvider);
  if (client == null || authService == null) return null;
  return AccountLinker(
    client,
    authService,
    ref.watch(profileRepositoryProvider),
    ref.watch(syncServiceProvider),
    ref.watch(appDatabaseProvider),
  );
});

/// Restores a returning account right after sign-in (see
/// [AccountLinker.restoreIfReturning]). The router's auth gate awaits this
/// before choosing between onboarding and home, so an existing account (login)
/// goes straight home while a brand-new sign-up falls through to onboarding.
/// Re-runs whenever the sign-in state changes.
final sessionRestoreProvider = FutureProvider<void>((ref) async {
  if (!ref.watch(isSignedInProvider)) return;
  final linker = ref.read(accountLinkerProvider);
  if (linker == null) return;
  try {
    await linker.restoreIfReturning();
  } catch (error) {
    // Offline or a transient failure: fall through. A returning user then
    // reaches onboarding, which still restores via linkSignedInUser.
    debugPrint('Session restore failed: $error');
  }
});
