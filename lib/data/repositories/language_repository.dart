import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../models/language_pair.dart';
import '../models/word.dart';

/// Discovers and validates the bundled language files, turning each into its
/// two selectable [LanguagePairInfo] directions.
///
/// Discovery is fully data-driven: every `*.json` under
/// [AppConstants.wordsAssetFolder] is found at runtime via [AssetManifest],
/// so adding a language is just dropping a file in that folder. A malformed
/// file is skipped with a logged error — it never crashes the app.
class LanguageRepository {
  const LanguageRepository();

  /// All selectable pairs across every valid bundled file, sorted by label so
  /// onboarding/switcher order is stable. Two pairs per valid file.
  Future<List<LanguagePairInfo>> discoverPairs() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) =>
            p.startsWith(AppConstants.wordsAssetFolder) && p.endsWith('.json'))
        .toList()
      ..sort();

    final pairs = <LanguagePairInfo>[];
    for (final path in paths) {
      try {
        final raw = await rootBundle.loadString(path);
        pairs.addAll(parseLanguageFile(raw));
      } catch (error) {
        // A single bad file must not take the app down: skip it, keep the
        // rest. (Missing keys, wrong types, missing levels, dup ids, …)
        debugPrint('Skipping malformed language file "$path": $error');
      }
    }

    pairs.sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    return pairs;
  }

  /// Parses and validates one language file's contents, returning its forward
  /// and reversed pairs. Throws a [FormatException] on any problem (missing
  /// keys, wrong types, a missing level, duplicate ids, …). Pure — no asset
  /// I/O — so it is unit-testable in isolation.
  static List<LanguagePairInfo> parseLanguageFile(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected a top-level JSON object');
    }

    final source = decoded['source'];
    final target = decoded['target'];
    final sourceName = decoded['sourceName'];
    final targetName = decoded['targetName'];
    final version = decoded['version'];
    final rawWords = decoded['words'];

    String nonEmpty(Object? value, String key) {
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Missing/empty "$key"');
      }
      return value.trim();
    }

    final src = nonEmpty(source, 'source');
    final tgt = nonEmpty(target, 'target');
    final srcName = nonEmpty(sourceName, 'sourceName');
    final tgtName = nonEmpty(targetName, 'targetName');
    if (version is! int) {
      throw const FormatException('Missing/non-int "version"');
    }
    if (src == tgt) {
      throw FormatException('"source" and "target" are the same ("$src")');
    }
    if (rawWords is! List) {
      throw const FormatException('Missing "words" array');
    }

    final words = <Word>[];
    final seenIds = <int>{};
    for (final entry in rawWords) {
      if (entry is! Map<String, dynamic>) {
        throw FormatException('Expected a JSON object per word, got: $entry');
      }
      final word = Word.fromJson(entry);
      if (!seenIds.add(word.id)) {
        throw FormatException('Duplicate word id: ${word.id}');
      }
      words.add(word);
    }

    final counts = countByLevel(words);
    for (var level = 1; level <= AppConstants.levelCount; level++) {
      if ((counts[level] ?? 0) == 0) {
        throw FormatException('Level $level has no words');
      }
    }

    return [
      LanguagePairInfo(
        pairId: '${src}_$tgt',
        promptCode: src,
        answerCode: tgt,
        promptName: srcName,
        answerName: tgtName,
        reversed: false,
        words: words,
      ),
      LanguagePairInfo(
        pairId: '${tgt}_$src',
        promptCode: tgt,
        answerCode: src,
        promptName: tgtName,
        answerName: srcName,
        reversed: true,
        words: words,
      ),
    ];
  }

  /// Number of words per level, keyed by level (1–10).
  static Map<int, int> countByLevel(List<Word> words) {
    final counts = <int, int>{};
    for (final word in words) {
      counts[word.level] = (counts[word.level] ?? 0) + 1;
    }
    return counts;
  }
}

final languageRepositoryProvider =
    Provider<LanguageRepository>((ref) => const LanguageRepository());
