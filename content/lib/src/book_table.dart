/// Canonical table of the 66 books of the Bible with chapter counts.
///
/// The canonical order is the traditional Protestant order used by the
/// M'Cheyne reading plan and most English Bibles.
library;

/// A single book of the Bible.
class Book {
  const Book(this.name, this.testament, this.chapters);

  /// Full book name as used in reading references, e.g. "1 Samuel".
  final String name;

  /// 'OT' or 'NT'.
  final String testament;

  /// Number of chapters.
  final int chapters;
}

/// All 66 books in canonical order.
const List<Book> books = [
  Book('Genesis', 'OT', 50),
  Book('Exodus', 'OT', 40),
  Book('Leviticus', 'OT', 27),
  Book('Numbers', 'OT', 36),
  Book('Deuteronomy', 'OT', 34),
  Book('Joshua', 'OT', 24),
  Book('Judges', 'OT', 21),
  Book('Ruth', 'OT', 4),
  Book('1 Samuel', 'OT', 31),
  Book('2 Samuel', 'OT', 24),
  Book('1 Kings', 'OT', 22),
  Book('2 Kings', 'OT', 25),
  Book('1 Chronicles', 'OT', 29),
  Book('2 Chronicles', 'OT', 36),
  Book('Ezra', 'OT', 10),
  Book('Nehemiah', 'OT', 13),
  Book('Esther', 'OT', 10),
  Book('Job', 'OT', 42),
  Book('Psalms', 'OT', 150),
  Book('Proverbs', 'OT', 31),
  Book('Ecclesiastes', 'OT', 12),
  Book('Song of Solomon', 'OT', 8),
  Book('Isaiah', 'OT', 66),
  Book('Jeremiah', 'OT', 52),
  Book('Lamentations', 'OT', 5),
  Book('Ezekiel', 'OT', 48),
  Book('Daniel', 'OT', 12),
  Book('Hosea', 'OT', 14),
  Book('Joel', 'OT', 3),
  Book('Amos', 'OT', 9),
  Book('Obadiah', 'OT', 1),
  Book('Jonah', 'OT', 4),
  Book('Micah', 'OT', 7),
  Book('Nahum', 'OT', 3),
  Book('Habakkuk', 'OT', 3),
  Book('Zephaniah', 'OT', 3),
  Book('Haggai', 'OT', 2),
  Book('Zechariah', 'OT', 14),
  Book('Malachi', 'OT', 4),
  Book('Matthew', 'NT', 28),
  Book('Mark', 'NT', 16),
  Book('Luke', 'NT', 24),
  Book('John', 'NT', 21),
  Book('Acts', 'NT', 28),
  Book('Romans', 'NT', 16),
  Book('1 Corinthians', 'NT', 16),
  Book('2 Corinthians', 'NT', 13),
  Book('Galatians', 'NT', 6),
  Book('Ephesians', 'NT', 6),
  Book('Philippians', 'NT', 4),
  Book('Colossians', 'NT', 4),
  Book('1 Thessalonians', 'NT', 5),
  Book('2 Thessalonians', 'NT', 3),
  Book('1 Timothy', 'NT', 6),
  Book('2 Timothy', 'NT', 4),
  Book('Titus', 'NT', 3),
  Book('Philemon', 'NT', 1),
  Book('Hebrews', 'NT', 13),
  Book('James', 'NT', 5),
  Book('1 Peter', 'NT', 5),
  Book('2 Peter', 'NT', 3),
  Book('1 John', 'NT', 5),
  Book('2 John', 'NT', 1),
  Book('3 John', 'NT', 1),
  Book('Jude', 'NT', 1),
  Book('Revelation', 'NT', 22),
];

final Map<String, Book> _byName = {for (final b in books) b.name: b};

/// Looks up a book by its full canonical name.
Book? bookByName(String name) => _byName[name];

/// Total number of chapters in the Bible.
int get totalChapters => books.fold(0, (sum, b) => sum + b.chapters);

/// Chronological reading order of the books, based on standard
/// public-domain scholarship. Each book is read chapter by chapter.
const List<String> chronologicalOrder = [
  'Genesis',
  'Job',
  'Exodus',
  'Leviticus',
  'Numbers',
  'Deuteronomy',
  'Joshua',
  'Judges',
  'Ruth',
  '1 Samuel',
  '2 Samuel',
  '1 Kings',
  '2 Kings',
  '1 Chronicles',
  'Psalms',
  '2 Chronicles',
  'Proverbs',
  'Ecclesiastes',
  'Song of Solomon',
  'Isaiah',
  'Hosea',
  'Joel',
  'Amos',
  'Obadiah',
  'Jonah',
  'Micah',
  'Nahum',
  'Zephaniah',
  'Habakkuk',
  'Jeremiah',
  'Lamentations',
  'Ezekiel',
  'Daniel',
  'Ezra',
  'Esther',
  'Nehemiah',
  'Haggai',
  'Zechariah',
  'Malachi',
  'Matthew',
  'Mark',
  'Luke',
  'John',
  'Acts',
  'James',
  'Galatians',
  '1 Thessalonians',
  '2 Thessalonians',
  '1 Corinthians',
  '2 Corinthians',
  'Romans',
  'Ephesians',
  'Philippians',
  'Colossians',
  'Philemon',
  '1 Timothy',
  '2 Timothy',
  'Titus',
  '1 Peter',
  '2 Peter',
  'Hebrews',
  'Jude',
  '1 John',
  '2 John',
  '3 John',
  'Revelation',
];

/// Rough average minutes to read one chapter, per book. Books whose chapters
/// tend to be long get a higher estimate. Anything not listed falls back to
/// [defaultMinutesPerChapter].
const double defaultMinutesPerChapter = 2.5;

const Map<String, double> _minutesOverride = {
  'Genesis': 3.2,
  'Exodus': 3.2,
  'Job': 3.5,
  'Psalms': 3.5,
  'Proverbs': 2.2,
  'Isaiah': 3.4,
  'Jeremiah': 3.4,
  'Ezekiel': 3.4,
  'Daniel': 3.2,
  'Revelation': 3.0,
};

/// Estimated minutes to read [chapterCount] chapters of [bookName].
int estimateMinutes(String bookName, int chapterCount) {
  final per = _minutesOverride[bookName] ?? defaultMinutesPerChapter;
  final minutes = per * chapterCount;
  return minutes < 1 ? 1 : minutes.round();
}
