import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import 'package:pilgrim_app/core/content/content_repository.dart';
import 'package:pilgrim_app/core/database/app_database.dart';
import 'package:pilgrim_app/core/providers.dart';
import 'package:pilgrim_app/features/settings/settings_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(tz_data.initializeTimeZones);

  late AppDatabase db;

  setUp(() async {
    FlutterLocalNotificationsPlatform.instance =
        AndroidFlutterLocalNotificationsPlugin();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final raw = File('assets/content/content.json').readAsStringSync();
    await ContentRepository(db).reconcile(SignedBundle.decode(raw));
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          home: Scaffold(body: SettingsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enableMicDrop(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.widgetWithText(SwitchListTile, 'mic drop'),
      200,
    );
    await tester.tap(find.widgetWithText(SwitchListTile, 'mic drop'));
    await tester.pumpAndSettle();
  }

  FilterChip chip(WidgetTester tester, String label) =>
      tester.widget<FilterChip>(
        find.ancestor(
          of: find.text(label),
          matching: find.byType(FilterChip),
        ),
      );

  testWidgets('chips start unselected; tapping selects, multiple stay on',
      (tester) async {
    await pumpSettings(tester);
    await enableMicDrop(tester);

    expect(chip(tester, 'Hope').selected, isFalse);
    expect(chip(tester, 'Peace').selected, isFalse);
    expect(chip(tester, 'Joy').selected, isFalse);

    await tester.tap(find.text('Hope'));
    await tester.pumpAndSettle();
    expect(chip(tester, 'Hope').selected, isTrue);
    expect(chip(tester, 'Peace').selected, isFalse);

    await tester.tap(find.text('Peace'));
    await tester.pumpAndSettle();
    expect(chip(tester, 'Hope').selected, isTrue);
    expect(chip(tester, 'Peace').selected, isTrue);
    expect(chip(tester, 'Joy').selected, isFalse);
  });

  testWidgets('deselecting every chip returns to all-categories mode',
      (tester) async {
    await pumpSettings(tester);
    await enableMicDrop(tester);

    await tester.tap(find.text('Hope'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Peace'));
    await tester.pumpAndSettle();
    expect(chip(tester, 'Hope').selected, isTrue);
    expect(chip(tester, 'Peace').selected, isTrue);

    await tester.tap(find.text('Hope'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Peace'));
    await tester.pumpAndSettle();

    expect(chip(tester, 'Hope').selected, isFalse);
    expect(chip(tester, 'Peace').selected, isFalse);
    expect(chip(tester, 'Joy').selected, isFalse);
  });
}
