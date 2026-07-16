import '../../core/constants/app_constants.dart';

/// A single vocabulary pair from a bundled language file. [source] and
/// [target] are the two sides exactly as written in the file (the file's
/// declared `source`/`target` languages); which one is prompted vs. answered
/// is decided per learning direction — see `WordDirection`.
class Word {
  const Word({
    required this.id,
    required this.level,
    required this.source,
    required this.target,
  });

  final int id;

  /// Level 1–[AppConstants.levelCount] this word belongs to.
  final int level;

  /// The file's source-language side of the pair.
  final String source;

  /// The file's target-language side of the pair.
  final String target;

  /// Parses and validates one entry of a language file's `words` array.
  ///
  /// Throws a [FormatException] describing the offending entry when a field
  /// is missing, has the wrong type, is empty, or the level is out of range.
  factory Word.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final level = json['level'];
    final source = json['source'];
    final target = json['target'];

    if (id is! int) {
      throw FormatException('Word entry has missing/non-int "id": $json');
    }
    if (level is! int || level < 1 || level > AppConstants.levelCount) {
      throw FormatException(
        'Word id=$id has invalid "level" (expected 1–${AppConstants.levelCount}): $level',
      );
    }
    if (source is! String || source.trim().isEmpty) {
      throw FormatException('Word id=$id has missing/empty "source" field');
    }
    if (target is! String || target.trim().isEmpty) {
      throw FormatException('Word id=$id has missing/empty "target" field');
    }

    return Word(id: id, level: level, source: source, target: target);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'source': source,
        'target': target,
      };

  @override
  String toString() =>
      'Word(id: $id, level: $level, source: $source, target: $target)';
}
