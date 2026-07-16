import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn1000words/core/db/app_database.dart';
import 'package:learn1000words/data/models/word_status.dart';
import 'package:learn1000words/data/sync/sync_service.dart';

void main() {
  late AppDatabase db;
  late SyncService sync;

  // The profile's active pair for these tests; progress is keyed by it.
  const activePair = 'it_hu';

  setUp(() async {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    sync = SyncService(db, null);
    await db.into(db.profiles).insert(
          ProfilesCompanion.insert(
            nickname: 'Anna',
            avatarId: 1,
            languagePair: activePair,
          ),
        );
  });

  tearDown(() async {
    sync.dispose();
    await db.close();
  });

  Future<void> markLocalMemorized(int wordId, {String pairId = activePair}) async {
    await db.into(db.wordProgress).insert(
          WordProgressCompanion(
            pairId: Value(pairId),
            wordId: Value(wordId),
            status: const Value(WordStatus.memorized),
            memorizedAt: Value(DateTime.now()),
          ),
        );
    final profile = await db.select(db.profiles).getSingle();
    await db.update(db.profiles).write(
          ProfilesCompanion(memorizedCount: Value(profile.memorizedCount + 1)),
        );
  }

  Future<Set<int>> memorizedIds() async {
    final rows = await (db.select(db.wordProgress)
          ..where((r) => r.status.equalsValue(WordStatus.memorized)))
        .get();
    return {for (final row in rows) row.wordId};
  }

  RemoteProfile remoteProfile({
    String nickname = 'CloudAnna',
    int avatarId = 3,
    String languagePair = activePair,
    int memorizedCount = 0,
    int currentLevel = 2,
    int streak = 5,
  }) =>
      RemoteProfile(
        nickname: nickname,
        avatarId: avatarId,
        languagePair: languagePair,
        memorizedCount: memorizedCount,
        currentLevel: currentLevel,
        streak: streak,
      );

  List<RemoteWord> remoteWords(List<int> ids, {String pairId = activePair}) => [
        for (final id in ids)
          RemoteWord(
            pairId: pairId,
            wordId: id,
            memorizedAt: DateTime(2026, 1, 1),
          ),
      ];

  group('applyRemoteSnapshot', () {
    test('restores cloud progress and identity on a fresh device', () async {
      // The cloud account is on a different active pair (hu_it); the local
      // profile adopts it and its per-pair count.
      await sync.applyRemoteSnapshot(
        profile: remoteProfile(memorizedCount: 3, languagePair: 'hu_it'),
        words: remoteWords([1, 2, 3], pairId: 'hu_it'),
      );

      expect(await memorizedIds(), {1, 2, 3});
      final profile = await db.select(db.profiles).getSingle();
      expect(profile.memorizedCount, 3);
      expect(profile.nickname, 'CloudAnna');
      expect(profile.avatarId, 3);
      expect(profile.languagePair, 'hu_it');
      expect(profile.currentLevel, 2);
      expect(profile.streak, 5);
    });

    test('merges as a union without double counting', () async {
      await markLocalMemorized(1);
      await markLocalMemorized(2);
      await db
          .update(db.profiles)
          .write(const ProfilesCompanion(streak: Value(3)));

      await sync.applyRemoteSnapshot(
        profile: remoteProfile(memorizedCount: 2, streak: 1, currentLevel: 1),
        words: remoteWords([2, 3]),
      );

      expect(await memorizedIds(), {1, 2, 3});
      final profile = await db.select(db.profiles).getSingle();
      expect(profile.memorizedCount, 3);
      // Local streak/level were higher: they win.
      expect(profile.streak, 3);
      expect(profile.currentLevel, 1);
    });

    test('does not create daily-activity rows (no goal/streak inflation)',
        () async {
      await sync.applyRemoteSnapshot(
        profile: remoteProfile(),
        words: remoteWords([1, 2, 3, 4, 5]),
      );

      expect(await db.select(db.dailyActivity).get(), isEmpty);
    });

    test('upgrades a local learning row to memorized', () async {
      await db.into(db.wordProgress).insert(
            const WordProgressCompanion(
              pairId: Value(activePair),
              wordId: Value(7),
              status: Value(WordStatus.learning),
            ),
          );

      await sync.applyRemoteSnapshot(
        profile: null,
        words: remoteWords([7]),
      );

      expect(await memorizedIds(), {7});
    });

    test('keeps the local identity when there is no cloud profile', () async {
      await markLocalMemorized(1);

      await sync.applyRemoteSnapshot(profile: null, words: remoteWords([9]));

      final profile = await db.select(db.profiles).getSingle();
      expect(profile.nickname, 'Anna');
      expect(profile.languagePair, activePair);
      // The count is still recomputed from the active pair's merged set.
      expect(profile.memorizedCount, 2);
      expect(await memorizedIds(), {1, 9});
    });

    test('adopts an unknown language pair from a newer app version', () async {
      // pairId is free text now: a pair this build does not ship is still
      // adopted (the UI falls back to the raw id) rather than being dropped.
      await sync.applyRemoteSnapshot(
        profile: remoteProfile(languagePair: 'de_fr'),
        words: const [],
      );

      final profile = await db.select(db.profiles).getSingle();
      expect(profile.languagePair, 'de_fr');
      expect(profile.nickname, 'CloudAnna');
    });
  });
}
