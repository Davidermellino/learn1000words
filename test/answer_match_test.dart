import 'package:flutter_test/flutter_test.dart';

import 'package:learn1000words/core/utils/answer_match.dart';

void main() {
  group('AnswerTemplate.fromTarget', () {
    test('single word yields one letter slot per character', () {
      final template = AnswerTemplate.fromTarget('ház');

      expect(template.slots, hasLength(3));
      expect(template.slots.every((slot) => slot.isLetter), isTrue);
      expect(template.letters, ['h', 'á', 'z']);
      expect(template.letterCount, 3);
    });

    test('multi-word target places a fixed space separator', () {
      final template = AnswerTemplate.fromTarget('jó reggelt');

      expect(template.slots, hasLength(10));
      expect(template.slots[2].isLetter, isFalse);
      expect(template.slots[2].char, ' ');
      expect(template.letterCount, 9);
      expect(template.letters, ['j', 'ó', 'r', 'e', 'g', 'g', 'e', 'l', 't']);
    });

    test('hyphens and apostrophes are fixed separators', () {
      expect(
        AnswerTemplate.fromTarget('e-mail').slots[1].isLetter,
        isFalse,
      );
      expect(
        AnswerTemplate.fromTarget("l'acqua").slots[1].isLetter,
        isFalse,
      );
    });

    test('surrounding whitespace is trimmed', () {
      final template = AnswerTemplate.fromTarget('  ház ');

      expect(template.target, 'ház');
      expect(template.letterCount, 3);
    });
  });

  group('matchLetterCells / isAnswerCorrect', () {
    test('"Ház" typed for target "ház" passes (case-insensitive)', () {
      final template = AnswerTemplate.fromTarget('ház');

      expect(isAnswerCorrect(template, ['H', 'á', 'z']), isTrue);
      expect(matchLetterCells(template, ['H', 'á', 'z']),
          [true, true, true]);
    });

    test('"haz" typed for target "ház" fails on the accent', () {
      final template = AnswerTemplate.fromTarget('ház');

      expect(isAnswerCorrect(template, ['h', 'a', 'z']), isFalse);
      expect(matchLetterCells(template, ['h', 'a', 'z']),
          [true, false, true]);
    });

    test('uppercase accented letters still match case-insensitively', () {
      final template = AnswerTemplate.fromTarget('Ő');

      expect(isAnswerCorrect(template, ['ő']), isTrue);
    });

    test('"jó reggelt" checks only the 9 letters around the fixed space', () {
      final template = AnswerTemplate.fromTarget('jó reggelt');
      final typed = ['j', 'ó', 'r', 'e', 'g', 'g', 'e', 'l', 't'];

      expect(typed, hasLength(template.letterCount));
      expect(isAnswerCorrect(template, typed), isTrue);
      expect(matchLetterCells(template, typed), everyElement(isTrue));
    });

    test('missing or empty cells count as wrong', () {
      final template = AnswerTemplate.fromTarget('ház');

      expect(matchLetterCells(template, ['h']), [true, false, false]);
      expect(matchLetterCells(template, ['h', '', 'z']),
          [true, false, true]);
      expect(isAnswerCorrect(template, []), isFalse);
    });

    test('one wrong letter fails the whole answer', () {
      final template = AnswerTemplate.fromTarget('jó reggelt');
      final typed = ['j', 'ó', 'r', 'e', 'g', 'g', 'e', 'l', 'd'];

      expect(isAnswerCorrect(template, typed), isFalse);
      expect(matchLetterCells(template, typed).last, isFalse);
    });
  });
}
