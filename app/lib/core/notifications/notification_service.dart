import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pilgrim_content/pilgrim_content.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules calm, invitational notifications on mobile: a daily reading
/// reminder plus "mic drop" — periodic Bible-verse nudges. Web and desktop are
/// no-ops (local scheduled notifications are not supported there).
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _dailyReminderId = 0;
  static const _nudgeIdBase = 1000;
  static const _maxNudges = 48;
  static const _testNudgeId = 9999;

  static const _nudgePayloadKind = 'micdrop';

  /// The last mic drop verse the user tapped; null once consumed.
  final ValueNotifier<VerseNudge?> nudgeTapped = ValueNotifier(null);

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
        defaultPresentAlert: true,
        defaultPresentBanner: true,
        defaultPresentSound: true,
      ),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final nudge = _parseNudgePayload(response.payload);
        if (nudge != null) nudgeTapped.value = nudge;
      },
    );

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

  /// Mic drop nudges are gentle, so they deliberately use inexact scheduling —
  /// no exact-alarm permission is required and the system can batch them.
  static const _inexactMode = AndroidScheduleMode.inexactAllowWhileIdle;

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

  /// The next [count] mic drop times: [intervalHours] apart, starting one
  /// interval from [now]. Pure and testable.
  static List<tz.TZDateTime> nextOccurrences(
      tz.TZDateTime now, int intervalHours, int count) {
    return List.generate(
      count,
      (i) => now.add(Duration(hours: intervalHours * (i + 1))),
    );
  }

  /// Picks [count] verses from [pool] in shuffled order, cycling without
  /// immediate repeats. Pure and testable.
  static List<VerseNudge> pickVerses(List<VerseNudge> pool, int count) {
    if (pool.isEmpty) return const [];
    final shuffled = [...pool]..shuffle(Random());
    return List.generate(count, (i) => shuffled[i % shuffled.length]);
  }

  /// Schedules one daily reminder at [hour]:[minute] using a random calm
  /// message from [messages]. Replaces any previously scheduled reminder.
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required List<String> messages,
  }) async {
    if (!_supported) return;
    await _plugin.cancel(id: _dailyReminderId);
    if (messages.isEmpty) return;

    final message = messages[Random().nextInt(messages.length)];
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = nextOccurrence(now, hour, minute);

    await _plugin.zonedSchedule(
      id: _dailyReminderId,
      title: 'mic',
      body: message,
      scheduledDate: scheduled,
      notificationDetails: _details(),
      androidScheduleMode: await _androidMode(),
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedules a rolling window of mic drop nudges for the next ~48 hours,
  /// one verse from [verses] in the enabled [categories] every [intervalHours].
  /// Replaces any previously scheduled nudges. A no-op when there is nothing
  /// to schedule.
  Future<void> scheduleNudges({
    required int intervalHours,
    required List<String> categories,
    required List<VerseNudge> verses,
  }) async {
    if (!_supported) return;
    await cancelNudges();
    if (intervalHours <= 0) return;

    final pool = verses.where((v) => categories.contains(v.category)).toList();
    if (pool.isEmpty) return;

    final now = tz.TZDateTime.now(tz.local);
    final times = nextOccurrences(now, intervalHours, _maxNudges);
    final picked = pickVerses(pool, times.length);

    for (var i = 0; i < times.length; i++) {
      final verse = picked[i];
      await _plugin.zonedSchedule(
        id: _nudgeIdBase + i,
        title: 'mic drop',
        body: '${verse.text}\n\n${verse.reference}',
        scheduledDate: times[i],
        notificationDetails: _nudgeDetails(),
        androidScheduleMode: _inexactMode,
        payload: _nudgePayload(verse),
      );
    }
  }

  /// Cancels every scheduled mic drop nudge, keeping the daily reminder.
  Future<void> cancelNudges() async {
    if (!_supported) return;
    for (var i = 0; i < _maxNudges; i++) {
      await _plugin.cancel(id: _nudgeIdBase + i);
    }
  }

  /// Immediately shows one mic drop notification (the Settings "send one now"
  /// button). Uses `show` so it needs no scheduling permissions.
  Future<void> sendOneNow(VerseNudge verse) async {
    if (!_supported) return;
    await _plugin.show(
      id: _testNudgeId,
      title: 'mic drop',
      body: '${verse.text}\n\n${verse.reference}',
      notificationDetails: _nudgeDetails(),
      payload: _nudgePayload(verse),
    );
  }

  /// The mic drop verse (if any) that launched the app, or null. The payload is
  /// consumed in the process so it won't re-show on a later launch.
  Future<VerseNudge?> takeLaunchNudge() async {
    if (!_supported) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    return _parseNudgePayload(details?.notificationResponse?.payload);
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

  NotificationDetails _nudgeDetails() => const NotificationDetails(
        android: AndroidNotificationDetails(
          'mic_drop',
          'mic drop',
          channelDescription: 'Bible verses dropped through the day.',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentSound: true,
        ),
      );

  static String _nudgePayload(VerseNudge verse) => jsonEncode({
        'kind': _nudgePayloadKind,
        'category': verse.category,
        'reference': verse.reference,
        'text': verse.text,
      });

  static VerseNudge? _parseNudgePayload(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map['kind'] != _nudgePayloadKind) return null;
      return VerseNudge(
        category: map['category'] as String,
        reference: map['reference'] as String,
        text: map['text'] as String,
      );
    } catch (_) {
      return null;
    }
  }
}
