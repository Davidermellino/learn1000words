import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/db/app_database.dart';
import '../features/profile/profile_repository.dart';
import 'language_providers.dart';
import 'models/word.dart';
import 'models/word_status.dart';

/// Progress of one level: how many of its words are memorized and whether
/// the level is reachable under sequential unlocking.
class LevelProgress {
  const LevelProgress({
    required this.level,
    required this.totalWords,
    required this.memorizedWords,
    required this.unlocked,
  });

  final int level;

  /// Words in this level per the active pair's dataset (100 in a full dataset,
  /// fewer in the placeholder — never hardcoded).
  final int totalWords;

  final int memorizedWords;

  /// Level 1 is always unlocked; level N unlocks once level N−1 is
  /// [completed].
  final bool unlocked;

  bool get completed => totalWords > 0 && memorizedWords >= totalWords;

  double get fraction =>
      totalWords == 0 ? 0 : (memorizedWords / totalWords).clamp(0, 1);
}

/// The active pair's word dataset. Loading until the pairs and the profile
/// (hence the active pair) are available; errors if discovery failed or no
/// valid pair exists.
final wordsProvider = Provider<AsyncValue<List<Word>>>((ref) {
  final pairs = ref.watch(languagePairsProvider);
  if (pairs.hasError) {
    return AsyncValue.error(pairs.error!, pairs.stackTrace!);
  }
  final profile = ref.watch(profileProvider);
  if (profile.hasError) {
    return AsyncValue.error(profile.error!, profile.stackTrace!);
  }
  if (!pairs.hasValue || !profile.hasValue) {
    return const AsyncValue.loading();
  }
  final pair = ref.watch(activePairProvider);
  if (pair == null) {
    return AsyncValue.error(
      StateError('No valid language pair available'),
      StackTrace.current,
    );
  }
  return AsyncValue.data(pair.words);
});

/// Ids of the active pair's memorized words, reactively streamed from
/// `word_progress` (scoped to the active pairId).
final memorizedWordIdsProvider = StreamProvider<Set<int>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final pair = ref.watch(activePairProvider);
  if (pair == null) return Stream.value(const <int>{});
  final query = db.select(db.wordProgress)
    ..where((row) =>
        row.status.equalsValue(WordStatus.memorized) &
        row.pairId.equals(pair.pairId));
  return query.watch().map(
        (rows) => {for (final row in rows) row.wordId},
      );
});

/// Single source of truth for level progress + sequential locking, shared by
/// Home and Level Detail — scoped to the active pair. Loading until both the
/// dataset and the first `word_progress` snapshot are available.
final levelsProgressProvider = Provider<AsyncValue<List<LevelProgress>>>((ref) {
  final words = ref.watch(wordsProvider);
  final memorizedIds = ref.watch(memorizedWordIdsProvider);

  if (words.hasError) {
    return AsyncValue.error(words.error!, words.stackTrace!);
  }
  if (memorizedIds.hasError) {
    return AsyncValue.error(memorizedIds.error!, memorizedIds.stackTrace!);
  }
  if (!words.hasValue || !memorizedIds.hasValue) {
    return const AsyncValue.loading();
  }
  return AsyncValue.data(
    buildLevels(words.requireValue, memorizedIds.requireValue),
  );
});

/// Progress of a single level, derived from [levelsProgressProvider].
final levelProgressProvider =
    Provider.family<AsyncValue<LevelProgress>, int>((ref, level) {
  return ref.watch(levelsProgressProvider).whenData(
        (levels) => levels.firstWhere((p) => p.level == level),
      );
});

/// Builds the per-level progress list (totals, memorized, sequential unlock)
/// from a word set and the memorized ids. Pure — reused by the writer to
/// derive the profile's current level.
List<LevelProgress> buildLevels(List<Word> words, Set<int> memorizedIds) {
  final totals = List<int>.filled(AppConstants.levelCount + 1, 0);
  final memorized = List<int>.filled(AppConstants.levelCount + 1, 0);
  for (final word in words) {
    totals[word.level]++;
    if (memorizedIds.contains(word.id)) memorized[word.level]++;
  }

  final levels = <LevelProgress>[];
  var previousCompleted = true; // level 1 is always unlocked
  for (var level = 1; level <= AppConstants.levelCount; level++) {
    final progress = LevelProgress(
      level: level,
      totalWords: totals[level],
      memorizedWords: memorized[level],
      unlocked: previousCompleted,
    );
    levels.add(progress);
    previousCompleted = progress.completed;
  }
  return levels;
}

/// The active pair's "current level": the highest unlocked level. Used for the
/// profile's denormalized `currentLevel` (shown to the user and to friends).
int currentLevelFromLevels(List<LevelProgress> levels) {
  var current = 1;
  for (final level in levels) {
    if (level.unlocked) current = level.level;
  }
  return current;
}
