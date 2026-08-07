// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ContentMetaTable extends ContentMeta
    with TableInfo<$ContentMetaTable, ContentMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, version, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentMetaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ContentMetaTable createAlias(String alias) {
    return $ContentMetaTable(attachedDatabase, alias);
  }
}

class ContentMetaData extends DataClass implements Insertable<ContentMetaData> {
  final String id;
  final int? version;
  final DateTime? updatedAt;
  const ContentMetaData({required this.id, this.version, this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || version != null) {
      map['version'] = Variable<int>(version);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ContentMetaCompanion toCompanion(bool nullToAbsent) {
    return ContentMetaCompanion(
      id: Value(id),
      version: version == null && nullToAbsent
          ? const Value.absent()
          : Value(version),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ContentMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentMetaData(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<int?>(json['version']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<int?>(version),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ContentMetaData copyWith({
    String? id,
    Value<int?> version = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => ContentMetaData(
    id: id ?? this.id,
    version: version.present ? version.value : this.version,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ContentMetaData copyWithCompanion(ContentMetaCompanion data) {
    return ContentMetaData(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetaData(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentMetaData &&
          other.id == this.id &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class ContentMetaCompanion extends UpdateCompanion<ContentMetaData> {
  final Value<String> id;
  final Value<int?> version;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ContentMetaCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentMetaCompanion.insert({
    required String id,
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ContentMetaData> custom({
    Expression<String>? id,
    Expression<int>? version,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentMetaCompanion copyWith({
    Value<String>? id,
    Value<int?>? version,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ContentMetaCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetaCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlansTable extends Plans with TableInfo<$PlansTable, Plan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDaysMeta = const VerificationMeta(
    'totalDays',
  );
  @override
  late final GeneratedColumn<int> totalDays = GeneratedColumn<int>(
    'total_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    slug,
    title,
    description,
    kind,
    totalDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Plan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('total_days')) {
      context.handle(
        _totalDaysMeta,
        totalDays.isAcceptableOrUnknown(data['total_days']!, _totalDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_totalDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slug};
  @override
  Plan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plan(
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      totalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_days'],
      )!,
    );
  }

  @override
  $PlansTable createAlias(String alias) {
    return $PlansTable(attachedDatabase, alias);
  }
}

class Plan extends DataClass implements Insertable<Plan> {
  final String slug;
  final String title;
  final String description;
  final String kind;
  final int totalDays;
  const Plan({
    required this.slug,
    required this.title,
    required this.description,
    required this.kind,
    required this.totalDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slug'] = Variable<String>(slug);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['kind'] = Variable<String>(kind);
    map['total_days'] = Variable<int>(totalDays);
    return map;
  }

  PlansCompanion toCompanion(bool nullToAbsent) {
    return PlansCompanion(
      slug: Value(slug),
      title: Value(title),
      description: Value(description),
      kind: Value(kind),
      totalDays: Value(totalDays),
    );
  }

  factory Plan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plan(
      slug: serializer.fromJson<String>(json['slug']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      kind: serializer.fromJson<String>(json['kind']),
      totalDays: serializer.fromJson<int>(json['totalDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slug': serializer.toJson<String>(slug),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'kind': serializer.toJson<String>(kind),
      'totalDays': serializer.toJson<int>(totalDays),
    };
  }

  Plan copyWith({
    String? slug,
    String? title,
    String? description,
    String? kind,
    int? totalDays,
  }) => Plan(
    slug: slug ?? this.slug,
    title: title ?? this.title,
    description: description ?? this.description,
    kind: kind ?? this.kind,
    totalDays: totalDays ?? this.totalDays,
  );
  Plan copyWithCompanion(PlansCompanion data) {
    return Plan(
      slug: data.slug.present ? data.slug.value : this.slug,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      kind: data.kind.present ? data.kind.value : this.kind,
      totalDays: data.totalDays.present ? data.totalDays.value : this.totalDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plan(')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('kind: $kind, ')
          ..write('totalDays: $totalDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slug, title, description, kind, totalDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plan &&
          other.slug == this.slug &&
          other.title == this.title &&
          other.description == this.description &&
          other.kind == this.kind &&
          other.totalDays == this.totalDays);
}

class PlansCompanion extends UpdateCompanion<Plan> {
  final Value<String> slug;
  final Value<String> title;
  final Value<String> description;
  final Value<String> kind;
  final Value<int> totalDays;
  final Value<int> rowid;
  const PlansCompanion({
    this.slug = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.kind = const Value.absent(),
    this.totalDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlansCompanion.insert({
    required String slug,
    required String title,
    required String description,
    required String kind,
    required int totalDays,
    this.rowid = const Value.absent(),
  }) : slug = Value(slug),
       title = Value(title),
       description = Value(description),
       kind = Value(kind),
       totalDays = Value(totalDays);
  static Insertable<Plan> custom({
    Expression<String>? slug,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? kind,
    Expression<int>? totalDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slug != null) 'slug': slug,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (kind != null) 'kind': kind,
      if (totalDays != null) 'total_days': totalDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlansCompanion copyWith({
    Value<String>? slug,
    Value<String>? title,
    Value<String>? description,
    Value<String>? kind,
    Value<int>? totalDays,
    Value<int>? rowid,
  }) {
    return PlansCompanion(
      slug: slug ?? this.slug,
      title: title ?? this.title,
      description: description ?? this.description,
      kind: kind ?? this.kind,
      totalDays: totalDays ?? this.totalDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (totalDays.present) {
      map['total_days'] = Variable<int>(totalDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlansCompanion(')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('kind: $kind, ')
          ..write('totalDays: $totalDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanDaysTable extends PlanDays with TableInfo<$PlanDaysTable, PlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planSlugMeta = const VerificationMeta(
    'planSlug',
  );
  @override
  late final GeneratedColumn<String> planSlug = GeneratedColumn<String>(
    'plan_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plans (slug)',
    ),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingsMeta = const VerificationMeta(
    'readings',
  );
  @override
  late final GeneratedColumn<String> readings = GeneratedColumn<String>(
    'readings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    planSlug,
    dayIndex,
    estimatedMinutes,
    readings,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan_slug')) {
      context.handle(
        _planSlugMeta,
        planSlug.isAcceptableOrUnknown(data['plan_slug']!, _planSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_planSlugMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedMinutesMeta);
    }
    if (data.containsKey('readings')) {
      context.handle(
        _readingsMeta,
        readings.isAcceptableOrUnknown(data['readings']!, _readingsMeta),
      );
    } else if (isInserting) {
      context.missing(_readingsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planSlug, dayIndex};
  @override
  PlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanDay(
      planSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_slug'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      readings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}readings'],
      )!,
    );
  }

  @override
  $PlanDaysTable createAlias(String alias) {
    return $PlanDaysTable(attachedDatabase, alias);
  }
}

class PlanDay extends DataClass implements Insertable<PlanDay> {
  final String planSlug;
  final int dayIndex;
  final int estimatedMinutes;
  final String readings;
  const PlanDay({
    required this.planSlug,
    required this.dayIndex,
    required this.estimatedMinutes,
    required this.readings,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plan_slug'] = Variable<String>(planSlug);
    map['day_index'] = Variable<int>(dayIndex);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['readings'] = Variable<String>(readings);
    return map;
  }

  PlanDaysCompanion toCompanion(bool nullToAbsent) {
    return PlanDaysCompanion(
      planSlug: Value(planSlug),
      dayIndex: Value(dayIndex),
      estimatedMinutes: Value(estimatedMinutes),
      readings: Value(readings),
    );
  }

  factory PlanDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanDay(
      planSlug: serializer.fromJson<String>(json['planSlug']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      readings: serializer.fromJson<String>(json['readings']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planSlug': serializer.toJson<String>(planSlug),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'readings': serializer.toJson<String>(readings),
    };
  }

  PlanDay copyWith({
    String? planSlug,
    int? dayIndex,
    int? estimatedMinutes,
    String? readings,
  }) => PlanDay(
    planSlug: planSlug ?? this.planSlug,
    dayIndex: dayIndex ?? this.dayIndex,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    readings: readings ?? this.readings,
  );
  PlanDay copyWithCompanion(PlanDaysCompanion data) {
    return PlanDay(
      planSlug: data.planSlug.present ? data.planSlug.value : this.planSlug,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      readings: data.readings.present ? data.readings.value : this.readings,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanDay(')
          ..write('planSlug: $planSlug, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('readings: $readings')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(planSlug, dayIndex, estimatedMinutes, readings);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanDay &&
          other.planSlug == this.planSlug &&
          other.dayIndex == this.dayIndex &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.readings == this.readings);
}

class PlanDaysCompanion extends UpdateCompanion<PlanDay> {
  final Value<String> planSlug;
  final Value<int> dayIndex;
  final Value<int> estimatedMinutes;
  final Value<String> readings;
  final Value<int> rowid;
  const PlanDaysCompanion({
    this.planSlug = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.readings = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanDaysCompanion.insert({
    required String planSlug,
    required int dayIndex,
    required int estimatedMinutes,
    required String readings,
    this.rowid = const Value.absent(),
  }) : planSlug = Value(planSlug),
       dayIndex = Value(dayIndex),
       estimatedMinutes = Value(estimatedMinutes),
       readings = Value(readings);
  static Insertable<PlanDay> custom({
    Expression<String>? planSlug,
    Expression<int>? dayIndex,
    Expression<int>? estimatedMinutes,
    Expression<String>? readings,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (planSlug != null) 'plan_slug': planSlug,
      if (dayIndex != null) 'day_index': dayIndex,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (readings != null) 'readings': readings,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanDaysCompanion copyWith({
    Value<String>? planSlug,
    Value<int>? dayIndex,
    Value<int>? estimatedMinutes,
    Value<String>? readings,
    Value<int>? rowid,
  }) {
    return PlanDaysCompanion(
      planSlug: planSlug ?? this.planSlug,
      dayIndex: dayIndex ?? this.dayIndex,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      readings: readings ?? this.readings,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planSlug.present) {
      map['plan_slug'] = Variable<String>(planSlug.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (readings.present) {
      map['readings'] = Variable<String>(readings.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanDaysCompanion(')
          ..write('planSlug: $planSlug, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('readings: $readings, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReflectionPromptsTable extends ReflectionPrompts
    with TableInfo<$ReflectionPromptsTable, ReflectionPrompt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReflectionPromptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [prompt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reflection_prompts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReflectionPrompt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {prompt};
  @override
  ReflectionPrompt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReflectionPrompt(
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
    );
  }

  @override
  $ReflectionPromptsTable createAlias(String alias) {
    return $ReflectionPromptsTable(attachedDatabase, alias);
  }
}

class ReflectionPrompt extends DataClass
    implements Insertable<ReflectionPrompt> {
  final String prompt;
  const ReflectionPrompt({required this.prompt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['prompt'] = Variable<String>(prompt);
    return map;
  }

  ReflectionPromptsCompanion toCompanion(bool nullToAbsent) {
    return ReflectionPromptsCompanion(prompt: Value(prompt));
  }

  factory ReflectionPrompt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReflectionPrompt(
      prompt: serializer.fromJson<String>(json['prompt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'prompt': serializer.toJson<String>(prompt)};
  }

  ReflectionPrompt copyWith({String? prompt}) =>
      ReflectionPrompt(prompt: prompt ?? this.prompt);
  ReflectionPrompt copyWithCompanion(ReflectionPromptsCompanion data) {
    return ReflectionPrompt(
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionPrompt(')
          ..write('prompt: $prompt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => prompt.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReflectionPrompt && other.prompt == this.prompt);
}

class ReflectionPromptsCompanion extends UpdateCompanion<ReflectionPrompt> {
  final Value<String> prompt;
  final Value<int> rowid;
  const ReflectionPromptsCompanion({
    this.prompt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReflectionPromptsCompanion.insert({
    required String prompt,
    this.rowid = const Value.absent(),
  }) : prompt = Value(prompt);
  static Insertable<ReflectionPrompt> custom({
    Expression<String>? prompt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (prompt != null) 'prompt': prompt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReflectionPromptsCompanion copyWith({
    Value<String>? prompt,
    Value<int>? rowid,
  }) {
    return ReflectionPromptsCompanion(
      prompt: prompt ?? this.prompt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionPromptsCompanion(')
          ..write('prompt: $prompt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationMessagesTable extends NotificationMessages
    with TableInfo<$NotificationMessagesTable, NotificationMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [message];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {message};
  @override
  NotificationMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationMessage(
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
    );
  }

  @override
  $NotificationMessagesTable createAlias(String alias) {
    return $NotificationMessagesTable(attachedDatabase, alias);
  }
}

class NotificationMessage extends DataClass
    implements Insertable<NotificationMessage> {
  final String message;
  const NotificationMessage({required this.message});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message'] = Variable<String>(message);
    return map;
  }

  NotificationMessagesCompanion toCompanion(bool nullToAbsent) {
    return NotificationMessagesCompanion(message: Value(message));
  }

  factory NotificationMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationMessage(
      message: serializer.fromJson<String>(json['message']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'message': serializer.toJson<String>(message)};
  }

  NotificationMessage copyWith({String? message}) =>
      NotificationMessage(message: message ?? this.message);
  NotificationMessage copyWithCompanion(NotificationMessagesCompanion data) {
    return NotificationMessage(
      message: data.message.present ? data.message.value : this.message,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationMessage(')
          ..write('message: $message')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => message.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationMessage && other.message == this.message);
}

class NotificationMessagesCompanion
    extends UpdateCompanion<NotificationMessage> {
  final Value<String> message;
  final Value<int> rowid;
  const NotificationMessagesCompanion({
    this.message = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationMessagesCompanion.insert({
    required String message,
    this.rowid = const Value.absent(),
  }) : message = Value(message);
  static Insertable<NotificationMessage> custom({
    Expression<String>? message,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (message != null) 'message': message,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationMessagesCompanion copyWith({
    Value<String>? message,
    Value<int>? rowid,
  }) {
    return NotificationMessagesCompanion(
      message: message ?? this.message,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationMessagesCompanion(')
          ..write('message: $message, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MicDropVersesTable extends MicDropVerses
    with TableInfo<$MicDropVersesTable, MicDropVerse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MicDropVersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseTextMeta = const VerificationMeta(
    'verseText',
  );
  @override
  late final GeneratedColumn<String> verseText = GeneratedColumn<String>(
    'verse_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, category, verseText, reference];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mic_drop_verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<MicDropVerse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('verse_text')) {
      context.handle(
        _verseTextMeta,
        verseText.isAcceptableOrUnknown(data['verse_text']!, _verseTextMeta),
      );
    } else if (isInserting) {
      context.missing(_verseTextMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MicDropVerse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MicDropVerse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      verseText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verse_text'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
    );
  }

  @override
  $MicDropVersesTable createAlias(String alias) {
    return $MicDropVersesTable(attachedDatabase, alias);
  }
}

class MicDropVerse extends DataClass implements Insertable<MicDropVerse> {
  final int id;
  final String category;
  final String verseText;
  final String reference;
  const MicDropVerse({
    required this.id,
    required this.category,
    required this.verseText,
    required this.reference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['verse_text'] = Variable<String>(verseText);
    map['reference'] = Variable<String>(reference);
    return map;
  }

  MicDropVersesCompanion toCompanion(bool nullToAbsent) {
    return MicDropVersesCompanion(
      id: Value(id),
      category: Value(category),
      verseText: Value(verseText),
      reference: Value(reference),
    );
  }

  factory MicDropVerse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MicDropVerse(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      verseText: serializer.fromJson<String>(json['verseText']),
      reference: serializer.fromJson<String>(json['reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'verseText': serializer.toJson<String>(verseText),
      'reference': serializer.toJson<String>(reference),
    };
  }

  MicDropVerse copyWith({
    int? id,
    String? category,
    String? verseText,
    String? reference,
  }) => MicDropVerse(
    id: id ?? this.id,
    category: category ?? this.category,
    verseText: verseText ?? this.verseText,
    reference: reference ?? this.reference,
  );
  MicDropVerse copyWithCompanion(MicDropVersesCompanion data) {
    return MicDropVerse(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      verseText: data.verseText.present ? data.verseText.value : this.verseText,
      reference: data.reference.present ? data.reference.value : this.reference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MicDropVerse(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('verseText: $verseText, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, verseText, reference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MicDropVerse &&
          other.id == this.id &&
          other.category == this.category &&
          other.verseText == this.verseText &&
          other.reference == this.reference);
}

class MicDropVersesCompanion extends UpdateCompanion<MicDropVerse> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> verseText;
  final Value<String> reference;
  const MicDropVersesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.verseText = const Value.absent(),
    this.reference = const Value.absent(),
  });
  MicDropVersesCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String verseText,
    required String reference,
  }) : category = Value(category),
       verseText = Value(verseText),
       reference = Value(reference);
  static Insertable<MicDropVerse> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? verseText,
    Expression<String>? reference,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (verseText != null) 'verse_text': verseText,
      if (reference != null) 'reference': reference,
    });
  }

  MicDropVersesCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? verseText,
    Value<String>? reference,
  }) {
    return MicDropVersesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      verseText: verseText ?? this.verseText,
      reference: reference ?? this.reference,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (verseText.present) {
      map['verse_text'] = Variable<String>(verseText.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MicDropVersesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('verseText: $verseText, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planSlugMeta = const VerificationMeta(
    'planSlug',
  );
  @override
  late final GeneratedColumn<String> planSlug = GeneratedColumn<String>(
    'plan_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reflectionMeta = const VerificationMeta(
    'reflection',
  );
  @override
  late final GeneratedColumn<String> reflection = GeneratedColumn<String>(
    'reflection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prayerMeta = const VerificationMeta('prayer');
  @override
  late final GeneratedColumn<String> prayer = GeneratedColumn<String>(
    'prayer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readingsMeta = const VerificationMeta(
    'readings',
  );
  @override
  late final GeneratedColumn<String> readings = GeneratedColumn<String>(
    'readings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    planSlug,
    dayIndex,
    prompt,
    reflection,
    prayer,
    mood,
    readings,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('plan_slug')) {
      context.handle(
        _planSlugMeta,
        planSlug.isAcceptableOrUnknown(data['plan_slug']!, _planSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_planSlugMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('reflection')) {
      context.handle(
        _reflectionMeta,
        reflection.isAcceptableOrUnknown(data['reflection']!, _reflectionMeta),
      );
    } else if (isInserting) {
      context.missing(_reflectionMeta);
    }
    if (data.containsKey('prayer')) {
      context.handle(
        _prayerMeta,
        prayer.isAcceptableOrUnknown(data['prayer']!, _prayerMeta),
      );
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('readings')) {
      context.handle(
        _readingsMeta,
        readings.isAcceptableOrUnknown(data['readings']!, _readingsMeta),
      );
    } else if (isInserting) {
      context.missing(_readingsMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      planSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_slug'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
      reflection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection'],
      )!,
      prayer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prayer'],
      ),
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      ),
      readings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}readings'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final DateTime date;
  final String planSlug;
  final int dayIndex;
  final String prompt;
  final String reflection;
  final String? prayer;
  final String? mood;
  final String readings;
  final DateTime completedAt;
  const Session({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['plan_slug'] = Variable<String>(planSlug);
    map['day_index'] = Variable<int>(dayIndex);
    map['prompt'] = Variable<String>(prompt);
    map['reflection'] = Variable<String>(reflection);
    if (!nullToAbsent || prayer != null) {
      map['prayer'] = Variable<String>(prayer);
    }
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<String>(mood);
    }
    map['readings'] = Variable<String>(readings);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      date: Value(date),
      planSlug: Value(planSlug),
      dayIndex: Value(dayIndex),
      prompt: Value(prompt),
      reflection: Value(reflection),
      prayer: prayer == null && nullToAbsent
          ? const Value.absent()
          : Value(prayer),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      readings: Value(readings),
      completedAt: Value(completedAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      planSlug: serializer.fromJson<String>(json['planSlug']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      prompt: serializer.fromJson<String>(json['prompt']),
      reflection: serializer.fromJson<String>(json['reflection']),
      prayer: serializer.fromJson<String?>(json['prayer']),
      mood: serializer.fromJson<String?>(json['mood']),
      readings: serializer.fromJson<String>(json['readings']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'planSlug': serializer.toJson<String>(planSlug),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'prompt': serializer.toJson<String>(prompt),
      'reflection': serializer.toJson<String>(reflection),
      'prayer': serializer.toJson<String?>(prayer),
      'mood': serializer.toJson<String?>(mood),
      'readings': serializer.toJson<String>(readings),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  Session copyWith({
    int? id,
    DateTime? date,
    String? planSlug,
    int? dayIndex,
    String? prompt,
    String? reflection,
    Value<String?> prayer = const Value.absent(),
    Value<String?> mood = const Value.absent(),
    String? readings,
    DateTime? completedAt,
  }) => Session(
    id: id ?? this.id,
    date: date ?? this.date,
    planSlug: planSlug ?? this.planSlug,
    dayIndex: dayIndex ?? this.dayIndex,
    prompt: prompt ?? this.prompt,
    reflection: reflection ?? this.reflection,
    prayer: prayer.present ? prayer.value : this.prayer,
    mood: mood.present ? mood.value : this.mood,
    readings: readings ?? this.readings,
    completedAt: completedAt ?? this.completedAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      planSlug: data.planSlug.present ? data.planSlug.value : this.planSlug,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      reflection: data.reflection.present
          ? data.reflection.value
          : this.reflection,
      prayer: data.prayer.present ? data.prayer.value : this.prayer,
      mood: data.mood.present ? data.mood.value : this.mood,
      readings: data.readings.present ? data.readings.value : this.readings,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('planSlug: $planSlug, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('prompt: $prompt, ')
          ..write('reflection: $reflection, ')
          ..write('prayer: $prayer, ')
          ..write('mood: $mood, ')
          ..write('readings: $readings, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    planSlug,
    dayIndex,
    prompt,
    reflection,
    prayer,
    mood,
    readings,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.date == this.date &&
          other.planSlug == this.planSlug &&
          other.dayIndex == this.dayIndex &&
          other.prompt == this.prompt &&
          other.reflection == this.reflection &&
          other.prayer == this.prayer &&
          other.mood == this.mood &&
          other.readings == this.readings &&
          other.completedAt == this.completedAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> planSlug;
  final Value<int> dayIndex;
  final Value<String> prompt;
  final Value<String> reflection;
  final Value<String?> prayer;
  final Value<String?> mood;
  final Value<String> readings;
  final Value<DateTime> completedAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.planSlug = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.prompt = const Value.absent(),
    this.reflection = const Value.absent(),
    this.prayer = const Value.absent(),
    this.mood = const Value.absent(),
    this.readings = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String planSlug,
    required int dayIndex,
    required String prompt,
    required String reflection,
    this.prayer = const Value.absent(),
    this.mood = const Value.absent(),
    required String readings,
    required DateTime completedAt,
  }) : date = Value(date),
       planSlug = Value(planSlug),
       dayIndex = Value(dayIndex),
       prompt = Value(prompt),
       reflection = Value(reflection),
       readings = Value(readings),
       completedAt = Value(completedAt);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? planSlug,
    Expression<int>? dayIndex,
    Expression<String>? prompt,
    Expression<String>? reflection,
    Expression<String>? prayer,
    Expression<String>? mood,
    Expression<String>? readings,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (planSlug != null) 'plan_slug': planSlug,
      if (dayIndex != null) 'day_index': dayIndex,
      if (prompt != null) 'prompt': prompt,
      if (reflection != null) 'reflection': reflection,
      if (prayer != null) 'prayer': prayer,
      if (mood != null) 'mood': mood,
      if (readings != null) 'readings': readings,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? planSlug,
    Value<int>? dayIndex,
    Value<String>? prompt,
    Value<String>? reflection,
    Value<String?>? prayer,
    Value<String?>? mood,
    Value<String>? readings,
    Value<DateTime>? completedAt,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      planSlug: planSlug ?? this.planSlug,
      dayIndex: dayIndex ?? this.dayIndex,
      prompt: prompt ?? this.prompt,
      reflection: reflection ?? this.reflection,
      prayer: prayer ?? this.prayer,
      mood: mood ?? this.mood,
      readings: readings ?? this.readings,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (planSlug.present) {
      map['plan_slug'] = Variable<String>(planSlug.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (reflection.present) {
      map['reflection'] = Variable<String>(reflection.value);
    }
    if (prayer.present) {
      map['prayer'] = Variable<String>(prayer.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (readings.present) {
      map['readings'] = Variable<String>(readings.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('planSlug: $planSlug, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('prompt: $prompt, ')
          ..write('reflection: $reflection, ')
          ..write('prayer: $prayer, ')
          ..write('mood: $mood, ')
          ..write('readings: $readings, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
  final String key;
  final String value;
  const SettingsTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(key: Value(key), value: Value(value));
  }

  factory SettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingsTableData copyWith({String? key, String? value}) =>
      SettingsTableData(key: key ?? this.key, value: value ?? this.value);
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressTable extends ReadingProgress
    with TableInfo<$ReadingProgressTable, ReadingProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _planSlugMeta = const VerificationMeta(
    'planSlug',
  );
  @override
  late final GeneratedColumn<String> planSlug = GeneratedColumn<String>(
    'plan_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<String> done = GeneratedColumn<String>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [planSlug, date, dayIndex, done];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('plan_slug')) {
      context.handle(
        _planSlugMeta,
        planSlug.isAcceptableOrUnknown(data['plan_slug']!, _planSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_planSlugMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    } else if (isInserting) {
      context.missing(_doneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {planSlug, date};
  @override
  ReadingProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressData(
      planSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_slug'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $ReadingProgressTable createAlias(String alias) {
    return $ReadingProgressTable(attachedDatabase, alias);
  }
}

class ReadingProgressData extends DataClass
    implements Insertable<ReadingProgressData> {
  final String planSlug;
  final String date;
  final int dayIndex;
  final String done;
  const ReadingProgressData({
    required this.planSlug,
    required this.date,
    required this.dayIndex,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['plan_slug'] = Variable<String>(planSlug);
    map['date'] = Variable<String>(date);
    map['day_index'] = Variable<int>(dayIndex);
    map['done'] = Variable<String>(done);
    return map;
  }

  ReadingProgressCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressCompanion(
      planSlug: Value(planSlug),
      date: Value(date),
      dayIndex: Value(dayIndex),
      done: Value(done),
    );
  }

  factory ReadingProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressData(
      planSlug: serializer.fromJson<String>(json['planSlug']),
      date: serializer.fromJson<String>(json['date']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      done: serializer.fromJson<String>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'planSlug': serializer.toJson<String>(planSlug),
      'date': serializer.toJson<String>(date),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'done': serializer.toJson<String>(done),
    };
  }

  ReadingProgressData copyWith({
    String? planSlug,
    String? date,
    int? dayIndex,
    String? done,
  }) => ReadingProgressData(
    planSlug: planSlug ?? this.planSlug,
    date: date ?? this.date,
    dayIndex: dayIndex ?? this.dayIndex,
    done: done ?? this.done,
  );
  ReadingProgressData copyWithCompanion(ReadingProgressCompanion data) {
    return ReadingProgressData(
      planSlug: data.planSlug.present ? data.planSlug.value : this.planSlug,
      date: data.date.present ? data.date.value : this.date,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressData(')
          ..write('planSlug: $planSlug, ')
          ..write('date: $date, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(planSlug, date, dayIndex, done);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressData &&
          other.planSlug == this.planSlug &&
          other.date == this.date &&
          other.dayIndex == this.dayIndex &&
          other.done == this.done);
}

class ReadingProgressCompanion extends UpdateCompanion<ReadingProgressData> {
  final Value<String> planSlug;
  final Value<String> date;
  final Value<int> dayIndex;
  final Value<String> done;
  final Value<int> rowid;
  const ReadingProgressCompanion({
    this.planSlug = const Value.absent(),
    this.date = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingProgressCompanion.insert({
    required String planSlug,
    required String date,
    required int dayIndex,
    required String done,
    this.rowid = const Value.absent(),
  }) : planSlug = Value(planSlug),
       date = Value(date),
       dayIndex = Value(dayIndex),
       done = Value(done);
  static Insertable<ReadingProgressData> custom({
    Expression<String>? planSlug,
    Expression<String>? date,
    Expression<int>? dayIndex,
    Expression<String>? done,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (planSlug != null) 'plan_slug': planSlug,
      if (date != null) 'date': date,
      if (dayIndex != null) 'day_index': dayIndex,
      if (done != null) 'done': done,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingProgressCompanion copyWith({
    Value<String>? planSlug,
    Value<String>? date,
    Value<int>? dayIndex,
    Value<String>? done,
    Value<int>? rowid,
  }) {
    return ReadingProgressCompanion(
      planSlug: planSlug ?? this.planSlug,
      date: date ?? this.date,
      dayIndex: dayIndex ?? this.dayIndex,
      done: done ?? this.done,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (planSlug.present) {
      map['plan_slug'] = Variable<String>(planSlug.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (done.present) {
      map['done'] = Variable<String>(done.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressCompanion(')
          ..write('planSlug: $planSlug, ')
          ..write('date: $date, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('done: $done, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ContentMetaTable contentMeta = $ContentMetaTable(this);
  late final $PlansTable plans = $PlansTable(this);
  late final $PlanDaysTable planDays = $PlanDaysTable(this);
  late final $ReflectionPromptsTable reflectionPrompts =
      $ReflectionPromptsTable(this);
  late final $NotificationMessagesTable notificationMessages =
      $NotificationMessagesTable(this);
  late final $MicDropVersesTable micDropVerses = $MicDropVersesTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $ReadingProgressTable readingProgress = $ReadingProgressTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contentMeta,
    plans,
    planDays,
    reflectionPrompts,
    notificationMessages,
    micDropVerses,
    sessions,
    settingsTable,
    readingProgress,
  ];
}

typedef $$ContentMetaTableCreateCompanionBuilder =
    ContentMetaCompanion Function({
      required String id,
      Value<int?> version,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ContentMetaTableUpdateCompanionBuilder =
    ContentMetaCompanion Function({
      Value<String> id,
      Value<int?> version,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$ContentMetaTableFilterComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContentMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentMetaTable,
          ContentMetaData,
          $$ContentMetaTableFilterComposer,
          $$ContentMetaTableOrderingComposer,
          $$ContentMetaTableAnnotationComposer,
          $$ContentMetaTableCreateCompanionBuilder,
          $$ContentMetaTableUpdateCompanionBuilder,
          (
            ContentMetaData,
            BaseReferences<_$AppDatabase, $ContentMetaTable, ContentMetaData>,
          ),
          ContentMetaData,
          PrefetchHooks Function()
        > {
  $$ContentMetaTableTableManager(_$AppDatabase db, $ContentMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int?> version = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentMetaCompanion(
                id: id,
                version: version,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int?> version = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentMetaCompanion.insert(
                id: id,
                version: version,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentMetaTable,
      ContentMetaData,
      $$ContentMetaTableFilterComposer,
      $$ContentMetaTableOrderingComposer,
      $$ContentMetaTableAnnotationComposer,
      $$ContentMetaTableCreateCompanionBuilder,
      $$ContentMetaTableUpdateCompanionBuilder,
      (
        ContentMetaData,
        BaseReferences<_$AppDatabase, $ContentMetaTable, ContentMetaData>,
      ),
      ContentMetaData,
      PrefetchHooks Function()
    >;
typedef $$PlansTableCreateCompanionBuilder =
    PlansCompanion Function({
      required String slug,
      required String title,
      required String description,
      required String kind,
      required int totalDays,
      Value<int> rowid,
    });
typedef $$PlansTableUpdateCompanionBuilder =
    PlansCompanion Function({
      Value<String> slug,
      Value<String> title,
      Value<String> description,
      Value<String> kind,
      Value<int> totalDays,
      Value<int> rowid,
    });

final class $$PlansTableReferences
    extends BaseReferences<_$AppDatabase, $PlansTable, Plan> {
  $$PlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanDaysTable, List<PlanDay>> _planDaysRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.planDays,
    aliasName: 'plans__slug__plan_days__plan_slug',
  );

  $$PlanDaysTableProcessedTableManager get planDaysRefs {
    final manager = $$PlanDaysTableTableManager(
      $_db,
      $_db.planDays,
    ).filter((f) => f.planSlug.slug.sqlEquals($_itemColumn<String>('slug')!));

    final cache = $_typedResult.readTableOrNull(_planDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlansTableFilterComposer extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> planDaysRefs(
    Expression<bool> Function($$PlanDaysTableFilterComposer f) f,
  ) {
    final $$PlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slug,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.planSlug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlansTableOrderingComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get totalDays =>
      $composableBuilder(column: $table.totalDays, builder: (column) => column);

  Expression<T> planDaysRefs<T extends Object>(
    Expression<T> Function($$PlanDaysTableAnnotationComposer a) f,
  ) {
    final $$PlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slug,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.planSlug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlansTable,
          Plan,
          $$PlansTableFilterComposer,
          $$PlansTableOrderingComposer,
          $$PlansTableAnnotationComposer,
          $$PlansTableCreateCompanionBuilder,
          $$PlansTableUpdateCompanionBuilder,
          (Plan, $$PlansTableReferences),
          Plan,
          PrefetchHooks Function({bool planDaysRefs})
        > {
  $$PlansTableTableManager(_$AppDatabase db, $PlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> slug = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlansCompanion(
                slug: slug,
                title: title,
                description: description,
                kind: kind,
                totalDays: totalDays,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String slug,
                required String title,
                required String description,
                required String kind,
                required int totalDays,
                Value<int> rowid = const Value.absent(),
              }) => PlansCompanion.insert(
                slug: slug,
                title: title,
                description: description,
                kind: kind,
                totalDays: totalDays,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({planDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (planDaysRefs) db.planDays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (planDaysRefs)
                    await $_getPrefetchedData<Plan, $PlansTable, PlanDay>(
                      currentTable: table,
                      referencedTable: $$PlansTableReferences
                          ._planDaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlansTableReferences(db, table, p0).planDaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planSlug == item.slug),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlansTable,
      Plan,
      $$PlansTableFilterComposer,
      $$PlansTableOrderingComposer,
      $$PlansTableAnnotationComposer,
      $$PlansTableCreateCompanionBuilder,
      $$PlansTableUpdateCompanionBuilder,
      (Plan, $$PlansTableReferences),
      Plan,
      PrefetchHooks Function({bool planDaysRefs})
    >;
typedef $$PlanDaysTableCreateCompanionBuilder =
    PlanDaysCompanion Function({
      required String planSlug,
      required int dayIndex,
      required int estimatedMinutes,
      required String readings,
      Value<int> rowid,
    });
typedef $$PlanDaysTableUpdateCompanionBuilder =
    PlanDaysCompanion Function({
      Value<String> planSlug,
      Value<int> dayIndex,
      Value<int> estimatedMinutes,
      Value<String> readings,
      Value<int> rowid,
    });

final class $$PlanDaysTableReferences
    extends BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDay> {
  $$PlanDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlansTable _planSlugTable(_$AppDatabase db) =>
      db.plans.createAlias('plan_days__plan_slug__plans__slug');

  $$PlansTableProcessedTableManager get planSlug {
    final $_column = $_itemColumn<String>('plan_slug')!;

    final manager = $$PlansTableTableManager(
      $_db,
      $_db.plans,
    ).filter((f) => f.slug.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planSlugTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readings => $composableBuilder(
    column: $table.readings,
    builder: (column) => ColumnFilters(column),
  );

  $$PlansTableFilterComposer get planSlug {
    final $$PlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planSlug,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.slug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableFilterComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readings => $composableBuilder(
    column: $table.readings,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlansTableOrderingComposer get planSlug {
    final $$PlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planSlug,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.slug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableOrderingComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get readings =>
      $composableBuilder(column: $table.readings, builder: (column) => column);

  $$PlansTableAnnotationComposer get planSlug {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planSlug,
      referencedTable: $db.plans,
      getReferencedColumn: (t) => t.slug,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlansTableAnnotationComposer(
            $db: $db,
            $table: $db.plans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanDaysTable,
          PlanDay,
          $$PlanDaysTableFilterComposer,
          $$PlanDaysTableOrderingComposer,
          $$PlanDaysTableAnnotationComposer,
          $$PlanDaysTableCreateCompanionBuilder,
          $$PlanDaysTableUpdateCompanionBuilder,
          (PlanDay, $$PlanDaysTableReferences),
          PlanDay,
          PrefetchHooks Function({bool planSlug})
        > {
  $$PlanDaysTableTableManager(_$AppDatabase db, $PlanDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> planSlug = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<String> readings = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanDaysCompanion(
                planSlug: planSlug,
                dayIndex: dayIndex,
                estimatedMinutes: estimatedMinutes,
                readings: readings,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String planSlug,
                required int dayIndex,
                required int estimatedMinutes,
                required String readings,
                Value<int> rowid = const Value.absent(),
              }) => PlanDaysCompanion.insert(
                planSlug: planSlug,
                dayIndex: dayIndex,
                estimatedMinutes: estimatedMinutes,
                readings: readings,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlanDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planSlug = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planSlug) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planSlug,
                                referencedTable: $$PlanDaysTableReferences
                                    ._planSlugTable(db),
                                referencedColumn: $$PlanDaysTableReferences
                                    ._planSlugTable(db)
                                    .slug,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanDaysTable,
      PlanDay,
      $$PlanDaysTableFilterComposer,
      $$PlanDaysTableOrderingComposer,
      $$PlanDaysTableAnnotationComposer,
      $$PlanDaysTableCreateCompanionBuilder,
      $$PlanDaysTableUpdateCompanionBuilder,
      (PlanDay, $$PlanDaysTableReferences),
      PlanDay,
      PrefetchHooks Function({bool planSlug})
    >;
typedef $$ReflectionPromptsTableCreateCompanionBuilder =
    ReflectionPromptsCompanion Function({
      required String prompt,
      Value<int> rowid,
    });
typedef $$ReflectionPromptsTableUpdateCompanionBuilder =
    ReflectionPromptsCompanion Function({
      Value<String> prompt,
      Value<int> rowid,
    });

class $$ReflectionPromptsTableFilterComposer
    extends Composer<_$AppDatabase, $ReflectionPromptsTable> {
  $$ReflectionPromptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReflectionPromptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReflectionPromptsTable> {
  $$ReflectionPromptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReflectionPromptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReflectionPromptsTable> {
  $$ReflectionPromptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);
}

class $$ReflectionPromptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReflectionPromptsTable,
          ReflectionPrompt,
          $$ReflectionPromptsTableFilterComposer,
          $$ReflectionPromptsTableOrderingComposer,
          $$ReflectionPromptsTableAnnotationComposer,
          $$ReflectionPromptsTableCreateCompanionBuilder,
          $$ReflectionPromptsTableUpdateCompanionBuilder,
          (
            ReflectionPrompt,
            BaseReferences<
              _$AppDatabase,
              $ReflectionPromptsTable,
              ReflectionPrompt
            >,
          ),
          ReflectionPrompt,
          PrefetchHooks Function()
        > {
  $$ReflectionPromptsTableTableManager(
    _$AppDatabase db,
    $ReflectionPromptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReflectionPromptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReflectionPromptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReflectionPromptsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> prompt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReflectionPromptsCompanion(prompt: prompt, rowid: rowid),
          createCompanionCallback:
              ({
                required String prompt,
                Value<int> rowid = const Value.absent(),
              }) => ReflectionPromptsCompanion.insert(
                prompt: prompt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReflectionPromptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReflectionPromptsTable,
      ReflectionPrompt,
      $$ReflectionPromptsTableFilterComposer,
      $$ReflectionPromptsTableOrderingComposer,
      $$ReflectionPromptsTableAnnotationComposer,
      $$ReflectionPromptsTableCreateCompanionBuilder,
      $$ReflectionPromptsTableUpdateCompanionBuilder,
      (
        ReflectionPrompt,
        BaseReferences<
          _$AppDatabase,
          $ReflectionPromptsTable,
          ReflectionPrompt
        >,
      ),
      ReflectionPrompt,
      PrefetchHooks Function()
    >;
typedef $$NotificationMessagesTableCreateCompanionBuilder =
    NotificationMessagesCompanion Function({
      required String message,
      Value<int> rowid,
    });
typedef $$NotificationMessagesTableUpdateCompanionBuilder =
    NotificationMessagesCompanion Function({
      Value<String> message,
      Value<int> rowid,
    });

class $$NotificationMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationMessagesTable> {
  $$NotificationMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationMessagesTable> {
  $$NotificationMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationMessagesTable> {
  $$NotificationMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);
}

class $$NotificationMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationMessagesTable,
          NotificationMessage,
          $$NotificationMessagesTableFilterComposer,
          $$NotificationMessagesTableOrderingComposer,
          $$NotificationMessagesTableAnnotationComposer,
          $$NotificationMessagesTableCreateCompanionBuilder,
          $$NotificationMessagesTableUpdateCompanionBuilder,
          (
            NotificationMessage,
            BaseReferences<
              _$AppDatabase,
              $NotificationMessagesTable,
              NotificationMessage
            >,
          ),
          NotificationMessage,
          PrefetchHooks Function()
        > {
  $$NotificationMessagesTableTableManager(
    _$AppDatabase db,
    $NotificationMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationMessagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationMessagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> message = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  NotificationMessagesCompanion(message: message, rowid: rowid),
          createCompanionCallback:
              ({
                required String message,
                Value<int> rowid = const Value.absent(),
              }) => NotificationMessagesCompanion.insert(
                message: message,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationMessagesTable,
      NotificationMessage,
      $$NotificationMessagesTableFilterComposer,
      $$NotificationMessagesTableOrderingComposer,
      $$NotificationMessagesTableAnnotationComposer,
      $$NotificationMessagesTableCreateCompanionBuilder,
      $$NotificationMessagesTableUpdateCompanionBuilder,
      (
        NotificationMessage,
        BaseReferences<
          _$AppDatabase,
          $NotificationMessagesTable,
          NotificationMessage
        >,
      ),
      NotificationMessage,
      PrefetchHooks Function()
    >;
typedef $$MicDropVersesTableCreateCompanionBuilder =
    MicDropVersesCompanion Function({
      Value<int> id,
      required String category,
      required String verseText,
      required String reference,
    });
typedef $$MicDropVersesTableUpdateCompanionBuilder =
    MicDropVersesCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<String> verseText,
      Value<String> reference,
    });

class $$MicDropVersesTableFilterComposer
    extends Composer<_$AppDatabase, $MicDropVersesTable> {
  $$MicDropVersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verseText => $composableBuilder(
    column: $table.verseText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MicDropVersesTableOrderingComposer
    extends Composer<_$AppDatabase, $MicDropVersesTable> {
  $$MicDropVersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verseText => $composableBuilder(
    column: $table.verseText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MicDropVersesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MicDropVersesTable> {
  $$MicDropVersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get verseText =>
      $composableBuilder(column: $table.verseText, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);
}

class $$MicDropVersesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MicDropVersesTable,
          MicDropVerse,
          $$MicDropVersesTableFilterComposer,
          $$MicDropVersesTableOrderingComposer,
          $$MicDropVersesTableAnnotationComposer,
          $$MicDropVersesTableCreateCompanionBuilder,
          $$MicDropVersesTableUpdateCompanionBuilder,
          (
            MicDropVerse,
            BaseReferences<_$AppDatabase, $MicDropVersesTable, MicDropVerse>,
          ),
          MicDropVerse,
          PrefetchHooks Function()
        > {
  $$MicDropVersesTableTableManager(_$AppDatabase db, $MicDropVersesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MicDropVersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MicDropVersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MicDropVersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> verseText = const Value.absent(),
                Value<String> reference = const Value.absent(),
              }) => MicDropVersesCompanion(
                id: id,
                category: category,
                verseText: verseText,
                reference: reference,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required String verseText,
                required String reference,
              }) => MicDropVersesCompanion.insert(
                id: id,
                category: category,
                verseText: verseText,
                reference: reference,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MicDropVersesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MicDropVersesTable,
      MicDropVerse,
      $$MicDropVersesTableFilterComposer,
      $$MicDropVersesTableOrderingComposer,
      $$MicDropVersesTableAnnotationComposer,
      $$MicDropVersesTableCreateCompanionBuilder,
      $$MicDropVersesTableUpdateCompanionBuilder,
      (
        MicDropVerse,
        BaseReferences<_$AppDatabase, $MicDropVersesTable, MicDropVerse>,
      ),
      MicDropVerse,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String planSlug,
      required int dayIndex,
      required String prompt,
      required String reflection,
      Value<String?> prayer,
      Value<String?> mood,
      required String readings,
      required DateTime completedAt,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> planSlug,
      Value<int> dayIndex,
      Value<String> prompt,
      Value<String> reflection,
      Value<String?> prayer,
      Value<String?> mood,
      Value<String> readings,
      Value<DateTime> completedAt,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planSlug => $composableBuilder(
    column: $table.planSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readings => $composableBuilder(
    column: $table.readings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planSlug => $composableBuilder(
    column: $table.planSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readings => $composableBuilder(
    column: $table.readings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get planSlug =>
      $composableBuilder(column: $table.planSlug, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prayer =>
      $composableBuilder(column: $table.prayer, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get readings =>
      $composableBuilder(column: $table.readings, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> planSlug = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> reflection = const Value.absent(),
                Value<String?> prayer = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                Value<String> readings = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                date: date,
                planSlug: planSlug,
                dayIndex: dayIndex,
                prompt: prompt,
                reflection: reflection,
                prayer: prayer,
                mood: mood,
                readings: readings,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String planSlug,
                required int dayIndex,
                required String prompt,
                required String reflection,
                Value<String?> prayer = const Value.absent(),
                Value<String?> mood = const Value.absent(),
                required String readings,
                required DateTime completedAt,
              }) => SessionsCompanion.insert(
                id: id,
                date: date,
                planSlug: planSlug,
                dayIndex: dayIndex,
                prompt: prompt,
                reflection: reflection,
                prayer: prayer,
                mood: mood,
                readings: readings,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsTableData,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $SettingsTableTable,
              SettingsTableData
            >,
          ),
          SettingsTableData,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  SettingsTableCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsTableData,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingsTableData,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>,
      ),
      SettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$ReadingProgressTableCreateCompanionBuilder =
    ReadingProgressCompanion Function({
      required String planSlug,
      required String date,
      required int dayIndex,
      required String done,
      Value<int> rowid,
    });
typedef $$ReadingProgressTableUpdateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<String> planSlug,
      Value<String> date,
      Value<int> dayIndex,
      Value<String> done,
      Value<int> rowid,
    });

class $$ReadingProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get planSlug => $composableBuilder(
    column: $table.planSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get planSlug => $composableBuilder(
    column: $table.planSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get planSlug =>
      $composableBuilder(column: $table.planSlug, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);
}

class $$ReadingProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressData,
          $$ReadingProgressTableFilterComposer,
          $$ReadingProgressTableOrderingComposer,
          $$ReadingProgressTableAnnotationComposer,
          $$ReadingProgressTableCreateCompanionBuilder,
          $$ReadingProgressTableUpdateCompanionBuilder,
          (
            ReadingProgressData,
            BaseReferences<
              _$AppDatabase,
              $ReadingProgressTable,
              ReadingProgressData
            >,
          ),
          ReadingProgressData,
          PrefetchHooks Function()
        > {
  $$ReadingProgressTableTableManager(
    _$AppDatabase db,
    $ReadingProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> planSlug = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<String> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressCompanion(
                planSlug: planSlug,
                date: date,
                dayIndex: dayIndex,
                done: done,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String planSlug,
                required String date,
                required int dayIndex,
                required String done,
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressCompanion.insert(
                planSlug: planSlug,
                date: date,
                dayIndex: dayIndex,
                done: done,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingProgressTable,
      ReadingProgressData,
      $$ReadingProgressTableFilterComposer,
      $$ReadingProgressTableOrderingComposer,
      $$ReadingProgressTableAnnotationComposer,
      $$ReadingProgressTableCreateCompanionBuilder,
      $$ReadingProgressTableUpdateCompanionBuilder,
      (
        ReadingProgressData,
        BaseReferences<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressData
        >,
      ),
      ReadingProgressData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ContentMetaTableTableManager get contentMeta =>
      $$ContentMetaTableTableManager(_db, _db.contentMeta);
  $$PlansTableTableManager get plans =>
      $$PlansTableTableManager(_db, _db.plans);
  $$PlanDaysTableTableManager get planDays =>
      $$PlanDaysTableTableManager(_db, _db.planDays);
  $$ReflectionPromptsTableTableManager get reflectionPrompts =>
      $$ReflectionPromptsTableTableManager(_db, _db.reflectionPrompts);
  $$NotificationMessagesTableTableManager get notificationMessages =>
      $$NotificationMessagesTableTableManager(_db, _db.notificationMessages);
  $$MicDropVersesTableTableManager get micDropVerses =>
      $$MicDropVersesTableTableManager(_db, _db.micDropVerses);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$ReadingProgressTableTableManager get readingProgress =>
      $$ReadingProgressTableTableManager(_db, _db.readingProgress);
}
