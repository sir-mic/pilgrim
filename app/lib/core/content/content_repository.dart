import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import 'package:pilgrim_content/pilgrim_content.dart';

import '../database/app_database.dart';
import 'signature_verifier.dart';

/// Seeds, verifies and reconciles signed content bundles into the local
/// database. The bundled asset covers first run and offline use; a remote
/// bundle (hosted anywhere static) delivers content updates without an app
/// update.
class ContentRepository {
  ContentRepository(
    this._db, {
    http.Client? client,
    BundleVerifier? verifier,
  })  : _client = client ?? http.Client(),
        _verifier = verifier ?? BundleVerifier();

  static const bundledAsset = 'assets/content/content.json';

  static const defaultManifestUrl =
      'https://sir-mic.github.io/pilgrim/content.json';

  final AppDatabase _db;
  final http.Client _client;
  final BundleVerifier _verifier;

  /// Loads the bundled content and reconciles it if the database is empty or
  /// on an older bundle version.
  Future<void> ensureBundledContent() async {
    final current = await _currentVersion();
    if (current != null && current >= 1) return;

    final raw = await rootBundle.loadString(bundledAsset);
    final bundle = SignedBundle.decode(raw);
    if (!await _verifier.verify(bundle)) {
      throw StateError('Bundled content failed signature verification.');
    }
    await reconcile(bundle);
  }

  /// Fetches the remote bundle and reconciles if it is newer. Failures are
  /// silent: the app keeps its last-known-good local content and stays usable
  /// offline.
  Future<void> refreshRemote({String? manifestUrl}) async {
    final url = manifestUrl ?? defaultManifestUrl;
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return;

      // Decode as UTF-8 explicitly: some static hosts omit the charset, in
      // which case http's latin1 default would corrupt non-ASCII copy and
      // break signature verification.
      final bundle = SignedBundle.decode(utf8.decode(response.bodyBytes));
      if (!await _verifier.verify(bundle)) return;

      final current = await _currentVersion();
      if (current == null || bundle.version > current) {
        await reconcile(bundle);
      }
    } catch (_) {
      // Keep local content; retry on a future launch.
    }
  }

  Future<int?> _currentVersion() async {
    final row = await (_db.select(_db.contentMeta)
          ..where((t) => t.id.equals('app')))
        .getSingleOrNull();
    return row?.version;
  }

  /// Applies a verified bundle. Plans and days are upserted; prompts and
  /// notification messages are replaced. User progress and journal entries
  /// (which reference plans by slug and store immutable snapshots) are never
  /// touched.
  Future<void> reconcile(SignedBundle bundle) {
    return _db.transaction(() async {
      for (final plan in bundle.content.plans) {
        await _db.into(_db.plans).insertOnConflictUpdate(
              PlansCompanion.insert(
                slug: plan.slug,
                title: plan.title,
                description: plan.description,
                kind: plan.kind,
                totalDays: plan.totalDays,
              ),
            );

        await (_db.delete(_db.planDays)
              ..where((t) => t.planSlug.equals(plan.slug)))
            .go();

        for (final day in plan.days) {
          await _db.into(_db.planDays).insert(
                PlanDaysCompanion.insert(
                  planSlug: plan.slug,
                  dayIndex: day.day,
                  estimatedMinutes: day.estimatedMinutes,
                  readings: jsonEncode(
                    day.readings.map((r) => r.toJson()).toList(),
                  ),
                ),
              );
        }
      }

      await _db.delete(_db.reflectionPrompts).go();
      for (final prompt in bundle.content.reflectionPrompts) {
        await _db.into(_db.reflectionPrompts).insert(
              ReflectionPromptsCompanion.insert(prompt: prompt),
            );
      }

      await _db.delete(_db.notificationMessages).go();
      for (final message in bundle.content.notificationMessages) {
        await _db.into(_db.notificationMessages).insert(
              NotificationMessagesCompanion.insert(message: message),
            );
      }

      await _db.into(_db.contentMeta).insertOnConflictUpdate(
            ContentMetaCompanion.insert(
              id: 'app',
              version: Value(bundle.version),
              updatedAt: Value(DateTime.now()),
            ),
          );
    });
  }
}
