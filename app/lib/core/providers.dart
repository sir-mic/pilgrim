import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import 'content/content_repository.dart';
import 'data/app_repository.dart';
import 'data/models.dart';
import 'database/app_database.dart';

/// The local database. Overridden in tests with an in-memory instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final contentRepositoryProvider =
    Provider<ContentRepository>((ref) => ContentRepository(ref.watch(databaseProvider)));

final appRepositoryProvider =
    Provider<AppRepository>((ref) => AppRepository(ref.watch(databaseProvider)));

/// Resolves once the bundled content has been verified and seeded.
final contentSeededProvider = FutureProvider<void>((ref) async {
  await ref.watch(contentRepositoryProvider).ensureBundledContent();
});

/// The user's theme preference (persisted; default dark).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

/// All plans, ready for plan selection screens.
final allPlansProvider = FutureProvider<List<PlanDefinition>>(
    (ref) => ref.watch(appRepositoryProvider).allPlans());

/// Today's reading, reactive to journal writes.
final currentReadingProvider = StreamProvider<CurrentReading>((ref) {
  final repo = ref.watch(appRepositoryProvider);
  return repo.watchSessions().asyncMap((_) async {
    final slug = await repo.currentPlanSlug();
    if (slug == null) throw const NoPlanException();
    return repo.currentReading(slug, DateTime.now());
  });
});

/// The journal timeline, newest first.
final journalProvider = StreamProvider<List<SessionEntry>>((ref) {
  return ref
      .watch(appRepositoryProvider)
      .watchSessions()
      .map((sessions) {
        final sorted = [...sessions]
          ..sort((a, b) => b.date.compareTo(a.date));
        return sorted;
      });
});

/// A randomly selected daily reflection prompt.
final randomPromptProvider = FutureProvider<String>(
    (ref) => ref.watch(appRepositoryProvider).randomPrompt());

/// Calm notification messages from the current content bundle.
final notificationMessagesProvider = FutureProvider<List<String>>(
    (ref) => ref.watch(appRepositoryProvider).notificationMessages());

/// Called once after first frame to silently check for remote content updates.
final remoteRefreshProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  final custom = await ref.watch(appRepositoryProvider).manifestUrl();
  await repo.refreshRemote(manifestUrl: custom);
});

class NoPlanException implements Exception {
  const NoPlanException();
}
