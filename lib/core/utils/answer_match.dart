/// Characters of a target answer that render as fixed, non-editable
/// separators in the segmented answer field. Everything else is a letter
/// the user must type.
const Set<String> answerSeparators = {' ', '-', "'", '’'};

/// One position of a segmented answer: either a letter the user types or a
/// fixed separator shown in place.
class AnswerSlot {
  const AnswerSlot({required this.char, required this.isLetter});

  /// The target character at this position (lettercase as in the dataset).
  final String char;

  /// True for typed cells, false for fixed separators.
  final bool isLetter;
}

/// A target answer split into per-character slots, driving both the segmented
/// input field and the per-letter comparison.
class AnswerTemplate {
  AnswerTemplate._(this.target, this.slots);

  /// Splits [target] (trimmed) into one slot per character, marking spaces,
  /// hyphens and apostrophes as fixed separators.
  ///
  /// Splits by UTF-16 code unit, which is exact for the Italian/Hungarian
  /// dataset: all its letters (including á é í ó ö ő ú ü ű) are single
  /// precomposed code units.
  factory AnswerTemplate.fromTarget(String target) {
    final trimmed = target.trim();
    final slots = [
      for (final char in trimmed.split(''))
        AnswerSlot(char: char, isLetter: !answerSeparators.contains(char)),
    ];
    return AnswerTemplate._(trimmed, slots);
  }

  /// The trimmed target answer.
  final String target;

  final List<AnswerSlot> slots;

  /// Number of cells the user actually types (separators excluded).
  int get letterCount => slots.where((slot) => slot.isLetter).length;

  /// The target letters in order, separators excluded.
  List<String> get letters => [
        for (final slot in slots)
          if (slot.isLetter) slot.char,
      ];
}

/// Compares each typed cell to the corresponding target letter of
/// [template]: case-insensitive, accent-strict (no normalization or accent
/// stripping, so "a" never matches "á").
///
/// Returns one bool per letter cell. Missing or empty cells count as wrong.
List<bool> matchLetterCells(AnswerTemplate template, List<String> typed) {
  final targets = template.letters;
  return [
    for (var i = 0; i < targets.length; i++)
      i < typed.length &&
          typed[i].isNotEmpty &&
          typed[i].toLowerCase() == targets[i].toLowerCase(),
  ];
}

/// True iff every letter cell of [typed] matches [template] per
/// [matchLetterCells].
bool isAnswerCorrect(AnswerTemplate template, List<String> typed) =>
    matchLetterCells(template, typed).every((matches) => matches);
