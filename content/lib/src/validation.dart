/// Validation of content bundles and reading plans.
///
/// These rules are also the basis of the package's automated tests, so a
/// content change is verified before it ships.
library;

import 'book_table.dart';
import 'models.dart';

/// Thrown when a bundle fails validation.
class ValidationException implements Exception {
  ValidationException(this.messages);

  final List<String> messages;

  @override
  String toString() => 'Validation failed:\n- ${messages.join('\n- ')}';
}

void validateBundle(BundleContent content) {
  final messages = <String>[];

  if (content.reflectionPrompts.isEmpty) {
    messages.add('reflectionPrompts must not be empty');
  }
  if (content.notificationMessages.isEmpty) {
    messages.add('notificationMessages must not be empty');
  }

  final slugs = <String>{};
  for (final plan in content.plans) {
    if (!slugs.add(plan.slug)) {
      messages.add('duplicate plan slug: ${plan.slug}');
    }
    _validatePlan(plan, messages);
  }

  if (messages.isNotEmpty) {
    throw ValidationException(messages);
  }
}

void _validatePlan(PlanDefinition plan, List<String> messages) {
  final prefix = 'plan ${plan.slug}';
  if (plan.days.isEmpty) {
    messages.add('$prefix has no days');
    return;
  }
  var previous = 0;
  for (final day in plan.days) {
    if (day.day != previous + 1) {
      messages.add('$prefix days must be 1..N in order, found ${day.day} '
          'after $previous');
    }
    previous = day.day;
    if (day.readings.isEmpty) {
      messages.add('$prefix day ${day.day} has no readings');
    }
    for (final reading in day.readings) {
      final book = bookByName(reading.book);
      if (book == null) {
        messages.add('$prefix day ${day.day}: unknown book "${reading.book}"');
        continue;
      }
      if (reading.start < 1 ||
          reading.start > book.chapters ||
          reading.endChapter > book.chapters) {
        messages.add('$prefix day ${day.day}: ${reading.book} '
            'chapters ${reading.start}–${reading.endChapter} exceed '
            '${book.chapters}');
      }
      if (reading.endChapter < reading.start) {
        messages.add('$prefix day ${day.day}: ${reading.book} end before '
            'start');
      }
    }
  }

  switch (plan.kind) {
    case 'sequential':
      _validateCoverage(plan, messages: messages, atMostOnce: true);
    case 'mcheyne':
      if (plan.totalDays != 365) {
        messages.add('$prefix M\'Cheyne plan must have 365 days, '
            'has ${plan.totalDays}');
      }
      // The M'Cheyne family of plans deliberately splits long chapters (e.g.
      // Psalm 119) across many days and repeats others, so only "covered at
      // least once" is enforced here.
      _validateCoverage(plan, messages: messages, atMostOnce: false);
  }
}

void _validateCoverage(
  PlanDefinition plan, {
  required List<String> messages,
  required bool atMostOnce,
}) {
  final prefix = 'plan ${plan.slug}';
  final count = <String, int>{};
  for (final book in books) {
    for (var c = 1; c <= book.chapters; c++) {
      count['${book.name} $c'] = 0;
    }
  }
  for (final day in plan.days) {
    for (final reading in day.readings) {
      for (var c = reading.start; c <= reading.endChapter; c++) {
        final key = '${reading.book} $c';
        if (count.containsKey(key)) count[key] = count[key]! + 1;
      }
    }
  }

  final missing = count.entries.where((e) => e.value == 0).toList();
  if (missing.isNotEmpty) {
    messages.add('$prefix missing ${missing.length} chapters '
        '(first: ${missing.first.key})');
  }

  if (atMostOnce) {
    final duplicated = count.entries.where((e) => e.value > 1).toList();
    if (duplicated.isNotEmpty) {
      messages.add('$prefix reads ${duplicated.length} chapters more than '
          'once (first: ${duplicated.first.key})');
    }
  }
}
