import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:learn1000words/data/repositories/friends_repository.dart';
import 'package:learn1000words/features/friends/friends_screen.dart';

/// The exception thrown by supabase when the device is offline and the
/// expired access token cannot be refreshed (the P5 friends-tab bug).
final _offlineError = AuthRetryableFetchException(
  message: "ClientException with SocketException: Failed host lookup: "
      "'zybxqvorynbvpaabywvd.supabase.co'",
);

/// A stand-in [FriendsRepository] that behaves like the real one with no
/// connectivity, and can be flipped back "online" to test the retry button.
///
/// It `implements` (not `extends`) the repository so the test needs no real
/// [SupabaseClient]: a real client starts an auth auto-refresh timer and a
/// background JSON isolate whose disposal never completes inside a fake-async
/// widget test, hanging it until the 10-minute timeout.
class _FakeFriendsRepository implements FriendsRepository {
  bool offline = true;

  @override
  Future<List<PublicProfile>> searchByNickname(String query) async {
    if (offline) throw _offlineError;
    return const [];
  }

  @override
  Future<List<FriendProfile>> fetchFriends() async {
    if (offline) throw _offlineError;
    return const [];
  }

  @override
  Future<List<IncomingRequest>> fetchIncomingRequests() async {
    if (offline) throw _offlineError;
    return const [];
  }

  @override
  Future<Set<String>> fetchOutgoingPendingIds() async {
    if (offline) throw _offlineError;
    return const {};
  }

  @override
  Future<void> sendRequest(String toUserId) async {
    if (offline) throw _offlineError;
  }

  @override
  Future<void> respondToRequest(String requestId, {required bool accept}) async {
    if (offline) throw _offlineError;
  }
}

void main() {
  testWidgets('friends screen shows friendly message + retry when offline',
      (tester) async {
    final repo = _FakeFriendsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [friendsRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: FriendsScreen()),
      ),
    );
    await tester.pump();

    const friendlyMessage =
        'Impossibile contattare il server. Controlla la connessione e riprova.';

    // Friends list failed: friendly message, no raw exception dump.
    expect(find.text(friendlyMessage), findsOneWidget);
    expect(find.text('Riprova'), findsOneWidget);
    expect(find.textContaining('AuthRetryableFetchException'), findsNothing);
    expect(find.textContaining('SocketException'), findsNothing);

    // Searching while offline shows a second friendly error, still no dump.
    await tester.enterText(find.byType(TextField), 'da');
    // First frame mounts the results section (starting the 300 ms debounce
    // timer); only then can time advance past it.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
    expect(find.text(friendlyMessage), findsNWidgets(2));
    expect(find.textContaining('AuthRetryableFetchException'), findsNothing);

    // Back online, the friends-list Riprova recovers to the empty state.
    repo.offline = false;
    await tester.tap(find.text('Riprova').last);
    await tester.pump();
    await tester.pump();
    expect(
      find.textContaining('Nessun amico ancora'),
      findsOneWidget,
    );
  });
}
