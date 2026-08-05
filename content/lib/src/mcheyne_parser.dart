/// Parser for M'Cheyne-style chapter references.
///
/// Source references may be chapter-level ("Genesis 9-10"), verse-level
/// ("Luke 1:1-38") or comma-separated multi-part ("Isaiah 8, 9:1-7").
/// Verse-level granularity is preserved for display and coverage so that
/// long chapters such as Psalm 119 stay true to the original plan.
library;

import 'book_table.dart';
import 'models.dart';

final Map<String, String> _aliases = {
  'Psalm': 'Psalms',
};

List<String> get _bookNamesByLength => [
      ..._aliases.keys,
      ...books.map((b) => b.name),
    ]..sort((a, b) => b.length.compareTo(a.length));

/// Parses a M'Cheyne reference into one or more readings.
List<ReadingRef> parseMcHeyneReference(String reference) {
  final parts = reference
      .split(',')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();

  final raw = <_RawPart>[];
  String? currentBook;

  for (final part in parts) {
    String? book;
    var rest = part;
    for (final name in _bookNamesByLength) {
      if (part.startsWith(name) &&
          (part.length == name.length || part[name.length] == ' ')) {
        book = _aliases[name] ?? name;
        rest = part.substring(name.length).trimLeft();
        break;
      }
    }
    if (book != null) {
      currentBook = book;
    } else if (currentBook == null) {
      throw FormatException('Reference without a book: "$reference"');
    }
    final chapter = _parseChapterAndVerses(rest, reference);
    raw.add(_RawPart(
      book: currentBook!,
      start: chapter.start,
      end: chapter.end,
      startVerse: chapter.startVerse,
      endVerse: chapter.endVerse,
    ));
  }

  // Merge overlapping or adjacent ranges per book.
  final byBook = <String, List<_RawPart>>{};
  for (final r in raw) {
    byBook.putIfAbsent(r.book, () => []).add(r);
  }

  final result = <ReadingRef>[];
  byBook.forEach((book, ranges) {
    ranges.sort((a, b) => a.start.compareTo(b.start));
    var mergedStart = ranges.first.start;
    var mergedEnd = ranges.first.end;
    var verseStart = ranges.first.startVerse;
    var verseEnd = ranges.first.endVerse;
    for (final r in ranges.skip(1)) {
      if (r.start <= mergedEnd + 1) {
        if (r.end > mergedEnd) mergedEnd = r.end;
        if (r.startVerse != null && verseStart == null) {
          verseStart = r.startVerse;
          verseEnd = r.endVerse;
        }
      } else {
        result.add(_toRef(book, mergedStart, mergedEnd, verseStart, verseEnd));
        mergedStart = r.start;
        mergedEnd = r.end;
        verseStart = r.startVerse;
        verseEnd = r.endVerse;
      }
    }
    result.add(_toRef(book, mergedStart, mergedEnd, verseStart, verseEnd));
  });

  return result;
}

ReadingRef _toRef(
    String book, int start, int end, int? verseStart, int? verseEnd) {
  final singleChapter = start == end;
  return ReadingRef(
    book: book,
    start: start,
    end: end == start ? null : end,
    startVerse: singleChapter ? verseStart : null,
    endVerse: singleChapter ? verseEnd : null,
  );
}

({int start, int end, int? startVerse, int? endVerse}) _parseChapterAndVerses(
    String rest, String reference) {
  final match =
      RegExp(r'^(\d+)(?:-(\d+))?(?::(\d+)(?:-(\d+))?)?').firstMatch(rest);
  if (match == null) {
    throw FormatException('Cannot parse chapter in "$reference"');
  }
  final start = int.parse(match.group(1)!);
  final endText = match.group(2);
  final end = endText == null ? start : int.parse(endText);
  if (end < start) {
    throw FormatException('Chapter range reversed in "$reference"');
  }
  final startVerseText = match.group(3);
  final startVerse =
      startVerseText == null ? null : int.parse(startVerseText);
  final endVerseText = match.group(4);
  final endVerse = endVerseText == null ? startVerse : int.parse(endVerseText);
  return (
    start: start,
    end: end,
    startVerse: startVerse,
    endVerse: endVerse,
  );
}

class _RawPart {
  const _RawPart({
    required this.book,
    required this.start,
    required this.end,
    this.startVerse,
    this.endVerse,
  });

  final String book;
  final int start;
  final int end;
  final int? startVerse;
  final int? endVerse;
}
