import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The Supabase client, or `null` when the build has no Supabase
/// configuration (see [Env]) — every consumer must handle the null so the
/// app keeps working fully offline / unconfigured.
///
/// Overridden in `main()` after a successful `Supabase.initialize`.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) => null);

/// Auth state changes (sign-in, sign-out, token refresh, initial session).
/// Emits nothing when Supabase is not configured.
final authStateProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const Stream.empty();
  return client.auth.onAuthStateChange;
});

/// The currently signed-in Supabase user, or `null` (signed out, or
/// Supabase not configured). Reactive via [authStateProvider].
final currentUserProvider = Provider<User?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return null;
  ref.watch(authStateProvider);
  return client.auth.currentUser;
});

/// Whether a user is signed in. The router's auth gate reads this to decide
/// whether to allow anything beyond the sign-in screen. Kept as its own
/// provider (rather than reading [currentUserProvider] directly in the router)
/// so tests can drive the gate with a plain `overrideWithValue`, without
/// constructing a real [SupabaseClient].
final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(currentUserProvider) != null,
);
