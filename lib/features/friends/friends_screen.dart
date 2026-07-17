import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/error_messages.dart';
import '../../data/language_providers.dart';
import '../../data/models/language_pair.dart';
import '../../data/repositories/friends_repository.dart';
import '../../l10n/app_localizations.dart';
import '../profile/avatar_view.dart';
import 'friends_providers.dart';

/// Friends tab: nickname search, incoming requests, and the accepted-friends
/// list. Requires a signed-in Supabase session; shows a sign-in prompt
/// otherwise (mirroring the account card on the Profile tab).
class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshAll() {
    ref.invalidate(friendsListProvider);
    ref.invalidate(incomingRequestsProvider);
    ref.invalidate(outgoingPendingIdsProvider);
  }

  Future<void> _runGuarded(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context);
    try {
      await action();
      _refreshAll();
    } catch (error) {
      debugPrint('Friends: action failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(l10n, error))),
      );
    }
  }

  Future<void> _sendRequest(PublicProfile target) {
    final l10n = AppLocalizations.of(context);
    return _runGuarded(() async {
      await ref.read(friendsRepositoryProvider)!.sendRequest(target.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.requestSentTo(target.nickname))),
      );
    });
  }

  Future<void> _respond(IncomingRequest request, {required bool accept}) {
    final l10n = AppLocalizations.of(context);
    return _runGuarded(() async {
      await ref
          .read(friendsRepositoryProvider)!
          .respondToRequest(request.requestId, accept: accept);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(accept
              ? l10n.nowFriendsWith(request.sender.nickname)
              : l10n.requestRejected),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = ref.watch(friendsRepositoryProvider) != null;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).navFriends)),
      body: signedIn ? _buildBody(context) : const _SignInPrompt(),
    );
  }

  Widget _buildBody(BuildContext context) {
    final query = ref.watch(friendSearchQueryProvider).trim();
    final requests =
        ref.watch(incomingRequestsProvider).valueOrNull ?? const [];
    final l10n = AppLocalizations.of(context);

    return RefreshIndicator(
      onRefresh: () async => _refreshAll(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.searchByNickname,
              border: const OutlineInputBorder(),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref
                            .read(friendSearchQueryProvider.notifier)
                            .state = '';
                      },
                    ),
            ),
            onChanged: (value) =>
                ref.read(friendSearchQueryProvider.notifier).state = value,
          ),
          if (query.length >= 2) ...[
            const SizedBox(height: 16),
            _SearchResults(onAdd: _sendRequest),
          ],
          if (requests.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.receivedRequests,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final request in requests)
              Card(
                child: ListTile(
                  leading: AvatarView(
                    avatarId: request.sender.avatarId,
                    size: 40,
                  ),
                  title: Text(request.sender.nickname),
                  subtitle: Text(l10n.wantsToBeFriend),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        color: Theme.of(context).colorScheme.primary,
                        tooltip: l10n.accept,
                        onPressed: () => _respond(request, accept: true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel_outlined),
                        tooltip: l10n.reject,
                        onPressed: () => _respond(request, accept: false),
                      ),
                    ],
                  ),
                ),
              ),
          ],
          const SizedBox(height: 24),
          Text(
            l10n.yourFriends,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const _FriendsList(),
        ],
      ),
    );
  }
}

/// Shown when Supabase is unconfigured or the user is signed out.
class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).signInToFindFriends,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.pushNamed('auth'),
              child: Text(AppLocalizations.of(context).logIn),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline error state with a friendly message and a retry button; keeps raw
/// exception text (socket dumps, stack-ish messages) out of the UI.
class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(friendlyErrorMessage(AppLocalizations.of(context), error)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }
}

/// Nickname search results with a context-aware action per row.
class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.onAdd});

  final Future<void> Function(PublicProfile) onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(friendSearchResultsProvider);
    final friendIds = {
      for (final friend in
          ref.watch(friendsListProvider).valueOrNull ?? const <FriendProfile>[])
        friend.id,
    };
    final sentIds =
        ref.watch(outgoingPendingIdsProvider).valueOrNull ?? const <String>{};
    final receivedIds = {
      for (final request in ref.watch(incomingRequestsProvider).valueOrNull ??
          const <IncomingRequest>[])
        request.sender.id,
    };

    return resultsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _ErrorRetry(
        error: error,
        onRetry: () => ref.invalidate(friendSearchResultsProvider),
      ),
      data: (results) {
        if (results.isEmpty) {
          return Text(AppLocalizations.of(context).noUsersFound);
        }
        final l10n = AppLocalizations.of(context);
        return Column(
          children: [
            for (final result in results)
              Card(
                child: ListTile(
                  leading: AvatarView(avatarId: result.avatarId, size: 40),
                  title: Text(result.nickname),
                  trailing: _actionFor(l10n, result, friendIds, sentIds,
                      receivedIds),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _actionFor(
    AppLocalizations l10n,
    PublicProfile result,
    Set<String> friendIds,
    Set<String> sentIds,
    Set<String> receivedIds,
  ) {
    if (friendIds.contains(result.id)) {
      return Text(l10n.alreadyFriends);
    }
    if (sentIds.contains(result.id)) {
      return Text(l10n.requestSentLabel);
    }
    // A pending request FROM them exists; adding accepts it (see
    // FriendsRepository.sendRequest).
    final label = receivedIds.contains(result.id) ? l10n.accept : l10n.add;
    return FilledButton.tonal(
      onPressed: () => onAdd(result),
      child: Text(label),
    );
  }
}

/// The accepted-friends list; each row shows the aggregate progress friends
/// are allowed to see, and tapping opens a larger detail sheet.
class _FriendsList extends ConsumerWidget {
  const _FriendsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pairs = ref.watch(languagePairsProvider).valueOrNull ?? const [];
    final l10n = AppLocalizations.of(context);

    return ref.watch(friendsListProvider).when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => _ErrorRetry(
            error: error,
            onRetry: () => ref.invalidate(friendsListProvider),
          ),
          data: (friends) {
            if (friends.isEmpty) {
              return Text(l10n.noFriendsYet);
            }
            return Column(
              children: [
                for (final friend in friends)
                  Card(
                    child: ListTile(
                      leading: AvatarView(avatarId: friend.avatarId, size: 40),
                      title: Text(friend.nickname),
                      subtitle: Text(
                        l10n.friendSummary(
                          _pairLabel(pairs, friend.languagePairId),
                          friend.currentLevel,
                          friend.memorizedCount,
                        ),
                      ),
                      onTap: () => _showFriendSheet(context, friend, pairs),
                    ),
                  ),
              ],
            );
          },
        );
  }

  /// The friend's active-pair label from the local discovered files, falling
  /// back to the raw id if this build doesn't ship that language.
  String _pairLabel(List<LanguagePairInfo> pairs, String pairId) {
    for (final pair in pairs) {
      if (pair.pairId == pairId) return pair.label;
    }
    return pairId;
  }

  void _showFriendSheet(
    BuildContext context,
    FriendProfile friend,
    List<LanguagePairInfo> pairs,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext);
        return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarView(avatarId: friend.avatarId, size: 80),
            const SizedBox(height: 16),
            Text(
              friend.nickname,
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(_pairLabel(pairs, friend.languagePairId)),
            const SizedBox(height: 4),
            Text(l10n.currentLevelLabel(friend.currentLevel)),
            const SizedBox(height: 4),
            Text(l10n.memorizedWordsCount(friend.memorizedCount)),
            const SizedBox(height: 16),
          ],
        ),
        );
      },
    );
  }
}
