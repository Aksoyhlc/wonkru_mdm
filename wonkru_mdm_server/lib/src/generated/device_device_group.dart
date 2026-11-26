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
import 'device_group.dart' as _i94jjjz5;

abstract class DeviceDeviceGroup
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceDeviceGroup._({
    this.id,
    required this.deviceId,
    this.device,
    required this.deviceGroupId,
    this.deviceGroup,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceDeviceGroup({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required int deviceGroupId,
    _i94jjjz5.DeviceGroup? deviceGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceDeviceGroupImpl;

  factory DeviceDeviceGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceDeviceGroup(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      deviceGroupId: jsonSerialization['deviceGroupId'] as int,
      deviceGroup: jsonSerialization['deviceGroup'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_i94jjjz5.DeviceGroup>(
              jsonSerialization['deviceGroup'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeviceDeviceGroupTable();

  static const db = DeviceDeviceGroupRepository._();

  @override
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  int deviceGroupId;

  _i94jjjz5.DeviceGroup? deviceGroup;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceDeviceGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceDeviceGroup copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceDeviceGroup$device(),
    int? deviceGroupId,
    _i94jjjz5.DeviceGroup? deviceGroup =
        const _UndefinedDeviceDeviceGroup$deviceGroup(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceDeviceGroup',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'deviceGroupId': deviceGroupId,
      if (deviceGroup != null) 'deviceGroup': deviceGroup?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceDeviceGroup',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'deviceGroupId': deviceGroupId,
      if (deviceGroup != null) 'deviceGroup': deviceGroup?.toJsonForProtocol(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static DeviceDeviceGroupInclude include({
    _ilo09f9g.DeviceInclude? device,
    _i94jjjz5.DeviceGroupInclude? deviceGroup,
  }) {
    return DeviceDeviceGroupInclude._(
      device: device,
      deviceGroup: deviceGroup,
    );
  }

  static DeviceDeviceGroupIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceDeviceGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceDeviceGroupTable>? orderBy,
    _is.OrderByListBuilder<DeviceDeviceGroupTable>? orderByList,
    DeviceDeviceGroupInclude? include,
  }) {
    return DeviceDeviceGroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceDeviceGroup.t),
      orderByList: orderByList?.call(DeviceDeviceGroup.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceDeviceGroup$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceDeviceGroup$device();
}

class _UndefinedDeviceDeviceGroup$deviceGroup extends _is.UndefinedSentinel
    implements _i94jjjz5.DeviceGroup {
  const _UndefinedDeviceDeviceGroup$deviceGroup();
}

class _DeviceDeviceGroupImpl extends DeviceDeviceGroup {
  _DeviceDeviceGroupImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required int deviceGroupId,
    _i94jjjz5.DeviceGroup? deviceGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         deviceGroupId: deviceGroupId,
         deviceGroup: deviceGroup,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceDeviceGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceDeviceGroup copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceDeviceGroup$device(),
    int? deviceGroupId,
    _i94jjjz5.DeviceGroup? deviceGroup =
        const _UndefinedDeviceDeviceGroup$deviceGroup(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return DeviceDeviceGroup(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      deviceGroupId: deviceGroupId ?? this.deviceGroupId,
      deviceGroup: deviceGroup is _is.UndefinedSentinel
          ? this.deviceGroup?.copyWith()
          : deviceGroup,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class DeviceDeviceGroupUpdateTable
    extends _is.UpdateTable<DeviceDeviceGroupTable> {
  DeviceDeviceGroupUpdateTable(super.table);

  _is.ColumnValue<int, int> deviceId(int value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<int, int> deviceGroupId(int value) => _is.ColumnValue(
    table.deviceGroupId,
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

class DeviceDeviceGroupTable extends _is.Table<int?> {
  DeviceDeviceGroupTable({super.tableRelation})
    : super(tableName: 'device_device_group') {
    updateTable = DeviceDeviceGroupUpdateTable(this);
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    deviceGroupId = _is.ColumnInt(
      'deviceGroupId',
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

  late final DeviceDeviceGroupUpdateTable updateTable;

  late final _is.ColumnInt deviceId;

  _ilo09f9g.DeviceTable? _device;

  late final _is.ColumnInt deviceGroupId;

  _i94jjjz5.DeviceGroupTable? _deviceGroup;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: DeviceDeviceGroup.t.deviceId,
      foreignField: _ilo09f9g.Device.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ilo09f9g.DeviceTable(tableRelation: foreignTableRelation),
    );
    return _device!;
  }

  _i94jjjz5.DeviceGroupTable get deviceGroup {
    if (_deviceGroup != null) return _deviceGroup!;
    _deviceGroup = _is.createRelationTable(
      relationFieldName: 'deviceGroup',
      field: DeviceDeviceGroup.t.deviceGroupId,
      foreignField: _i94jjjz5.DeviceGroup.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i94jjjz5.DeviceGroupTable(tableRelation: foreignTableRelation),
    );
    return _deviceGroup!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    deviceId,
    deviceGroupId,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'device') {
      return device;
    }
    if (relationField == 'deviceGroup') {
      return deviceGroup;
    }
    return null;
  }
}

class DeviceDeviceGroupInclude extends _is.IncludeObject {
  DeviceDeviceGroupInclude._({
    _ilo09f9g.DeviceInclude? device,
    _i94jjjz5.DeviceGroupInclude? deviceGroup,
  }) {
    _device = device;
    _deviceGroup = deviceGroup;
  }

  _ilo09f9g.DeviceInclude? _device;

  _i94jjjz5.DeviceGroupInclude? _deviceGroup;

  @override
  Map<String, _is.Include?> get includes => {
    'device': _device,
    'deviceGroup': _deviceGroup,
  };

  @override
  _is.Table<int?> get table => DeviceDeviceGroup.t;
}

class DeviceDeviceGroupIncludeList extends _is.IncludeList {
  DeviceDeviceGroupIncludeList._({
    _is.WhereExpressionBuilder<DeviceDeviceGroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceDeviceGroup.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceDeviceGroup.t;
}

class DeviceDeviceGroupRepository {
  const DeviceDeviceGroupRepository._();

  final attachRow = const DeviceDeviceGroupAttachRowRepository._();

  /// Returns a list of [DeviceDeviceGroup]s matching the given query parameters.
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
  Future<List<DeviceDeviceGroup>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceDeviceGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceDeviceGroupTable>? orderBy,
    _is.OrderByListBuilder<DeviceDeviceGroupTable>? orderByList,
    _is.Transaction? transaction,
    DeviceDeviceGroupInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceDeviceGroup>(
      where: where?.call(DeviceDeviceGroup.t),
      orderBy: orderBy?.call(DeviceDeviceGroup.t),
      orderByList: orderByList?.call(DeviceDeviceGroup.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceDeviceGroup]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeviceDeviceGroup.t`.
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
  _ida.Stream<List<DeviceDeviceGroup>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceDeviceGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceDeviceGroupTable>? orderBy,
    _is.OrderByListBuilder<DeviceDeviceGroupTable>? orderByList,
    DeviceDeviceGroupInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceDeviceGroup>(
      where: where?.call(DeviceDeviceGroup.t),
      orderBy: orderBy?.call(DeviceDeviceGroup.t),
      orderByList: orderByList?.call(DeviceDeviceGroup.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceDeviceGroup] matching the given query parameters.
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
  Future<DeviceDeviceGroup?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceDeviceGroupTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceDeviceGroupTable>? orderBy,
    _is.OrderByListBuilder<DeviceDeviceGroupTable>? orderByList,
    _is.Transaction? transaction,
    DeviceDeviceGroupInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceDeviceGroup>(
      where: where?.call(DeviceDeviceGroup.t),
      orderBy: orderBy?.call(DeviceDeviceGroup.t),
      orderByList: orderByList?.call(DeviceDeviceGroup.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceDeviceGroup] by its [id] or null if no such row exists.
  Future<DeviceDeviceGroup?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceDeviceGroupInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceDeviceGroup>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceDeviceGroup]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceDeviceGroup]s will have their `id` fields set.
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
  Future<List<DeviceDeviceGroup>> insert(
    _is.DatabaseSession session,
    List<DeviceDeviceGroup> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceDeviceGroup>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceDeviceGroup] and returns the inserted row.
  ///
  /// The returned [DeviceDeviceGroup] will have its `id` field set.
  Future<DeviceDeviceGroup> insertRow(
    _is.DatabaseSession session,
    DeviceDeviceGroup row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceDeviceGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceDeviceGroup]s in the list and returns the resulting rows.
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
  /// The returned [DeviceDeviceGroup]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceDeviceGroup>> upsert(
    _is.DatabaseSession session,
    List<DeviceDeviceGroup> rows, {
    required _is.ColumnSelections<DeviceDeviceGroupTable> conflictColumns,
    _is.ColumnSelections<DeviceDeviceGroupTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceDeviceGroupTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceDeviceGroup>(
      rows,
      conflictColumns: conflictColumns(DeviceDeviceGroup.t),
      updateColumns: updateColumns?.call(DeviceDeviceGroup.t),
      updateWhere: updateWhere?.call(DeviceDeviceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceDeviceGroup] and returns the resulting row.
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
  /// The returned [DeviceDeviceGroup] will have its `id` field set.
  Future<DeviceDeviceGroup?> upsertRow(
    _is.DatabaseSession session,
    DeviceDeviceGroup row, {
    required _is.ColumnSelections<DeviceDeviceGroupTable> conflictColumns,
    _is.ColumnSelections<DeviceDeviceGroupTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceDeviceGroupTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceDeviceGroup>(
      row,
      conflictColumns: conflictColumns(DeviceDeviceGroup.t),
      updateColumns: updateColumns?.call(DeviceDeviceGroup.t),
      updateWhere: updateWhere?.call(DeviceDeviceGroup.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceDeviceGroup]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceDeviceGroup>> update(
    _is.DatabaseSession session,
    List<DeviceDeviceGroup> rows, {
    _is.ColumnSelections<DeviceDeviceGroupTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceDeviceGroup>(
      rows,
      columns: columns?.call(DeviceDeviceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceDeviceGroup]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceDeviceGroup> updateRow(
    _is.DatabaseSession session,
    DeviceDeviceGroup row, {
    _is.ColumnSelections<DeviceDeviceGroupTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceDeviceGroup>(
      row,
      columns: columns?.call(DeviceDeviceGroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceDeviceGroup] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceDeviceGroup?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceDeviceGroupUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceDeviceGroup>(
      id,
      columnValues: columnValues(DeviceDeviceGroup.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceDeviceGroup]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceDeviceGroup>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceDeviceGroupUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DeviceDeviceGroupTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceDeviceGroupTable>? orderBy,
    _is.OrderByListBuilder<DeviceDeviceGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceDeviceGroup>(
      columnValues: columnValues(DeviceDeviceGroup.t.updateTable),
      where: where(DeviceDeviceGroup.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceDeviceGroup.t),
      orderByList: orderByList?.call(DeviceDeviceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceDeviceGroup]s in the list and returns the deleted rows.
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
  Future<List<DeviceDeviceGroup>> delete(
    _is.DatabaseSession session,
    List<DeviceDeviceGroup> rows, {
    _is.OrderByBuilder<DeviceDeviceGroupTable>? orderBy,
    _is.OrderByListBuilder<DeviceDeviceGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceDeviceGroup>(
      rows,
      orderBy: orderBy?.call(DeviceDeviceGroup.t),
      orderByList: orderByList?.call(DeviceDeviceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceDeviceGroup].
  Future<DeviceDeviceGroup> deleteRow(
    _is.DatabaseSession session,
    DeviceDeviceGroup row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceDeviceGroup>(
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
  Future<List<DeviceDeviceGroup>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceDeviceGroupTable> where,
    _is.OrderByBuilder<DeviceDeviceGroupTable>? orderBy,
    _is.OrderByListBuilder<DeviceDeviceGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceDeviceGroup>(
      where: where(DeviceDeviceGroup.t),
      orderBy: orderBy?.call(DeviceDeviceGroup.t),
      orderByList: orderByList?.call(DeviceDeviceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceDeviceGroupTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceDeviceGroup>(
      where: where?.call(DeviceDeviceGroup.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceDeviceGroup] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceDeviceGroupTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceDeviceGroup>(
      where: where(DeviceDeviceGroup.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceDeviceGroupAttachRowRepository {
  const DeviceDeviceGroupAttachRowRepository._();

  /// Creates a relation between the given [DeviceDeviceGroup] and [Device]
  /// by setting the [DeviceDeviceGroup]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    DeviceDeviceGroup deviceDeviceGroup,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (deviceDeviceGroup.id == null) {
      throw ArgumentError.notNull('deviceDeviceGroup.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $deviceDeviceGroup = deviceDeviceGroup.copyWith(deviceId: device.id);
    await session.db.updateRow<DeviceDeviceGroup>(
      $deviceDeviceGroup,
      columns: [DeviceDeviceGroup.t.deviceId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [DeviceDeviceGroup] and [DeviceGroup]
  /// by setting the [DeviceDeviceGroup]'s foreign key `deviceGroupId` to refer to the [DeviceGroup].
  Future<void> deviceGroup(
    _is.DatabaseSession session,
    DeviceDeviceGroup deviceDeviceGroup,
    _i94jjjz5.DeviceGroup deviceGroup, {
    _is.Transaction? transaction,
  }) async {
    if (deviceDeviceGroup.id == null) {
      throw ArgumentError.notNull('deviceDeviceGroup.id');
    }
    if (deviceGroup.id == null) {
      throw ArgumentError.notNull('deviceGroup.id');
    }

    var $deviceDeviceGroup = deviceDeviceGroup.copyWith(
      deviceGroupId: deviceGroup.id,
    );
    await session.db.updateRow<DeviceDeviceGroup>(
      $deviceDeviceGroup,
      columns: [DeviceDeviceGroup.t.deviceGroupId],
      transaction: transaction,
    );
  }
}
