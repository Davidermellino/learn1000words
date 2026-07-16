import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/env.dart';
import 'core/constants/app_constants.dart';
import 'core/db/app_database.dart';
import 'core/notifications/notification_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/language_repository.dart';
import 'data/supabase/supabase_providers.dart';
import 'data/sync/sync_service.dart';
import 'features/profile/streak_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Discover the bundled language pairs up front (also surfaces malformed
  // files in the logs early); the app re-discovers lazily via a provider.
  const languages = LanguageRepository();
  final pairs = await languages.discoverPairs();
  debugPrint(
    'Discovered ${pairs.length} language pair(s): '
    '${pairs.map((p) => p.pairId).join(', ')}',
  );

  final database = AppDatabase();
  await database.customSelect('SELECT 1').get();
  debugPrint('Drift database opened (schema v${database.schemaVersion})');

  // A day may have passed with the goal unmet since the last run.
  await StreakService(database).syncStreak();

  final notifications = NotificationService();
  await notifications.init();

  // Cloud sync is optional: without the SUPABASE_URL / SUPABASE_ANON_KEY
  // dart-defines the app runs fully local, exactly as before P5.
  SupabaseClient? supabaseClient;
  if (Env.hasSupabase) {
    // publishableKey accepts both the legacy anon key and the newer
    // sb_publishable_… key — SUPABASE_ANON_KEY may hold either.
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
    );
    supabaseClient = Supabase.instance.client;
    debugPrint('Supabase initialized (cloud sync enabled)');
  } else {
    debugPrint('Supabase not configured — running local-only');
  }

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        notificationServiceProvider.overrideWithValue(notifications),
        supabaseClientProvider.overrideWithValue(supabaseClient),
      ],
      child: const Learn1000WordsApp(),
    ),
  );
}

class Learn1000WordsApp extends ConsumerWidget {
  const Learn1000WordsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keeps the daily reminder scheduled and in sync with the profile.
    ref.watch(reminderSchedulerProvider);
    // Resumes any cloud push left pending by a previous (offline) run.
    ref.watch(syncBootstrapProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
