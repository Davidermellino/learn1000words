import 'package:flutter_test/flutter_test.dart';
import 'package:learn1000words/core/config/env.dart';
import 'package:learn1000words/features/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Records the Supabase auth calls [AuthService] makes, without any network or
/// a real [SupabaseClient] — the real client starts an auto-refresh timer that
/// hangs the test isolate (see the project's Supabase widget-test note). Only
/// the members [AuthService] touches are implemented; the rest route through
/// [noSuchMethod].
class _FakeGoTrueClient implements GoTrueClient {
  OAuthProvider? idTokenProvider;
  String? idToken;
  String? passwordEmail;
  String? passwordValue;
  String? signUpEmail;
  bool signOutCalled = false;

  /// When set, [signInWithPassword] throws it instead of succeeding.
  AuthException? passwordError;

  /// The session [signUp] reports back (null = confirmation e-mail required).
  Session? signUpSession;

  @override
  Future<AuthResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
    String? accessToken,
    String? nonce,
    String? captchaToken,
  }) async {
    idTokenProvider = provider;
    this.idToken = idToken;
    return AuthResponse();
  }

  @override
  Future<AuthResponse> signInWithPassword({
    String? email,
    String? phone,
    required String password,
    String? captchaToken,
  }) async {
    passwordEmail = email;
    passwordValue = password;
    final error = passwordError;
    if (error != null) throw error;
    return AuthResponse();
  }

  @override
  Future<AuthResponse> signUp({
    String? email,
    String? phone,
    required String password,
    String? emailRedirectTo,
    Map<String, dynamic>? data,
    String? captchaToken,
    OtpChannel channel = OtpChannel.sms,
  }) async {
    signUpEmail = email;
    return AuthResponse(session: signUpSession);
  }

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
  // signOut() best-effort-calls the google_sign_in platform channel; the
  // binding must exist for that channel call (its failure is swallowed).
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeGoTrueClient gotrue;
  late _FakeSupabaseClient client;

  setUp(() {
    gotrue = _FakeGoTrueClient();
    client = _FakeSupabaseClient(gotrue);
  });

  // Google sign-in is gated behind Env.hasGoogleSignIn, a compile-time
  // String.fromEnvironment. These run only when the build carries
  // GOOGLE_WEB_CLIENT_ID (e.g. `flutter test --dart-define-from-file=env.json`);
  // a plain `flutter test` skips them so the suite still passes.
  final googleSkip = Env.hasGoogleSignIn
      ? false
      : 'needs GOOGLE_WEB_CLIENT_ID (run with --dart-define-from-file=env.json)';

  group('signInWithGoogle', () {
    test('exchanges the Google ID token with Supabase', () async {
      final auth = AuthService(
        client,
        googleIdTokenProvider: () async => 'id-token-abc',
      );

      await auth.signInWithGoogle();

      expect(gotrue.idTokenProvider, OAuthProvider.google);
      expect(gotrue.idToken, 'id-token-abc');
    }, skip: googleSkip);

    test('a dismissed account picker is a silent cancellation', () async {
      final auth = AuthService(
        client,
        googleIdTokenProvider: () async => null, // user backed out
      );

      await expectLater(
        auth.signInWithGoogle(),
        throwsA(
          isA<AuthServiceException>()
              .having((e) => e.cancelled, 'cancelled', isTrue),
        ),
      );
      // No token → no Supabase exchange.
      expect(gotrue.idToken, isNull);
    }, skip: googleSkip);

    test('a native failure surfaces as a (non-cancelled) error', () async {
      final auth = AuthService(
        client,
        googleIdTokenProvider: () async =>
            throw const AuthServiceException('Accesso Google non riuscito: 10'),
      );

      await expectLater(
        auth.signInWithGoogle(),
        throwsA(
          isA<AuthServiceException>()
              .having((e) => e.cancelled, 'cancelled', isFalse),
        ),
      );
      expect(gotrue.idToken, isNull);
    }, skip: googleSkip);
  });

  group('signInWithEmail', () {
    test('signs in with the given email and password', () async {
      final auth = AuthService(client);

      await auth.signInWithEmail(
        email: 'davide@example.com',
        password: 'hunter2!',
      );

      expect(gotrue.passwordEmail, 'davide@example.com');
      expect(gotrue.passwordValue, 'hunter2!');
    });

    test('maps invalid_credentials to a friendly message', () async {
      gotrue.passwordError = const AuthException(
        'Invalid login credentials',
        code: 'invalid_credentials',
      );
      final auth = AuthService(client);

      await expectLater(
        auth.signInWithEmail(email: 'a@b.com', password: 'wrong'),
        throwsA(
          isA<AuthServiceException>().having(
            (e) => e.message,
            'message',
            'Email o password non validi.',
          ),
        ),
      );
    });

    test('maps a network failure to a connection message', () async {
      gotrue.passwordError = AuthRetryableFetchException();
      final auth = AuthService(client);

      await expectLater(
        auth.signInWithEmail(email: 'a@b.com', password: 'x'),
        throwsA(
          isA<AuthServiceException>().having(
            (e) => e.message,
            'message',
            contains('Impossibile contattare il server'),
          ),
        ),
      );
    });
  });

  group('signUpWithEmail', () {
    test('returns false when email confirmation is required', () async {
      gotrue.signUpSession = null; // GoTrue withholds the session until confirm
      final auth = AuthService(client);

      final hasSession = await auth.signUpWithEmail(
        email: 'new@example.com',
        password: 'hunter2!',
      );

      expect(hasSession, isFalse);
      expect(gotrue.signUpEmail, 'new@example.com');
    });
  });

  group('signOut', () {
    test('signs out of Supabase', () async {
      final auth = AuthService(client);

      await auth.signOut();

      expect(gotrue.signOutCalled, isTrue);
    });
  });
}
