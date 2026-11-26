/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:wonkru_mdm_server/src/generated/protocol.dart' as _ij1wyujj;
import 'application.dart' as _ice4s91e;

abstract class ApplicationVersion
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ApplicationVersion._({
    this.id,
    required this.applicationId,
    this.application,
    required this.versionName,
    required this.versionCode,
    this.filePath,
    this.fileSizeBytes,
    this.checksumSha256,
    this.minSdkVersion,
    this.targetSdkVersion,
    bool? isActive,
    this.permissions,
    bool? isDefault,
    this.createdAt,
    this.updatedAt,
  }) : isActive = isActive ?? true,
       isDefault = isDefault ?? false;

  factory ApplicationVersion({
    int? id,
    required int applicationId,
    _ice4s91e.Application? application,
    required String versionName,
    required int versionCode,
    String? filePath,
    int? fileSizeBytes,
    String? checksumSha256,
    int? minSdkVersion,
    int? targetSdkVersion,
    bool? isActive,
    String? permissions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ApplicationVersionImpl;

  factory ApplicationVersion.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApplicationVersion(
      id: jsonSerialization['id'] as int?,
      applicationId: jsonSerialization['applicationId'] as int,
      application: jsonSerialization['application'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ice4s91e.Application>(
              jsonSerialization['application'],
            ),
      versionName: jsonSerialization['versionName'] as String,
      versionCode: jsonSerialization['versionCode'] as int,
      filePath: jsonSerialization['filePath'] as String?,
      fileSizeBytes: jsonSerialization['fileSizeBytes'] as int?,
      checksumSha256: jsonSerialization['checksumSha256'] as String?,
      minSdkVersion: jsonSerialization['minSdkVersion'] as int?,
      targetSdkVersion: jsonSerialization['targetSdkVersion'] as int?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      permissions: jsonSerialization['permissions'] as String?,
      isDefault: jsonSerialization['isDefault'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isDefault']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ApplicationVersionTable();

  static const db = ApplicationVersionRepository._();

  @override
  int? id;

  int applicationId;

  _ice4s91e.Application? application;

  String versionName;

  int versionCode;

  String? filePath;

  int? fileSizeBytes;

  String? checksumSha256;

  int? minSdkVersion;

  int? targetSdkVersion;

  bool isActive;

  /// JSON list of permissions declared by the APK.
  String? permissions;

  bool isDefault;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ApplicationVersion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApplicationVersion copyWith({
    int? id,
    int? applicationId,
    _ice4s91e.Application? application =
        const _UndefinedApplicationVersion$application(),
    String? versionName,
    int? versionCode,
    String? filePath,
    int? fileSizeBytes,
    String? checksumSha256,
    int? minSdkVersion,
    int? targetSdkVersion,
    bool? isActive,
    String? permissions,
    bool? isDefault,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApplicationVersion',
      if (id != null) 'id': id,
      'applicationId': applicationId,
      if (application != null) 'application': application?.toJson(),
      'versionName': versionName,
      'versionCode': versionCode,
      if (filePath != null) 'filePath': filePath,
      if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
      if (checksumSha256 != null) 'checksumSha256': checksumSha256,
      if (minSdkVersion != null) 'minSdkVersion': minSdkVersion,
      if (targetSdkVersion != null) 'targetSdkVersion': targetSdkVersion,
      'isActive': isActive,
      if (permissions != null) 'permissions': permissions,
      'isDefault': isDefault,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApplicationVersion',
      if (id != null) 'id': id,
      'applicationId': applicationId,
      if (application != null) 'application': application?.toJsonForProtocol(),
      'versionName': versionName,
      'versionCode': versionCode,
      if (filePath != null) 'filePath': filePath,
      if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
      if (checksumSha256 != null) 'checksumSha256': checksumSha256,
      if (minSdkVersion != null) 'minSdkVersion': minSdkVersion,
      if (targetSdkVersion != null) 'targetSdkVersion': targetSdkVersion,
      'isActive': isActive,
      if (permissions != null) 'permissions': permissions,
      'isDefault': isDefault,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static ApplicationVersionInclude include({
    _ice4s91e.ApplicationInclude? application,
  }) {
    return ApplicationVersionInclude._(application: application);
  }

  static ApplicationVersionIncludeList includeList({
    _is.WhereExpressionBuilder<ApplicationVersionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationVersionTable>? orderBy,
    _is.OrderByListBuilder<ApplicationVersionTable>? orderByList,
    ApplicationVersionInclude? include,
  }) {
    return ApplicationVersionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApplicationVersion.t),
      orderByList: orderByList?.call(ApplicationVersion.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedApplicationVersion$application extends _is.UndefinedSentinel
    implements _ice4s91e.Application {
  const _UndefinedApplicationVersion$application();
}

class _ApplicationVersionImpl extends ApplicationVersion {
  _ApplicationVersionImpl({
    int? id,
    required int applicationId,
    _ice4s91e.Application? application,
    required String versionName,
    required int versionCode,
    String? filePath,
    int? fileSizeBytes,
    String? checksumSha256,
    int? minSdkVersion,
    int? targetSdkVersion,
    bool? isActive,
    String? permissions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         applicationId: applicationId,
         application: application,
         versionName: versionName,
         versionCode: versionCode,
         filePath: filePath,
         fileSizeBytes: fileSizeBytes,
         checksumSha256: checksumSha256,
         minSdkVersion: minSdkVersion,
         targetSdkVersion: targetSdkVersion,
         isActive: isActive,
         permissions: permissions,
         isDefault: isDefault,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ApplicationVersion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApplicationVersion copyWith({
    Object? id = _Undefined,
    int? applicationId,
    _ice4s91e.Application? application =
        const _UndefinedApplicationVersion$application(),
    String? versionName,
    int? versionCode,
    Object? filePath = _Undefined,
    Object? fileSizeBytes = _Undefined,
    Object? checksumSha256 = _Undefined,
    Object? minSdkVersion = _Undefined,
    Object? targetSdkVersion = _Undefined,
    bool? isActive,
    Object? permissions = _Undefined,
    bool? isDefault,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return ApplicationVersion(
      id: id is int? ? id : this.id,
      applicationId: applicationId ?? this.applicationId,
      application: application is _is.UndefinedSentinel
          ? this.application?.copyWith()
          : application,
      versionName: versionName ?? this.versionName,
      versionCode: versionCode ?? this.versionCode,
      filePath: filePath is String? ? filePath : this.filePath,
      fileSizeBytes: fileSizeBytes is int? ? fileSizeBytes : this.fileSizeBytes,
      checksumSha256: checksumSha256 is String?
          ? checksumSha256
          : this.checksumSha256,
      minSdkVersion: minSdkVersion is int? ? minSdkVersion : this.minSdkVersion,
      targetSdkVersion: targetSdkVersion is int?
          ? targetSdkVersion
          : this.targetSdkVersion,
      isActive: isActive ?? this.isActive,
      permissions: permissions is String? ? permissions : this.permissions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class ApplicationVersionUpdateTable
    extends _is.UpdateTable<ApplicationVersionTable> {
  ApplicationVersionUpdateTable(super.table);

  _is.ColumnValue<int, int> applicationId(int value) => _is.ColumnValue(
    table.applicationId,
    value,
  );

  _is.ColumnValue<String, String> versionName(String value) => _is.ColumnValue(
    table.versionName,
    value,
  );

  _is.ColumnValue<int, int> versionCode(int value) => _is.ColumnValue(
    table.versionCode,
    value,
  );

  _is.ColumnValue<String, String> filePath(String? value) => _is.ColumnValue(
    table.filePath,
    value,
  );

  _is.ColumnValue<int, int> fileSizeBytes(int? value) => _is.ColumnValue(
    table.fileSizeBytes,
    value,
  );

  _is.ColumnValue<String, String> checksumSha256(String? value) =>
      _is.ColumnValue(
        table.checksumSha256,
        value,
      );

  _is.ColumnValue<int, int> minSdkVersion(int? value) => _is.ColumnValue(
    table.minSdkVersion,
    value,
  );

  _is.ColumnValue<int, int> targetSdkVersion(int? value) => _is.ColumnValue(
    table.targetSdkVersion,
    value,
  );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );

  _is.ColumnValue<String, String> permissions(String? value) => _is.ColumnValue(
    table.permissions,
    value,
  );

  _is.ColumnValue<bool, bool> isDefault(bool value) => _is.ColumnValue(
    table.isDefault,
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
}

class ApplicationVersionTable extends _is.Table<int?> {
  ApplicationVersionTable({super.tableRelation})
    : super(tableName: 'application_versions') {
    updateTable = ApplicationVersionUpdateTable(this);
    applicationId = _is.ColumnInt(
      'applicationId',
      this,
    );
    versionName = _is.ColumnString(
      'versionName',
      this,
    );
    versionCode = _is.ColumnInt(
      'versionCode',
      this,
    );
    filePath = _is.ColumnString(
      'filePath',
      this,
    );
    fileSizeBytes = _is.ColumnInt(
      'fileSizeBytes',
      this,
    );
    checksumSha256 = _is.ColumnString(
      'checksumSha256',
      this,
    );
    minSdkVersion = _is.ColumnInt(
      'minSdkVersion',
      this,
    );
    targetSdkVersion = _is.ColumnInt(
      'targetSdkVersion',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
    permissions = _is.ColumnString(
      'permissions',
      this,
    );
    isDefault = _is.ColumnBool(
      'isDefault',
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
  }

  late final ApplicationVersionUpdateTable updateTable;

  late final _is.ColumnInt applicationId;

  _ice4s91e.ApplicationTable? _application;

  late final _is.ColumnString versionName;

  late final _is.ColumnInt versionCode;

  late final _is.ColumnString filePath;

  late final _is.ColumnInt fileSizeBytes;

  late final _is.ColumnString checksumSha256;

  late final _is.ColumnInt minSdkVersion;

  late final _is.ColumnInt targetSdkVersion;

  late final _is.ColumnBool isActive;

  /// JSON list of permissions declared by the APK.
  late final _is.ColumnString permissions;

  late final _is.ColumnBool isDefault;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _ice4s91e.ApplicationTable get application {
    if (_application != null) return _application!;
    _application = _is.createRelationTable(
      relationFieldName: 'application',
      field: ApplicationVersion.t.applicationId,
      foreignField: _ice4s91e.Application.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ice4s91e.ApplicationTable(tableRelation: foreignTableRelation),
    );
    return _application!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    applicationId,
    versionName,
    versionCode,
    filePath,
    fileSizeBytes,
    checksumSha256,
    minSdkVersion,
    targetSdkVersion,
    isActive,
    permissions,
    isDefault,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'application') {
      return application;
    }
    return null;
  }
}

class ApplicationVersionInclude extends _is.IncludeObject {
  ApplicationVersionInclude._({_ice4s91e.ApplicationInclude? application}) {
    _application = application;
  }

  _ice4s91e.ApplicationInclude? _application;

  @override
  Map<String, _is.Include?> get includes => {'application': _application};

  @override
  _is.Table<int?> get table => ApplicationVersion.t;
}

class ApplicationVersionIncludeList extends _is.IncludeList {
  ApplicationVersionIncludeList._({
    _is.WhereExpressionBuilder<ApplicationVersionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ApplicationVersion.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ApplicationVersion.t;
}

class ApplicationVersionRepository {
  const ApplicationVersionRepository._();

  final attachRow = const ApplicationVersionAttachRowRepository._();

  /// Returns a list of [ApplicationVersion]s matching the given query parameters.
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
  Future<List<ApplicationVersion>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationVersionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationVersionTable>? orderBy,
    _is.OrderByListBuilder<ApplicationVersionTable>? orderByList,
    _is.Transaction? transaction,
    ApplicationVersionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ApplicationVersion>(
      where: where?.call(ApplicationVersion.t),
      orderBy: orderBy?.call(ApplicationVersion.t),
      orderByList: orderByList?.call(ApplicationVersion.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ApplicationVersion]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ApplicationVersion.t`.
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
  _ida.Stream<List<ApplicationVersion>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationVersionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationVersionTable>? orderBy,
    _is.OrderByListBuilder<ApplicationVersionTable>? orderByList,
    ApplicationVersionInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ApplicationVersion>(
      where: where?.call(ApplicationVersion.t),
      orderBy: orderBy?.call(ApplicationVersion.t),
      orderByList: orderByList?.call(ApplicationVersion.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ApplicationVersion] matching the given query parameters.
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
  Future<ApplicationVersion?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationVersionTable>? where,
    int? offset,
    _is.OrderByBuilder<ApplicationVersionTable>? orderBy,
    _is.OrderByListBuilder<ApplicationVersionTable>? orderByList,
    _is.Transaction? transaction,
    ApplicationVersionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ApplicationVersion>(
      where: where?.call(ApplicationVersion.t),
      orderBy: orderBy?.call(ApplicationVersion.t),
      orderByList: orderByList?.call(ApplicationVersion.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ApplicationVersion] by its [id] or null if no such row exists.
  Future<ApplicationVersion?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ApplicationVersionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ApplicationVersion>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ApplicationVersion]s in the list and returns the inserted rows.
  ///
  /// The returned [ApplicationVersion]s will have their `id` fields set.
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
  Future<List<ApplicationVersion>> insert(
    _is.DatabaseSession session,
    List<ApplicationVersion> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ApplicationVersion>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ApplicationVersion] and returns the inserted row.
  ///
  /// The returned [ApplicationVersion] will have its `id` field set.
  Future<ApplicationVersion> insertRow(
    _is.DatabaseSession session,
    ApplicationVersion row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ApplicationVersion>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ApplicationVersion]s in the list and returns the resulting rows.
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
  /// The returned [ApplicationVersion]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ApplicationVersion>> upsert(
    _is.DatabaseSession session,
    List<ApplicationVersion> rows, {
    required _is.ColumnSelections<ApplicationVersionTable> conflictColumns,
    _is.ColumnSelections<ApplicationVersionTable>? updateColumns,
    _is.WhereExpressionBuilder<ApplicationVersionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ApplicationVersion>(
      rows,
      conflictColumns: conflictColumns(ApplicationVersion.t),
      updateColumns: updateColumns?.call(ApplicationVersion.t),
      updateWhere: updateWhere?.call(ApplicationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ApplicationVersion] and returns the resulting row.
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
  /// The returned [ApplicationVersion] will have its `id` field set.
  Future<ApplicationVersion?> upsertRow(
    _is.DatabaseSession session,
    ApplicationVersion row, {
    required _is.ColumnSelections<ApplicationVersionTable> conflictColumns,
    _is.ColumnSelections<ApplicationVersionTable>? updateColumns,
    _is.WhereExpressionBuilder<ApplicationVersionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ApplicationVersion>(
      row,
      conflictColumns: conflictColumns(ApplicationVersion.t),
      updateColumns: updateColumns?.call(ApplicationVersion.t),
      updateWhere: updateWhere?.call(ApplicationVersion.t),
      transaction: transaction,
    );
  }

  /// Updates all [ApplicationVersion]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ApplicationVersion>> update(
    _is.DatabaseSession session,
    List<ApplicationVersion> rows, {
    _is.ColumnSelections<ApplicationVersionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ApplicationVersion>(
      rows,
      columns: columns?.call(ApplicationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ApplicationVersion]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ApplicationVersion> updateRow(
    _is.DatabaseSession session,
    ApplicationVersion row, {
    _is.ColumnSelections<ApplicationVersionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ApplicationVersion>(
      row,
      columns: columns?.call(ApplicationVersion.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ApplicationVersion] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ApplicationVersion?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ApplicationVersionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ApplicationVersion>(
      id,
      columnValues: columnValues(ApplicationVersion.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ApplicationVersion]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ApplicationVersion>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ApplicationVersionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ApplicationVersionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationVersionTable>? orderBy,
    _is.OrderByListBuilder<ApplicationVersionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ApplicationVersion>(
      columnValues: columnValues(ApplicationVersion.t.updateTable),
      where: where(ApplicationVersion.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApplicationVersion.t),
      orderByList: orderByList?.call(ApplicationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ApplicationVersion]s in the list and returns the deleted rows.
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
  Future<List<ApplicationVersion>> delete(
    _is.DatabaseSession session,
    List<ApplicationVersion> rows, {
    _is.OrderByBuilder<ApplicationVersionTable>? orderBy,
    _is.OrderByListBuilder<ApplicationVersionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ApplicationVersion>(
      rows,
      orderBy: orderBy?.call(ApplicationVersion.t),
      orderByList: orderByList?.call(ApplicationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ApplicationVersion].
  Future<ApplicationVersion> deleteRow(
    _is.DatabaseSession session,
    ApplicationVersion row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ApplicationVersion>(
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
  Future<List<ApplicationVersion>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ApplicationVersionTable> where,
    _is.OrderByBuilder<ApplicationVersionTable>? orderBy,
    _is.OrderByListBuilder<ApplicationVersionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ApplicationVersion>(
      where: where(ApplicationVersion.t),
      orderBy: orderBy?.call(ApplicationVersion.t),
      orderByList: orderByList?.call(ApplicationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationVersionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ApplicationVersion>(
      where: where?.call(ApplicationVersion.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ApplicationVersion] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ApplicationVersionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ApplicationVersion>(
      where: where(ApplicationVersion.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ApplicationVersionAttachRowRepository {
  const ApplicationVersionAttachRowRepository._();

  /// Creates a relation between the given [ApplicationVersion] and [Application]
  /// by setting the [ApplicationVersion]'s foreign key `applicationId` to refer to the [Application].
  Future<void> application(
    _is.DatabaseSession session,
    ApplicationVersion applicationVersion,
    _ice4s91e.Application application, {
    _is.Transaction? transaction,
  }) async {
    if (applicationVersion.id == null) {
      throw ArgumentError.notNull('applicationVersion.id');
    }
    if (application.id == null) {
      throw ArgumentError.notNull('application.id');
    }

    var $applicationVersion = applicationVersion.copyWith(
      applicationId: application.id,
    );
    await session.db.updateRow<ApplicationVersion>(
      $applicationVersion,
      columns: [ApplicationVersion.t.applicationId],
      transaction: transaction,
    );
  }
}
