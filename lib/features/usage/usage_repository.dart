import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../data/language_providers.dart';

/// Saves and reads the sentences written in the Usage mode. Ungraded by
/// design: rows keep the raw sentence and its target word (scoped to the
/// language pair) so a future LLM grader can score them later.
class UsageRepository {
  UsageRepository(this._db);

  final AppDatabase _db;

  Future<void> saveSentence({
    required String pairId,
    required int wordId,
    required String sentence,
  }) {
    return _db.into(_db.usageSentences).insert(
          UsageSentencesCompanion.insert(
            pairId: pairId,
            wordId: wordId,
            sentence: sentence,
            createdAt: DateTime.now(),
          ),
        );
  }

  /// Saved sentences for [pairId], newest first.
  Stream<List<UsageSentenceRow>> watchSentences(String pairId) {
    final query = _db.select(_db.usageSentences)
      ..where((row) => row.pairId.equals(pairId))
      ..orderBy([
        (row) => OrderingTerm.desc(row.createdAt),
        (row) => OrderingTerm.desc(row.id),
      ]);
    return query.watch();
  }
}

final usageRepositoryProvider = Provider<UsageRepository>(
  (ref) => UsageRepository(ref.watch(appDatabaseProvider)),
);

/// The active pair's saved usage sentences, newest first, reactively
/// streamed. Empty while the active pair is still resolving.
final usageSentencesProvider = StreamProvider<List<UsageSentenceRow>>((ref) {
  final pair = ref.watch(activePairProvider);
  if (pair == null) return Stream.value(const []);
  return ref.watch(usageRepositoryProvider).watchSentences(pair.pairId);
});
