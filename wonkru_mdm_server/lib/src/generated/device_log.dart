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

abstract class DeviceLog
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceLog._({
    this.id,
    required this.deviceId,
    this.device,
    this.entryUuid,
    this.sessionId,
    this.loggedAt,
    int? level,
    this.tag,
    required this.message,
    this.stacktrace,
    this.createdAt,
    this.updatedAt,
  }) : level = level ?? 2;

  factory DeviceLog({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    String? entryUuid,
    String? sessionId,
    DateTime? loggedAt,
    int? level,
    String? tag,
    required String message,
    String? stacktrace,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceLogImpl;

  factory DeviceLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLog(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      entryUuid: jsonSerialization['entryUuid'] as String?,
      sessionId: jsonSerialization['sessionId'] as String?,
      loggedAt: jsonSerialization['loggedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['loggedAt']),
      level: jsonSerialization['level'] as int?,
      tag: jsonSerialization['tag'] as String?,
      message: jsonSerialization['message'] as String,
      stacktrace: jsonSerialization['stacktrace'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeviceLogTable();

  static const db = DeviceLogRepository._();

  @override
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  String? entryUuid;

  String? sessionId;

  DateTime? loggedAt;

  int level;

  String? tag;

  String message;

  String? stacktrace;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceLog copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceLog$device(),
    String? entryUuid,
    String? sessionId,
    DateTime? loggedAt = const _is.$UndefinedDateTime(),
    int? level,
    String? tag,
    String? message,
    String? stacktrace,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceLog',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      if (entryUuid != null) 'entryUuid': entryUuid,
      if (sessionId != null) 'sessionId': sessionId,
      if (loggedAt != null) 'loggedAt': loggedAt?.toJson(),
      'level': level,
      if (tag != null) 'tag': tag,
      'message': message,
      if (stacktrace != null) 'stacktrace': stacktrace,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceLog',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      if (entryUuid != null) 'entryUuid': entryUuid,
      if (sessionId != null) 'sessionId': sessionId,
      if (loggedAt != null) 'loggedAt': loggedAt?.toJson(),
      'level': level,
      if (tag != null) 'tag': tag,
      'message': message,
      if (stacktrace != null) 'stacktrace': stacktrace,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static DeviceLogInclude include({_ilo09f9g.DeviceInclude? device}) {
    return DeviceLogInclude._(device: device);
  }

  static DeviceLogIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceLogTable>? orderBy,
    _is.OrderByListBuilder<DeviceLogTable>? orderByList,
    DeviceLogInclude? include,
  }) {
    return DeviceLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceLog.t),
      orderByList: orderByList?.call(DeviceLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceLog$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceLog$device();
}

class _DeviceLogImpl extends DeviceLog {
  _DeviceLogImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    String? entryUuid,
    String? sessionId,
    DateTime? loggedAt,
    int? level,
    String? tag,
    required String message,
    String? stacktrace,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         entryUuid: entryUuid,
         sessionId: sessionId,
         loggedAt: loggedAt,
         level: level,
         tag: tag,
         message: message,
         stacktrace: stacktrace,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceLog copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceLog$device(),
    Object? entryUuid = _Undefined,
    Object? sessionId = _Undefined,
    DateTime? loggedAt = const _is.$UndefinedDateTime(),
    int? level,
    Object? tag = _Undefined,
    String? message,
    Object? stacktrace = _Undefined,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return DeviceLog(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      entryUuid: entryUuid is String? ? entryUuid : this.entryUuid,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      loggedAt: loggedAt is _is.UndefinedSentinel ? this.loggedAt : loggedAt,
      level: level ?? this.level,
      tag: tag is String? ? tag : this.tag,
      message: message ?? this.message,
      stacktrace: stacktrace is String? ? stacktrace : this.stacktrace,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class DeviceLogUpdateTable extends _is.UpdateTable<DeviceLogTable> {
  DeviceLogUpdateTable(super.table);

  _is.ColumnValue<int, int> deviceId(int value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<String, String> entryUuid(String? value) => _is.ColumnValue(
    table.entryUuid,
    value,
  );

  _is.ColumnValue<String, String> sessionId(String? value) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> loggedAt(DateTime? value) =>
      _is.ColumnValue(
        table.loggedAt,
        value,
      );

  _is.ColumnValue<int, int> level(int value) => _is.ColumnValue(
    table.level,
    value,
  );

  _is.ColumnValue<String, String> tag(String? value) => _is.ColumnValue(
    table.tag,
    value,
  );

  _is.ColumnValue<String, String> message(String value) => _is.ColumnValue(
    table.message,
    value,
  );

  _is.ColumnValue<String, String> stacktrace(String? value) => _is.ColumnValue(
    table.stacktrace,
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

class DeviceLogTable extends _is.Table<int?> {
  DeviceLogTable({super.tableRelation}) : super(tableName: 'device_logs') {
    updateTable = DeviceLogUpdateTable(this);
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    entryUuid = _is.ColumnString(
      'entryUuid',
      this,
    );
    sessionId = _is.ColumnString(
      'sessionId',
      this,
    );
    loggedAt = _is.ColumnDateTime(
      'loggedAt',
      this,
    );
    level = _is.ColumnInt(
      'level',
      this,
    );
    tag = _is.ColumnString(
      'tag',
      this,
    );
    message = _is.ColumnString(
      'message',
      this,
    );
    stacktrace = _is.ColumnString(
      'stacktrace',
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

  late final DeviceLogUpdateTable updateTable;

  late final _is.ColumnInt deviceId;

  _ilo09f9g.DeviceTable? _device;

  late final _is.ColumnString entryUuid;

  late final _is.ColumnString sessionId;

  late final _is.ColumnDateTime loggedAt;

  late final _is.ColumnInt level;

  late final _is.ColumnString tag;

  late final _is.ColumnString message;

  late final _is.ColumnString stacktrace;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: DeviceLog.t.deviceId,
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
    entryUuid,
    sessionId,
    loggedAt,
    level,
    tag,
    message,
    stacktrace,
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

class DeviceLogInclude extends _is.IncludeObject {
  DeviceLogInclude._({_ilo09f9g.DeviceInclude? device}) {
    _device = device;
  }

  _ilo09f9g.DeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {'device': _device};

  @override
  _is.Table<int?> get table => DeviceLog.t;
}

class DeviceLogIncludeList extends _is.IncludeList {
  DeviceLogIncludeList._({
    _is.WhereExpressionBuilder<DeviceLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceLog.t;
}

class DeviceLogRepository {
  const DeviceLogRepository._();

  final attachRow = const DeviceLogAttachRowRepository._();

  /// Returns a list of [DeviceLog]s matching the given query parameters.
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
  Future<List<DeviceLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceLogTable>? orderBy,
    _is.OrderByListBuilder<DeviceLogTable>? orderByList,
    _is.Transaction? transaction,
    DeviceLogInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceLog>(
      where: where?.call(DeviceLog.t),
      orderBy: orderBy?.call(DeviceLog.t),
      orderByList: orderByList?.call(DeviceLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceLog]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeviceLog.t`.
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
  _ida.Stream<List<DeviceLog>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceLogTable>? orderBy,
    _is.OrderByListBuilder<DeviceLogTable>? orderByList,
    DeviceLogInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceLog>(
      where: where?.call(DeviceLog.t),
      orderBy: orderBy?.call(DeviceLog.t),
      orderByList: orderByList?.call(DeviceLog.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceLog] matching the given query parameters.
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
  Future<DeviceLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceLogTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceLogTable>? orderBy,
    _is.OrderByListBuilder<DeviceLogTable>? orderByList,
    _is.Transaction? transaction,
    DeviceLogInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceLog>(
      where: where?.call(DeviceLog.t),
      orderBy: orderBy?.call(DeviceLog.t),
      orderByList: orderByList?.call(DeviceLog.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceLog] by its [id] or null if no such row exists.
  Future<DeviceLog?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceLogInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceLog>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceLog]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceLog]s will have their `id` fields set.
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
  Future<List<DeviceLog>> insert(
    _is.DatabaseSession session,
    List<DeviceLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceLog] and returns the inserted row.
  ///
  /// The returned [DeviceLog] will have its `id` field set.
  Future<DeviceLog> insertRow(
    _is.DatabaseSession session,
    DeviceLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceLog]s in the list and returns the resulting rows.
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
  /// The returned [DeviceLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceLog>> upsert(
    _is.DatabaseSession session,
    List<DeviceLog> rows, {
    required _is.ColumnSelections<DeviceLogTable> conflictColumns,
    _is.ColumnSelections<DeviceLogTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceLog>(
      rows,
      conflictColumns: conflictColumns(DeviceLog.t),
      updateColumns: updateColumns?.call(DeviceLog.t),
      updateWhere: updateWhere?.call(DeviceLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceLog] and returns the resulting row.
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
  /// The returned [DeviceLog] will have its `id` field set.
  Future<DeviceLog?> upsertRow(
    _is.DatabaseSession session,
    DeviceLog row, {
    required _is.ColumnSelections<DeviceLogTable> conflictColumns,
    _is.ColumnSelections<DeviceLogTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceLog>(
      row,
      conflictColumns: conflictColumns(DeviceLog.t),
      updateColumns: updateColumns?.call(DeviceLog.t),
      updateWhere: updateWhere?.call(DeviceLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceLog>> update(
    _is.DatabaseSession session,
    List<DeviceLog> rows, {
    _is.ColumnSelections<DeviceLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceLog>(
      rows,
      columns: columns?.call(DeviceLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceLog> updateRow(
    _is.DatabaseSession session,
    DeviceLog row, {
    _is.ColumnSelections<DeviceLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceLog>(
      row,
      columns: columns?.call(DeviceLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceLog?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceLogUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceLog>(
      id,
      columnValues: columnValues(DeviceLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceLogUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DeviceLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceLogTable>? orderBy,
    _is.OrderByListBuilder<DeviceLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceLog>(
      columnValues: columnValues(DeviceLog.t.updateTable),
      where: where(DeviceLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceLog.t),
      orderByList: orderByList?.call(DeviceLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceLog]s in the list and returns the deleted rows.
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
  Future<List<DeviceLog>> delete(
    _is.DatabaseSession session,
    List<DeviceLog> rows, {
    _is.OrderByBuilder<DeviceLogTable>? orderBy,
    _is.OrderByListBuilder<DeviceLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceLog>(
      rows,
      orderBy: orderBy?.call(DeviceLog.t),
      orderByList: orderByList?.call(DeviceLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceLog].
  Future<DeviceLog> deleteRow(
    _is.DatabaseSession session,
    DeviceLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceLog>(
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
  Future<List<DeviceLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceLogTable> where,
    _is.OrderByBuilder<DeviceLogTable>? orderBy,
    _is.OrderByListBuilder<DeviceLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceLog>(
      where: where(DeviceLog.t),
      orderBy: orderBy?.call(DeviceLog.t),
      orderByList: orderByList?.call(DeviceLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceLog>(
      where: where?.call(DeviceLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceLog>(
      where: where(DeviceLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceLogAttachRowRepository {
  const DeviceLogAttachRowRepository._();

  /// Creates a relation between the given [DeviceLog] and [Device]
  /// by setting the [DeviceLog]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    DeviceLog deviceLog,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (deviceLog.id == null) {
      throw ArgumentError.notNull('deviceLog.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $deviceLog = deviceLog.copyWith(deviceId: device.id);
    await session.db.updateRow<DeviceLog>(
      $deviceLog,
      columns: [DeviceLog.t.deviceId],
      transaction: transaction,
    );
  }
}
