import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/supabase/supabase_providers.dart';
import '../../features/auth/account_linker.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/flashcards/flashcards_screen.dart';
import '../../features/friends/friends_screen.dart';
import '../../features/home/app_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/known_words/known_words_screen.dart';
import '../../features/level/level_detail_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_repository.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/test/test_screen.dart';
import '../../features/usage/usage_history_screen.dart';
import '../../features/usage/usage_screen.dart';

/// App navigation: a two-stage gate (sign-in, then onboarding) in front of the
/// four bottom-nav branches, with the level detail and its (stub) learning
/// modes nested under Home.
///
/// The gate is mandatory — there is no local-only path:
///  - no Supabase session      → `/auth` (register, or switch to log in)
///  - session but no profile    → `/onboarding` (first-run profile setup)
///  - session and a profile     → the app (home, levels, usage, friends…)
///
/// A returning account (login) never sees onboarding: [sessionRestoreProvider]
/// runs first and, if the account already has a cloud profile, seeds the local
/// profile from it — so the gate then finds a profile and routes to home.
///
/// Exposed as a provider (not a top-level constant) so the redirect can read
/// Riverpod directly and a [refreshListenable] can re-run it whenever the
/// session or the profile changes — that is what pushes a signed-out user back
/// to `/auth` and a freshly onboarded user on to home.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);
  ref.listen(isSignedInProvider, (_, _) => refresh.notify());
  ref.listen(profileProvider, (_, _) => refresh.notify());
  ref.listen(sessionRestoreProvider, (_, _) => refresh.notify());

  return GoRouter(
    refreshListenable: refresh,
    redirect: (context, state) async {
      final signedIn = ref.read(isSignedInProvider);
      final loc = state.matchedLocation;
      final onAuth = loc == '/auth';
      final onOnboarding = loc == '/onboarding';

      if (!signedIn) return onAuth ? null : '/auth';

      // Restore a returning account (seeds the local profile from the cloud)
      // before deciding, so login lands on home and only a brand-new sign-up
      // falls through to onboarding.
      await ref.read(sessionRestoreProvider.future);

      final profile = await ref.read(profileProvider.future);
      if (profile == null) return onOnboarding ? null : '/onboarding';

      return (onAuth || onOnboarding) ? '/' : null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Sign-in gate. Full-screen (outside the shell) like onboarding.
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'level/:level',
                    name: 'level',
                    builder: (context, state) =>
                        LevelDetailScreen(level: _levelOf(state)),
                    routes: [
                      GoRoute(
                        path: 'flashcards',
                        name: 'flashcards',
                        builder: (context, state) =>
                            FlashcardsScreen(level: _levelOf(state)),
                      ),
                      GoRoute(
                        path: 'test',
                        name: 'test',
                        builder: (context, state) =>
                            TestScreen(level: _levelOf(state)),
                      ),
                      GoRoute(
                        path: 'usage',
                        name: 'usage',
                        builder: (context, state) =>
                            UsageScreen(level: _levelOf(state)),
                        routes: [
                          GoRoute(
                            path: 'history',
                            name: 'usage-history',
                            builder: (context, state) =>
                                const UsageHistoryScreen(),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'known',
                        name: 'level-known',
                        builder: (context, state) =>
                            KnownWordsScreen(level: _levelOf(state)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/known-words',
                name: 'known-words',
                builder: (context, state) => const KnownWordsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/friends',
                name: 'friends',
                builder: (context, state) => const FriendsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Bridges Riverpod change notifications to [GoRouter.refreshListenable];
/// [notify] re-runs the redirect after a sign-in/out or profile change.
class _RouterRefresh extends ChangeNotifier {
  void notify() => notifyListeners();
}

int _levelOf(GoRouterState state) {
  final level = int.tryParse(state.pathParameters['level'] ?? '');
  if (level == null || level < 1) {
    throw StateError('Invalid level in route: ${state.uri}');
  }
  return level;
}
