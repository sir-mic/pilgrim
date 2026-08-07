/// Data models for the signed content bundle shipped with Pilgrim.
library;

import 'dart:convert';

import 'book_table.dart';

/// A single reading reference, e.g. "John 1-3" or "Psalm 23".
class ReadingRef {
  const ReadingRef({
    required this.book,
    required this.start,
    this.end,
    this.section,
    this.startVerse,
    this.endVerse,
  });

  final String book;
  final int start;
  final int? end;

  /// End chapter; defaults to [start] for a single-chapter reading.
  int get endChapter => end ?? start;

  /// The section label from the source plan (e.g. "Family Reading 1").
  /// Only present on M'Cheyne plan days.
  final String? section;

  /// Optional verse range (for chapter-portion readings such as Psalm 119).
  final int? startVerse;
  final int? endVerse;

  ReadingRef copyWith({String? section}) => ReadingRef(
        book: book,
        start: start,
        end: end,
        section: section ?? this.section,
        startVerse: startVerse,
        endVerse: endVerse,
      );

  String display() {
    final chapterText =
        end == null || end == start ? '$start' : '$start–$end';
    final verseText = startVerse == null
        ? ''
        : ':' +
            (endVerse == null || endVerse == startVerse
                ? '$startVerse'
                : '$startVerse–$endVerse');
    return '$book $chapterText$verseText';
  }

  factory ReadingRef.fromJson(Map<String, dynamic> json) => ReadingRef(
        book: json['book'] as String,
        start: json['start'] as int,
        end: json['end'] as int?,
        section: json['section'] as String?,
        startVerse: json['startVerse'] as int?,
        endVerse: json['endVerse'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'book': book,
        'start': start,
        if (end != null) 'end': end,
        if (section != null) 'section': section,
        if (startVerse != null) 'startVerse': startVerse,
        if (endVerse != null) 'endVerse': endVerse,
      };
}

/// One day of a reading plan.
class PlanDay {
  const PlanDay({
    required this.day,
    required this.readings,
    required this.estimatedMinutes,
  });

  /// 1-based day index within the plan.
  final int day;
  final List<ReadingRef> readings;
  final int estimatedMinutes;

  factory PlanDay.fromJson(Map<String, dynamic> json) => PlanDay(
        day: json['day'] as int,
        readings: (json['readings'] as List<dynamic>)
            .map((e) => ReadingRef.fromJson(e as Map<String, dynamic>))
            .toList(),
        estimatedMinutes: json['estimatedMinutes'] as int,
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'readings': readings.map((r) => r.toJson()).toList(),
        'estimatedMinutes': estimatedMinutes,
      };
}

/// A reading plan definition.
class PlanDefinition {
  const PlanDefinition({
    required this.slug,
    required this.title,
    required this.description,
    required this.kind,
    required this.days,
  });

  final String slug;
  final String title;
  final String description;

  /// 'sequential' (one chapter per day through the Bible) or 'mcheyne'.
  final String kind;
  final List<PlanDay> days;

  int get totalDays => days.length;

  factory PlanDefinition.fromJson(Map<String, dynamic> json) => PlanDefinition(
        slug: json['slug'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        kind: json['kind'] as String,
        days: (json['days'] as List<dynamic>)
            .map((e) => PlanDay.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'title': title,
        'description': description,
        'kind': kind,
        'days': days.map((d) => d.toJson()).toList(),
      };
}

/// One Bible verse for the mic drop notifications, tagged with its [category]
/// (e.g. "hope", "temptation", "peace").
class VerseNudge {
  const VerseNudge({
    required this.category,
    required this.text,
    required this.reference,
  });

  final String category;
  final String text;
  final String reference;

  factory VerseNudge.fromJson(Map<String, dynamic> json) => VerseNudge(
        category: json['category'] as String,
        text: json['text'] as String,
        reference: json['reference'] as String,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'text': text,
        'reference': reference,
      };
}

/// The editorial content carried in a signed bundle.
class BundleContent {
  const BundleContent({
    required this.plans,
    required this.reflectionPrompts,
    required this.notificationMessages,
    this.verseNudges = const [],
  });

  final List<PlanDefinition> plans;
  final List<String> reflectionPrompts;
  final List<String> notificationMessages;

  /// Bible verses for the mic drop notifications. Absent in older bundles.
  final List<VerseNudge> verseNudges;

  factory BundleContent.fromJson(Map<String, dynamic> json) => BundleContent(
        plans: (json['plans'] as List<dynamic>)
            .map((e) => PlanDefinition.fromJson(e as Map<String, dynamic>))
            .toList(),
        reflectionPrompts: (json['reflectionPrompts'] as List<dynamic>)
            .cast<String>(),
        notificationMessages: (json['notificationMessages'] as List<dynamic>)
            .cast<String>(),
        verseNudges: (json['verseNudges'] as List<dynamic>? ?? const [])
            .map((e) => VerseNudge.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'plans': plans.map((p) => p.toJson()).toList(),
        'reflectionPrompts': reflectionPrompts,
        'notificationMessages': notificationMessages,
        'verseNudges': verseNudges.map((v) => v.toJson()).toList(),
      };
}

/// A signed content bundle: versioned editorial content plus an Ed25519
/// signature over the canonical JSON encoding of [content].
class SignedBundle {
  const SignedBundle({
    required this.version,
    required this.content,
    required this.signature,
  });

  final int version;
  final BundleContent content;

  /// Base64-encoded Ed25519 signature over the canonical encoding of [content].
  final String signature;

  Map<String, dynamic> toJson() => {
        'version': version,
        'content': content.toJson(),
        'signature': signature,
      };

  factory SignedBundle.fromJson(Map<String, dynamic> json) => SignedBundle(
        version: json['version'] as int,
        content: BundleContent.fromJson(json['content'] as Map<String, dynamic>),
        signature: json['signature'] as String,
      );

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  static SignedBundle decode(String raw) =>
      SignedBundle.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
