import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Tracks which content bundle version is currently in the local database.
class ContentMeta extends Table {
  TextColumn get id => text()();

  IntColumn get version => integer().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Reading plans. Progress is tracked by stable day index; plans are only
/// ever added or updated, never deleted.
class Plans extends Table {
  TextColumn get slug => text()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  TextColumn get kind => text()();

  IntColumn get totalDays => integer()();

  @override
  Set<Column> get primaryKey => {slug};
}

/// One day of a reading plan. `readings` holds a JSON array of readings.
class PlanDays extends Table {
  TextColumn get planSlug => text().references(Plans, #slug)();

  IntColumn get dayIndex => integer()();

  IntColumn get estimatedMinutes => integer()();

  TextColumn get readings => text()();

  @override
  Set<Column> get primaryKey => {planSlug, dayIndex};
}

/// Daily reflection prompts, curated and updated via content bundles.
class ReflectionPrompts extends Table {
  TextColumn get prompt => text()();

  @override
  Set<Column> get primaryKey => {prompt};
}

/// Calm, invitational notification messages.
class NotificationMessages extends Table {
  TextColumn get message => text()();

  @override
  Set<Column> get primaryKey => {message};
}

/// Journal entries. Readings are stored as an immutable snapshot at the time
/// of completion so later content changes can never rewrite history.
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get date => dateTime()();

  TextColumn get planSlug => text()();

  IntColumn get dayIndex => integer()();

  TextColumn get prompt => text()();

  TextColumn get reflection => text()();

  TextColumn get prayer => text().nullable()();

  TextColumn get mood => text().nullable()();

  TextColumn get readings => text()();

  DateTimeColumn get completedAt => dateTime()();
}

/// Simple key/value settings (current plan, reminder prefs, theme, …).
class SettingsTable extends Table {
  TextColumn get key => text()();

  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    ContentMeta,
    Plans,
    PlanDays,
    ReflectionPrompts,
    NotificationMessages,
    Sessions,
    SettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

QueryExecutor _openConnection() => driftDatabase(name: 'pilgrim');
