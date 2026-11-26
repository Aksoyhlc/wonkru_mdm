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
import 'device.dart' as _ilo09f9g;

abstract class DeviceApplication
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceApplication._({
    this.id,
    required this.deviceId,
    this.device,
    required this.packageName,
    required this.appName,
    this.versionName,
    this.versionCode,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    this.isPowerSaveWhitelisted,
    this.lastSeenAt,
    this.createdAt,
    this.updatedAt,
  }) : isSystemApp = isSystemApp ?? false,
       isUninstallBlocked = isUninstallBlocked ?? false;

  factory DeviceApplication({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String packageName,
    required String appName,
    String? versionName,
    int? versionCode,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    bool? isPowerSaveWhitelisted,
    DateTime? lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceApplicationImpl;

  factory DeviceApplication.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceApplication(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      packageName: jsonSerialization['packageName'] as String,
      appName: jsonSerialization['appName'] as String,
      versionName: jsonSerialization['versionName'] as String?,
      versionCode: jsonSerialization['versionCode'] as int?,
      isSystemApp: jsonSerialization['isSystemApp'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isSystemApp']),
      isUninstallBlocked: jsonSerialization['isUninstallBlocked'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['isUninstallBlocked'],
            ),
      isPowerSaveWhitelisted:
          jsonSerialization['isPowerSaveWhitelisted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['isPowerSaveWhitelisted'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeviceApplicationTable();

  static const db = DeviceApplicationRepository._();

  @override
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  String packageName;

  String appName;

  String? versionName;

  int? versionCode;

  bool isSystemApp;

  bool isUninstallBlocked;

  bool? isPowerSaveWhitelisted;

  DateTime? lastSeenAt;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceApplication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceApplication copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceApplication$device(),
    String? packageName,
    String? appName,
    String? versionName,
    int? versionCode,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    bool? isPowerSaveWhitelisted,
    DateTime? lastSeenAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceApplication',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'packageName': packageName,
      'appName': appName,
      if (versionName != null) 'versionName': versionName,
      if (versionCode != null) 'versionCode': versionCode,
      'isSystemApp': isSystemApp,
      'isUninstallBlocked': isUninstallBlocked,
      if (isPowerSaveWhitelisted != null)
        'isPowerSaveWhitelisted': isPowerSaveWhitelisted,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceApplication',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'packageName': packageName,
      'appName': appName,
      if (versionName != null) 'versionName': versionName,
      if (versionCode != null) 'versionCode': versionCode,
      'isSystemApp': isSystemApp,
      'isUninstallBlocked': isUninstallBlocked,
      if (isPowerSaveWhitelisted != null)
        'isPowerSaveWhitelisted': isPowerSaveWhitelisted,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static DeviceApplicationInclude include({_ilo09f9g.DeviceInclude? device}) {
    return DeviceApplicationInclude._(device: device);
  }

  static DeviceApplicationIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceApplicationTable>? orderBy,
    _is.OrderByListBuilder<DeviceApplicationTable>? orderByList,
    DeviceApplicationInclude? include,
  }) {
    return DeviceApplicationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceApplication.t),
      orderByList: orderByList?.call(DeviceApplication.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceApplication$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceApplication$device();
}

class _DeviceApplicationImpl extends DeviceApplication {
  _DeviceApplicationImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String packageName,
    required String appName,
    String? versionName,
    int? versionCode,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    bool? isPowerSaveWhitelisted,
    DateTime? lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         packageName: packageName,
         appName: appName,
         versionName: versionName,
         versionCode: versionCode,
         isSystemApp: isSystemApp,
         isUninstallBlocked: isUninstallBlocked,
         isPowerSaveWhitelisted: isPowerSaveWhitelisted,
         lastSeenAt: lastSeenAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceApplication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceApplication copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceApplication$device(),
    String? packageName,
    String? appName,
    Object? versionName = _Undefined,
    Object? versionCode = _Undefined,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    Object? isPowerSaveWhitelisted = _Undefined,
    DateTime? lastSeenAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return DeviceApplication(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      versionName: versionName is String? ? versionName : this.versionName,
      versionCode: versionCode is int? ? versionCode : this.versionCode,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      isUninstallBlocked: isUninstallBlocked ?? this.isUninstallBlocked,
      isPowerSaveWhitelisted: isPowerSaveWhitelisted is bool?
          ? isPowerSaveWhitelisted
          : this.isPowerSaveWhitelisted,
      lastSeenAt: lastSeenAt is _is.UndefinedSentinel
          ? this.lastSeenAt
          : lastSeenAt,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class DeviceApplicationUpdateTable
    extends _is.UpdateTable<DeviceApplicationTable> {
  DeviceApplicationUpdateTable(super.table);

  _is.ColumnValue<int, int> deviceId(int value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<String, String> packageName(String value) => _is.ColumnValue(
    table.packageName,
    value,
  );

  _is.ColumnValue<String, String> appName(String value) => _is.ColumnValue(
    table.appName,
    value,
  );

  _is.ColumnValue<String, String> versionName(String? value) => _is.ColumnValue(
    table.versionName,
    value,
  );

  _is.ColumnValue<int, int> versionCode(int? value) => _is.ColumnValue(
    table.versionCode,
    value,
  );

  _is.ColumnValue<bool, bool> isSystemApp(bool value) => _is.ColumnValue(
    table.isSystemApp,
    value,
  );

  _is.ColumnValue<bool, bool> isUninstallBlocked(bool value) => _is.ColumnValue(
    table.isUninstallBlocked,
    value,
  );

  _is.ColumnValue<bool, bool> isPowerSaveWhitelisted(bool? value) =>
      _is.ColumnValue(
        table.isPowerSaveWhitelisted,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastSeenAt,
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

class DeviceApplicationTable extends _is.Table<int?> {
  DeviceApplicationTable({super.tableRelation})
    : super(tableName: 'device_applications') {
    updateTable = DeviceApplicationUpdateTable(this);
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    packageName = _is.ColumnString(
      'packageName',
      this,
    );
    appName = _is.ColumnString(
      'appName',
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
    isSystemApp = _is.ColumnBool(
      'isSystemApp',
      this,
    );
    isUninstallBlocked = _is.ColumnBool(
      'isUninstallBlocked',
      this,
    );
    isPowerSaveWhitelisted = _is.ColumnBool(
      'isPowerSaveWhitelisted',
      this,
    );
    lastSeenAt = _is.ColumnDateTime(
      'lastSeenAt',
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

  late final DeviceApplicationUpdateTable updateTable;

  late final _is.ColumnInt deviceId;

  _ilo09f9g.DeviceTable? _device;

  late final _is.ColumnString packageName;

  late final _is.ColumnString appName;

  late final _is.ColumnString versionName;

  late final _is.ColumnInt versionCode;

  late final _is.ColumnBool isSystemApp;

  late final _is.ColumnBool isUninstallBlocked;

  late final _is.ColumnBool isPowerSaveWhitelisted;

  late final _is.ColumnDateTime lastSeenAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: DeviceApplication.t.deviceId,
      foreignField: _ilo09f9g.Device.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ilo09f9g.DeviceTable(tableRelation: foreignTableRelation),
    );
    return _device!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    deviceId,
    packageName,
    appName,
    versionName,
    versionCode,
    isSystemApp,
    isUninstallBlocked,
    isPowerSaveWhitelisted,
    lastSeenAt,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'device') {
      return device;
    }
    return null;
  }
}

class DeviceApplicationInclude extends _is.IncludeObject {
  DeviceApplicationInclude._({_ilo09f9g.DeviceInclude? device}) {
    _device = device;
  }

  _ilo09f9g.DeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {'device': _device};

  @override
  _is.Table<int?> get table => DeviceApplication.t;
}

class DeviceApplicationIncludeList extends _is.IncludeList {
  DeviceApplicationIncludeList._({
    _is.WhereExpressionBuilder<DeviceApplicationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceApplication.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceApplication.t;
}

class DeviceApplicationRepository {
  const DeviceApplicationRepository._();

  final attachRow = const DeviceApplicationAttachRowRepository._();

  /// Returns a list of [DeviceApplication]s matching the given query parameters.
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
  Future<List<DeviceApplication>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceApplicationTable>? orderBy,
    _is.OrderByListBuilder<DeviceApplicationTable>? orderByList,
    _is.Transaction? transaction,
    DeviceApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceApplication>(
      where: where?.call(DeviceApplication.t),
      orderBy: orderBy?.call(DeviceApplication.t),
      orderByList: orderByList?.call(DeviceApplication.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceApplication]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeviceApplication.t`.
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
  _ida.Stream<List<DeviceApplication>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceApplicationTable>? orderBy,
    _is.OrderByListBuilder<DeviceApplicationTable>? orderByList,
    DeviceApplicationInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceApplication>(
      where: where?.call(DeviceApplication.t),
      orderBy: orderBy?.call(DeviceApplication.t),
      orderByList: orderByList?.call(DeviceApplication.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceApplication] matching the given query parameters.
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
  Future<DeviceApplication?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceApplicationTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceApplicationTable>? orderBy,
    _is.OrderByListBuilder<DeviceApplicationTable>? orderByList,
    _is.Transaction? transaction,
    DeviceApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceApplication>(
      where: where?.call(DeviceApplication.t),
      orderBy: orderBy?.call(DeviceApplication.t),
      orderByList: orderByList?.call(DeviceApplication.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceApplication] by its [id] or null if no such row exists.
  Future<DeviceApplication?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceApplicationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceApplication>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceApplication]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceApplication]s will have their `id` fields set.
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
  Future<List<DeviceApplication>> insert(
    _is.DatabaseSession session,
    List<DeviceApplication> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceApplication>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceApplication] and returns the inserted row.
  ///
  /// The returned [DeviceApplication] will have its `id` field set.
  Future<DeviceApplication> insertRow(
    _is.DatabaseSession session,
    DeviceApplication row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceApplication>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceApplication]s in the list and returns the resulting rows.
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
  /// The returned [DeviceApplication]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceApplication>> upsert(
    _is.DatabaseSession session,
    List<DeviceApplication> rows, {
    required _is.ColumnSelections<DeviceApplicationTable> conflictColumns,
    _is.ColumnSelections<DeviceApplicationTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceApplicationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceApplication>(
      rows,
      conflictColumns: conflictColumns(DeviceApplication.t),
      updateColumns: updateColumns?.call(DeviceApplication.t),
      updateWhere: updateWhere?.call(DeviceApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceApplication] and returns the resulting row.
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
  /// The returned [DeviceApplication] will have its `id` field set.
  Future<DeviceApplication?> upsertRow(
    _is.DatabaseSession session,
    DeviceApplication row, {
    required _is.ColumnSelections<DeviceApplicationTable> conflictColumns,
    _is.ColumnSelections<DeviceApplicationTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceApplicationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceApplication>(
      row,
      conflictColumns: conflictColumns(DeviceApplication.t),
      updateColumns: updateColumns?.call(DeviceApplication.t),
      updateWhere: updateWhere?.call(DeviceApplication.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceApplication]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceApplication>> update(
    _is.DatabaseSession session,
    List<DeviceApplication> rows, {
    _is.ColumnSelections<DeviceApplicationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceApplication>(
      rows,
      columns: columns?.call(DeviceApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceApplication]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceApplication> updateRow(
    _is.DatabaseSession session,
    DeviceApplication row, {
    _is.ColumnSelections<DeviceApplicationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceApplication>(
      row,
      columns: columns?.call(DeviceApplication.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceApplication] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceApplication?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceApplicationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceApplication>(
      id,
      columnValues: columnValues(DeviceApplication.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceApplication]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceApplication>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceApplicationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DeviceApplicationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceApplicationTable>? orderBy,
    _is.OrderByListBuilder<DeviceApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceApplication>(
      columnValues: columnValues(DeviceApplication.t.updateTable),
      where: where(DeviceApplication.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceApplication.t),
      orderByList: orderByList?.call(DeviceApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceApplication]s in the list and returns the deleted rows.
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
  Future<List<DeviceApplication>> delete(
    _is.DatabaseSession session,
    List<DeviceApplication> rows, {
    _is.OrderByBuilder<DeviceApplicationTable>? orderBy,
    _is.OrderByListBuilder<DeviceApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceApplication>(
      rows,
      orderBy: orderBy?.call(DeviceApplication.t),
      orderByList: orderByList?.call(DeviceApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceApplication].
  Future<DeviceApplication> deleteRow(
    _is.DatabaseSession session,
    DeviceApplication row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceApplication>(
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
  Future<List<DeviceApplication>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceApplicationTable> where,
    _is.OrderByBuilder<DeviceApplicationTable>? orderBy,
    _is.OrderByListBuilder<DeviceApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceApplication>(
      where: where(DeviceApplication.t),
      orderBy: orderBy?.call(DeviceApplication.t),
      orderByList: orderByList?.call(DeviceApplication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceApplicationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceApplication>(
      where: where?.call(DeviceApplication.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceApplication] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceApplicationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceApplication>(
      where: where(DeviceApplication.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceApplicationAttachRowRepository {
  const DeviceApplicationAttachRowRepository._();

  /// Creates a relation between the given [DeviceApplication] and [Device]
  /// by setting the [DeviceApplication]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    DeviceApplication deviceApplication,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (deviceApplication.id == null) {
      throw ArgumentError.notNull('deviceApplication.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $deviceApplication = deviceApplication.copyWith(deviceId: device.id);
    await session.db.updateRow<DeviceApplication>(
      $deviceApplication,
      columns: [DeviceApplication.t.deviceId],
      transaction: transaction,
    );
  }
}
