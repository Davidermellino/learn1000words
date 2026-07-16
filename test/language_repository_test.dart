import 'package:flutter_test/flutter_test.dart';
import 'package:learn1000words/data/models/language_pair.dart';
import 'package:learn1000words/data/repositories/language_repository.dart';

/// A well-formed file body with one word on every level (10 levels).
String validFile({
  String source = 'it',
  String target = 'hu',
  String sourceName = 'Italiano',
  String targetName = 'Magyar',
}) {
  final words = [
    for (var level = 1; level <= 10; level++)
      '{ "id": $level, "level": $level, "source": "s$level", "target": "t$level" }',
  ].join(',\n');
  return '''
{
  "source": "$source",
  "target": "$target",
  "sourceName": "$sourceName",
  "targetName": "$targetName",
  "version": 1,
  "words": [ $words ]
}
''';
}

void main() {
  group('parseLanguageFile', () {
    test('yields two directions per file, labelled from the file', () {
      final pairs = LanguageRepository.parseLanguageFile(validFile());

      expect(pairs.map((p) => p.pairId), ['it_hu', 'hu_it']);

      final forward = pairs[0];
      expect(forward.reversed, isFalse);
      expect(forward.label, 'Italiano → Magyar');
      expect(forward.promptCode, 'it');
      expect(forward.answerCode, 'hu');

      final reverse = pairs[1];
      expect(reverse.reversed, isTrue);
      expect(reverse.label, 'Magyar → Italiano');
      // Both directions share the same underlying word list.
      expect(reverse.words, same(forward.words));
      expect(forward.words, hasLength(10));
    });

    test('resolves prompt/answer sides by direction', () {
      final pairs = LanguageRepository.parseLanguageFile(validFile());
      final word = pairs[0].words.first; // source "s1", target "t1"

      expect(word.promptFor(pairs[0]), 's1'); // forward: source is the prompt
      expect(word.answerFor(pairs[0]), 't1');
      expect(word.promptFor(pairs[1]), 't1'); // reversed: target is the prompt
      expect(word.answerFor(pairs[1]), 's1');
    });

    test('rejects a missing level', () {
      // Drop level 10 by only emitting 9 levels.
      final words = [
        for (var level = 1; level <= 9; level++)
          '{ "id": $level, "level": $level, "source": "s", "target": "t" }',
      ].join(',');
      final raw =
          '{ "source": "it", "target": "hu", "sourceName": "I", '
          '"targetName": "M", "version": 1, "words": [ $words ] }';

      expect(
        () => LanguageRepository.parseLanguageFile(raw),
        throwsFormatException,
      );
    });

    test('rejects duplicate ids', () {
      final words = [
        for (var level = 1; level <= 10; level++)
          // Same id (1) on every entry.
          '{ "id": 1, "level": $level, "source": "s", "target": "t" }',
      ].join(',');
      final raw =
          '{ "source": "it", "target": "hu", "sourceName": "I", '
          '"targetName": "M", "version": 1, "words": [ $words ] }';

      expect(
        () => LanguageRepository.parseLanguageFile(raw),
        throwsFormatException,
      );
    });

    test('rejects missing top-level keys', () {
      expect(
        () => LanguageRepository.parseLanguageFile('{ "words": [] }'),
        throwsFormatException,
      );
    });

    test('rejects source == target', () {
      expect(
        () => LanguageRepository.parseLanguageFile(
          validFile(source: 'it', target: 'it'),
        ),
        throwsFormatException,
      );
    });
  });

  group('two-step selection', () {
    // Two files sharing the source "it": it→hu, it→es (plus their reverses).
    final pairs = [
      ...LanguageRepository.parseLanguageFile(validFile()), // it_hu / hu_it
      ...LanguageRepository.parseLanguageFile(
        validFile(target: 'es', targetName: 'Español'),
      ), // it_es / es_it
    ];

    test('distinctSources dedupes by source code, first name wins', () {
      final sources = pairs.distinctSources();

      // "it" is the source of two pairs but appears once; order is preserved.
      expect(sources.map((s) => s.code), ['it', 'hu', 'es']);
      expect(
        sources.singleWhere((s) => s.code == 'it').name,
        'Italiano',
      );
    });

    test('withSource returns only the pairs sharing that source', () {
      // "it" pairs with both targets.
      final fromIt = pairs.withSource('it');
      expect(fromIt.map((p) => p.pairId), ['it_hu', 'it_es']);
      expect(fromIt.map((p) => p.answerName), ['Magyar', 'Español']);

      // A source with a single target still yields a (one-item) list.
      expect(pairs.withSource('hu').map((p) => p.pairId), ['hu_it']);
      expect(pairs.withSource('zz'), isEmpty);
    });
  });
}
