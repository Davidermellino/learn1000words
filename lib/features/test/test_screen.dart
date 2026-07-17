import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/utils/answer_match.dart';
import '../../data/language_providers.dart';
import '../../data/models/language_pair.dart';
import '../../data/models/word.dart';
import '../../data/progress_provider.dart';
import '../../data/progress_writer.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/segmented_answer_field.dart';

/// Test for one level: the not-yet-memorized words one at a time, answered
/// in a segmented per-letter field. A fully correct answer (case-insensitive,
/// accents strict) marks the word memorized; a wrong one shows the solution
/// and leaves the word in the pool for the next run.
class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key, required this.level});

  final int level;

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  /// Snapshot of the words to test, taken once when data is first available
  /// so marking words memorized mid-run doesn't reshuffle the sequence.
  List<Word>? _pool;

  int _index = 0;
  int _correctCount = 0;
  List<String> _typed = const [];

  /// Per-letter results of the checked answer, null while typing.
  List<bool>? _results;

  void _initPool(List<Word> words, Set<int> memorizedIds) {
    _pool = words
        .where((word) =>
            word.level == widget.level && !memorizedIds.contains(word.id))
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    _index = 0;
    _correctCount = 0;
    _typed = const [];
    _results = null;
  }

  Future<void> _check(
    Word word,
    AnswerTemplate template,
    LanguagePairInfo pair,
    List<Word> pairWords,
  ) async {
    final results = matchLetterCells(template, _typed);
    final correct = results.every((matches) => matches);
    setState(() => _results = results);
    if (correct) {
      _correctCount++;
      await ref.read(progressWriterProvider).markMemorized(
            pairId: pair.pairId,
            wordId: word.id,
            pairWords: pairWords,
          );
    }
  }

  void _advance() {
    setState(() {
      _index++;
      _typed = const [];
      _results = null;
    });
  }

  void _retry() {
    setState(() => _pool = null);
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordsProvider);
    final memorizedAsync = ref.watch(memorizedWordIdsProvider);
    final pair = ref.watch(activePairProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.testTitle(widget.level))),
      body: Builder(
        builder: (context) {
          final error = wordsAsync.error ?? memorizedAsync.error;
          if (error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.testLoadError(error)),
              ),
            );
          }
          if (!wordsAsync.hasValue || !memorizedAsync.hasValue ||
              pair == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_pool == null) {
            _initPool(wordsAsync.requireValue, memorizedAsync.requireValue);
          }
          final pool = _pool!;

          if (pool.isEmpty) {
            return const _AllMemorizedView();
          }
          if (_index >= pool.length) {
            return _SummaryView(
              correct: _correctCount,
              total: pool.length,
              onRetry: _retry,
            );
          }

          final word = pool[_index];
          final template = AnswerTemplate.fromTarget(word.answerFor(pair));
          return _QuestionView(
            // Fresh field/typing state per word.
            key: ValueKey(word.id),
            prompt: word.promptFor(pair),
            template: template,
            index: _index,
            total: pool.length,
            results: _results,
            onChanged: (typed) => setState(() => _typed = typed),
            onCheck: _typed.length == template.letterCount
                ? () => _check(word, template, pair, wordsAsync.requireValue)
                : null,
            onAdvance: _advance,
          );
        },
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    super.key,
    required this.prompt,
    required this.template,
    required this.index,
    required this.total,
    required this.results,
    required this.onChanged,
    required this.onCheck,
    required this.onAdvance,
  });

  final String prompt;
  final AnswerTemplate template;
  final int index;
  final int total;

  /// Null while answering; per-letter correctness once checked.
  final List<bool>? results;

  final ValueChanged<List<String>> onChanged;

  /// Null while the answer is incomplete (disables the check button).
  final VoidCallback? onCheck;

  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final checked = results != null;
    final correct = checked && results!.every((matches) => matches);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${index + 1} / $total',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontFamily: AppFonts.mono,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            prompt,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(fontFamily: AppFonts.mono),
          ),
          const SizedBox(height: 32),
          SegmentedAnswerField(
            template: template,
            enabled: !checked,
            autofocus: true,
            cellResults: results,
            onChanged: onChanged,
            onSubmitted: () => onCheck?.call(),
          ),
          const SizedBox(height: 24),
          if (checked) ...[
            correct
                ? const _CorrectBanner()
                : Column(
                    children: [
                      Text(
                        l10n.answerWrong,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium
                            ?.copyWith(color: colorScheme.error),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: l10n.correctAnswerPrefix),
                            TextSpan(
                              text: template.target,
                              style: const TextStyle(
                                fontFamily: AppFonts.mono,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onAdvance,
              child: Text(l10n.next),
            ),
          ] else
            FilledButton(
              onPressed: onCheck,
              child: Text(l10n.check),
            ),
        ],
      ),
    );
  }
}

/// Success feedback: "Corretto" marked with the amber highlighter behind the
/// ink — the app's one use of amber, made literal.
class _CorrectBanner extends StatelessWidget {
  const _CorrectBanner();

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: tokens.highlighter,
          borderRadius: BorderRadius.circular(AppRadii.small),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, size: 20, color: tokens.onHighlighter),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).answerCorrect,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: tokens.onHighlighter,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// End-of-run summary; the wrong words are still in the pool next time.
class _SummaryView extends StatelessWidget {
  const _SummaryView({
    required this.correct,
    required this.total,
    required this.onRetry,
  });

  final int correct;
  final int total;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allDone = correct == total;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              allDone ? Icons.emoji_events : Icons.flag,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.testCompleted,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.testScore(correct, total),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!allDone)
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.retryRemaining),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.backToLevel),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when every word of the level is already memorized.
class _AllMemorizedView extends StatelessWidget {
  const _AllMemorizedView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.levelCompleted,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.allWordsMemorized,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.backToLevel),
            ),
          ],
        ),
      ),
    );
  }
}
