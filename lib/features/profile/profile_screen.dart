import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/error_messages.dart';
import '../../data/language_providers.dart';
import '../../data/models/language_pair.dart';
import '../../data/progress_writer.dart';
import '../../data/supabase/supabase_providers.dart';
import '../auth/account_deleter.dart';
import '../auth/account_linker.dart';
import 'avatar_view.dart';
import 'profile_repository.dart';
import 'streak_provider.dart';

/// Allowed daily goals (words newly memorized per day).
const _goalChoices = [5, 10, 20];

/// Profile view: identity card, today's goal progress + streak, and the
/// gamification settings (daily goal, reminder time).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profilo')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Nessun profilo ancora.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _IdentityCard(profile: profile),
              const SizedBox(height: 16),
              _LanguageCard(profile: profile),
              const SizedBox(height: 16),
              const _AccountCard(),
              _TodayCard(profile: profile),
              const SizedBox(height: 16),
              _SettingsCard(profile: profile),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text(friendlyErrorMessage(error))),
      ),
    );
  }
}

class _IdentityCard extends ConsumerWidget {
  const _IdentityCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Label from the active pair's file; fall back to the raw id while the
    // pairs are still discovering (or if the stored id is unknown).
    final label =
        ref.watch(activePairProvider)?.label ?? profile.languagePair;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AvatarView(avatarId: profile.avatarId, size: 80),
            const SizedBox(height: 16),
            Text(
              profile.nickname,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(label),
            const SizedBox(height: 8),
            Text('Parole memorizzate: ${profile.memorizedCount}'),
            Text('Livello attuale: ${profile.currentLevel}'),
          ],
        ),
      ),
    );
  }
}

/// Lets the user switch the active language pair. Progress is per pair, so
/// switching back restores the other pair's progress untouched.
class _LanguageCard extends ConsumerWidget {
  const _LanguageCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pairs = ref.watch(languagePairsProvider).valueOrNull ?? const [];
    final active = ref.watch(activePairProvider);

    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: const Icon(Icons.translate),
        title: const Text('Lingua'),
        subtitle: Text(active?.label ?? profile.languagePair),
        trailing: const Icon(Icons.chevron_right),
        // Only offer a switch when there is more than one pair to choose from.
        onTap: pairs.length < 2
            ? null
            : () => _pickLanguage(context, ref, pairs, active?.pairId),
      ),
    );
  }

  /// Two-step, Duolingo-style switch: pick the source language, then a target
  /// that actually pairs with it. Step 2 is always shown, even for a single
  /// available target. Every label comes from the files.
  Future<void> _pickLanguage(
    BuildContext context,
    WidgetRef ref,
    List<LanguagePairInfo> pairs,
    String? activePairId,
  ) async {
    // Step 1: source language.
    final activeSource = _sourceOfPair(pairs, activePairId);
    final sourceCode = await _pickSource(context, pairs, activeSource);
    if (sourceCode == null || !context.mounted) return;

    // Step 2: a target paired with the chosen source.
    final targets = pairs.withSource(sourceCode);
    final chosenId = await _pickTarget(context, targets, activePairId);
    if (chosenId == null || chosenId == activePairId) return;
    final chosen = pairs.firstWhere((p) => p.pairId == chosenId);

    await ref.read(profileRepositoryProvider).updateLanguagePair(chosen.pairId);
    // Refresh the profile's per-pair aggregates for the newly active pair.
    await ref
        .read(progressWriterProvider)
        .refreshProfileForPair(chosen.pairId, chosen.words);
  }

  /// Step 1 dialog: the deduplicated source languages. Returns the chosen
  /// source code, or `null` if dismissed.
  Future<String?> _pickSource(
    BuildContext context,
    List<LanguagePairInfo> pairs,
    String? activeSourceCode,
  ) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Da quale lingua vuoi partire?'),
        children: [
          RadioGroup<String>(
            groupValue: activeSourceCode,
            onChanged: (value) {
              if (value != null) Navigator.of(dialogContext).pop(value);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final source in pairs.distinctSources())
                  RadioListTile<String>(
                    value: source.code,
                    title: Text(source.name),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Step 2 dialog: the targets paired with the chosen source. Always shown,
  /// even for a single target. Returns the chosen pair id, or `null`.
  Future<String?> _pickTarget(
    BuildContext context,
    List<LanguagePairInfo> targets,
    String? activePairId,
  ) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Quale lingua vuoi imparare?'),
        children: [
          RadioGroup<String>(
            groupValue: activePairId,
            onChanged: (value) {
              if (value != null) Navigator.of(dialogContext).pop(value);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final pair in targets)
                  RadioListTile<String>(
                    value: pair.pairId,
                    title: Text(pair.answerName),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The source (prompt) code of [pairId] among [pairs], or `null` — used to
  /// pre-select the source in step 1.
  String? _sourceOfPair(List<LanguagePairInfo> pairs, String? pairId) {
    if (pairId == null) return null;
    for (final pair in pairs) {
      if (pair.pairId == pairId) return pair.promptCode;
    }
    return null;
  }
}

/// Account row: the signed-in email and a sign-out action. Sign-in is
/// mandatory, so there is no signed-out state to handle here — signing out
/// returns to the registration screen via the router's auth gate. Hidden only
/// when the build has no Supabase configuration.
class _AccountCard extends ConsumerWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(supabaseClientProvider) == null) {
      return const SizedBox.shrink();
    }
    final user = ref.watch(currentUserProvider);

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Account'),
              subtitle: Text(user?.email ?? 'Account collegato'),
              trailing: TextButton(
                onPressed: () => _confirmSignOut(context, ref),
                child: const Text('Esci'),
              ),
            ),
            const Divider(height: 1, indent: 24, endIndent: 24),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              leading: Icon(Icons.delete_forever_outlined,
                  color: theme.colorScheme.error),
              title: Text(
                'Elimina account',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              subtitle: const Text(
                'Rimuove definitivamente il tuo account e tutti i dati.',
              ),
              onTap: () => _confirmDeleteAccount(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Uscire dall’account?'),
        content: const Text(
          'I dati su questo dispositivo verranno rimossi. I tuoi progressi '
          'restano al sicuro nel cloud e vengono ripristinati al prossimo '
          'accesso.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Esci'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final linker = ref.read(accountLinkerProvider);
    if (linker != null) await linker.signOutAndUnlink();
  }

  /// Immediate, irreversible account deletion. The dialog spells that out; on
  /// confirm the edge function wipes all cloud data and the auth user, then the
  /// local data is cleared and the session ends — the router's auth gate then
  /// sends the user back to the registration screen.
  Future<void> _confirmDeleteAccount(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminare l’account?'),
        content: const Text(
          'Questa azione è immediata e irreversibile. Il tuo account, i tuoi '
          'progressi e tutti i dati associati verranno eliminati '
          'definitivamente dal cloud e da questo dispositivo. Non è possibile '
          'annullare né recuperare i dati.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Elimina definitivamente'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final deleter = ref.read(accountDeleterProvider);
    if (deleter == null || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    // Block interaction while the deletion runs (a network round-trip).
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await deleter.deleteAccount();
      // The router redirects to /auth on the now-empty session; just dismiss
      // the progress spinner. (Guard for the async gap.)
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    } catch (error) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      messenger.showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(error))),
      );
    }
  }
}

/// Today's progress toward the goal and the current streak.
class _TodayCard extends ConsumerWidget {
  const _TodayCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayActivityProvider).valueOrNull;
    final count = today?.memorizedCount ?? 0;
    final goalMet = today?.goalMet ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Oggi', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(
              '$count/${profile.dailyGoal} parole oggi · '
              '🔥 serie di ${profile.streak} '
              '${profile.streak == 1 ? 'giorno' : 'giorni'}',
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: profile.dailyGoal == 0
                  ? 0
                  : (count / profile.dailyGoal).clamp(0, 1).toDouble(),
              minHeight: 10,
              borderRadius: BorderRadius.circular(6),
              color: AppTokens.of(context).highlighter,
              backgroundColor: AppTokens.of(context).hairline,
            ),
            if (goalMet) ...[
              const SizedBox(height: 12),
              const Text('Obiettivo raggiunto! 🎉'),
            ],
          ],
        ),
      ),
    );
  }
}

/// Daily goal (5/10/20) and reminder-time settings.
class _SettingsCard extends ConsumerWidget {
  const _SettingsCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderTime = TimeOfDay(
      hour: profile.reminderHour,
      minute: profile.reminderMinute,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Impostazioni',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            const Text('Obiettivo giornaliero'),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: [
                for (final goal in _goalChoices)
                  ButtonSegment(value: goal, label: Text('$goal parole')),
              ],
              selected: {
                // A legacy/custom goal keeps the UI consistent by snapping
                // the highlight to the nearest choice; saving picks exact.
                _goalChoices.contains(profile.dailyGoal)
                    ? profile.dailyGoal
                    : _goalChoices.first,
              },
              onSelectionChanged: (selection) => ref
                  .read(profileRepositoryProvider)
                  .updateDailyGoal(selection.first),
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Promemoria giornaliero'),
              subtitle: Text(reminderTime.format(context)),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: reminderTime,
                );
                if (picked == null) return;
                await ref.read(profileRepositoryProvider).updateReminderTime(
                      hour: picked.hour,
                      minute: picked.minute,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
