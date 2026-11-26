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

abstract class DeviceReport
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceReport._({
    this.id,
    required this.deviceId,
    this.device,
    required this.type,
    required this.payload,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceReport({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String type,
    required String payload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceReportImpl;

  factory DeviceReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceReport(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      type: jsonSerialization['type'] as String,
      payload: jsonSerialization['payload'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeviceReportTable();

  static const db = DeviceReportRepository._();

  @override
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  /// Stored as a raw string because the value set is open: administrators can
  /// define arbitrary report types via the `send_report` action, so a typed enum
  /// would fail to deserialize unknown values. The module `DeviceReportType`
  /// enum remains the typed contract for known types.
  String type;

  /// JSON report payload.
  String payload;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceReport copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceReport$device(),
    String? type,
    String? payload,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceReport',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'type': type,
      'payload': payload,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceReport',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'type': type,
      'payload': payload,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static DeviceReportInclude include({_ilo09f9g.DeviceInclude? device}) {
    return DeviceReportInclude._(device: device);
  }

  static DeviceReportIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceReportTable>? orderBy,
    _is.OrderByListBuilder<DeviceReportTable>? orderByList,
    DeviceReportInclude? include,
  }) {
    return DeviceReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceReport.t),
      orderByList: orderByList?.call(DeviceReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceReport$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceReport$device();
}

class _DeviceReportImpl extends DeviceReport {
  _DeviceReportImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String type,
    required String payload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         type: type,
         payload: payload,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceReport copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceReport$device(),
    String? type,
    String? payload,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return DeviceReport(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class DeviceReportUpdateTable extends _is.UpdateTable<DeviceReportTable> {
  DeviceReportUpdateTable(super.table);

  _is.ColumnValue<int, int> deviceId(int value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<String, String> type(String value) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<String, String> payload(String value) => _is.ColumnValue(
    table.payload,
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

class DeviceReportTable extends _is.Table<int?> {
  DeviceReportTable({super.tableRelation})
    : super(tableName: 'device_reports') {
    updateTable = DeviceReportUpdateTable(this);
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    type = _is.ColumnString(
      'type',
      this,
    );
    payload = _is.ColumnString(
      'payload',
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

  late final DeviceReportUpdateTable updateTable;

  late final _is.ColumnInt deviceId;

  _ilo09f9g.DeviceTable? _device;

  /// Stored as a raw string because the value set is open: administrators can
  /// define arbitrary report types via the `send_report` action, so a typed enum
  /// would fail to deserialize unknown values. The module `DeviceReportType`
  /// enum remains the typed contract for known types.
  late final _is.ColumnString type;

  /// JSON report payload.
  late final _is.ColumnString payload;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: DeviceReport.t.deviceId,
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
    type,
    payload,
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

class DeviceReportInclude extends _is.IncludeObject {
  DeviceReportInclude._({_ilo09f9g.DeviceInclude? device}) {
    _device = device;
  }

  _ilo09f9g.DeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {'device': _device};

  @override
  _is.Table<int?> get table => DeviceReport.t;
}

class DeviceReportIncludeList extends _is.IncludeList {
  DeviceReportIncludeList._({
    _is.WhereExpressionBuilder<DeviceReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceReport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceReport.t;
}

class DeviceReportRepository {
  const DeviceReportRepository._();

  final attachRow = const DeviceReportAttachRowRepository._();

  /// Returns a list of [DeviceReport]s matching the given query parameters.
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
  Future<List<DeviceReport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceReportTable>? orderBy,
    _is.OrderByListBuilder<DeviceReportTable>? orderByList,
    _is.Transaction? transaction,
    DeviceReportInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceReport>(
      where: where?.call(DeviceReport.t),
      orderBy: orderBy?.call(DeviceReport.t),
      orderByList: orderByList?.call(DeviceReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceReport]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeviceReport.t`.
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
  _ida.Stream<List<DeviceReport>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceReportTable>? orderBy,
    _is.OrderByListBuilder<DeviceReportTable>? orderByList,
    DeviceReportInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceReport>(
      where: where?.call(DeviceReport.t),
      orderBy: orderBy?.call(DeviceReport.t),
      orderByList: orderByList?.call(DeviceReport.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceReport] matching the given query parameters.
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
  Future<DeviceReport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceReportTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceReportTable>? orderBy,
    _is.OrderByListBuilder<DeviceReportTable>? orderByList,
    _is.Transaction? transaction,
    DeviceReportInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceReport>(
      where: where?.call(DeviceReport.t),
      orderBy: orderBy?.call(DeviceReport.t),
      orderByList: orderByList?.call(DeviceReport.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceReport] by its [id] or null if no such row exists.
  Future<DeviceReport?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceReportInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceReport>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceReport]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceReport]s will have their `id` fields set.
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
  Future<List<DeviceReport>> insert(
    _is.DatabaseSession session,
    List<DeviceReport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceReport] and returns the inserted row.
  ///
  /// The returned [DeviceReport] will have its `id` field set.
  Future<DeviceReport> insertRow(
    _is.DatabaseSession session,
    DeviceReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceReport]s in the list and returns the resulting rows.
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
  /// The returned [DeviceReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceReport>> upsert(
    _is.DatabaseSession session,
    List<DeviceReport> rows, {
    required _is.ColumnSelections<DeviceReportTable> conflictColumns,
    _is.ColumnSelections<DeviceReportTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceReportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceReport>(
      rows,
      conflictColumns: conflictColumns(DeviceReport.t),
      updateColumns: updateColumns?.call(DeviceReport.t),
      updateWhere: updateWhere?.call(DeviceReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceReport] and returns the resulting row.
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
  /// The returned [DeviceReport] will have its `id` field set.
  Future<DeviceReport?> upsertRow(
    _is.DatabaseSession session,
    DeviceReport row, {
    required _is.ColumnSelections<DeviceReportTable> conflictColumns,
    _is.ColumnSelections<DeviceReportTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceReportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceReport>(
      row,
      conflictColumns: conflictColumns(DeviceReport.t),
      updateColumns: updateColumns?.call(DeviceReport.t),
      updateWhere: updateWhere?.call(DeviceReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceReport>> update(
    _is.DatabaseSession session,
    List<DeviceReport> rows, {
    _is.ColumnSelections<DeviceReportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceReport>(
      rows,
      columns: columns?.call(DeviceReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceReport> updateRow(
    _is.DatabaseSession session,
    DeviceReport row, {
    _is.ColumnSelections<DeviceReportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceReport>(
      row,
      columns: columns?.call(DeviceReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceReport?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceReportUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceReport>(
      id,
      columnValues: columnValues(DeviceReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceReport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceReportUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DeviceReportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceReportTable>? orderBy,
    _is.OrderByListBuilder<DeviceReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceReport>(
      columnValues: columnValues(DeviceReport.t.updateTable),
      where: where(DeviceReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceReport.t),
      orderByList: orderByList?.call(DeviceReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceReport]s in the list and returns the deleted rows.
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
  Future<List<DeviceReport>> delete(
    _is.DatabaseSession session,
    List<DeviceReport> rows, {
    _is.OrderByBuilder<DeviceReportTable>? orderBy,
    _is.OrderByListBuilder<DeviceReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceReport>(
      rows,
      orderBy: orderBy?.call(DeviceReport.t),
      orderByList: orderByList?.call(DeviceReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceReport].
  Future<DeviceReport> deleteRow(
    _is.DatabaseSession session,
    DeviceReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceReport>(
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
  Future<List<DeviceReport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceReportTable> where,
    _is.OrderByBuilder<DeviceReportTable>? orderBy,
    _is.OrderByListBuilder<DeviceReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceReport>(
      where: where(DeviceReport.t),
      orderBy: orderBy?.call(DeviceReport.t),
      orderByList: orderByList?.call(DeviceReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceReportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceReport>(
      where: where?.call(DeviceReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceReport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceReportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceReport>(
      where: where(DeviceReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceReportAttachRowRepository {
  const DeviceReportAttachRowRepository._();

  /// Creates a relation between the given [DeviceReport] and [Device]
  /// by setting the [DeviceReport]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    DeviceReport deviceReport,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (deviceReport.id == null) {
      throw ArgumentError.notNull('deviceReport.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $deviceReport = deviceReport.copyWith(deviceId: device.id);
    await session.db.updateRow<DeviceReport>(
      $deviceReport,
      columns: [DeviceReport.t.deviceId],
      transaction: transaction,
    );
  }
}
