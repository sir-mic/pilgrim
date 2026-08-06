import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules calm, invitational daily reminders on mobile. Web and desktop are
/// no-ops (local scheduled notifications are not supported there).
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool get _supported => !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    if (!_supported) return;
    tz_data.initializeTimeZones();
    await _setDeviceTimezone();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings: settings);

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  /// Points [tz.local] at the device's real timezone. Without this the
  /// `timezone` package defaults to UTC and scheduled times fire hours late on
  /// non-UTC devices.
  Future<void> _setDeviceTimezone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Best effort: fall back to the timezone package default (UTC).
    }
  }

  /// Requests permission for exact alarms on Android 12+ (launches the system
  /// settings screen when needed) and reports whether exact alarms are usable.
  /// Returns true on iOS and older Android versions.
  Future<bool> ensureExactAlarms() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;
    if (await android.canScheduleExactNotifications() == true) return true;
    await android.requestExactAlarmsPermission();
    return await android.canScheduleExactNotifications() == true;
  }

  Future<AndroidScheduleMode> _androidMode() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return AndroidScheduleMode.inexactAllowWhileIdle;
    final exact = await android.canScheduleExactNotifications();
    return exact == true
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// The next [hour]:[minute] on or after [now] — today if still ahead,
  /// otherwise tomorrow. Pure and testable.
  static tz.TZDateTime nextOccurrence(
      tz.TZDateTime now, int hour, int minute) {
    var scheduled =
        tz.TZDateTime(now.location, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Schedules one daily reminder at [hour]:[minute] using a random calm
  /// message from [messages]. Replaces any previously scheduled reminder.
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required List<String> messages,
  }) async {
    if (!_supported) return;
    await _plugin.cancelAll();
    if (messages.isEmpty) return;

    final message = messages[Random().nextInt(messages.length)];
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = nextOccurrence(now, hour, minute);

    await _plugin.zonedSchedule(
      id: 0,
      title: 'mic',
      body: message,
      scheduledDate: scheduled,
      notificationDetails: _details(),
      androidScheduleMode: await _androidMode(),
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Fires a single reminder about ten seconds from now so the user can confirm
  /// the nudge works without waiting for the daily time.
  Future<void> scheduleTest() async {
    if (!_supported) return;
    final scheduled =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    await _plugin.zonedSchedule(
      id: 99,
      title: 'mic',
      body: 'Reminder test — the nudge works.',
      scheduledDate: scheduled,
      notificationDetails: _details(),
      androidScheduleMode: await _androidMode(),
    );
  }

  Future<void> cancelAll() async {
    if (!_supported) return;
    await _plugin.cancelAll();
  }

  NotificationDetails _details() => const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reading',
          'Daily reading',
          channelDescription: 'A gentle invitation to today\'s reading.',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: DarwinNotificationDetails(),
      );
}
