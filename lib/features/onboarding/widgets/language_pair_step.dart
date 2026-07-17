import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/language_button.dart';
import '../../../data/language_providers.dart';
import '../../../data/models/language_pair.dart';
import '../../../l10n/app_localizations.dart';

/// Step 3: pick which language pair to learn, from the pairs discovered in
/// `assets/words/`. A two-step, Duolingo-style flow — first the source
/// language (deduplicated), then a target that actually pairs with it. Both
/// steps render as flag + name buttons. Every label comes from the files;
/// nothing about a language is hardcoded.
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

  /// True once the user has explicitly gone back to step 1. Without this, a
  /// preselected pair would keep resolving to its source and trap the flow on
  /// step 2 — the back control could never return to the source list.
  bool _onSourceStep = false;

  @override
  Widget build(BuildContext context) {
    final pairsAsync = ref.watch(languagePairsProvider);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: pairsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text(
          l10n.languagesLoadError(error),
          textAlign: TextAlign.center,
        ),
        data: (pairs) {
          if (pairs.isEmpty) {
            return Text(
              l10n.noLanguagesAvailable,
              textAlign: TextAlign.center,
            );
          }
          // Resolve which step to show. If a pair is already selected (e.g. the
          // user came back to this step) start on its source's target list —
          // unless the user has explicitly returned to the source step.
          final activeSource = _onSourceStep
              ? null
              : _sourceCode ??
                  _sourceOfSelectedPair(pairs, widget.selectedPairId);
          // Scrollable: the button list (up to 17 languages) can exceed the
          // fixed height given by the parent PageView, which does not scroll
          // on its own (NeverScrollableScrollPhysics).
          return SingleChildScrollView(
            child: activeSource == null
                ? _buildSourceStep(context, pairs)
                : _buildTargetStep(context, pairs, activeSource),
          );
        },
      ),
    );
  }

  /// Step 1: the deduplicated source languages, as flag + name buttons. Every
  /// source is always selectable — re-picking the currently active source just
  /// proceeds to step 2 as normal.
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
          AppLocalizations.of(context).pickSourceLanguage,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        for (final source in sources) ...[
          LanguageButton(
            code: source.code,
            name: source.name,
            onPressed: () => setState(() {
              _sourceCode = source.code;
              _onSourceStep = false;
            }),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  /// Step 2: the targets paired with [sourceCode], as flag + name buttons.
  /// Always shown, even when a single target is available, for a consistent
  /// flow. The currently selected pair is drawn as active.
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
            onPressed: () => setState(() {
              _sourceCode = null;
              _onSourceStep = true;
            }),
            icon: const Icon(Icons.arrow_back),
            label: Text(sourceName),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).pickTargetLanguage,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        for (final pair in targets) ...[
          LanguageButton(
            code: pair.answerCode,
            name: pair.answerName,
            selected: pair.pairId == widget.selectedPairId,
            onPressed: () => widget.onSelected(pair.pairId),
          ),
          const SizedBox(height: 8),
        ],
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
