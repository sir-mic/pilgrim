import 'dart:convert';

import 'book_table.dart';
import 'default_copy.dart';
import 'mcheyne_parser.dart';
import 'models.dart';
import 'verse_library.dart';

/// Builds the three Pilgrim reading plans.
///
/// These are shared by the build CLI and the web admin tool so a bundle built
/// in the browser is byte-for-byte consistent with one built on disk.

/// One chapter a day, every book, in canonical order.
PlanDefinition buildSlowWalkPlan() {
  final days = <PlanDay>[];
  var day = 1;
  for (final book in books) {
    for (var chapter = 1; chapter <= book.chapters; chapter++, day++) {
      days.add(PlanDay(
        day: day,
        readings: [
          ReadingRef(book: book.name, start: chapter),
        ],
        estimatedMinutes: estimateMinutes(book.name, 1),
      ));
    }
  }
  return PlanDefinition(
    slug: 'slow-walk',
    title: 'Slow Walk',
    description:
        'One book at a time, one chapter a day. A gentle pace for careful study.',
    kind: 'sequential',
    days: days,
  );
}

/// One chapter a day, in the order the events happened.
PlanDefinition buildChronologicalPlan() {
  final days = <PlanDay>[];
  var day = 1;
  for (final bookName in chronologicalOrder) {
    final book = bookByName(bookName)!;
    for (var chapter = 1; chapter <= book.chapters; chapter++, day++) {
      days.add(PlanDay(
        day: day,
        readings: [
          ReadingRef(book: book.name, start: chapter),
        ],
        estimatedMinutes: estimateMinutes(book.name, 1),
      ));
    }
  }
  return PlanDefinition(
    slug: 'chronological',
    title: 'Chronological',
    description:
        'Read the Bible in the order events happened, one chapter a day.',
    kind: 'sequential',
    days: days,
  );
}

/// The classic M'Cheyne plan, from the public-domain source JSON.
PlanDefinition buildBibleInOneYearPlan(String mcheyneSourceJson) {
  final list = jsonDecode(mcheyneSourceJson) as List<dynamic>;
  final entries = list
      .map((e) => e as Map<String, dynamic>)
      .toList()
    ..sort((a, b) {
      final ma = a['month'] as int, mb = b['month'] as int;
      final da = a['day'] as int, db = b['day'] as int;
      return (ma * 100 + da).compareTo(mb * 100 + db);
    });

  final days = <PlanDay>[];
  for (var i = 0; i < entries.length; i++) {
    final entry = entries[i];
    final readings = (entry['readings'] as List<dynamic>).expand((r) {
      final map = r as Map<String, dynamic>;
      final reference = map['reference'] as String;
      final parsed = parseMcHeyneReference(reference);
      if (parsed.length == 1) {
        return [parsed.first.copyWith(section: map['label'] as String?)];
      }
      return parsed;
    }).toList();
    days.add(PlanDay(
      day: i + 1,
      readings: readings,
      estimatedMinutes: readings.fold<int>(
        0,
        (sum, r) => sum + estimateMinutes(r.book, r.endChapter - r.start + 1),
      ),
    ));
  }

  return PlanDefinition(
    slug: 'bible-in-one-year',
    title: 'Bible in One Year',
    description:
        'The classic M\'Cheyne plan: Old Testament, New Testament, Psalms and '
        'Proverbs each day. About 15–20 minutes.',
    kind: 'mcheyne',
    days: days,
  );
}

/// The default bundle content: all three plans and the shipped copy.
BundleContent buildDefaultBundleContent(
  int version, {
  required String mcheyneSourceJson,
  List<String>? reflectionPrompts,
  List<String>? notificationMessages,
  List<VerseNudge>? verseNudges,
}) {
  return BundleContent(
    plans: [
      buildSlowWalkPlan(),
      buildBibleInOneYearPlan(mcheyneSourceJson),
      buildChronologicalPlan(),
    ],
    reflectionPrompts: reflectionPrompts ?? defaultReflectionPrompts,
    notificationMessages: notificationMessages ?? defaultNotificationMessages,
    verseNudges: verseNudges ?? buildDefaultVerseNudges(),
  );
}
