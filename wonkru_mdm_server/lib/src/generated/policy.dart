/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;

abstract class Policy implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Policy._({
    this.id,
    required this.name,
    this.slug,
    this.description,
    this.activeTimeRanges,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    this.adminPassword,
    this.batterySettings,
    this.storageSettings,
    this.audioSettings,
    this.displaySettings,
    this.securitySettings,
    this.restrictionSettings,
    this.launcher,
    this.syncSettings,
    this.otherSettings,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : isActive = isActive ?? true,
       version = version ?? 1,
       defaultPolicy = defaultPolicy ?? false;

  factory Policy({
    int? id,
    required String name,
    String? slug,
    String? description,
    String? activeTimeRanges,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    String? adminPassword,
    String? batterySettings,
    String? storageSettings,
    String? audioSettings,
    String? displaySettings,
    String? securitySettings,
    String? restrictionSettings,
    String? launcher,
    String? syncSettings,
    String? otherSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _PolicyImpl;

  factory Policy.fromJson(Map<String, dynamic> jsonSerialization) {
    return Policy(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String?,
      description: jsonSerialization['description'] as String?,
      activeTimeRanges: jsonSerialization['activeTimeRanges'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      version: jsonSerialization['version'] as int?,
      defaultPolicy: jsonSerialization['defaultPolicy'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['defaultPolicy']),
      adminPassword: jsonSerialization['adminPassword'] as String?,
      batterySettings: jsonSerialization['batterySettings'] as String?,
      storageSettings: jsonSerialization['storageSettings'] as String?,
      audioSettings: jsonSerialization['audioSettings'] as String?,
      displaySettings: jsonSerialization['displaySettings'] as String?,
      securitySettings: jsonSerialization['securitySettings'] as String?,
      restrictionSettings: jsonSerialization['restrictionSettings'] as String?,
      launcher: jsonSerialization['launcher'] as String?,
      syncSettings: jsonSerialization['syncSettings'] as String?,
      otherSettings: jsonSerialization['otherSettings'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = PolicyTable();

  static const db = PolicyRepository._();

  @override
  int? id;

  String name;

  String? slug;

  String? description;

  /// JSON describing the allowed time ranges.
  String? activeTimeRanges;

  bool isActive;

  int version;

  bool defaultPolicy;

  /// Argon2id hash of the admin password.
  String? adminPassword;

  /// JSON setting blocks.
  String? batterySettings;

  String? storageSettings;

  String? audioSettings;

  String? displaySettings;

  String? securitySettings;

  String? restrictionSettings;

  /// JSON launcher configuration.
  String? launcher;

  String? syncSettings;

  String? otherSettings;

  DateTime? createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Policy]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Policy copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? activeTimeRanges,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    String? adminPassword,
    String? batterySettings,
    String? storageSettings,
    String? audioSettings,
    String? displaySettings,
    String? securitySettings,
    String? restrictionSettings,
    String? launcher,
    String? syncSettings,
    String? otherSettings,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
    DateTime? deletedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Policy',
      if (id != null) 'id': id,
      'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (activeTimeRanges != null) 'activeTimeRanges': activeTimeRanges,
      'isActive': isActive,
      'version': version,
      'defaultPolicy': defaultPolicy,
      if (adminPassword != null) 'adminPassword': adminPassword,
      if (batterySettings != null) 'batterySettings': batterySettings,
      if (storageSettings != null) 'storageSettings': storageSettings,
      if (audioSettings != null) 'audioSettings': audioSettings,
      if (displaySettings != null) 'displaySettings': displaySettings,
      if (securitySettings != null) 'securitySettings': securitySettings,
      if (restrictionSettings != null)
        'restrictionSettings': restrictionSettings,
      if (launcher != null) 'launcher': launcher,
      if (syncSettings != null) 'syncSettings': syncSettings,
      if (otherSettings != null) 'otherSettings': otherSettings,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Policy',
      if (id != null) 'id': id,
      'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (activeTimeRanges != null) 'activeTimeRanges': activeTimeRanges,
      'isActive': isActive,
      'version': version,
      'defaultPolicy': defaultPolicy,
      if (adminPassword != null) 'adminPassword': adminPassword,
      if (batterySettings != null) 'batterySettings': batterySettings,
      if (storageSettings != null) 'storageSettings': storageSettings,
      if (audioSettings != null) 'audioSettings': audioSettings,
      if (displaySettings != null) 'displaySettings': displaySettings,
      if (securitySettings != null) 'securitySettings': securitySettings,
      if (restrictionSettings != null)
        'restrictionSettings': restrictionSettings,
      if (launcher != null) 'launcher': launcher,
      if (syncSettings != null) 'syncSettings': syncSettings,
      if (otherSettings != null) 'otherSettings': otherSettings,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static PolicyInclude include() {
    return PolicyInclude._();
  }

  static PolicyIncludeList includeList({
    _is.WhereExpressionBuilder<PolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyTable>? orderBy,
    _is.OrderByListBuilder<PolicyTable>? orderByList,
    PolicyInclude? include,
  }) {
    return PolicyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PolicyImpl extends Policy {
  _PolicyImpl({
    int? id,
    required String name,
    String? slug,
    String? description,
    String? activeTimeRanges,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    String? adminPassword,
    String? batterySettings,
    String? storageSettings,
    String? audioSettings,
    String? displaySettings,
    String? securitySettings,
    String? restrictionSettings,
    String? launcher,
    String? syncSettings,
    String? otherSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         name: name,
         slug: slug,
         description: description,
         activeTimeRanges: activeTimeRanges,
         isActive: isActive,
         version: version,
         defaultPolicy: defaultPolicy,
         adminPassword: adminPassword,
         batterySettings: batterySettings,
         storageSettings: storageSettings,
         audioSettings: audioSettings,
         displaySettings: displaySettings,
         securitySettings: securitySettings,
         restrictionSettings: restrictionSettings,
         launcher: launcher,
         syncSettings: syncSettings,
         otherSettings: otherSettings,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Policy]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Policy copyWith({
    Object? id = _Undefined,
    String? name,
    Object? slug = _Undefined,
    Object? description = _Undefined,
    Object? activeTimeRanges = _Undefined,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    Object? adminPassword = _Undefined,
    Object? batterySettings = _Undefined,
    Object? storageSettings = _Undefined,
    Object? audioSettings = _Undefined,
    Object? displaySettings = _Undefined,
    Object? securitySettings = _Undefined,
    Object? restrictionSettings = _Undefined,
    Object? launcher = _Undefined,
    Object? syncSettings = _Undefined,
    Object? otherSettings = _Undefined,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
    DateTime? deletedAt = const _is.$UndefinedDateTime(),
  }) {
    return Policy(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      slug: slug is String? ? slug : this.slug,
      description: description is String? ? description : this.description,
      activeTimeRanges: activeTimeRanges is String?
          ? activeTimeRanges
          : this.activeTimeRanges,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      defaultPolicy: defaultPolicy ?? this.defaultPolicy,
      adminPassword: adminPassword is String?
          ? adminPassword
          : this.adminPassword,
      batterySettings: batterySettings is String?
          ? batterySettings
          : this.batterySettings,
      storageSettings: storageSettings is String?
          ? storageSettings
          : this.storageSettings,
      audioSettings: audioSettings is String?
          ? audioSettings
          : this.audioSettings,
      displaySettings: displaySettings is String?
          ? displaySettings
          : this.displaySettings,
      securitySettings: securitySettings is String?
          ? securitySettings
          : this.securitySettings,
      restrictionSettings: restrictionSettings is String?
          ? restrictionSettings
          : this.restrictionSettings,
      launcher: launcher is String? ? launcher : this.launcher,
      syncSettings: syncSettings is String? ? syncSettings : this.syncSettings,
      otherSettings: otherSettings is String?
          ? otherSettings
          : this.otherSettings,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
      deletedAt: deletedAt is _is.UndefinedSentinel
          ? this.deletedAt
          : deletedAt,
    );
  }
}

class PolicyUpdateTable extends _is.UpdateTable<PolicyTable> {
  PolicyUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> slug(String? value) => _is.ColumnValue(
    table.slug,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> activeTimeRanges(String? value) =>
      _is.ColumnValue(
        table.activeTimeRanges,
        value,
      );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );

  _is.ColumnValue<bool, bool> defaultPolicy(bool value) => _is.ColumnValue(
    table.defaultPolicy,
    value,
  );

  _is.ColumnValue<String, String> adminPassword(String? value) =>
      _is.ColumnValue(
        table.adminPassword,
        value,
      );

  _is.ColumnValue<String, String> batterySettings(String? value) =>
      _is.ColumnValue(
        table.batterySettings,
        value,
      );

  _is.ColumnValue<String, String> storageSettings(String? value) =>
      _is.ColumnValue(
        table.storageSettings,
        value,
      );

  _is.ColumnValue<String, String> audioSettings(String? value) =>
      _is.ColumnValue(
        table.audioSettings,
        value,
      );

  _is.ColumnValue<String, String> displaySettings(String? value) =>
      _is.ColumnValue(
        table.displaySettings,
        value,
      );

  _is.ColumnValue<String, String> securitySettings(String? value) =>
      _is.ColumnValue(
        table.securitySettings,
        value,
      );

  _is.ColumnValue<String, String> restrictionSettings(String? value) =>
      _is.ColumnValue(
        table.restrictionSettings,
        value,
      );

  _is.ColumnValue<String, String> launcher(String? value) => _is.ColumnValue(
    table.launcher,
    value,
  );

  _is.ColumnValue<String, String> syncSettings(String? value) =>
      _is.ColumnValue(
        table.syncSettings,
        value,
      );

  _is.ColumnValue<String, String> otherSettings(String? value) =>
      _is.ColumnValue(
        table.otherSettings,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _is.ColumnValue(
        table.deletedAt,
        value,
      );
}

class PolicyTable extends _is.Table<int?> {
  PolicyTable({super.tableRelation}) : super(tableName: 'policies') {
    updateTable = PolicyUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    slug = _is.ColumnString(
      'slug',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    activeTimeRanges = _is.ColumnString(
      'activeTimeRanges',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
    version = _is.ColumnInt(
      'version',
      this,
    );
    defaultPolicy = _is.ColumnBool(
      'defaultPolicy',
      this,
    );
    adminPassword = _is.ColumnString(
      'adminPassword',
      this,
    );
    batterySettings = _is.ColumnString(
      'batterySettings',
      this,
    );
    storageSettings = _is.ColumnString(
      'storageSettings',
      this,
    );
    audioSettings = _is.ColumnString(
      'audioSettings',
      this,
    );
    displaySettings = _is.ColumnString(
      'displaySettings',
      this,
    );
    securitySettings = _is.ColumnString(
      'securitySettings',
      this,
    );
    restrictionSettings = _is.ColumnString(
      'restrictionSettings',
      this,
    );
    launcher = _is.ColumnString(
      'launcher',
      this,
    );
    syncSettings = _is.ColumnString(
      'syncSettings',
      this,
    );
    otherSettings = _is.ColumnString(
      'otherSettings',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
    deletedAt = _is.ColumnDateTime(
      'deletedAt',
      this,
    );
  }

  late final PolicyUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString slug;

  late final _is.ColumnString description;

  /// JSON describing the allowed time ranges.
  late final _is.ColumnString activeTimeRanges;

  late final _is.ColumnBool isActive;

  late final _is.ColumnInt version;

  late final _is.ColumnBool defaultPolicy;

  /// Argon2id hash of the admin password.
  late final _is.ColumnString adminPassword;

  /// JSON setting blocks.
  late final _is.ColumnString batterySettings;

  late final _is.ColumnString storageSettings;

  late final _is.ColumnString audioSettings;

  late final _is.ColumnString displaySettings;

  late final _is.ColumnString securitySettings;

  late final _is.ColumnString restrictionSettings;

  /// JSON launcher configuration.
  late final _is.ColumnString launcher;

  late final _is.ColumnString syncSettings;

  late final _is.ColumnString otherSettings;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime deletedAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    slug,
    description,
    activeTimeRanges,
    isActive,
    version,
    defaultPolicy,
    adminPassword,
    batterySettings,
    storageSettings,
    audioSettings,
    displaySettings,
    securitySettings,
    restrictionSettings,
    launcher,
    syncSettings,
    otherSettings,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

class PolicyInclude extends _is.IncludeObject {
  PolicyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Policy.t;
}

class PolicyIncludeList extends _is.IncludeList {
  PolicyIncludeList._({
    _is.WhereExpressionBuilder<PolicyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Policy.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Policy.t;
}

class PolicyRepository {
  const PolicyRepository._();

  /// Returns a list of [Policy]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Policy>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyTable>? orderBy,
    _is.OrderByListBuilder<PolicyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Policy>(
      where: where?.call(Policy.t),
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Policy]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `Policy.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<Policy>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyTable>? orderBy,
    _is.OrderByListBuilder<PolicyTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Policy>(
      where: where?.call(Policy.t),
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Policy] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Policy?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyTable>? where,
    int? offset,
    _is.OrderByBuilder<PolicyTable>? orderBy,
    _is.OrderByListBuilder<PolicyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Policy>(
      where: where?.call(Policy.t),
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Policy] by its [id] or null if no such row exists.
  Future<Policy?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Policy>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Policy]s in the list and returns the inserted rows.
  ///
  /// The returned [Policy]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Policy>> insert(
    _is.DatabaseSession session,
    List<Policy> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Policy>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Policy] and returns the inserted row.
  ///
  /// The returned [Policy] will have its `id` field set.
  Future<Policy> insertRow(
    _is.DatabaseSession session,
    Policy row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Policy>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Policy]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Policy]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Policy>> upsert(
    _is.DatabaseSession session,
    List<Policy> rows, {
    required _is.ColumnSelections<PolicyTable> conflictColumns,
    _is.ColumnSelections<PolicyTable>? updateColumns,
    _is.WhereExpressionBuilder<PolicyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Policy>(
      rows,
      conflictColumns: conflictColumns(Policy.t),
      updateColumns: updateColumns?.call(Policy.t),
      updateWhere: updateWhere?.call(Policy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Policy] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Policy] will have its `id` field set.
  Future<Policy?> upsertRow(
    _is.DatabaseSession session,
    Policy row, {
    required _is.ColumnSelections<PolicyTable> conflictColumns,
    _is.ColumnSelections<PolicyTable>? updateColumns,
    _is.WhereExpressionBuilder<PolicyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Policy>(
      row,
      conflictColumns: conflictColumns(Policy.t),
      updateColumns: updateColumns?.call(Policy.t),
      updateWhere: updateWhere?.call(Policy.t),
      transaction: transaction,
    );
  }

  /// Updates all [Policy]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Policy>> update(
    _is.DatabaseSession session,
    List<Policy> rows, {
    _is.ColumnSelections<PolicyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Policy>(
      rows,
      columns: columns?.call(Policy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Policy]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Policy> updateRow(
    _is.DatabaseSession session,
    Policy row, {
    _is.ColumnSelections<PolicyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Policy>(
      row,
      columns: columns?.call(Policy.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Policy] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Policy?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PolicyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Policy>(
      id,
      columnValues: columnValues(Policy.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Policy]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Policy>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PolicyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PolicyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyTable>? orderBy,
    _is.OrderByListBuilder<PolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Policy>(
      columnValues: columnValues(Policy.t.updateTable),
      where: where(Policy.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Policy]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Policy>> delete(
    _is.DatabaseSession session,
    List<Policy> rows, {
    _is.OrderByBuilder<PolicyTable>? orderBy,
    _is.OrderByListBuilder<PolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Policy>(
      rows,
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Policy].
  Future<Policy> deleteRow(
    _is.DatabaseSession session,
    Policy row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Policy>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Policy>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PolicyTable> where,
    _is.OrderByBuilder<PolicyTable>? orderBy,
    _is.OrderByListBuilder<PolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Policy>(
      where: where(Policy.t),
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Policy>(
      where: where?.call(Policy.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Policy] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PolicyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Policy>(
      where: where(Policy.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
