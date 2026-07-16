import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:learn1000words/core/db/app_database.dart';
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
      ],
      child: const Learn1000WordsApp(),
    ),
  );
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
        languagePair: 'it_hu',
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
        ],
        child: const Learn1000WordsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('learn1000words'), findsOneWidget);

    await _disposeTree(tester);
  });
}
