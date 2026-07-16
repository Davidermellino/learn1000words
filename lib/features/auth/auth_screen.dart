import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/supabase/supabase_providers.dart';
import 'auth_service.dart';

/// Whether the screen is showing the sign-up (registration) form or the
/// sign-in (login) form. Registration is the default for a fresh launch.
enum _AuthMode { register, login }

/// Mandatory auth gate: Google, Apple (iOS only) and email/password. This is
/// the app's entry point when there is no Supabase session — there is no
/// local-only path past it. It opens on the registration form, with a link to
/// switch to login.
///
/// On success the router's auth gate redirects onward: a brand-new account
/// goes to onboarding (which claims the nickname), while a returning account
/// (login) is restored from the cloud and lands straight on home — see
/// [sessionRestoreProvider].
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  _AuthMode _mode = _AuthMode.register;
  bool _busy = false;

  bool get _isRegister => _mode == _AuthMode.register;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(supabaseClientProvider) != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegister ? 'Registrati' : 'Accedi'),
      ),
      body: !configured
          ? const _NotConfigured()
          : AbsorbPointer(
              absorbing: _busy,
              child: Stack(
                children: [
                  _buildSignInForm(context),
                  if (_busy)
                    ColoredBox(
                      color: Theme.of(context)
                          .colorScheme
                          .scrim
                          .withValues(alpha: 0.32),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    // Native Sign in with Apple only exists on Apple platforms. The flow is
    // implemented but unverified until P5.5 (Codemagic/TestFlight).
    final showApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          _isRegister ? 'Crea il tuo account' : 'Bentornato',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _isRegister
              ? 'Registrati per salvare i tuoi progressi nel cloud e '
                    'ritrovarli su ogni dispositivo.'
              : 'Accedi per ritrovare i tuoi progressi.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        FilledButton.tonalIcon(
          onPressed: () => _run((auth) => auth.signInWithGoogle()),
          icon: const Icon(Icons.g_mobiledata, size: 28),
          label: const Text('Continua con Google'),
        ),
        if (showApple) ...[
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => _run((auth) => auth.signInWithApple()),
            icon: const Icon(Icons.apple),
            label: const Text('Continua con Apple'),
          ),
        ],
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'oppure con email',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => _runEmail(signUp: _isRegister),
          child: Text(_isRegister ? 'Registrati' : 'Accedi'),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => setState(
              () => _mode = _isRegister ? _AuthMode.login : _AuthMode.register,
            ),
            child: Text(
              _isRegister
                  ? 'Hai già un account? Accedi'
                  : 'Non hai un account? Registrati',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _runEmail({required bool signUp}) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Inserisci email e password.');
      return Future.value();
    }
    return _run((auth) async {
      if (!signUp) {
        await auth.signInWithEmail(email: email, password: password);
        return true;
      }
      final hasSession = await auth.signUpWithEmail(
        email: email,
        password: password,
      );
      if (!hasSession) {
        _showMessage(
          'Registrazione avviata: conferma la tua email, poi accedi con le '
          'tue credenziali.',
        );
      }
      return hasSession;
    });
  }

  /// Runs a sign-in flow. On success a Supabase session exists and the
  /// router's auth gate redirects onward — to onboarding for a new account, or
  /// straight to home for a returning one (restored by sessionRestoreProvider).
  Future<void> _run(Future<Object?> Function(AuthService auth) signIn) async {
    final auth = ref.read(authServiceProvider);
    if (auth == null) return;

    setState(() => _busy = true);
    try {
      // A false outcome means email sign-up is pending confirmation: no
      // session yet, so stay on this screen and let the message guide them.
      await signIn(auth);
    } on AuthServiceException catch (error) {
      if (!error.cancelled) _showMessage(error.message);
    } catch (error) {
      debugPrint('Sign-in failed: $error');
      _showMessage('Qualcosa è andato storto. Riprova.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _NotConfigured extends StatelessWidget {
  const _NotConfigured();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          'La sincronizzazione cloud non è configurata in questa build.\n'
          'Vedi SUPABASE_SETUP.md.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
