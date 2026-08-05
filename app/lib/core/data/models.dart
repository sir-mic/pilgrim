import 'dart:convert';

import 'package:pilgrim_content/pilgrim_content.dart';

/// A completed reading, persisted as a journal entry.
class SessionEntry {
  const SessionEntry({
    required this.id,
    required this.date,
    required this.planSlug,
    required this.dayIndex,
    required this.prompt,
    required this.reflection,
    this.prayer,
    this.mood,
    required this.readings,
    required this.completedAt,
  });

  final int id;
  final DateTime date;
  final String planSlug;
  final int dayIndex;
  final String prompt;
  final String reflection;
  final String? prayer;
  final String? mood;
  final List<ReadingRef> readings;
  final DateTime completedAt;
}

/// Everything the home screen needs to render today's reading.
class CurrentReading {
  const CurrentReading({
    required this.plan,
    required this.currentDay,
    required this.completedCount,
    this.todaysSession,
  });

  final PlanDefinition plan;

  /// 1-based index of the next reading (one past the last completed).
  final int currentDay;

  /// Days completed in the current run of the plan.
  final int completedCount;

  final SessionEntry? todaysSession;

  bool get planFinished => currentDay > plan.totalDays;

  PlanDay? get day => planFinished ? null : plan.days[currentDay - 1];

  /// True once the user has ever read with this plan.
  bool get hasHistory => completedCount > 0 || currentDay > 1;
}

String encodeReadings(List<ReadingRef> readings) =>
    jsonEncode(readings.map((r) => r.toJson()).toList());

List<ReadingRef> decodeReadings(String raw) => (jsonDecode(raw) as List<dynamic>)
    .map((e) => ReadingRef.fromJson(e as Map<String, dynamic>))
    .toList();
