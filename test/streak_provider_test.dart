import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn1000words/core/db/app_database.dart';
import 'package:learn1000words/features/profile/streak_provider.dart';

void main() {
  group('streakAfterGoalMet', () {
    test('increments the streak when yesterday met the goal', () {
      expect(
        StreakService.streakAfterGoalMet(currentStreak: 4, yesterdayMet: true),
        5,
      );
    });

    test('starts a fresh streak of 1 when yesterday missed the goal', () {
      expect(
        StreakService.streakAfterGoalMet(currentStreak: 0, yesterdayMet: false),
        1,
      );
      // A stale, not-yet-reset streak also restarts at 1.
      expect(
        StreakService.streakAfterGoalMet(currentStreak: 7, yesterdayMet: false),
        1,
      );
    });
  });

  group('isStreakBroken', () {
    test('broken only when neither today nor yesterday met the goal', () {
      expect(
        StreakService.isStreakBroken(todayMet: false, yesterdayMet: false),
        isTrue,
      );
      expect(
        StreakService.isStreakBroken(todayMet: false, yesterdayMet: true),
        isFalse,
      );
      expect(
        StreakService.isStreakBroken(todayMet: true, yesterdayMet: false),
        isFalse,
      );
    });
  });

  group('StreakService over Drift', () {
    late AppDatabase db;
    late StreakService service;

    // Fixed "now" so tests don't depend on the wall clock.
    final today = DateTime(2026, 7, 13, 15, 30);
    final yesterday = DateTime(2026, 7, 12);

    setUp(() async {
      db = AppDatabase.withExecutor(NativeDatabase.memory());
      service = StreakService(db);
      await db.into(db.profiles).insert(
            ProfilesCompanion.insert(
              nickname: 'test',
              avatarId: 1,
              languagePair: 'it_hu',
              dailyGoal: const Value(3),
            ),
          );
    });

    tearDown(() => db.close());

    Future<DailyActivityRow?> activityOn(DateTime day) =>
        (db.select(db.dailyActivity)
              ..where((row) => row.date.equals(dailyActivityKey(day))))
            .getSingleOrNull();

    Future<Profile> profile() => db.select(db.profiles).getSingle();

    Future<void> seedActivity(DateTime day,
        {required int count, required bool goalMet}) {
      return db.into(db.dailyActivity).insert(
            DailyActivityCompanion.insert(
              date: dailyActivityKey(day),
              memorizedCount: Value(count),
              goalMet: Value(goalMet),
            ),
          );
    }

    test('recordMemorized increments today\'s count', () async {
      await service.recordMemorized(now: today);
      await service.recordMemorized(now: today);

      final row = await activityOn(today);
      expect(row?.memorizedCount, 2);
      expect(row?.goalMet, isFalse);
      expect((await profile()).streak, 0);
    });

    test('reaching the goal marks goalMet and starts a streak of 1', () async {
      for (var i = 0; i < 3; i++) {
        await service.recordMemorized(now: today);
      }

      final row = await activityOn(today);
      expect(row?.memorizedCount, 3);
      expect(row?.goalMet, isTrue);
      expect((await profile()).streak, 1);
    });

    test('meeting the goal after yesterday met it increments the streak',
        () async {
      await seedActivity(yesterday, count: 3, goalMet: true);
      await (db.update(db.profiles)).write(
        const ProfilesCompanion(streak: Value(4)),
      );

      for (var i = 0; i < 3; i++) {
        await service.recordMemorized(now: today);
      }

      expect((await profile()).streak, 5);
    });

    test('words beyond the goal do not advance the streak again', () async {
      for (var i = 0; i < 5; i++) {
        await service.recordMemorized(now: today);
      }

      final row = await activityOn(today);
      expect(row?.memorizedCount, 5);
      expect((await profile()).streak, 1);
    });

    test('syncStreak resets the streak after a fully missed day', () async {
      // Goal was last met two days ago; yesterday passed unmet.
      await seedActivity(
        DateTime(2026, 7, 11),
        count: 3,
        goalMet: true,
      );
      await (db.update(db.profiles)).write(
        const ProfilesCompanion(streak: Value(6)),
      );

      await service.syncStreak(now: today);

      expect((await profile()).streak, 0);
    });

    test('syncStreak keeps the streak when yesterday met the goal', () async {
      await seedActivity(yesterday, count: 3, goalMet: true);
      await (db.update(db.profiles)).write(
        const ProfilesCompanion(streak: Value(6)),
      );

      await service.syncStreak(now: today);

      expect((await profile()).streak, 6);
    });
  });
}
