import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/db/app_database.dart';
import '../features/profile/streak_provider.dart';
import 'models/word.dart';
import 'models/word_status.dart';
import 'progress_provider.dart';
import 'sync/sync_service.dart';

/// Writes word-progress changes. All memorization writes go through here so
/// Home / Level Detail / Known Words update reactively off `word_progress`,
/// and the profile's per-pair `memorizedCount` / `currentLevel` stay
/// consistent for the active pair.
class ProgressWriter {
  ProgressWriter(this._db, this._streak, this._sync);

  final AppDatabase _db;
  final StreakService _streak;
  final SyncService _sync;

  /// Marks the word ([pairId], [wordId]) memorized (idempotent): upserts its
  /// `word_progress` row with status=memorized and memorizedAt=now, refreshes
  /// the profile's `memorizedCount` / `currentLevel` for this pair, and
  /// records the word in today's daily activity (goal / streak bookkeeping) —
  /// unless the word was already memorized, in which case nothing changes.
  ///
  /// [pairWords] are the pair's full word set, needed to derive the current
  /// level. The daily goal / streak are global (any pair counts).
  Future<void> markMemorized({
    required String pairId,
    required int wordId,
    required List<Word> pairWords,
  }) async {
    final changed = await _db.transaction(() async {
      final existing = await (_db.select(_db.wordProgress)
            ..where((row) =>
                row.pairId.equals(pairId) & row.wordId.equals(wordId)))
          .getSingleOrNull();
      if (existing?.status == WordStatus.memorized) return false;

      await _db.into(_db.wordProgress).insertOnConflictUpdate(
            WordProgressCompanion(
              pairId: Value(pairId),
              wordId: Value(wordId),
              status: const Value(WordStatus.memorized),
              memorizedAt: Value(DateTime.now()),
            ),
          );

      await _refreshProfileAggregates(pairId, pairWords);
      await _streak.recordMemorized();
      return true;
    });

    // After the transaction commits: mirror the change to the cloud
    // (debounced; no-op when signed out or offline — see SyncService).
    if (changed) _sync.schedulePush();
  }

  /// Recomputes and stores the profile's `memorizedCount` and `currentLevel`
  /// for [pairId] (the active pair), from that pair's memorized rows and
  /// [pairWords]. Used both when memorizing and when switching pair, so the
  /// profile always reflects the pair currently in focus.
  Future<void> refreshProfileForPair(
    String pairId,
    List<Word> pairWords,
  ) =>
      _db.transaction(() => _refreshProfileAggregates(pairId, pairWords));

  Future<void> _refreshProfileAggregates(
    String pairId,
    List<Word> pairWords,
  ) async {
    final profile = await _db.select(_db.profiles).getSingleOrNull();
    if (profile == null) return;

    final memorizedRows = await (_db.select(_db.wordProgress)
          ..where((row) =>
              row.pairId.equals(pairId) &
              row.status.equalsValue(WordStatus.memorized)))
        .get();
    final memorizedIds = {for (final row in memorizedRows) row.wordId};
    final levels = buildLevels(pairWords, memorizedIds);

    await (_db.update(_db.profiles)..where((row) => row.id.equals(profile.id)))
        .write(
      ProfilesCompanion(
        memorizedCount: Value(memorizedIds.length),
        currentLevel: Value(currentLevelFromLevels(levels)),
      ),
    );
  }
}

final progressWriterProvider = Provider<ProgressWriter>(
  (ref) => ProgressWriter(
    ref.watch(appDatabaseProvider),
    ref.watch(streakServiceProvider),
    ref.watch(syncServiceProvider),
  ),
);
