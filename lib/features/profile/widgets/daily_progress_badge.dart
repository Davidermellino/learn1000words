import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile_repository.dart';
import '../streak_provider.dart';

/// Compact "7/10 · 🔥 4" badge with today's memorized-word progress and the
/// current streak. Shown in the Home app bar; renders nothing until a
/// profile exists.
class DailyProgressBadge extends ConsumerWidget {
  const DailyProgressBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).valueOrNull;
    if (profile == null) return const SizedBox.shrink();
    final today = ref.watch(todayActivityProvider).valueOrNull;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: Text(
          '${today?.memorizedCount ?? 0}/${profile.dailyGoal} · '
          '🔥 ${profile.streak}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
