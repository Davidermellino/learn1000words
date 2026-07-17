import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/language_providers.dart';
import '../../data/models/language_pair.dart';
import '../../data/progress_provider.dart';
import '../../l10n/app_localizations.dart';

/// The memorized words (prompt + answer), searchable, with the total count.
/// Without [level] it is the global "Parole conosciute" tab; with [level]
/// it is the per-level list opened from Level Detail.
class KnownWordsScreen extends ConsumerStatefulWidget {
  const KnownWordsScreen({super.key, this.level});

  /// When set, only this level's memorized words are shown.
  final int? level;

  @override
  ConsumerState<KnownWordsScreen> createState() => _KnownWordsScreenState();
}

class _KnownWordsScreenState extends ConsumerState<KnownWordsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordsProvider);
    final memorizedAsync = ref.watch(memorizedWordIdsProvider);
    final pair = ref.watch(activePairProvider);
    final l10n = AppLocalizations.of(context);

    final level = widget.level;
    final title = level == null
        ? l10n.knownWordsTitle
        : l10n.knownWordsTitleLevel(level);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Builder(
        builder: (context) {
          final error = wordsAsync.error ?? memorizedAsync.error;
          if (error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.wordsLoadError(error)),
              ),
            );
          }
          if (!wordsAsync.hasValue || !memorizedAsync.hasValue ||
              pair == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final memorizedIds = memorizedAsync.requireValue;
          final known = wordsAsync.requireValue
              .where((word) =>
                  memorizedIds.contains(word.id) &&
                  (level == null || word.level == level))
              .toList()
            ..sort((a, b) => a.id.compareTo(b.id));

          final query = _query.trim().toLowerCase();
          final visible = query.isEmpty
              ? known
              : known
                  .where((word) =>
                      word.source.toLowerCase().contains(query) ||
                      word.target.toLowerCase().contains(query))
                  .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: l10n.searchWordHint,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    query.isEmpty
                        ? l10n.knownWordsCount(known.length)
                        : l10n.knownWordsFiltered(visible.length, known.length),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: known.isEmpty
                    ? const _EmptyView()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final word = visible[index];
                          final textTheme = Theme.of(context).textTheme;
                          final scheme = Theme.of(context).colorScheme;
                          return ListTile(
                            title: Text(
                              word.promptFor(pair),
                              style: textTheme.bodyLarge?.copyWith(
                                fontFamily: AppFonts.mono,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              word.answerFor(pair),
                              style: textTheme.bodyMedium?.copyWith(
                                fontFamily: AppFonts.mono,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: Text(
                              l10n.levelAbbr(word.level),
                              style: textTheme.bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noWordsMemorizedYet,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
