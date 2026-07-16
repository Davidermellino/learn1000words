import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/word_status.dart';

part 'app_database.g.dart';

/// Placeholder key-value table so the P0 schema is non-empty.
/// Real tables (progress, known words, streaks, …) arrive in later phases.
class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Single local-only user profile row. Populated by onboarding.
///
/// [remoteUserId], [memorizedCount] and [currentLevel] are placeholders for
/// the Supabase-backed sync arriving in Phase 5 — unused until then.
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nickname => text()();
  IntColumn get avatarId => integer()();

  /// The active learning pair's stable id (e.g. `it_hu`), discovered from a
  /// bundled language file — never an enum, so new languages need no schema
  /// change. Progress is keyed by this + wordId.
  TextColumn get languagePair => text()();
  IntColumn get dailyGoal => integer().withDefault(const Constant(10))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  TextColumn get remoteUserId => text().nullable()();
  IntColumn get memorizedCount => integer().withDefault(const Constant(0))();
  IntColumn get currentLevel => integer().withDefault(const Constant(1))();
  IntColumn get reminderHour => integer().withDefault(const Constant(19))();
  IntColumn get reminderMinute => integer().withDefault(const Constant(0))();
}

/// Per-word learning progress, keyed by (pairId, wordId): the same word id
/// tracked independently per language pair. One row per (pair, word) the user
/// has interacted with; absence of a row means the word is still untouched
/// ("learning").
///
/// [pairId] is a [LanguagePairInfo.pairId] and [wordId] a word id in that
/// pair's bundled file (neither is a Drift table, so no foreign key).
@DataClassName('WordProgressRow')
class WordProgress extends Table {
  TextColumn get pairId => text()();
  IntColumn get wordId => integer()();
  TextColumn get status => textEnum<WordStatus>()
      .withDefault(Constant(WordStatus.learning.name))();
  DateTimeColumn get memorizedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {pairId, wordId};
}

/// A sentence the user wrote in the Usage mode. Ungraded for now: the raw
/// sentence plus its target word are kept so a future LLM grader can score
/// them retroactively.
@DataClassName('UsageSentenceRow')
class UsageSentences extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// The language pair (a [LanguagePairInfo.pairId]) the sentence was written
  /// under; the history is scoped to the active pair.
  TextColumn get pairId => text()();

  /// Id of the word (in the pair's bundled file) the sentence had to use.
  IntColumn get wordId => integer()();

  TextColumn get sentence => text().named('text')();
  DateTimeColumn get createdAt => dateTime()();
}

/// One row per local calendar day the user memorized at least one word.
/// Backs the daily-goal progress and the streak.
@DataClassName('DailyActivityRow')
class DailyActivity extends Table {
  /// Local calendar day as `yyyy-MM-dd`.
  TextColumn get date => text()();

  IntColumn get memorizedCount => integer().withDefault(const Constant(0))();
  BoolColumn get goalMet => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {date};
}

@DriftDatabase(
  tables: [AppMeta, Profiles, WordProgress, UsageSentences, DailyActivity],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'learn1000words'));

  /// In-memory / custom-executor constructor for unit tests.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 5;

  /// Wipes all on-device user data — profile, per-word progress, usage
  /// sentences and daily activity — in one transaction. Called on sign-out so
  /// the next account starts from a clean slate (no stale profile or progress
  /// leaking across accounts). The signed-out user loses nothing that matters:
  /// their data lives on in the cloud and is restored on the next login (see
  /// AccountLinker.restoreIfReturning). Sync bookkeeping in [appMeta] is reset
  /// separately by SyncService.clearSyncState.
  Future<void> clearLocalData() {
    return transaction(() async {
      await delete(wordProgress).go();
      await delete(usageSentences).go();
      await delete(dailyActivity).go();
      await delete(profiles).go();
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 4) {
            // Pre-v5 shapes are all superseded by the data-driven languages
            // rework below; nothing before v4 is worth stepping through.
          }
          if (from < 5) {
            // Data-driven languages re-keys word_progress to (pairId, wordId)
            // and adds pair_id to usage_sentences. Old test data is
            // expendable (see the P8 objective): wipe and recreate rather
            // than migrate. This also covers any partial pre-v4 schema.
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
            }
            await m.createAll();
          }
        },
      );
}

/// Overridden in `main()` with the single app-wide instance.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw StateError('appDatabaseProvider must be overridden in main'),
);
