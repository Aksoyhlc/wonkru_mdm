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
import 'package:wonkru_core_server/wonkru_core_server.dart' as _i3xu12wm;
import 'package:wonkru_mdm_server/src/generated/protocol.dart' as _ij1wyujj;
import 'device.dart' as _ilo09f9g;

/// A durable command queued for a device.
///
/// Commands are written as `pending` and pushed over the device stream when the
/// device is connected. Every row carries a `commandId` the agent echoes back
/// in its `ack`, so delivery is at-least-once and idempotent.
abstract class DeviceCommand
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceCommand._({
    this.id,
    required this.deviceId,
    this.device,
    required this.commandId,
    this.bulkId,
    required this.action,
    this.params,
    required this.status,
    int? attempts,
    this.response,
    this.createdAt,
    this.sentAt,
    this.ackedAt,
  }) : attempts = attempts ?? 0;

  factory DeviceCommand({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String commandId,
    String? bulkId,
    required _i3xu12wm.DeviceAction action,
    String? params,
    required _i3xu12wm.DeviceCommandStatus status,
    int? attempts,
    String? response,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? ackedAt,
  }) = _DeviceCommandImpl;

  factory DeviceCommand.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceCommand(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      commandId: jsonSerialization['commandId'] as String,
      bulkId: jsonSerialization['bulkId'] as String?,
      action: _i3xu12wm.DeviceAction.fromJson(
        (jsonSerialization['action'] as String),
      ),
      params: jsonSerialization['params'] as String?,
      status: _i3xu12wm.DeviceCommandStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      attempts: jsonSerialization['attempts'] as int?,
      response: jsonSerialization['response'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      ackedAt: jsonSerialization['ackedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['ackedAt']),
    );
  }

  static final t = DeviceCommandTable();

  static const db = DeviceCommandRepository._();

  @override
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  String commandId;

  /// Bulk-send id; null for single-device commands.
  String? bulkId;

  _i3xu12wm.DeviceAction action;

  /// JSON object with the action parameters.
  String? params;

  /// Delivery state: `pending`, `sent`, `acked`, `timeout` or `error`.
  _i3xu12wm.DeviceCommandStatus status;

  int attempts;

  /// JSON response returned with the ack.
  String? response;

  DateTime? createdAt;

  DateTime? sentAt;

  DateTime? ackedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceCommand]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceCommand copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceCommand$device(),
    String? commandId,
    String? bulkId,
    _i3xu12wm.DeviceAction? action,
    String? params,
    _i3xu12wm.DeviceCommandStatus? status,
    int? attempts,
    String? response,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? sentAt = const _is.$UndefinedDateTime(),
    DateTime? ackedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceCommand',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'commandId': commandId,
      if (bulkId != null) 'bulkId': bulkId,
      'action': action.toJson(),
      if (params != null) 'params': params,
      'status': status.toJson(),
      'attempts': attempts,
      if (response != null) 'response': response,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (ackedAt != null) 'ackedAt': ackedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceCommand',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'commandId': commandId,
      if (bulkId != null) 'bulkId': bulkId,
      'action': action.toJson(),
      if (params != null) 'params': params,
      'status': status.toJson(),
      'attempts': attempts,
      if (response != null) 'response': response,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (ackedAt != null) 'ackedAt': ackedAt?.toJson(),
    };
  }

  static DeviceCommandInclude include({_ilo09f9g.DeviceInclude? device}) {
    return DeviceCommandInclude._(device: device);
  }

  static DeviceCommandIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceCommandTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceCommandTable>? orderBy,
    _is.OrderByListBuilder<DeviceCommandTable>? orderByList,
    DeviceCommandInclude? include,
  }) {
    return DeviceCommandIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceCommand.t),
      orderByList: orderByList?.call(DeviceCommand.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceCommand$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceCommand$device();
}

class _DeviceCommandImpl extends DeviceCommand {
  _DeviceCommandImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String commandId,
    String? bulkId,
    required _i3xu12wm.DeviceAction action,
    String? params,
    required _i3xu12wm.DeviceCommandStatus status,
    int? attempts,
    String? response,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? ackedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         commandId: commandId,
         bulkId: bulkId,
         action: action,
         params: params,
         status: status,
         attempts: attempts,
         response: response,
         createdAt: createdAt,
         sentAt: sentAt,
         ackedAt: ackedAt,
       );

  /// Returns a shallow copy of this [DeviceCommand]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceCommand copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceCommand$device(),
    String? commandId,
    Object? bulkId = _Undefined,
    _i3xu12wm.DeviceAction? action,
    Object? params = _Undefined,
    _i3xu12wm.DeviceCommandStatus? status,
    int? attempts,
    Object? response = _Undefined,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? sentAt = const _is.$UndefinedDateTime(),
    DateTime? ackedAt = const _is.$UndefinedDateTime(),
  }) {
    return DeviceCommand(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      commandId: commandId ?? this.commandId,
      bulkId: bulkId is String? ? bulkId : this.bulkId,
      action: action ?? this.action,
      params: params is String? ? params : this.params,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      response: response is String? ? response : this.response,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      sentAt: sentAt is _is.UndefinedSentinel ? this.sentAt : sentAt,
      ackedAt: ackedAt is _is.UndefinedSentinel ? this.ackedAt : ackedAt,
    );
  }
}

class DeviceCommandUpdateTable extends _is.UpdateTable<DeviceCommandTable> {
  DeviceCommandUpdateTable(super.table);

  _is.ColumnValue<int, int> deviceId(int value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<String, String> commandId(String value) => _is.ColumnValue(
    table.commandId,
    value,
  );

  _is.ColumnValue<String, String> bulkId(String? value) => _is.ColumnValue(
    table.bulkId,
    value,
  );

  _is.ColumnValue<_i3xu12wm.DeviceAction, _i3xu12wm.DeviceAction> action(
    _i3xu12wm.DeviceAction value,
  ) => _is.ColumnValue(
    table.action,
    value,
  );

  _is.ColumnValue<String, String> params(String? value) => _is.ColumnValue(
    table.params,
    value,
  );

  _is.ColumnValue<_i3xu12wm.DeviceCommandStatus, _i3xu12wm.DeviceCommandStatus>
  status(_i3xu12wm.DeviceCommandStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<String, String> response(String? value) => _is.ColumnValue(
    table.response,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> sentAt(DateTime? value) =>
      _is.ColumnValue(
        table.sentAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> ackedAt(DateTime? value) =>
      _is.ColumnValue(
        table.ackedAt,
        value,
      );
}

class DeviceCommandTable extends _is.Table<int?> {
  DeviceCommandTable({super.tableRelation})
    : super(tableName: 'device_commands') {
    updateTable = DeviceCommandUpdateTable(this);
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    commandId = _is.ColumnString(
      'commandId',
      this,
    );
    bulkId = _is.ColumnString(
      'bulkId',
      this,
    );
    action = _is.ColumnEnum(
      'action',
      this,
      _is.EnumSerialization.byName,
    );
    params = _is.ColumnString(
      'params',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
    );
    response = _is.ColumnString(
      'response',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    sentAt = _is.ColumnDateTime(
      'sentAt',
      this,
    );
    ackedAt = _is.ColumnDateTime(
      'ackedAt',
      this,
    );
  }

  late final DeviceCommandUpdateTable updateTable;

  late final _is.ColumnInt deviceId;

  _ilo09f9g.DeviceTable? _device;

  late final _is.ColumnString commandId;

  /// Bulk-send id; null for single-device commands.
  late final _is.ColumnString bulkId;

  late final _is.ColumnEnum<_i3xu12wm.DeviceAction> action;

  /// JSON object with the action parameters.
  late final _is.ColumnString params;

  /// Delivery state: `pending`, `sent`, `acked`, `timeout` or `error`.
  late final _is.ColumnEnum<_i3xu12wm.DeviceCommandStatus> status;

  late final _is.ColumnInt attempts;

  /// JSON response returned with the ack.
  late final _is.ColumnString response;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime sentAt;

  late final _is.ColumnDateTime ackedAt;

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: DeviceCommand.t.deviceId,
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
    commandId,
    bulkId,
    action,
    params,
    status,
    attempts,
    response,
    createdAt,
    sentAt,
    ackedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'device') {
      return device;
    }
    return null;
  }
}

class DeviceCommandInclude extends _is.IncludeObject {
  DeviceCommandInclude._({_ilo09f9g.DeviceInclude? device}) {
    _device = device;
  }

  _ilo09f9g.DeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {'device': _device};

  @override
  _is.Table<int?> get table => DeviceCommand.t;
}

class DeviceCommandIncludeList extends _is.IncludeList {
  DeviceCommandIncludeList._({
    _is.WhereExpressionBuilder<DeviceCommandTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceCommand.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceCommand.t;
}

class DeviceCommandRepository {
  const DeviceCommandRepository._();

  final attachRow = const DeviceCommandAttachRowRepository._();

  /// Returns a list of [DeviceCommand]s matching the given query parameters.
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
  Future<List<DeviceCommand>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceCommandTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceCommandTable>? orderBy,
    _is.OrderByListBuilder<DeviceCommandTable>? orderByList,
    _is.Transaction? transaction,
    DeviceCommandInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceCommand>(
      where: where?.call(DeviceCommand.t),
      orderBy: orderBy?.call(DeviceCommand.t),
      orderByList: orderByList?.call(DeviceCommand.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceCommand]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeviceCommand.t`.
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
  _ida.Stream<List<DeviceCommand>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceCommandTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceCommandTable>? orderBy,
    _is.OrderByListBuilder<DeviceCommandTable>? orderByList,
    DeviceCommandInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceCommand>(
      where: where?.call(DeviceCommand.t),
      orderBy: orderBy?.call(DeviceCommand.t),
      orderByList: orderByList?.call(DeviceCommand.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceCommand] matching the given query parameters.
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
  Future<DeviceCommand?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceCommandTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceCommandTable>? orderBy,
    _is.OrderByListBuilder<DeviceCommandTable>? orderByList,
    _is.Transaction? transaction,
    DeviceCommandInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceCommand>(
      where: where?.call(DeviceCommand.t),
      orderBy: orderBy?.call(DeviceCommand.t),
      orderByList: orderByList?.call(DeviceCommand.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceCommand] by its [id] or null if no such row exists.
  Future<DeviceCommand?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceCommandInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceCommand>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceCommand]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceCommand]s will have their `id` fields set.
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
  Future<List<DeviceCommand>> insert(
    _is.DatabaseSession session,
    List<DeviceCommand> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceCommand>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceCommand] and returns the inserted row.
  ///
  /// The returned [DeviceCommand] will have its `id` field set.
  Future<DeviceCommand> insertRow(
    _is.DatabaseSession session,
    DeviceCommand row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceCommand>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceCommand]s in the list and returns the resulting rows.
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
  /// The returned [DeviceCommand]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceCommand>> upsert(
    _is.DatabaseSession session,
    List<DeviceCommand> rows, {
    required _is.ColumnSelections<DeviceCommandTable> conflictColumns,
    _is.ColumnSelections<DeviceCommandTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceCommandTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceCommand>(
      rows,
      conflictColumns: conflictColumns(DeviceCommand.t),
      updateColumns: updateColumns?.call(DeviceCommand.t),
      updateWhere: updateWhere?.call(DeviceCommand.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceCommand] and returns the resulting row.
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
  /// The returned [DeviceCommand] will have its `id` field set.
  Future<DeviceCommand?> upsertRow(
    _is.DatabaseSession session,
    DeviceCommand row, {
    required _is.ColumnSelections<DeviceCommandTable> conflictColumns,
    _is.ColumnSelections<DeviceCommandTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceCommandTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceCommand>(
      row,
      conflictColumns: conflictColumns(DeviceCommand.t),
      updateColumns: updateColumns?.call(DeviceCommand.t),
      updateWhere: updateWhere?.call(DeviceCommand.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceCommand]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceCommand>> update(
    _is.DatabaseSession session,
    List<DeviceCommand> rows, {
    _is.ColumnSelections<DeviceCommandTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceCommand>(
      rows,
      columns: columns?.call(DeviceCommand.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceCommand]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceCommand> updateRow(
    _is.DatabaseSession session,
    DeviceCommand row, {
    _is.ColumnSelections<DeviceCommandTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceCommand>(
      row,
      columns: columns?.call(DeviceCommand.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceCommand] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceCommand?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceCommandUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceCommand>(
      id,
      columnValues: columnValues(DeviceCommand.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceCommand]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceCommand>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceCommandUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DeviceCommandTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceCommandTable>? orderBy,
    _is.OrderByListBuilder<DeviceCommandTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceCommand>(
      columnValues: columnValues(DeviceCommand.t.updateTable),
      where: where(DeviceCommand.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceCommand.t),
      orderByList: orderByList?.call(DeviceCommand.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceCommand]s in the list and returns the deleted rows.
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
  Future<List<DeviceCommand>> delete(
    _is.DatabaseSession session,
    List<DeviceCommand> rows, {
    _is.OrderByBuilder<DeviceCommandTable>? orderBy,
    _is.OrderByListBuilder<DeviceCommandTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceCommand>(
      rows,
      orderBy: orderBy?.call(DeviceCommand.t),
      orderByList: orderByList?.call(DeviceCommand.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceCommand].
  Future<DeviceCommand> deleteRow(
    _is.DatabaseSession session,
    DeviceCommand row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceCommand>(
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
  Future<List<DeviceCommand>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceCommandTable> where,
    _is.OrderByBuilder<DeviceCommandTable>? orderBy,
    _is.OrderByListBuilder<DeviceCommandTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceCommand>(
      where: where(DeviceCommand.t),
      orderBy: orderBy?.call(DeviceCommand.t),
      orderByList: orderByList?.call(DeviceCommand.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceCommandTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceCommand>(
      where: where?.call(DeviceCommand.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceCommand] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceCommandTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceCommand>(
      where: where(DeviceCommand.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceCommandAttachRowRepository {
  const DeviceCommandAttachRowRepository._();

  /// Creates a relation between the given [DeviceCommand] and [Device]
  /// by setting the [DeviceCommand]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    DeviceCommand deviceCommand,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (deviceCommand.id == null) {
      throw ArgumentError.notNull('deviceCommand.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $deviceCommand = deviceCommand.copyWith(deviceId: device.id);
    await session.db.updateRow<DeviceCommand>(
      $deviceCommand,
      columns: [DeviceCommand.t.deviceId],
      transaction: transaction,
    );
  }
}
