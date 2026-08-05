import 'dart:math';

import 'package:drift/drift.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import '../database/app_database.dart' hide PlanDay;
import 'models.dart';

/// Reads and writes user data: plans, progress, journal entries and settings.
class AppRepository {
  AppRepository(this._db);

  final AppDatabase _db;

  // ------------------------------------------------------------------ settings

  static const keyPlanSlug = 'planSlug';
  static const keyOnboarded = 'onboarded';
  static const keyReminderEnabled = 'reminderEnabled';
  static const keyReminderHour = 'reminderHour';
  static const keyReminderMinute = 'reminderMinute';
  static const keyThemeMode = 'themeMode';
  static const keyManifestUrl = 'manifestUrl';

  Future<String?> getSetting(String key) async {
    final row = await (_db.select(_db.settingsTable)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) => _db.into(_db.settingsTable)
      .insertOnConflictUpdate(
          SettingsTableCompanion.insert(key: key, value: value));

  Future<String?> currentPlanSlug() => getSetting(keyPlanSlug);

  Future<bool> isOnboarded() async =>
      await getSetting(keyOnboarded) == '1';

  Future<void> setOnboarded() => setSetting(keyOnboarded, '1');

  Future<void> setCurrentPlan(String slug) => setSetting(keyPlanSlug, slug);

  Future<int?> reminderHour() async =>
      int.tryParse(await getSetting(keyReminderHour) ?? '');

  Future<int?> reminderMinute() async =>
      int.tryParse(await getSetting(keyReminderMinute) ?? '');

  Future<bool> reminderEnabled() async =>
      await getSetting(keyReminderEnabled) == '1';

  Future<String?> manifestUrl() => getSetting(keyManifestUrl);

  // ------------------------------------------------------------------- plans

  Future<List<PlanDefinition>> allPlans() async {
    final planRows = await (_db.select(_db.plans)
          ..orderBy([(t) => OrderingTerm(expression: t.title)]))
        .get();
    final result = <PlanDefinition>[];
    for (final plan in planRows) {
      final days = await (_db.select(_db.planDays)
            ..where((t) => t.planSlug.equals(plan.slug))
            ..orderBy([(t) => OrderingTerm(expression: t.dayIndex)]))
          .get();
      result.add(PlanDefinition(
        slug: plan.slug,
        title: plan.title,
        description: plan.description,
        kind: plan.kind,
        days: days
            .map((d) => PlanDay(
                  day: d.dayIndex,
                  readings: decodeReadings(d.readings),
                  estimatedMinutes: d.estimatedMinutes,
                ))
            .toList(),
      ));
    }
    return result;
  }

  Future<PlanDefinition?> planBySlug(String slug) async {
    final plan = await (_db.select(_db.plans)
          ..where((t) => t.slug.equals(slug)))
        .getSingleOrNull();
    if (plan == null) return null;
    final days = await (_db.select(_db.planDays)
          ..where((t) => t.planSlug.equals(slug))
          ..orderBy([(t) => OrderingTerm(expression: t.dayIndex)]))
        .get();
    return PlanDefinition(
      slug: plan.slug,
      title: plan.title,
      description: plan.description,
      kind: plan.kind,
      days: days
          .map((d) => PlanDay(
                day: d.dayIndex,
                readings: decodeReadings(d.readings),
                estimatedMinutes: d.estimatedMinutes,
              ))
          .toList(),
    );
  }

  // ---------------------------------------------------------------- progress

  static String progressKey(String planSlug) => 'progress_$planSlug';

  /// Days completed in the current run of [planSlug].
  Future<int> completedCount(String planSlug) async =>
      int.tryParse(await getSetting(progressKey(planSlug)) ?? '') ?? 0;

  /// Total sessions ever logged for [planSlug] (all runs, journal intact).
  Future<int> totalSessionsForPlan(String planSlug) async {
    final rows = await (_db.select(_db.sessions)
          ..where((t) => t.planSlug.equals(planSlug)))
        .get();
    return rows.length;
  }

  /// Restarts [planSlug] from day one without touching the journal.
  Future<void> restartPlan(String planSlug) =>
      setSetting(progressKey(planSlug), '0');

  /// Restarts whatever plan is currently selected.
  Future<void> restartCurrentPlan() async {
    final slug = await currentPlanSlug();
    if (slug != null) await restartPlan(slug);
  }

  Future<SessionEntry?> sessionOnDate(String planSlug, DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final row = await (_db.select(_db.sessions)
          ..where((t) =>
              t.planSlug.equals(planSlug) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .getSingleOrNull();
    return row == null ? null : _toSession(row);
  }

  /// Loads the current reading for [planSlug] for [today].
  Future<CurrentReading> currentReading(String planSlug, DateTime today) async {
    final plan = await planBySlug(planSlug);
    if (plan == null) {
      throw StateError('Current plan not found: $planSlug');
    }
    final completed = await completedCount(planSlug);
    final todaysSession = await sessionOnDate(planSlug, today);
    return CurrentReading(
      plan: plan,
      currentDay: completed + 1,
      completedCount: completed,
      todaysSession: todaysSession,
    );
  }

  // ----------------------------------------------------------------- sessions

  Future<int> insertSession({
    required DateTime date,
    required String planSlug,
    required int dayIndex,
    required String prompt,
    required String reflection,
    String? prayer,
    String? mood,
    required List<ReadingRef> readings,
  }) async {
    final id = await _db.transaction(() async {
      final newId = await _db.into(_db.sessions).insert(
            SessionsCompanion.insert(
              date: DateTime(date.year, date.month, date.day),
              planSlug: planSlug,
              dayIndex: dayIndex,
              prompt: prompt,
              reflection: reflection,
              prayer: Value(prayer),
              mood: Value(mood),
              readings: encodeReadings(readings),
              completedAt: DateTime.now(),
            ),
          );
      await setSetting(progressKey(planSlug), '$dayIndex');
      return newId;
    });
    return id;
  }

  Stream<List<SessionEntry>> watchSessions() =>
      _db.select(_db.sessions).watch().map((rows) => rows.map(_toSession).toList());

  Future<List<SessionEntry>> searchSessions(String query) async {
    final like = '%${query.toLowerCase()}%';
    final rows = await (_db.select(_db.sessions)
          ..where((t) =>
              t.reflection.lower().like(like) |
              t.prayer.lower().like(like) |
              t.readings.lower().like(like)))
        .get();
    return rows.map(_toSession).toList();
  }

  Future<int> totalSessions() async => (await _db.select(_db.sessions).get()).length;

  Future<Map<String, int>> sessionsPerPlan() async {
    final rows = await _db.select(_db.sessions).get();
    final map = <String, int>{};
    for (final row in rows) {
      map[row.planSlug] = (map[row.planSlug] ?? 0) + 1;
    }
    return map;
  }

  // ------------------------------------------------------------ prompts & copy

  Future<String> randomPrompt({Random? random}) async {
    final prompts = await _db.select(_db.reflectionPrompts).get();
    if (prompts.isEmpty) return 'What did God show you today?';
    return prompts[random?.nextInt(prompts.length) ?? Random().nextInt(prompts.length)].prompt;
  }

  Future<List<String>> notificationMessages() async {
    final rows = await _db.select(_db.notificationMessages).get();
    return rows.map((r) => r.message).toList();
  }

  /// Plans the user has completed at least once, ever.
  Future<List<PlanDefinition>> completedPlans() async {
    final rows = await _db.select(_db.sessions).get();
    final maxDay = <String, int>{};
    for (final row in rows) {
      final current = maxDay[row.planSlug] ?? 0;
      if (row.dayIndex > current) maxDay[row.planSlug] = row.dayIndex;
    }
    final plans = await allPlans();
    return plans.where((p) => (maxDay[p.slug] ?? 0) >= p.totalDays).toList();
  }

  // ----------------------------------------------------------------- helpers

  SessionEntry _toSession(Session row) => SessionEntry(
        id: row.id,
        date: row.date,
        planSlug: row.planSlug,
        dayIndex: row.dayIndex,
        prompt: row.prompt,
        reflection: row.reflection,
        prayer: row.prayer,
        mood: row.mood,
        readings: decodeReadings(row.readings),
        completedAt: row.completedAt,
      );
}
