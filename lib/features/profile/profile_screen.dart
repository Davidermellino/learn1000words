import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/locale/locale_controller.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/error_messages.dart';
import '../../core/widgets/language_button.dart';
import '../../data/language_providers.dart';
import '../../data/models/language_pair.dart';
import '../../data/progress_writer.dart';
import '../../data/supabase/supabase_providers.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.noProfileYet));
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
            Center(child: Text(friendlyErrorMessage(l10n, error))),
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
            Text(AppLocalizations.of(context)
                .memorizedWordsCount(profile.memorizedCount)),
            Text(AppLocalizations.of(context)
                .currentLevelLabel(profile.currentLevel)),
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
        title: Text(AppLocalizations.of(context).languageTileTitle),
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

  /// Step 1 dialog: the deduplicated source languages, as flag + name buttons.
  /// Every source is always selectable — tapping the currently active source
  /// simply proceeds to step 2. Returns the chosen source code, or `null` if
  /// dismissed.
  Future<String?> _pickSource(
    BuildContext context,
    List<LanguagePairInfo> pairs,
    String? activeSourceCode,
  ) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(AppLocalizations.of(dialogContext).pickSourceLanguage),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          // Bounded + scrollable: up to 17 languages no longer fit
          // unscrolled inside a SimpleDialog's fixed content area.
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final source in pairs.distinctSources()) ...[
                    LanguageButton(
                      code: source.code,
                      name: source.name,
                      selected: source.code == activeSourceCode,
                      onPressed: () =>
                          Navigator.of(dialogContext).pop(source.code),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Step 2 dialog: the targets paired with the chosen source, as flag + name
  /// buttons. Always shown, even for a single target. Tapping the active pair
  /// is a harmless no-op (the caller ignores it). Returns the chosen pair id,
  /// or `null`.
  Future<String?> _pickTarget(
    BuildContext context,
    List<LanguagePairInfo> targets,
    String? activePairId,
  ) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(AppLocalizations.of(dialogContext).pickTargetLanguage),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          // Bounded + scrollable: same overflow risk as the source-step
          // dialog once a source pairs with many targets.
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final pair in targets) ...[
                    LanguageButton(
                      code: pair.answerCode,
                      name: pair.answerName,
                      selected: pair.pairId == activePairId,
                      onPressed: () =>
                          Navigator.of(dialogContext).pop(pair.pairId),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
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
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(l10n.account),
              subtitle: Text(user?.email ?? l10n.accountLinked),
              trailing: TextButton(
                onPressed: () => _confirmSignOut(context, ref),
                child: Text(l10n.signOut),
              ),
            ),
            const Divider(height: 1, indent: 24, endIndent: 24),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              leading: Icon(Icons.delete_forever_outlined,
                  color: theme.colorScheme.error),
              title: Text(
                l10n.deleteAccount,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              subtitle: Text(l10n.deleteAccountSubtitle),
              onTap: () => _confirmDeleteAccount(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.signOut),
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
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAccountConfirmTitle),
        content: Text(l10n.deleteAccountConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteAccountConfirmButton),
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
      // Do NOT manually pop the spinner here: signOut() above already
      // triggers the router's auth redirect, which replaces the entire
      // navigator stack (dialog included) before this line can run. Popping
      // manually races that teardown and throws a lifecycle assertion
      // ('element._lifecycleState == _ElementLifecycle.inactive').
    } catch (error) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      messenger.showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(l10n, error))),
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
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.todayLabel,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(
              l10n.todaySummary(count, profile.dailyGoal, profile.streak),
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
              Text(l10n.goalReached),
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
    final l10n = AppLocalizations.of(context);
    // The explicit UI-language override (null = follow the device locale).
    final localeOverride = ref.watch(localeControllerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.settingsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(l10n.dailyGoalLabel),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: [
                for (final goal in _goalChoices)
                  ButtonSegment(
                      value: goal, label: Text(l10n.goalWordsSegment(goal))),
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
              title: Text(l10n.reminderTitle),
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language_outlined),
              title: Text(l10n.appLanguageTitle),
              // Own-language name of the choice, or "System default" when unset.
              subtitle: Text(
                localeOverride == null
                    ? l10n.systemDefaultLanguage
                    : kNativeLanguageNames[localeOverride.languageCode] ??
                        localeOverride.languageCode,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickAppLanguage(context, ref, localeOverride),
            ),
          ],
        ),
      ),
    );
  }

  /// Lets the user override the UI language: "System default" (follow the
  /// device locale) plus each supported language by its own name. Applying a
  /// choice updates the whole app immediately and persists it. Dismissing the
  /// dialog changes nothing.
  Future<void> _pickAppLanguage(
    BuildContext context,
    WidgetRef ref,
    Locale? current,
  ) async {
    final l10n = AppLocalizations.of(context);
    // Returns a Locale for a language, `_LangChoice.system` for the default
    // option, or null when dismissed (so "System default" is distinguishable
    // from a dismissal).
    final choice = await showDialog<Object>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(l10n.appLanguageTitle),
        children: [
          _LanguageOption(
            label: l10n.systemDefaultLanguage,
            selected: current == null,
            onTap: () =>
                Navigator.of(dialogContext).pop(_LangChoice.system),
          ),
          for (final locale in kSupportedLocales)
            _LanguageOption(
              label: kNativeLanguageNames[locale.languageCode] ??
                  locale.languageCode,
              selected: current?.languageCode == locale.languageCode,
              onTap: () => Navigator.of(dialogContext).pop(locale),
            ),
        ],
      ),
    );
    if (choice == null) return;
    final locale = choice is Locale ? choice : null;
    await ref.read(localeControllerProvider.notifier).setLocale(locale);
  }
}

/// Sentinel popped by the "System default" row of the language picker, so it
/// is distinguishable from dismissing the dialog (which returns null).
enum _LangChoice { system }

/// One row of the app-language picker: a language name with a leading check
/// when it is the active choice. Matches the app's SimpleDialog option style.
class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SimpleDialogOption(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check : null,
              size: 20,
              color: scheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
