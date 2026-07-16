import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/friends_repository.dart';

/// Runs a Supabase-backed read for the Friends tab, logging failures — e.g. an
/// offline auth token-refresh (`AuthRetryableFetchException` / `Failed host
/// lookup`) — to the debug console before rethrowing. Callers turn the
/// rethrown error into a friendly retry state via [friendlyErrorMessage]; this
/// log keeps the real cause visible to developers without surfacing it to the
/// user.
Future<T> _loggedRead<T>(String label, Future<T> Function() read) async {
  try {
    return await read();
  } catch (error) {
    debugPrint('Friends: $label failed: $error');
    rethrow;
  }
}

/// Accepted friends with their level + memorized count.
final friendsListProvider =
    FutureProvider.autoDispose<List<FriendProfile>>((ref) {
  final repo = ref.watch(friendsRepositoryProvider);
  if (repo == null) return const [];
  return _loggedRead('fetchFriends', repo.fetchFriends);
});

/// Pending requests addressed to the current user.
final incomingRequestsProvider =
    FutureProvider.autoDispose<List<IncomingRequest>>((ref) {
  final repo = ref.watch(friendsRepositoryProvider);
  if (repo == null) return const [];
  return _loggedRead('fetchIncomingRequests', repo.fetchIncomingRequests);
});

/// Ids the current user has already sent a pending request to; used to mark
/// search results as "request sent".
final outgoingPendingIdsProvider =
    FutureProvider.autoDispose<Set<String>>((ref) {
  final repo = ref.watch(friendsRepositoryProvider);
  if (repo == null) return const <String>{};
  return _loggedRead('fetchOutgoingPendingIds', repo.fetchOutgoingPendingIds);
});

/// The live nickname search text (set by the search field).
final friendSearchQueryProvider =
    StateProvider.autoDispose<String>((ref) => '');

/// Search results for [friendSearchQueryProvider]. Debounced: a keystroke
/// rebuilds this provider, and the 300 ms pause means abandoned queries never
/// hit the network.
final friendSearchResultsProvider =
    FutureProvider.autoDispose<List<PublicProfile>>((ref) async {
  final repo = ref.watch(friendsRepositoryProvider);
  final query = ref.watch(friendSearchQueryProvider).trim();
  if (repo == null || query.length < 2) return const [];

  var disposed = false;
  ref.onDispose(() => disposed = true);
  await Future<void>.delayed(const Duration(milliseconds: 300));
  if (disposed) return const [];

  return _loggedRead('searchByNickname', () => repo.searchByNickname(query));
});
