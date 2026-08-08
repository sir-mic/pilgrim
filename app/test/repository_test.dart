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

    test('multiple chapters in one day keep the latest as today\'s reading',
        () async {
      await content.reconcile(await loadBundled());
      await repo.setCurrentPlan('slow-walk');
      final day = DateTime(2026, 8, 5);

      final first = await repo.currentReading('slow-walk', day);
      await repo.insertSession(
        date: day,
        planSlug: 'slow-walk',
        dayIndex: first.currentDay,
        prompt: 'What did God show you today?',
        reflection: 'First chapter.',
        readings: first.day!.readings,
      );
      final second = await repo.currentReading('slow-walk', day);
      expect(second.currentDay, 2);
      await repo.insertSession(
        date: day,
        planSlug: 'slow-walk',
        dayIndex: second.currentDay,
        prompt: 'What did God show you today?',
        reflection: 'Second chapter.',
        readings: second.day!.readings,
      );

      final todays = await repo.sessionOnDate('slow-walk', day);
      expect(todays!.dayIndex, 2);
      expect(todays.reflection, 'Second chapter.');

      final reading = await repo.currentReading('slow-walk', day);
      expect(reading.completedCount, 2);
      expect(reading.currentDay, 3);
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

  /// Builds a signed [version] bundle whose prompts/messages/verses differ
  /// from the bundled defaults, using the real maintainer signing key.
  Future<SignedBundle> signed(int version, {String? prompt}) async {
    final v1 = SignedBundle.decode(
        File('assets/content/content.json').readAsStringSync());
    final pem = File('../content/keys/private_key.pem').readAsStringSync();
    final content = BundleContent(
      plans: v1.content.plans,
      reflectionPrompts: [prompt ?? 'Remote prompt v$version.'],
      notificationMessages: ['Remote message v$version.'],
      verseNudges: const [
        VerseNudge(
          category: 'hope',
          text: 'Remote verse text.',
          reference: 'Romans 15:13',
        ),
      ],
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

  group('mic drop', () {
    test('bundled content seeds verses across categories', () async {
      await content.reconcile(await loadBundled());

      final verses = await repo.allMicDropVerses();
      expect(verses.length, greaterThanOrEqualTo(100));
      final categories = verses.map((v) => v.category).toSet();
      expect(categories, containsAll(['hope', 'temptation', 'peace']));
      final hope = verses.where((v) => v.category == 'hope');
      expect(hope, isNotEmpty);
      expect(hope.first.text.trim(), isNotEmpty);
      expect(hope.first.reference.trim(), isNotEmpty);
    });

    test('settings round-trip', () async {
      expect(await repo.micDropEnabled(), isFalse);
      expect(await repo.micDropIntervalHours(), isNull);
      expect(await repo.micDropCategories(), isNull);

      await repo.setMicDropEnabled(true);
      await repo.setMicDropIntervalHours(3);
      await repo.setMicDropCategories(['hope', 'peace']);

      expect(await repo.micDropEnabled(), isTrue);
      expect(await repo.micDropIntervalHours(), 3);
      expect(await repo.micDropCategories(), ['hope', 'peace']);

      await repo.clearMicDropCategories();
      expect(await repo.micDropCategories(), isNull);
    });

    test('remote bundle replaces the verse pool', () async {
      await content.reconcile(await loadBundled());
      expect(await repo.allMicDropVerses(), isNotEmpty);

      final remote = ContentRepository(
        db,
        client: _FakeClient((await signed(3)).encode()),
      );
      await remote.refreshRemote();

      final verses = await repo.allMicDropVerses();
      expect(verses.single.category, 'hope');
      expect(verses.single.reference, 'Romans 15:13');
    });
  });

  group('remote refresh', () {
    test('applies a newer signed bundle', () async {
      await content.reconcile(await loadBundled());
      expect(await storedVersion(), 2);
      expect(await repo.notificationMessages(),
          contains('The Word is waiting.'));

      final v3 = await signed(3);
      final remote = ContentRepository(db, client: _FakeClient(v3.encode()));
      await remote.refreshRemote();

      expect(await storedVersion(), 3);
      expect(await repo.notificationMessages(), ['Remote message v3.']);
      expect(await repo.randomPrompt(random: Random(1)), 'Remote prompt v3.');
    });

    test('ignores an older bundle', () async {
      await content.reconcile(await loadBundled());
      final stale = await signed(1, prompt: 'Old prompt.');
      final remote = ContentRepository(db, client: _FakeClient(stale.encode()));
      await remote.refreshRemote();

      expect(await storedVersion(), 2);
      expect(await repo.notificationMessages(),
          isNot(contains('Remote message v1.')));
    });

    test('ignores a tampered bundle', () async {
      await content.reconcile(await loadBundled());
      final v3 = await signed(3);
      final tampered = SignedBundle(
        version: v3.version,
        content: v3.content,
        signature: 'AAAA${v3.signature.substring(4)}',
      );
      final remote =
          ContentRepository(db, client: _FakeClient(tampered.encode()));
      await remote.refreshRemote();

      expect(await storedVersion(), 2);
      expect(await repo.notificationMessages(),
          isNot(contains('Remote message v3.')));
    });
  });
}
