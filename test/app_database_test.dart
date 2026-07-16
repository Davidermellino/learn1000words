import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn1000words/core/db/app_database.dart';
import 'package:learn1000words/data/models/word_status.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('clearLocalData wipes every user-data table so sign-out starts fresh',
      () async {
    // Seed a fully populated device: profile, progress, usage, daily activity.
    await db.into(db.profiles).insert(
          ProfilesCompanion.insert(
            nickname: 'Anna',
            avatarId: 1,
            languagePair: 'it_hu',
          ),
        );
    await db.into(db.wordProgress).insert(
          WordProgressCompanion(
            pairId: const Value('it_hu'),
            wordId: const Value(7),
            status: const Value(WordStatus.memorized),
            memorizedAt: Value(DateTime.now()),
          ),
        );
    await db.into(db.usageSentences).insert(
          UsageSentencesCompanion.insert(
            pairId: 'it_hu',
            wordId: 7,
            sentence: 'una frase',
            createdAt: DateTime.now(),
          ),
        );
    await db.into(db.dailyActivity).insert(
          DailyActivityCompanion.insert(
            date: '2026-07-15',
            memorizedCount: const Value(1),
          ),
        );

    await db.clearLocalData();

    expect(await db.select(db.profiles).get(), isEmpty);
    expect(await db.select(db.wordProgress).get(), isEmpty);
    expect(await db.select(db.usageSentences).get(), isEmpty);
    expect(await db.select(db.dailyActivity).get(), isEmpty);
  });
}
