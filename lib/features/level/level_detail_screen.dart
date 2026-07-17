import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/progress_provider.dart';
import '../../l10n/app_localizations.dart';

/// Detail of one level: progress header + the menu of learning modes.
/// Mode bodies are stubs until their phases land (P3 flashcards, …).
class LevelDetailScreen extends ConsumerWidget {
  const LevelDetailScreen({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(levelProgressProvider(level));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.levelTitle(level))),
      body: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.levelLoadError(error)),
          ),
        ),
        data: (progress) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ProgressHeader(progress: progress),
            const SizedBox(height: 16),
            _ModeTile(
              icon: Icons.style_outlined,
              title: l10n.modeFlashcardsTitle,
              subtitle: l10n.modeFlashcardsSubtitle,
              routeName: 'flashcards',
              level: level,
            ),
            _ModeTile(
              icon: Icons.quiz_outlined,
              title: l10n.modeTestTitle,
              subtitle: l10n.modeTestSubtitle,
              routeName: 'test',
              level: level,
            ),
            _ModeTile(
              icon: Icons.chat_bubble_outline,
              title: l10n.modeUsageTitle,
              subtitle: l10n.modeUsageSubtitle,
              routeName: 'usage',
              level: level,
            ),
            _ModeTile(
              icon: Icons.check_circle_outline,
              title: l10n.knownWordsTitle,
              subtitle: l10n.modeKnownSubtitle,
              routeName: 'level-known',
              level: level,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.progress});

  final LevelProgress progress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final tokens = AppTokens.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${progress.memorizedWords}',
                  style: textTheme.displaySmall,
                ),
                Text(
                  ' / ${progress.totalWords}',
                  style: textTheme.titleMedium?.copyWith(
                    fontFamily: AppFonts.mono,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context).memorizedWordsCaption,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // The bar measures known words, so it is the one place a level's
            // amber lives outside the Home stack.
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress.fraction,
                minHeight: 10,
                color: tokens.highlighter,
                backgroundColor: tokens.hairline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routeName,
    required this.level,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.goNamed(
          routeName,
          pathParameters: {'level': '$level'},
        ),
      ),
    );
  }
}
