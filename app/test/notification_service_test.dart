import 'package:flutter_test/flutter_test.dart';
import 'package:pilgrim_app/core/notifications/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(tz_data.initializeTimeZones);

  test('nextOccurrence picks today when the time is still ahead', () {
    tz.setLocalLocation(tz.getLocation('Asia/Manila'));
    final now = tz.TZDateTime(tz.local, 2026, 8, 6, 10, 0);
    final next = NotificationService.nextOccurrence(now, 10, 35);
    expect(next, tz.TZDateTime(tz.local, 2026, 8, 6, 10, 35));
  });

  test('nextOccurrence rolls to tomorrow once the time has passed', () {
    tz.setLocalLocation(tz.getLocation('Asia/Manila'));
    final now = tz.TZDateTime(tz.local, 2026, 8, 6, 10, 40);
    final next = NotificationService.nextOccurrence(now, 10, 35);
    expect(next, tz.TZDateTime(tz.local, 2026, 8, 7, 10, 35));
  });

  test('nextOccurrence is timezone-aware, never interpreted as UTC', () {
    tz.setLocalLocation(tz.getLocation('Asia/Manila'));
    final now = tz.TZDateTime(tz.local, 2026, 8, 6, 10, 0);
    final next = NotificationService.nextOccurrence(now, 10, 35);
    expect(next.toUtc(), tz.TZDateTime(tz.UTC, 2026, 8, 6, 2, 35));
  });

  test('nextOccurrence never lands in the past', () {
    tz.setLocalLocation(tz.getLocation('UTC'));
    final now = tz.TZDateTime(tz.local, 2026, 8, 6, 23, 59, 59);
    final next = NotificationService.nextOccurrence(now, 0, 0);
    expect(next.isAfter(now), isTrue);
    expect(next.day, 7);
  });
}
