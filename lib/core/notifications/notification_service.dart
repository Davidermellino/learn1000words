import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/profile/profile_repository.dart';

/// Daily study-reminder notifications via flutter_local_notifications.
///
/// Timezone note: we deliberately avoid a timezone-lookup dependency, so
/// `tz.local` stays UTC. The next occurrence is computed on the local wall
/// clock and converted instant-exactly with [tz.TZDateTime.from], so the
/// first fire is always right; the daily repeat then matches that UTC wall
/// time, which drifts by an hour after a DST switch until the app is next
/// opened (we reschedule on every launch and on every time change).
class NotificationService {
  static const int _dailyReminderId = 1001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes timezone data and the plugin. Call once before [runApp].
  Future<void> init() async {
    tz_data.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // Permission is requested explicitly in [requestPermissions] so it can
      // be tied to setup instead of popping at first plugin touch.
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings: settings);
  }

  /// Asks for notification permission: the Android 13+ POST_NOTIFICATIONS
  /// runtime dialog, or the iOS alert/badge/sound prompt. Safe to call every
  /// launch — the OS only shows the dialog when the choice is still open.
  Future<void> requestPermissions() async {
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (error) {
      // Notifications are a nice-to-have; never break startup over them.
      debugPrint('Notification permission request failed: $error');
    }
  }

  /// (Re)schedules the single daily reminder at [hour]:[minute] local time,
  /// replacing any previous schedule. Uses an exact alarm when Android
  /// permits it (SCHEDULE_EXACT_ALARM), otherwise falls back to inexact —
  /// good enough for a gentle daily nudge.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final canExact = await android?.canScheduleExactNotifications() ?? false;

      await _plugin.cancel(id: _dailyReminderId);
      await _plugin.zonedSchedule(
        id: _dailyReminderId,
        title: 'learn1000words 📚',
        body: 'Le tue parole ti aspettano: un po\' di pratica '
            'mantiene viva la serie! 🔥',
        scheduledDate: _nextInstanceOf(hour, minute),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder',
            'Promemoria giornaliero',
            channelDescription:
                'Promemoria quotidiano per esercitarti con le parole',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint(
        'Daily reminder scheduled at '
        '$hour:${minute.toString().padLeft(2, '0')} (exact: $canExact)',
      );
    } catch (error) {
      debugPrint('Scheduling the daily reminder failed: $error');
    }
  }

  /// Next local-wall-clock occurrence of [hour]:[minute], as a TZDateTime.
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour, minute);
    if (!next.isAfter(now)) {
      next = DateTime(now.year, now.month, now.day + 1, hour, minute);
    }
    return tz.TZDateTime.from(next, tz.local);
  }
}

/// Overridden in `main()` with the initialized instance.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) =>
      throw StateError('notificationServiceProvider must be overridden'),
);

/// The profile's reminder time, isolated so schedule churn only happens when
/// the time itself changes (not on every profile write).
final _reminderTimeProvider = Provider<(int, int)?>((ref) {
  final profile = ref.watch(profileProvider).valueOrNull;
  return profile == null ? null : (profile.reminderHour, profile.reminderMinute);
});

/// Keeps the daily reminder in sync with the profile: once a profile exists,
/// asks for permission and (re)schedules whenever the reminder time changes.
/// Watch it from the root widget to activate.
final reminderSchedulerProvider = Provider<void>((ref) {
  final time = ref.watch(_reminderTimeProvider);
  if (time == null) return;
  final service = ref.watch(notificationServiceProvider);
  final (hour, minute) = time;
  Future(() async {
    await service.requestPermissions();
    await service.scheduleDailyReminder(hour: hour, minute: minute);
  });
});
