import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/env.dart';
import '../../data/supabase/supabase_providers.dart';

/// Auth failure the UI should surface. [cancelled] marks a user-initiated
/// abort (dismissed the account picker) — show nothing for those.
class AuthServiceException implements Exception {
  const AuthServiceException(this.message, {this.cancelled = false});

  final String message;
  final bool cancelled;

  @override
  String toString() => message;
}

/// Acquires a Google ID token for the Supabase exchange. Returns the token,
/// or `null` when the user dismissed the account picker (a cancellation).
/// Throws [AuthServiceException] on a real failure.
///
/// Injected into [AuthService] so tests can drive the flow without the native
/// google_sign_in plugin; production uses [AuthService.nativeGoogleIdToken].
typedef GoogleIdTokenProvider = Future<String?> Function();

/// Wraps the three Supabase sign-in flows. Only ever constructed when
/// Supabase is configured (see [authServiceProvider]).
class AuthService {
  AuthService(this._client, {GoogleIdTokenProvider? googleIdTokenProvider})
      : _obtainGoogleIdToken = googleIdTokenProvider ?? nativeGoogleIdToken;

  final SupabaseClient _client;
  final GoogleIdTokenProvider _obtainGoogleIdToken;

  /// Native Google Sign-In → Supabase ID-token exchange.
  ///
  /// Android setup (see SUPABASE_SETUP.md): needs GOOGLE_WEB_CLIENT_ID (the
  /// *web* OAuth client, used as serverClientId so the ID token is issued
  /// for Supabase) and the app's debug SHA-1 registered on an *Android*
  /// OAuth client in the same Google Cloud project.
  Future<void> signInWithGoogle() async {
    if (!Env.hasGoogleSignIn) {
      throw const AuthServiceException(
        'Accesso Google non configurato (manca GOOGLE_WEB_CLIENT_ID).',
      );
    }
    final idToken = await _obtainGoogleIdToken();
    // A null token means the user dismissed the account picker.
    if (idToken == null) {
      throw const AuthServiceException('Accesso annullato.', cancelled: true);
    }
    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

  /// The real native Google flow (google_sign_in 6.x).
  ///
  /// Uses the 6.x API deliberately: 7.x (Credential Manager) hard-crashes on
  /// Android when Google returns a credential with a null email
  /// (flutter/flutter#139219). See the pinned version in pubspec.yaml.
  static Future<String?> nativeGoogleIdToken() async {
    final google = GoogleSignIn(
      serverClientId: Env.googleWebClientId,
      clientId: Env.googleIosClientId.isEmpty ? null : Env.googleIosClientId,
    );

    final GoogleSignInAccount? account;
    try {
      account = await google.signIn();
    } on PlatformException catch (error) {
      throw AuthServiceException(
        'Accesso Google non riuscito: ${error.message ?? error.code}',
      );
    }
    if (account == null) return null; // user dismissed the picker

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw const AuthServiceException(
        'Google non ha restituito un ID token.',
      );
    }
    return idToken;
  }

  /// Native Sign in with Apple → Supabase ID-token exchange.
  ///
  /// iOS/macOS only. UNVERIFIED until the app runs on a real Apple device
  /// (P5.5, Codemagic/TestFlight) — kept behind the platform check in the UI.
  ///
  /// No nonce is sent: hashing one requires package:crypto (an unlisted
  /// dependency), and GoTrue accepts Apple tokens without a nonce claim.
  /// TODO(P5.5): revisit adding crypto for nonce replay protection.
  Future<void> signInWithApple() async {
    final AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const AuthServiceException('Accesso annullato.',
            cancelled: true);
      }
      throw AuthServiceException('Accesso Apple non riuscito: ${error.code}');
    }

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthServiceException(
        'Apple non ha restituito un token di identità.',
      );
    }
    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (error) {
      throw AuthServiceException(_emailAuthMessage(error));
    }
  }

  /// Returns true when a session was created immediately; false when the
  /// Supabase project requires email confirmation first (the user must click
  /// the link in the email, then sign in).
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await _client.auth.signUp(email: email, password: password);
      return response.session != null;
    } on AuthException catch (error) {
      throw AuthServiceException(_emailAuthMessage(error));
    }
  }

  /// Signs out of Supabase (and Google, best-effort). Local data stays.
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {
      // Best effort; the Supabase sign-out is what matters.
    }
    await _client.auth.signOut();
  }

  static String _emailAuthMessage(AuthException error) {
    // Network-level failure (offline, server unreachable): the raw message
    // is a socket exception dump — replace it wholesale.
    if (error is AuthRetryableFetchException) {
      return 'Impossibile contattare il server. Controlla la connessione '
          'e riprova.';
    }
    return switch (error.code) {
      'invalid_credentials' => 'Email o password non validi.',
      'email_not_confirmed' =>
        'Email non ancora confermata: controlla la tua casella di posta.',
      'user_already_exists' => 'Esiste già un account con questa email.',
      'weak_password' => 'Password troppo debole (minimo 6 caratteri).',
      _ => 'Errore di autenticazione: ${error.message}',
    };
  }
}

/// `null` while Supabase is not configured — the auth UI is hidden then.
final authServiceProvider = Provider<AuthService?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client == null ? null : AuthService(client);
});
