import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../data/progress_provider.dart';
import '../../l10n/app_localizations.dart';
import '../profile/widgets/daily_progress_badge.dart';
import 'widgets/level_card.dart';

/// Levels overview: a grid of 10 cards with memorized-word progress and
/// sequential locking driven by [levelsProgressProvider].
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProgressProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: const [DailyProgressBadge()],
      ),
      body: levelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.levelsLoadError(error)),
          ),
        ),
        data: (levels) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: levels.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final progress = levels[index];
            return LevelCard(
              progress: progress,
              onTap: () {
                if (progress.unlocked) {
                  context.goNamed(
                    'level',
                    pathParameters: {'level': '${progress.level}'},
                  );
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.completeLevelFirst(progress.level - 1),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
