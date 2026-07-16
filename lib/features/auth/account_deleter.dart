import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/db/app_database.dart';
import '../../data/sync/sync_service.dart';
import '../../data/supabase/supabase_providers.dart';
import 'auth_service.dart';

/// Deletes the caller's own account, immediately and irreversibly.
///
/// Injected into [AccountDeleter] so tests can drive the flow without a real
/// [SupabaseClient] / edge-function call; production uses
/// [invokeDeleteAccountFunction], which calls the `delete-account` edge
/// function. The caller's JWT is attached automatically by `functions.invoke`,
/// and the function only ever deletes that verified user (never a client-
/// supplied id).
typedef DeleteAccountInvoker = Future<void> Function();

/// Orchestrates account deletion: the cloud side (all Supabase rows + the auth
/// user, via the edge function) followed by wiping every trace on this device.
///
/// Order matters: the edge function runs FIRST, while the session (and its
/// JWT) still exists — that is what proves to the server which user to delete.
/// Only once the cloud data is gone do we sign out and clear local Drift, so a
/// failure server-side leaves the account fully intact and the user still
/// signed in.
class AccountDeleter {
  // Body assignment (not an initializing formal) keeps the public param name
  // `invokeDelete` while the field stays private.
  AccountDeleter(
    this._authService,
    this._sync,
    this._db, {
    required DeleteAccountInvoker invokeDelete,
  }) : _invokeDelete = invokeDelete; // ignore: prefer_initializing_formals

  final AuthService _authService;
  final SyncService _sync;
  final AppDatabase _db;
  final DeleteAccountInvoker _invokeDelete;

  /// Deletes the account and all associated data. On success no session
  /// remains, so the router's auth gate sends the user back to registration.
  /// Rethrows on failure (e.g. offline) with nothing changed.
  Future<void> deleteAccount() async {
    // 1. Server-side: remove all cloud rows and the auth user itself.
    await _invokeDelete();
    // 2. No session should survive a deleted auth user. Sign out locally and
    //    wipe on-device data so the next account starts from a clean slate.
    await _authService.signOut();
    await _sync.clearSyncState();
    await _db.clearLocalData();
  }
}

/// The production invoker: calls the `delete-account` edge function. The
/// current session's access token is attached automatically, so the function
/// can verify the caller and self-delete only their own data. A non-2xx
/// response surfaces as a [FunctionException], propagated to the caller.
Future<void> invokeDeleteAccountFunction(SupabaseClient client) async {
  await client.functions.invoke('delete-account');
}

/// `null` while Supabase is not configured — the delete-account UI is hidden
/// then (like the rest of the account controls).
final accountDeleterProvider = Provider<AccountDeleter?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final authService = ref.watch(authServiceProvider);
  if (client == null || authService == null) return null;
  return AccountDeleter(
    authService,
    ref.watch(syncServiceProvider),
    ref.watch(appDatabaseProvider),
    invokeDelete: () => invokeDeleteAccountFunction(client),
  );
});
