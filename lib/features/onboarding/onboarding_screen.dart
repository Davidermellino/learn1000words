import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/account_linker.dart';
import '../profile/profile_repository.dart';
import 'widgets/avatar_step.dart';
import 'widgets/daily_goal_step.dart';
import 'widgets/language_pair_step.dart';
import 'widgets/nickname_step.dart';

/// First-run onboarding: nickname → avatar → language pair → daily goal.
/// Reached only after sign-in (the router gates it behind a session). Writes
/// the local profile row, links it to the signed-in account (nickname claim
/// for a new account, cloud restore for a returning one), then routes to Home.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _nicknameController = TextEditingController();

  int _page = 0;
  int? _avatarId;
  String? _languagePairId;
  int _dailyGoal = 10;
  bool _submitting = false;

  static const _stepCount = 4;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_page) {
      case 0:
        return isValidNickname(_nicknameController.text);
      case 1:
        return _avatarId != null;
      case 2:
        return _languagePairId != null;
      default:
        return true;
    }
  }

  void _goNext() {
    if (_page < _stepCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    setState(() => _submitting = true);
    final repo = ref.read(profileRepositoryProvider);
    await repo.createProfile(
      nickname: _nicknameController.text.trim(),
      avatarId: _avatarId!,
      languagePairId: _languagePairId!,
      dailyGoal: _dailyGoal,
    );
    ref.invalidate(profileProvider);
    await ref.read(profileProvider.future);

    // The user signed in before onboarding, so link the just-created local
    // profile to the account now: claim the nickname (new account) or restore
    // the existing cloud profile (returning account). This is what sets
    // remoteUserId so progress syncs — without it the sync service refuses to
    // push. `linker` is null only in an unconfigured build, which can never
    // reach onboarding (the gate needs a session).
    final linker = ref.read(accountLinkerProvider);
    if (linker != null && !await _linkAccount(linker)) {
      // The user abandoned the flow during a nickname conflict; abortLink
      // signed them out, so the router will send them back to sign-in.
      if (mounted) setState(() => _submitting = false);
      return;
    }

    if (mounted) context.go('/');
  }

  /// Claims the nickname / restores the cloud profile after sign-in, prompting
  /// for a different nickname on a uniqueness conflict. Returns false only
  /// when the user gives up on the conflict (which aborts the sign-in).
  Future<bool> _linkAccount(AccountLinker linker) async {
    var result = await linker.linkSignedInUser();
    while (result == LinkResult.nicknameTaken) {
      final nickname = await _promptNickname();
      if (nickname == null) {
        await linker.abortLink();
        return false;
      }
      result = await linker.claimNickname(nickname);
    }
    return true;
  }

  /// Asks for a different nickname after a uniqueness conflict. Returns `null`
  /// when the user gives up.
  Future<String?> _promptNickname() async {
    final controller = TextEditingController();
    try {
      return await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            title: const Text('Nickname già in uso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Questo nickname è già stato scelto da qualcun altro. '
                  'Scegline un altro:',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLength: 20,
                  onChanged: (_) => setDialogState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Annulla'),
              ),
              FilledButton(
                onPressed: isValidNickname(controller.text)
                    ? () => Navigator.of(
                        dialogContext,
                      ).pop(controller.text.trim())
                    : null,
                child: const Text('Conferma'),
              ),
            ],
          ),
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _stepCount; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _page
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  Center(
                    child: NicknameStep(
                      controller: _nicknameController,
                      errorText: nicknameErrorText(_nicknameController.text),
                    ),
                  ),
                  Center(
                    child: AvatarStep(
                      selectedAvatarId: _avatarId,
                      onSelected: (id) => setState(() => _avatarId = id),
                    ),
                  ),
                  Center(
                    child: LanguagePairStep(
                      selectedPairId: _languagePairId,
                      onSelected: (pairId) =>
                          setState(() => _languagePairId = pairId),
                    ),
                  ),
                  Center(
                    child: DailyGoalStep(
                      selected: _dailyGoal,
                      onSelected: (goal) => setState(() => _dailyGoal = goal),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_page > 0)
                    TextButton(
                      onPressed: _submitting ? null : _goBack,
                      child: const Text('Indietro'),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: (_canProceed && !_submitting) ? _goNext : null,
                    child: Text(_page == _stepCount - 1 ? 'Fine' : 'Avanti'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
