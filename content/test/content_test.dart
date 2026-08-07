import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:pilgrim_content/pilgrim_content.dart';
import 'package:test/test.dart';

void main() {
  group('book table', () {
    test('has 66 books', () {
      expect(books.length, 66);
    });

    test('total chapters is 1189', () {
      expect(totalChapters, 1189);
    });

    test('chronological order covers all books exactly once', () {
      expect(chronologicalOrder.length, 66);
      expect(chronologicalOrder.toSet().length, 66);
      for (final name in chronologicalOrder) {
        expect(bookByName(name), isNotNull, reason: name);
      }
    });
  });

  group('canonical JSON', () {
    test('is deterministic and sorted', () {
      final a = canonicalEncode({'b': 2, 'a': [1, {'z': true}], 'c': null});
      final b = canonicalEncode({'c': null, 'b': 2, 'a': [1, {'z': true}]});
      expect(a, b);
      expect(a, '{"a":[1,{"z":true}],"b":2,"c":null}');
    });
  });

  group('bundle validation', () {
    test('accepts a valid bundle', () {
      final bundle = _validContent();
      expect(() => validateBundle(bundle), returnsNormally);
    });

    test('rejects unknown book', () {
      final bundle = BundleContent(
        plans: [
          PlanDefinition(
            slug: 'p',
            title: 'P',
            description: 'd',
            kind: 'sequential',
            days: [
              PlanDay(
                day: 1,
                readings: [const ReadingRef(book: 'Not A Book', start: 1)],
                estimatedMinutes: 1,
              ),
            ],
          ),
        ],
        reflectionPrompts: ['p'],
        notificationMessages: ['n'],
      );
      expect(() => validateBundle(bundle), throwsA(isA<ValidationException>()));
    });

    test('rejects chapters out of range', () {
      final bundle = BundleContent(
        plans: [
          PlanDefinition(
            slug: 'p',
            title: 'P',
            description: 'd',
            kind: 'sequential',
            days: [
              PlanDay(
                day: 1,
                readings: [const ReadingRef(book: 'John', start: 22)],
                estimatedMinutes: 1,
              ),
            ],
          ),
        ],
        reflectionPrompts: ['p'],
        notificationMessages: ['n'],
      );
      expect(() => validateBundle(bundle), throwsA(isA<ValidationException>()));
    });
  });

  group('verse library', () {
    test('is generous: at least 8 verses per category', () {
      expect(verseLibrary.length, greaterThanOrEqualTo(10),
          reason: 'wanted a broad set of "usual" categories');
      for (final entry in verseLibrary.entries) {
        expect(entry.value.length, greaterThanOrEqualTo(8),
            reason: 'category ${entry.key} needs a deep pool');
      }
    });

    test('every verse has text and a reference', () {
      for (final entry in verseLibrary.entries) {
        for (final verse in entry.value) {
          expect(verse.text.trim(), isNotEmpty, reason: entry.key);
          expect(verse.reference.trim(), isNotEmpty, reason: entry.key);
        }
      }
    });

    test('flattens to a validating bundle list', () {
      final nudges = buildDefaultVerseNudges();
      expect(nudges, isNotEmpty);
      final categories = nudges.map((v) => v.category).toSet();
      expect(categories, verseLibrary.keys.toSet());
      expect(() => validateBundle(BundleContent(
            plans: const [],
            reflectionPrompts: ['p'],
            notificationMessages: ['n'],
            verseNudges: nudges,
          )),
          returnsNormally);
    });

    test('verseNudges round-trip through JSON', () {
      final nudge = const VerseNudge(
        category: 'hope',
        text: 'And in his word do I hope.',
        reference: 'Psalm 130:5',
      );
      expect(
        VerseNudge.fromJson(nudge.toJson()),
        isA<VerseNudge>()
            .having((v) => v.category, 'category', 'hope')
            .having((v) => v.text, 'text', nudge.text)
            .having((v) => v.reference, 'reference', nudge.reference),
      );
    });

    test('BundleContent tolerates bundles without verseNudges', () {
      final content = BundleContent.fromJson(const {
        'plans': [],
        'reflectionPrompts': ['p'],
        'notificationMessages': ['n'],
      });
      expect(content.verseNudges, isEmpty);
    });
  });

  group('signing round-trip', () {
    test('signs and verifies', () async {
      final pair = await Ed25519().newKeyPair();
      final public = await pair.extractPublicKey();
      final content = _validContent();

      // Sign with the SimpleKeyPair directly.
      final signature =
          await Ed25519().sign(bundleMessageBytes(content), keyPair: pair);
      final bundle = SignedBundle(
        version: 1,
        content: content,
        signature: base64Encode(signature.bytes),
      );

      final ok = await verifyBundle(bundle, Uint8List.fromList(public.bytes));
      expect(ok, isTrue);
    });

    test('detects tampering', () async {
      final pair = await Ed25519().newKeyPair();
      final public = await pair.extractPublicKey();
      final content = _validContent();
      final signature =
          await Ed25519().sign(bundleMessageBytes(content), keyPair: pair);
      final bundle = SignedBundle(
        version: 1,
        content: _validContent(),
        signature: base64Encode(signature.bytes),
      );
      final ok = await verifyBundle(bundle, Uint8List.fromList(public.bytes));
      expect(ok, isTrue);

      // Tamper: change a prompt, signature no longer matches.
      final tampered = SignedBundle(
        version: 1,
        content: BundleContent(
          plans: content.plans,
          reflectionPrompts: ['Changed.'],
          notificationMessages: content.notificationMessages,
        ),
        signature: bundle.signature,
      );
      final bad = await verifyBundle(tampered, Uint8List.fromList(public.bytes));
      expect(bad, isFalse);
    });
  });

  group('M\'Cheyne reference parser', () {
    test('parses a simple chapter', () {
      final refs = parseMcHeyneReference('Genesis 1');
      expect(refs.single.book, 'Genesis');
      expect(refs.single.start, 1);
      expect(refs.single.end, isNull);
    });

    test('parses a multi-word book', () {
      final refs = parseMcHeyneReference('1 Corinthians 13');
      expect(refs.single.book, '1 Corinthians');
      expect(refs.single.start, 13);
    });

    test('aliases Psalm to Psalms', () {
      final refs = parseMcHeyneReference('Psalm 23');
      expect(refs.single.book, 'Psalms');
      expect(refs.single.start, 23);
    });

    test('parses a chapter range', () {
      final refs = parseMcHeyneReference('Genesis 9-10');
      expect(refs.single.book, 'Genesis');
      expect(refs.single.start, 9);
      expect(refs.single.end, 10);
    });

    test('collapses a verse reference to its chapter', () {
      final refs = parseMcHeyneReference('Luke 1:1-38');
      expect(refs.single.book, 'Luke');
      expect(refs.single.start, 1);
      expect(refs.single.startVerse, 1);
      expect(refs.single.endVerse, 38);
      expect(refs.single.display(), 'Luke 1:1–38');
    });

    test('merges multi-part references into one range', () {
      final refs = parseMcHeyneReference('Isaiah 8, 9:1-7');
      expect(refs.single.book, 'Isaiah');
      expect(refs.single.start, 8);
      expect(refs.single.end, 9);
    });

    test('throws on a reference with no book', () {
      expect(() => parseMcHeyneReference('9-10'), throwsFormatException);
    });
  });

  group('built bundle', () {
    final bundlePath = 'build/content.json';
    final bundleFile = File(bundlePath);

    test('exists and parses', () {
      expect(bundleFile.existsSync(), isTrue,
          reason: 'run `dart run pilgrim_build build` first');
      final bundle =
          SignedBundle.decode(bundleFile.readAsStringSync());
      expect(bundle.version, greaterThanOrEqualTo(1));
      expect(bundle.content.plans, hasLength(3));
    });

    test('passes full validation', () {
      final bundle = SignedBundle.decode(bundleFile.readAsStringSync());
      expect(() => validateBundle(bundle.content), returnsNormally);
    });
  });
}

BundleContent _validContent() {
  final days = <PlanDay>[];
  var day = 1;
  for (final book in books) {
    for (var c = 1; c <= book.chapters; c++, day++) {
      days.add(PlanDay(
        day: day,
        readings: [ReadingRef(book: book.name, start: c)],
        estimatedMinutes: 2,
      ));
    }
  }
  return BundleContent(
    plans: [
      PlanDefinition(
        slug: 'whole-bible',
        title: 'Whole Bible',
        description: 'd',
        kind: 'sequential',
        days: days,
      ),
    ],
    reflectionPrompts: ['p'],
    notificationMessages: ['n'],
    verseNudges: const [
      VerseNudge(category: 'hope', text: 't', reference: 'Psalm 1:1'),
    ],
  );
}
