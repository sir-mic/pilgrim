import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:pilgrim_content/pilgrim_content.dart';

import 'package:pilgrim_app/core/content/content_repository.dart';
import 'package:pilgrim_app/core/content/signature_verifier.dart';
import 'package:pilgrim_app/core/data/app_repository.dart';
import 'package:pilgrim_app/core/database/app_database.dart';

/// Serves a fixed response body over HTTP for the injected client.
class _FakeClient extends http.BaseClient {
  _FakeClient(this.body);
  final String body;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(Stream.value(utf8.encode(body)), 200);
  }
}

void main() {
  late AppDatabase db;
  late ContentRepository content;
  late AppRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    content = ContentRepository(db);
    repo = AppRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<SignedBundle> loadBundled() async {
    final raw = File('assets/content/content.json').readAsStringSync();
    final bundle = SignedBundle.decode(raw);
    final verifier = BundleVerifier();
    expect(await verifier.verify(bundle), isTrue);
    return bundle;
  }

  test('bundled content seeds plans and today\'s reading', () async {
    await content.reconcile(await loadBundled());

    final plans = await repo.allPlans();
    expect(plans.length, 3);

    await repo.setCurrentPlan('bible-in-one-year');
    final reading =
        await repo.currentReading('bible-in-one-year', DateTime(2026, 8, 5));

    expect(reading.plan.slug, 'bible-in-one-year');
    expect(reading.currentDay, 1);
    expect(reading.day!.readings, isNotEmpty);
    expect(reading.day!.readings.first.display(), isNotEmpty);
  });

  test('completing a reading writes a searchable journal entry', () async {
    await content.reconcile(await loadBundled());
    await repo.setCurrentPlan('slow-walk');

    final reading =
        await repo.currentReading('slow-walk', DateTime(2026, 8, 5));
    await repo.insertSession(
      date: DateTime(2026, 8, 5),
      planSlug: 'slow-walk',
      dayIndex: reading.currentDay,
      prompt: 'What did God show you today?',
      reflection: 'He is near.',
      prayer: 'Thank you.',
      mood: 'Peaceful',
      readings: reading.day!.readings,
    );

    final journal = await repo.watchSessions().first;
    expect(journal.length, 1);
    expect(journal.first.reflection, 'He is near.');
    expect(journal.first.mood, 'Peaceful');
    expect(journal.first.readings.first.display(),
        reading.day!.readings.first.display());

    final found = await repo.searchSessions('near');
    expect(found.length, 1);
    expect(await repo.completedCount('slow-walk'), 1);
    expect(await repo.totalSessions(), 1);
    expect(await repo.completedPlans(), isEmpty);
  });

  test('restarting a plan resets progress but keeps the journal', () async {
    await content.reconcile(await loadBundled());
    await repo.setCurrentPlan('slow-walk');

    final reading =
        await repo.currentReading('slow-walk', DateTime(2026, 8, 5));
    await repo.insertSession(
      date: DateTime(2026, 8, 5),
      planSlug: 'slow-walk',
      dayIndex: 1,
      prompt: 'What did God show you today?',
      reflection: 'A small step.',
      readings: reading.day!.readings,
    );
    expect(await repo.completedCount('slow-walk'), 1);

    await repo.restartCurrentPlan();
    expect(await repo.completedCount('slow-walk'), 0);
    expect(await repo.totalSessions(), 1);
  });

  test('settings persist and read back', () async {
    await repo.setSetting(AppRepository.keyThemeMode, 'light');
    await repo.setSetting(AppRepository.keyReminderHour, '6');
    await repo.setSetting(AppRepository.keyReminderMinute, '30');
    await repo.setCurrentPlan('chronological');
    await repo.setOnboarded();

    expect(await repo.getSetting(AppRepository.keyThemeMode), 'light');
    expect(await repo.reminderHour(), 6);
    expect(await repo.reminderMinute(), 30);
    expect(await repo.currentPlanSlug(), 'chronological');
    expect(await repo.isOnboarded(), isTrue);
  });

  group('reading progress', () {
    final day = DateTime(2026, 8, 5);

    test('partial progress persists, reads back, and clears', () async {
      await repo.setReadingProgress(
        planSlug: 'slow-walk',
        date: day,
        dayIndex: 1,
        done: [0],
      );
      expect(await repo.readingProgress('slow-walk', day), [0]);

      await repo.setReadingProgress(
        planSlug: 'slow-walk',
        date: day,
        dayIndex: 1,
        done: [0, 1],
      );
      expect(await repo.readingProgress('slow-walk', day), [0, 1]);

      await repo.setReadingProgress(
        planSlug: 'slow-walk',
        date: day,
        dayIndex: 1,
        done: [],
      );
      expect(await repo.readingProgress('slow-walk', day), isNull);
    });

    test('progress is keyed by date, so stale days are ignored', () async {
      await repo.setReadingProgress(
        planSlug: 'slow-walk',
        date: day,
        dayIndex: 1,
        done: [0],
      );
      expect(
        await repo.readingProgress('slow-walk', day.add(const Duration(days: 1))),
        isNull,
      );
    });

    test('currentReading includes today\'s partial progress', () async {
      await content.reconcile(await loadBundled());
      await repo.setCurrentPlan('bible-in-one-year');
      await repo.setReadingProgress(
        planSlug: 'bible-in-one-year',
        date: day,
        dayIndex: 1,
        done: [0, 2],
      );

      final reading = await repo.currentReading('bible-in-one-year', day);
      expect(reading.inProgressDone, [0, 2]);
      expect(reading.hasInProgress, isTrue);
      expect(reading.progressDate, '2026-08-05');
    });

    test('completing a session clears the day\'s partial progress', () async {
      await content.reconcile(await loadBundled());
      await repo.setCurrentPlan('slow-walk');
      await repo.setReadingProgress(
        planSlug: 'slow-walk',
        date: day,
        dayIndex: 1,
        done: [0],
      );

      final reading = await repo.currentReading('slow-walk', day);
      await repo.insertSession(
        date: day,
        planSlug: 'slow-walk',
        dayIndex: reading.currentDay,
        prompt: 'What did God show you today?',
        reflection: 'He is near.',
        readings: reading.day!.readings,
      );

      expect(await repo.readingProgress('slow-walk', day), isNull);
    });

    test('restarting a plan clears today\'s partial progress', () async {
      await repo.setReadingProgress(
        planSlug: 'slow-walk',
        date: DateTime.now(),
        dayIndex: 3,
        done: [0],
      );
      await repo.restartPlan('slow-walk');
      expect(
        await repo.readingProgress('slow-walk', DateTime.now()),
        isNull,
      );
    });
  });

  group('remote refresh', () {
    /// Builds a signed [version] bundle whose prompts/messages differ from the
    /// bundled defaults, using the real maintainer signing key.
    Future<SignedBundle> signed(int version, {String? prompt}) async {
      final v1 =
          SignedBundle.decode(File('assets/content/content.json').readAsStringSync());
      final pem = File('../content/keys/private_key.pem').readAsStringSync();
      final content = BundleContent(
        plans: v1.content.plans,
        reflectionPrompts: [prompt ?? 'Remote prompt v$version.'],
        notificationMessages: ['Remote message v$version.'],
      );
      final signature = await signBundleFromPem(content, pem);
      return SignedBundle(
          version: version, content: content, signature: signature);
    }

    Future<int?> storedVersion() async {
      final row = await (db.select(db.contentMeta)
            ..where((t) => t.id.equals('app')))
          .getSingleOrNull();
      return row?.version;
    }

    test('applies a newer signed bundle', () async {
      await content.reconcile(await loadBundled());
      expect(await storedVersion(), 1);
      expect(await repo.notificationMessages(),
          contains('The Word is waiting.'));

      final v2 = await signed(2);
      final remote = ContentRepository(db, client: _FakeClient(v2.encode()));
      await remote.refreshRemote();

      expect(await storedVersion(), 2);
      expect(await repo.notificationMessages(), ['Remote message v2.']);
      expect(await repo.randomPrompt(random: Random(1)), 'Remote prompt v2.');
    });

    test('ignores an older bundle', () async {
      await content.reconcile(await loadBundled());
      final stale = await signed(1, prompt: 'Old prompt.');
      final remote = ContentRepository(db, client: _FakeClient(stale.encode()));
      await remote.refreshRemote();

      expect(await storedVersion(), 1);
      expect(await repo.notificationMessages(),
          isNot(contains('Remote message v1.')));
    });

    test('ignores a tampered bundle', () async {
      await content.reconcile(await loadBundled());
      final v2 = await signed(2);
      final tampered = SignedBundle(
        version: v2.version,
        content: v2.content,
        signature: 'AAAA${v2.signature.substring(4)}',
      );
      final remote =
          ContentRepository(db, client: _FakeClient(tampered.encode()));
      await remote.refreshRemote();

      expect(await storedVersion(), 1);
      expect(await repo.notificationMessages(),
          isNot(contains('Remote message v2.')));
    });
  });
}
