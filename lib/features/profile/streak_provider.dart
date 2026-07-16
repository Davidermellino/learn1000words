import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';

/// Key of a `daily_activity` row: the local calendar day as `yyyy-MM-dd`.
String dailyActivityKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// Daily-goal and streak bookkeeping over `daily_activity` + the profile.
///
/// The rules, kept as pure functions so they are unit-testable in isolation:
/// - a day's goal is met when [DailyActivityRow.memorizedCount] reaches the
///   profile's dailyGoal; that day the streak advances via [streakAfterGoalMet];
/// - a day that passes with the goal unmet breaks the streak; [syncStreak]
///   applies the reset the next time the app runs.
class StreakService {
  StreakService(this._db);

  final AppDatabase _db;

  /// The streak value to store the moment today's goal is met: one more than
  /// yesterday's run, or a fresh streak of 1 when yesterday's goal was not
  /// met (covers both streak==0 fresh starts and not-yet-reset stale runs).
  static int streakAfterGoalMet({
    required int currentStreak,
    required bool yesterdayMet,
  }) =>
      yesterdayMet ? currentStreak + 1 : 1;

  /// Whether a stored positive streak is stale: neither today nor yesterday
  /// met the goal, so at least one full day passed without meeting it.
  static bool isStreakBroken({
    required bool todayMet,
    required bool yesterdayMet,
  }) =>
      !todayMet && !yesterdayMet;

  /// Records one newly memorized word for [now]'s calendar day: increments
  /// `memorizedCount` and, when it first reaches the profile's goal, marks
  /// the day `goalMet` and advances the profile streak.
  ///
  /// Runs its own transaction; when called from inside another Drift
  /// transaction (the memorize flow) it simply joins it.
  Future<void> recordMemorized({DateTime? now}) {
    final today = now ?? DateTime.now();
    return _db.transaction(() async {
      final todayKey = dailyActivityKey(today);
      final existing = await (_db.select(_db.dailyActivity)
            ..where((row) => row.date.equals(todayKey)))
          .getSingleOrNull();
      final count = (existing?.memorizedCount ?? 0) + 1;
      var goalMet = existing?.goalMet ?? false;

      final profile = await _db.select(_db.profiles).getSingleOrNull();
      if (!goalMet && profile != null && count >= profile.dailyGoal) {
        goalMet = true;
        final yesterdayKey = dailyActivityKey(
          DateTime(today.year, today.month, today.day - 1),
        );
        final yesterday = await (_db.select(_db.dailyActivity)
              ..where((row) => row.date.equals(yesterdayKey)))
            .getSingleOrNull();
        await (_db.update(_db.profiles)
              ..where((row) => row.id.equals(profile.id)))
            .write(
          ProfilesCompanion(
            streak: Value(streakAfterGoalMet(
              currentStreak: profile.streak,
              yesterdayMet: yesterday?.goalMet ?? false,
            )),
          ),
        );
      }

      await _db.into(_db.dailyActivity).insertOnConflictUpdate(
            DailyActivityCompanion(
              date: Value(todayKey),
              memorizedCount: Value(count),
              goalMet: Value(goalMet),
            ),
          );
    });
  }

  /// Resets a stale streak to 0. Call once on startup: if neither today nor
  /// yesterday met the goal, a full day passed unmet and the streak is over.
  Future<void> syncStreak({DateTime? now}) async {
    final today = now ?? DateTime.now();
    final profile = await _db.select(_db.profiles).getSingleOrNull();
    if (profile == null || profile.streak == 0) return;

    Future<bool> met(DateTime day) async {
      final row = await (_db.select(_db.dailyActivity)
            ..where((r) => r.date.equals(dailyActivityKey(day))))
          .getSingleOrNull();
      return row?.goalMet ?? false;
    }

    final broken = isStreakBroken(
      todayMet: await met(today),
      yesterdayMet: await met(DateTime(today.year, today.month, today.day - 1)),
    );
    if (broken) {
      await (_db.update(_db.profiles)
            ..where((row) => row.id.equals(profile.id)))
          .write(const ProfilesCompanion(streak: Value(0)));
    }
  }
}

final streakServiceProvider = Provider<StreakService>(
  (ref) => StreakService(ref.watch(appDatabaseProvider)),
);

/// Today's `daily_activity` row, reactively streamed; `null` until the first
/// word of the day is memorized. The day key is fixed at provider build —
/// fine for normal session lengths.
final todayActivityProvider = StreamProvider<DailyActivityRow?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final query = db.select(db.dailyActivity)
    ..where((row) => row.date.equals(dailyActivityKey(DateTime.now())));
  return query.watchSingleOrNull();
});
