import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/profile/profile_repository.dart';
import 'models/language_pair.dart';
import 'repositories/language_repository.dart';

/// Every selectable language pair discovered in `assets/words/`, loaded once
/// per app run. Two pairs per valid file; malformed files are skipped.
final languagePairsProvider = FutureProvider<List<LanguagePairInfo>>(
  (ref) => ref.watch(languageRepositoryProvider).discoverPairs(),
);

/// The profile's active pair, resolved against the discovered list. `null`
/// while either the pairs or the profile are still loading, or when the
/// stored pairId is no longer available (falls back to the first pair so the
/// app stays usable).
final activePairProvider = Provider<LanguagePairInfo?>((ref) {
  final pairs = ref.watch(languagePairsProvider).valueOrNull;
  final profile = ref.watch(profileProvider).valueOrNull;
  if (pairs == null || pairs.isEmpty || profile == null) return null;
  for (final pair in pairs) {
    if (pair.pairId == profile.languagePair) return pair;
  }
  return pairs.first;
});
