import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn1000words/core/db/app_database.dart';
import 'package:learn1000words/data/models/word_status.dart';
import 'package:learn1000words/data/sync/sync_service.dart';
import 'package:learn1000words/features/auth/account_deleter.dart';
import 'package:learn1000words/features/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Minimal GoTrue fake: only [signOut] is exercised by [AuthService.signOut].
/// A real [SupabaseClient] starts an auto-refresh timer that hangs the test
/// isolate (see the project's Supabase widget-test note), so we never build one.
class _FakeGoTrueClient implements GoTrueClient {
  bool signOutCalled = false;

  @override
  Future<void> signOut({SignOutScope scope = SignOutScope.local}) async {
    signOutCalled = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSupabaseClient implements SupabaseClient {
  _FakeSupabaseClient(this._auth);

  final GoTrueClient _auth;

  @override
  GoTrueClient get auth => _auth;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // AuthService.signOut() best-effort-calls the google_sign_in platform
  // channel; the binding must exist for that channel call (its failure is
  // swallowed).
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late _FakeGoTrueClient gotrue;
  late AuthService authService;
  late SyncService sync;

  setUp(() async {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    gotrue = _FakeGoTrueClient();
    authService = AuthService(_FakeSupabaseClient(gotrue));
    // No Supabase client: clearSyncState only touches local bookkeeping.
    sync = SyncService(db, null);

    // Seed a linked profile with some progress and sync bookkeeping, so we can
    // assert it is all gone after deletion.
    await db.into(db.profiles).insert(
          ProfilesCompanion.insert(
            nickname: 'Anna',
            avatarId: 1,
            languagePair: 'it_hu',
            remoteUserId: const Value('user-123'),
          ),
        );
    await db.into(db.wordProgress).insert(
          WordProgressCompanion(
            pairId: const Value('it_hu'),
            wordId: const Value(1),
            status: const Value(WordStatus.memorized),
            memorizedAt: Value(DateTime.now()),
          ),
        );
    await db.into(db.appMeta).insert(
          AppMetaCompanion(
            key: const Value(SyncService.pendingKey),
            value: const Value('1'),
          ),
        );
  });

  tearDown(() async {
    sync.dispose();
    await db.close();
  });

  test('deleteAccount deletes cloud data, then wipes local state and session',
      () async {
    var invoked = 0;
    final deleter = AccountDeleter(
      authService,
      sync,
      db,
      invokeDelete: () async => invoked++,
    );

    await deleter.deleteAccount();

    // The edge function was called (cloud-side deletion).
    expect(invoked, 1);
    // The session was ended.
    expect(gotrue.signOutCalled, isTrue);
    // Local Drift data is wiped: no profile, no progress.
    expect(await db.select(db.profiles).getSingleOrNull(), isNull);
    expect(await db.select(db.wordProgress).get(), isEmpty);
    // Sync bookkeeping is cleared.
    final meta = await (db.select(db.appMeta)
          ..where((r) => r.key.equals(SyncService.pendingKey)))
        .getSingleOrNull();
    expect(meta, isNull);
  });

  test('a failed edge-function call leaves everything intact', () async {
    final deleter = AccountDeleter(
      authService,
      sync,
      db,
      invokeDelete: () async => throw Exception('offline'),
    );

    await expectLater(deleter.deleteAccount(), throwsA(isA<Exception>()));

    // The cloud call runs first and failed, so nothing local was touched and
    // the user is still signed in.
    expect(gotrue.signOutCalled, isFalse);
    expect(await db.select(db.profiles).getSingleOrNull(), isNotNull);
    expect(await db.select(db.wordProgress).get(), isNotEmpty);
  });
}
