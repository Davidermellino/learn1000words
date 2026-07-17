import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:learn1000words/core/db/app_database.dart';
import 'package:learn1000words/core/locale/locale_controller.dart';
import 'package:learn1000words/core/notifications/notification_service.dart';
import 'package:learn1000words/data/supabase/supabase_providers.dart';
import 'package:learn1000words/main.dart';

/// Pumps the whole app against an in-memory database, with the auth gate
/// forced to [signedIn] (so tests never construct a real SupabaseClient).
Future<AppDatabase> _pumpApp(
  WidgetTester tester, {
  required bool signedIn,
}) async {
  // Phone-like surface: the default 800x600 window squeezes the level grid
  // into cells tighter than any real device.
  tester.view.physicalSize = const Size(822, 1800);
  tester.view.devicePixelRatio = 2.0; // 411x900 logical, Pixel-like
  addTearDown(tester.view.reset);

  final db = AppDatabase.withExecutor(NativeDatabase.memory());
  addTearDown(db.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        // Never initialized in tests; with no profile in the fresh database
        // the reminder scheduler stays inactive anyway.
        notificationServiceProvider.overrideWithValue(NotificationService()),
        // Drive the router's auth gate without a SupabaseClient.
        isSignedInProvider.overrideWithValue(signedIn),
        // Pin the UI to Italian so the assertions below are deterministic
        // regardless of the test host's locale.
        startupLocaleProvider.overrideWithValue(const Locale('it')),
      ],
      child: const Learn1000WordsApp(),
    ),
  );
  // Clear the branded splash overlay (1.6s hold + fade) so assertions see the
  // underlying screen; its hold is a plain timer that pumpAndSettle alone
  // won't advance past while nothing is animating.
  await tester.pump();
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
  return db;
}

/// Disposes the tree inside the test: drift stream cleanup schedules
/// zero-duration timers on provider disposal, and they must fire before the
/// framework's pending-timer check.
Future<void> _disposeTree(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

Future<void> _insertProfile(AppDatabase db) => db
    .into(db.profiles)
    .insert(
      ProfilesCompanion.insert(
        nickname: 'test',
        avatarId: 1,
        // A pair that exists in the bundled assets/words so home can resolve
        // it (the old 'it_hu' demo pair was removed in the vocab rework).
        languagePair: 'en_it',
      ),
    );

void main() {
  testWidgets('unauthenticated launch is gated to the registration screen', (
    tester,
  ) async {
    // No session and no profile: the gate must land on the auth screen, which
    // defaults to registration — never home or onboarding. (Supabase is
    // unconfigured in tests, so only the 'Registrati' app-bar title renders;
    // the form body itself needs a configured client.)
    await _pumpApp(tester, signedIn: false);

    expect(find.text('Registrati'), findsWidgets);
    expect(find.text('learn1000words'), findsNothing);
    expect(find.text('Come vuoi essere chiamato?'), findsNothing);

    await _disposeTree(tester);
  });

  testWidgets('authenticated with no profile is routed to onboarding', (
    tester,
  ) async {
    // Signed in but no local profile yet: first-run onboarding, not home.
    await _pumpApp(tester, signedIn: true);

    expect(find.text('Come vuoi essere chiamato?'), findsOneWidget);
    expect(find.text('learn1000words'), findsNothing);

    await _disposeTree(tester);
  });

  testWidgets('authenticated with a profile reaches home', (tester) async {
    final db = AppDatabase.withExecutor(NativeDatabase.memory());
    addTearDown(db.close);
    await _insertProfile(db);

    tester.view.physicalSize = const Size(822, 1800);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          notificationServiceProvider.overrideWithValue(NotificationService()),
          isSignedInProvider.overrideWithValue(true),
          startupLocaleProvider.overrideWithValue(const Locale('it')),
        ],
        child: const Learn1000WordsApp(),
      ),
    );
    // Clear the branded splash overlay with bounded pumps (home keeps an
    // indeterminate animation running, so pumpAndSettle would never idle).
    await tester.pump();
    await tester.pump(const Duration(seconds: 2)); // splash hold fires; fade begins
    await tester.pump(const Duration(seconds: 1)); // fade completes; splash removed
    await tester.pump();

    // Home's app bar carries the app name; the splash (which also showed it)
    // is now gone, so it appears exactly once.
    expect(find.text('learn1000words'), findsOneWidget);

    await _disposeTree(tester);
  });
}
