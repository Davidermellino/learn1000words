import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/supabase/supabase_providers.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegister ? l10n.signUp : l10n.logIn),
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
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Brand ermine — the app's entry-point logo (also the launcher icon).
        Image.asset(
          'assets/icon/ermine_logo.png',
          height: 96,
          semanticLabel: 'learn1000words',
        ),
        const SizedBox(height: 16),
        Text(
          _isRegister ? l10n.authCreateAccount : l10n.authWelcomeBack,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _isRegister ? l10n.authRegisterSubtitle : l10n.authLoginSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        FilledButton.tonalIcon(
          onPressed: () => _run((auth) => auth.signInWithGoogle()),
          icon: const Icon(Icons.g_mobiledata, size: 28),
          label: Text(l10n.authContinueGoogle),
        ),
        if (showApple) ...[
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => _run((auth) => auth.signInWithApple()),
            icon: const Icon(Icons.apple),
            label: Text(l10n.authContinueApple),
          ),
        ],
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                l10n.authOrWithEmail,
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
          decoration: InputDecoration(
            labelText: l10n.emailLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => _runEmail(signUp: _isRegister),
          child: Text(_isRegister ? l10n.signUp : l10n.logIn),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => setState(
              () => _mode = _isRegister ? _AuthMode.login : _AuthMode.register,
            ),
            child: Text(
              _isRegister ? l10n.authSwitchToLogin : l10n.authSwitchToRegister,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _runEmail({required bool signUp}) {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage(l10n.authEnterEmailPassword);
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
        _showMessage(l10n.authSignupPending);
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
    final l10n = AppLocalizations.of(context);

    setState(() => _busy = true);
    try {
      // A false outcome means email sign-up is pending confirmation: no
      // session yet, so stay on this screen and let the message guide them.
      await signIn(auth);
    } on AuthServiceException catch (error) {
      if (!error.cancelled) _showMessage(error.message);
    } catch (error) {
      debugPrint('Sign-in failed: $error');
      _showMessage(l10n.authGenericError);
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
          AppLocalizations.of(context).authNotConfigured,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
