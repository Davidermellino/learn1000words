import 'word.dart';

/// One selectable learning direction, discovered from a bundled language file.
///
/// Every file yields TWO of these — a forward pair (file source → file target)
/// and a reversed one (file target → file source). Everything user-facing
/// (names, label) comes from the file; nothing about a language is hardcoded
/// in Dart. The stable [pairId] (e.g. `it_hu`, `hu_it`) is what progress and
/// the profile are keyed by.
class LanguagePairInfo {
  const LanguagePairInfo({
    required this.pairId,
    required this.promptCode,
    required this.answerCode,
    required this.promptName,
    required this.answerName,
    required this.reversed,
    required this.words,
  });

  /// Stable id `"{promptCode}_{answerCode}"`, e.g. `it_hu` / `hu_it`.
  final String pairId;

  /// Language code shown as the prompt (e.g. `it`).
  final String promptCode;

  /// Language code the user answers in (e.g. `hu`).
  final String answerCode;

  /// Display name of the prompt language (e.g. `Italiano`).
  final String promptName;

  /// Display name of the answer language (e.g. `Magyar`).
  final String answerName;

  /// True when this is the file's target → source direction, so a [Word]'s
  /// `target` is the prompt and its `source` is the answer.
  final bool reversed;

  /// The pair's words, shared with the file's other direction (unresolved —
  /// prompt/answer are picked via [reversed], see `WordDirection`).
  final List<Word> words;

  /// Onboarding / switcher label, e.g. `Italiano → Magyar`. From the file.
  String get label => '$promptName → $answerName';
}

/// Picks the prompt/answer side of a [Word] for a given pair direction.
extension WordDirection on Word {
  String promptFor(LanguagePairInfo pair) => pair.reversed ? target : source;

  String answerFor(LanguagePairInfo pair) => pair.reversed ? source : target;
}

/// A distinct source language for the first step of the two-step selector,
/// de-duplicated from the discovered pairs by [LanguagePairInfo.promptCode].
/// Its [name] comes straight from a pair (the file) — nothing hardcoded.
class SourceLanguage {
  const SourceLanguage({required this.code, required this.name});

  /// The source language code — a pair's [LanguagePairInfo.promptCode].
  final String code;

  /// Display name shown in step 1 — a pair's [LanguagePairInfo.promptName].
  final String name;
}

/// Two-step selection derived purely from already-discovered pairs; it never
/// touches how pairs are discovered, parsed, or validated.
extension LanguagePairSelection on List<LanguagePairInfo> {
  /// The distinct source languages across these pairs, de-duplicated by
  /// [LanguagePairInfo.promptCode] and kept in this list's order (so the first
  /// name seen for a code wins). Step 1 of the two-step selector.
  List<SourceLanguage> distinctSources() {
    final seen = <String>{};
    final sources = <SourceLanguage>[];
    for (final pair in this) {
      if (seen.add(pair.promptCode)) {
        sources.add(
          SourceLanguage(code: pair.promptCode, name: pair.promptName),
        );
      }
    }
    return sources;
  }

  /// The pairs whose source (prompt) language is [sourceCode], in this list's
  /// order — the targets offered for a chosen source. Step 2 of the selector.
  List<LanguagePairInfo> withSource(String sourceCode) =>
      where((pair) => pair.promptCode == sourceCode).toList();
}
