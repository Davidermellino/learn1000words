import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/language_providers.dart';
import '../../data/models/language_pair.dart';
import '../../data/models/word.dart';
import '../../data/progress_provider.dart';
import '../../l10n/app_localizations.dart';
import 'usage_repository.dart';

/// Usage mode for one level: shows a random memorized word and lets the user
/// write a sentence with it. Sentences are saved as-is — no correctness
/// check for now; an LLM grader arrives in a later phase.
class UsageScreen extends ConsumerStatefulWidget {
  const UsageScreen({super.key, required this.level});

  final int level;

  @override
  ConsumerState<UsageScreen> createState() => _UsageScreenState();
}

class _UsageScreenState extends ConsumerState<UsageScreen> {
  final _random = Random();
  final _controller = TextEditingController();

  /// Id of the word currently shown; picked lazily once data is available.
  int? _wordId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Random word of the pool, avoiding an immediate repeat when possible.
  int _pickWordId(List<Word> pool) {
    if (pool.length == 1) return pool.first.id;
    while (true) {
      final id = pool[_random.nextInt(pool.length)].id;
      if (id != _wordId) return id;
    }
  }

  void _nextWord(List<Word> pool) {
    setState(() {
      _wordId = _pickWordId(pool);
      _controller.clear();
    });
  }

  Future<void> _save(Word word, String pairId) async {
    final sentence = _controller.text.trim();
    if (sentence.isEmpty) return;
    await ref
        .read(usageRepositoryProvider)
        .saveSentence(pairId: pairId, wordId: word.id, sentence: sentence);
    if (!mounted) return;
    _controller.clear();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).sentenceSaved),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordsProvider);
    final memorizedAsync = ref.watch(memorizedWordIdsProvider);
    final pair = ref.watch(activePairProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.usageTitle(widget.level)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: l10n.yourSentences,
            onPressed: () => context.goNamed(
              'usage-history',
              pathParameters: {'level': '${widget.level}'},
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final error = wordsAsync.error ?? memorizedAsync.error;
          if (error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.loadErrorGeneric(error)),
              ),
            );
          }
          if (!wordsAsync.hasValue || !memorizedAsync.hasValue ||
              pair == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final memorizedIds = memorizedAsync.requireValue;
          final pool = wordsAsync.requireValue
              .where((word) =>
                  word.level == widget.level && memorizedIds.contains(word.id))
              .toList();

          if (pool.isEmpty) {
            return const _NoMemorizedWordsView();
          }

          _wordId ??= _pickWordId(pool);
          final word = pool.firstWhere(
            (w) => w.id == _wordId,
            orElse: () => pool.first,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  word.answerFor(pair),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontFamily: AppFonts.mono),
                ),
                const SizedBox(height: 4),
                Text(
                  word.promptFor(pair),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: AppFonts.mono,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  minLines: 3,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: l10n.writeSentenceHint,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _controller.text.trim().isEmpty
                      ? null
                      : () => _save(word, pair.pairId),
                  child: Text(l10n.done),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _nextWord(pool),
                  icon: const Icon(Icons.shuffle),
                  label: Text(l10n.anotherWord),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shown when the level has no memorized words to practice yet.
class _NoMemorizedWordsView extends StatelessWidget {
  const _NoMemorizedWordsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_note,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noMemorizedInLevel,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).backToLevel),
            ),
          ],
        ),
      ),
    );
  }
}
