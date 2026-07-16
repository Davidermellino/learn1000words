import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/language_providers.dart';
import '../../../data/models/language_pair.dart';

/// Step 3: pick which language pair to learn, from the pairs discovered in
/// `assets/words/`. A two-step, Duolingo-style flow — first the source
/// language (deduplicated), then a target that actually pairs with it. Every
/// label comes from the files; nothing about a language is hardcoded.
class LanguagePairStep extends ConsumerStatefulWidget {
  const LanguagePairStep({
    super.key,
    required this.selectedPairId,
    required this.onSelected,
  });

  final String? selectedPairId;
  final ValueChanged<String> onSelected;

  @override
  ConsumerState<LanguagePairStep> createState() => _LanguagePairStepState();
}

class _LanguagePairStepState extends ConsumerState<LanguagePairStep> {
  /// The source picked in step 1; `null` means step 1 is showing. Not the
  /// final selection — the pair id is only reported once a target is chosen.
  String? _sourceCode;

  @override
  Widget build(BuildContext context) {
    final pairsAsync = ref.watch(languagePairsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: pairsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text(
          'Errore nel caricamento delle lingue:\n$error',
          textAlign: TextAlign.center,
        ),
        data: (pairs) {
          if (pairs.isEmpty) {
            return const Text(
              'Nessuna lingua disponibile.',
              textAlign: TextAlign.center,
            );
          }
          // Resolve which step to show. If a pair is already selected (e.g. the
          // user came back to this step) start on its source's target list.
          final activeSource = _sourceCode ??
              _sourceOfSelectedPair(pairs, widget.selectedPairId);
          return activeSource == null
              ? _buildSourceStep(context, pairs)
              : _buildTargetStep(context, pairs, activeSource);
        },
      ),
    );
  }

  /// Step 1: the deduplicated source languages.
  Widget _buildSourceStep(
    BuildContext context,
    List<LanguagePairInfo> pairs,
  ) {
    final sources = pairs.distinctSources();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Da quale lingua vuoi partire?',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        for (final source in sources) ...[
          Card(
            child: ListTile(
              title: Text(source.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => setState(() => _sourceCode = source.code),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  /// Step 2: the targets paired with [sourceCode]. Always shown, even when a
  /// single target is available, for a consistent flow.
  Widget _buildTargetStep(
    BuildContext context,
    List<LanguagePairInfo> pairs,
    String sourceCode,
  ) {
    final targets = pairs.withSource(sourceCode);
    final sourceName = targets.first.promptName;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _sourceCode = null),
            icon: const Icon(Icons.arrow_back),
            label: Text(sourceName),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Quale lingua vuoi imparare?',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        RadioGroup<String>(
          groupValue: widget.selectedPairId,
          onChanged: (value) {
            if (value != null) widget.onSelected(value);
          },
          child: Column(
            children: [
              for (final pair in targets) ...[
                RadioListTile<String>(
                  title: Text(pair.answerName),
                  value: pair.pairId,
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// The source (prompt) code of the currently selected pair, if any — used to
  /// land back on step 2 when the user returns to this step.
  String? _sourceOfSelectedPair(
    List<LanguagePairInfo> pairs,
    String? selectedPairId,
  ) {
    if (selectedPairId == null) return null;
    for (final pair in pairs) {
      if (pair.pairId == selectedPairId) return pair.promptCode;
    }
    return null;
  }
}
