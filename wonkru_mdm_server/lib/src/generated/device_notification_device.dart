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
import 'device_notification.dart' as _ixgsn4mm;

abstract class DeviceNotificationDevice
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceNotificationDevice._({
    this.id,
    required this.deviceNotificationId,
    this.deviceNotification,
    required this.deviceId,
    this.device,
    required this.status,
    this.sentAt,
    this.receivedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceNotificationDevice({
    int? id,
    required int deviceNotificationId,
    _ixgsn4mm.DeviceNotification? deviceNotification,
    required int deviceId,
    _ilo09f9g.Device? device,
    required _i3xu12wm.NotificationDeliveryStatus status,
    DateTime? sentAt,
    DateTime? receivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceNotificationDeviceImpl;

  factory DeviceNotificationDevice.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceNotificationDevice(
      id: jsonSerialization['id'] as int?,
      deviceNotificationId: jsonSerialization['deviceNotificationId'] as int,
      deviceNotification: jsonSerialization['deviceNotification'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ixgsn4mm.DeviceNotification>(
              jsonSerialization['deviceNotification'],
            ),
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      status: _i3xu12wm.NotificationDeliveryStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeviceNotificationDeviceTable();

  static const db = DeviceNotificationDeviceRepository._();

  @override
  int? id;

  int deviceNotificationId;

  _ixgsn4mm.DeviceNotification? deviceNotification;

  int deviceId;

  _ilo09f9g.Device? device;

  _i3xu12wm.NotificationDeliveryStatus status;

  DateTime? sentAt;

  DateTime? receivedAt;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceNotificationDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceNotificationDevice copyWith({
    int? id,
    int? deviceNotificationId,
    _ixgsn4mm.DeviceNotification? deviceNotification =
        const _UndefinedDeviceNotificationDevice$deviceNotification(),
    int? deviceId,
    _ilo09f9g.Device? device =
        const _UndefinedDeviceNotificationDevice$device(),
    _i3xu12wm.NotificationDeliveryStatus? status,
    DateTime? sentAt = const _is.$UndefinedDateTime(),
    DateTime? receivedAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceNotificationDevice',
      if (id != null) 'id': id,
      'deviceNotificationId': deviceNotificationId,
      if (deviceNotification != null)
        'deviceNotification': deviceNotification?.toJson(),
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'status': status.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceNotificationDevice',
      if (id != null) 'id': id,
      'deviceNotificationId': deviceNotificationId,
      if (deviceNotification != null)
        'deviceNotification': deviceNotification?.toJsonForProtocol(),
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'status': status.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static DeviceNotificationDeviceInclude include({
    _ixgsn4mm.DeviceNotificationInclude? deviceNotification,
    _ilo09f9g.DeviceInclude? device,
  }) {
    return DeviceNotificationDeviceInclude._(
      deviceNotification: deviceNotification,
      device: device,
    );
  }

  static DeviceNotificationDeviceIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceNotificationDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationDeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationDeviceTable>? orderByList,
    DeviceNotificationDeviceInclude? include,
  }) {
    return DeviceNotificationDeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceNotificationDevice.t),
      orderByList: orderByList?.call(DeviceNotificationDevice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceNotificationDevice$deviceNotification
    extends _is.UndefinedSentinel
    implements _ixgsn4mm.DeviceNotification {
  const _UndefinedDeviceNotificationDevice$deviceNotification();
}

class _UndefinedDeviceNotificationDevice$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceNotificationDevice$device();
}

class _DeviceNotificationDeviceImpl extends DeviceNotificationDevice {
  _DeviceNotificationDeviceImpl({
    int? id,
    required int deviceNotificationId,
    _ixgsn4mm.DeviceNotification? deviceNotification,
    required int deviceId,
    _ilo09f9g.Device? device,
    required _i3xu12wm.NotificationDeliveryStatus status,
    DateTime? sentAt,
    DateTime? receivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceNotificationId: deviceNotificationId,
         deviceNotification: deviceNotification,
         deviceId: deviceId,
         device: device,
         status: status,
         sentAt: sentAt,
         receivedAt: receivedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceNotificationDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceNotificationDevice copyWith({
    Object? id = _Undefined,
    int? deviceNotificationId,
    _ixgsn4mm.DeviceNotification? deviceNotification =
        const _UndefinedDeviceNotificationDevice$deviceNotification(),
    int? deviceId,
    _ilo09f9g.Device? device =
        const _UndefinedDeviceNotificationDevice$device(),
    _i3xu12wm.NotificationDeliveryStatus? status,
    DateTime? sentAt = const _is.$UndefinedDateTime(),
    DateTime? receivedAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return DeviceNotificationDevice(
      id: id is int? ? id : this.id,
      deviceNotificationId: deviceNotificationId ?? this.deviceNotificationId,
      deviceNotification: deviceNotification is _is.UndefinedSentinel
          ? this.deviceNotification?.copyWith()
          : deviceNotification,
      deviceId: deviceId ?? this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      status: status ?? this.status,
      sentAt: sentAt is _is.UndefinedSentinel ? this.sentAt : sentAt,
      receivedAt: receivedAt is _is.UndefinedSentinel
          ? this.receivedAt
          : receivedAt,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class DeviceNotificationDeviceUpdateTable
    extends _is.UpdateTable<DeviceNotificationDeviceTable> {
  DeviceNotificationDeviceUpdateTable(super.table);

  _is.ColumnValue<int, int> deviceNotificationId(int value) => _is.ColumnValue(
    table.deviceNotificationId,
    value,
  );

  _is.ColumnValue<int, int> deviceId(int value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<
    _i3xu12wm.NotificationDeliveryStatus,
    _i3xu12wm.NotificationDeliveryStatus
  >
  status(_i3xu12wm.NotificationDeliveryStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> sentAt(DateTime? value) =>
      _is.ColumnValue(
        table.sentAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime? value) =>
      _is.ColumnValue(
        table.receivedAt,
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

class DeviceNotificationDeviceTable extends _is.Table<int?> {
  DeviceNotificationDeviceTable({super.tableRelation})
    : super(tableName: 'device_notification_devices') {
    updateTable = DeviceNotificationDeviceUpdateTable(this);
    deviceNotificationId = _is.ColumnInt(
      'deviceNotificationId',
      this,
    );
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    sentAt = _is.ColumnDateTime(
      'sentAt',
      this,
    );
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
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

  late final DeviceNotificationDeviceUpdateTable updateTable;

  late final _is.ColumnInt deviceNotificationId;

  _ixgsn4mm.DeviceNotificationTable? _deviceNotification;

  late final _is.ColumnInt deviceId;

  _ilo09f9g.DeviceTable? _device;

  late final _is.ColumnEnum<_i3xu12wm.NotificationDeliveryStatus> status;

  late final _is.ColumnDateTime sentAt;

  late final _is.ColumnDateTime receivedAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _ixgsn4mm.DeviceNotificationTable get deviceNotification {
    if (_deviceNotification != null) return _deviceNotification!;
    _deviceNotification = _is.createRelationTable(
      relationFieldName: 'deviceNotification',
      field: DeviceNotificationDevice.t.deviceNotificationId,
      foreignField: _ixgsn4mm.DeviceNotification.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _ixgsn4mm.DeviceNotificationTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return _deviceNotification!;
  }

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: DeviceNotificationDevice.t.deviceId,
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
    deviceNotificationId,
    deviceId,
    status,
    sentAt,
    receivedAt,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'deviceNotification') {
      return deviceNotification;
    }
    if (relationField == 'device') {
      return device;
    }
    return null;
  }
}

class DeviceNotificationDeviceInclude extends _is.IncludeObject {
  DeviceNotificationDeviceInclude._({
    _ixgsn4mm.DeviceNotificationInclude? deviceNotification,
    _ilo09f9g.DeviceInclude? device,
  }) {
    _deviceNotification = deviceNotification;
    _device = device;
  }

  _ixgsn4mm.DeviceNotificationInclude? _deviceNotification;

  _ilo09f9g.DeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {
    'deviceNotification': _deviceNotification,
    'device': _device,
  };

  @override
  _is.Table<int?> get table => DeviceNotificationDevice.t;
}

class DeviceNotificationDeviceIncludeList extends _is.IncludeList {
  DeviceNotificationDeviceIncludeList._({
    _is.WhereExpressionBuilder<DeviceNotificationDeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceNotificationDevice.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceNotificationDevice.t;
}

class DeviceNotificationDeviceRepository {
  const DeviceNotificationDeviceRepository._();

  final attachRow = const DeviceNotificationDeviceAttachRowRepository._();

  /// Returns a list of [DeviceNotificationDevice]s matching the given query parameters.
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
  Future<List<DeviceNotificationDevice>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceNotificationDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationDeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationDeviceTable>? orderByList,
    _is.Transaction? transaction,
    DeviceNotificationDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceNotificationDevice>(
      where: where?.call(DeviceNotificationDevice.t),
      orderBy: orderBy?.call(DeviceNotificationDevice.t),
      orderByList: orderByList?.call(DeviceNotificationDevice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceNotificationDevice]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeviceNotificationDevice.t`.
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
  _ida.Stream<List<DeviceNotificationDevice>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceNotificationDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationDeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationDeviceTable>? orderByList,
    DeviceNotificationDeviceInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceNotificationDevice>(
      where: where?.call(DeviceNotificationDevice.t),
      orderBy: orderBy?.call(DeviceNotificationDevice.t),
      orderByList: orderByList?.call(DeviceNotificationDevice.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceNotificationDevice] matching the given query parameters.
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
  Future<DeviceNotificationDevice?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceNotificationDeviceTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationDeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationDeviceTable>? orderByList,
    _is.Transaction? transaction,
    DeviceNotificationDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceNotificationDevice>(
      where: where?.call(DeviceNotificationDevice.t),
      orderBy: orderBy?.call(DeviceNotificationDevice.t),
      orderByList: orderByList?.call(DeviceNotificationDevice.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceNotificationDevice] by its [id] or null if no such row exists.
  Future<DeviceNotificationDevice?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceNotificationDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceNotificationDevice>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceNotificationDevice]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceNotificationDevice]s will have their `id` fields set.
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
  Future<List<DeviceNotificationDevice>> insert(
    _is.DatabaseSession session,
    List<DeviceNotificationDevice> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceNotificationDevice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceNotificationDevice] and returns the inserted row.
  ///
  /// The returned [DeviceNotificationDevice] will have its `id` field set.
  Future<DeviceNotificationDevice> insertRow(
    _is.DatabaseSession session,
    DeviceNotificationDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceNotificationDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceNotificationDevice]s in the list and returns the resulting rows.
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
  /// The returned [DeviceNotificationDevice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceNotificationDevice>> upsert(
    _is.DatabaseSession session,
    List<DeviceNotificationDevice> rows, {
    required _is.ColumnSelections<DeviceNotificationDeviceTable>
    conflictColumns,
    _is.ColumnSelections<DeviceNotificationDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceNotificationDeviceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceNotificationDevice>(
      rows,
      conflictColumns: conflictColumns(DeviceNotificationDevice.t),
      updateColumns: updateColumns?.call(DeviceNotificationDevice.t),
      updateWhere: updateWhere?.call(DeviceNotificationDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceNotificationDevice] and returns the resulting row.
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
  /// The returned [DeviceNotificationDevice] will have its `id` field set.
  Future<DeviceNotificationDevice?> upsertRow(
    _is.DatabaseSession session,
    DeviceNotificationDevice row, {
    required _is.ColumnSelections<DeviceNotificationDeviceTable>
    conflictColumns,
    _is.ColumnSelections<DeviceNotificationDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceNotificationDeviceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceNotificationDevice>(
      row,
      conflictColumns: conflictColumns(DeviceNotificationDevice.t),
      updateColumns: updateColumns?.call(DeviceNotificationDevice.t),
      updateWhere: updateWhere?.call(DeviceNotificationDevice.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceNotificationDevice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceNotificationDevice>> update(
    _is.DatabaseSession session,
    List<DeviceNotificationDevice> rows, {
    _is.ColumnSelections<DeviceNotificationDeviceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceNotificationDevice>(
      rows,
      columns: columns?.call(DeviceNotificationDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceNotificationDevice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceNotificationDevice> updateRow(
    _is.DatabaseSession session,
    DeviceNotificationDevice row, {
    _is.ColumnSelections<DeviceNotificationDeviceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceNotificationDevice>(
      row,
      columns: columns?.call(DeviceNotificationDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceNotificationDevice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceNotificationDevice?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceNotificationDeviceUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceNotificationDevice>(
      id,
      columnValues: columnValues(DeviceNotificationDevice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceNotificationDevice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceNotificationDevice>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceNotificationDeviceUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DeviceNotificationDeviceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationDeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceNotificationDevice>(
      columnValues: columnValues(DeviceNotificationDevice.t.updateTable),
      where: where(DeviceNotificationDevice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceNotificationDevice.t),
      orderByList: orderByList?.call(DeviceNotificationDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceNotificationDevice]s in the list and returns the deleted rows.
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
  Future<List<DeviceNotificationDevice>> delete(
    _is.DatabaseSession session,
    List<DeviceNotificationDevice> rows, {
    _is.OrderByBuilder<DeviceNotificationDeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceNotificationDevice>(
      rows,
      orderBy: orderBy?.call(DeviceNotificationDevice.t),
      orderByList: orderByList?.call(DeviceNotificationDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceNotificationDevice].
  Future<DeviceNotificationDevice> deleteRow(
    _is.DatabaseSession session,
    DeviceNotificationDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceNotificationDevice>(
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
  Future<List<DeviceNotificationDevice>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceNotificationDeviceTable> where,
    _is.OrderByBuilder<DeviceNotificationDeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceNotificationDevice>(
      where: where(DeviceNotificationDevice.t),
      orderBy: orderBy?.call(DeviceNotificationDevice.t),
      orderByList: orderByList?.call(DeviceNotificationDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceNotificationDeviceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceNotificationDevice>(
      where: where?.call(DeviceNotificationDevice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceNotificationDevice] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceNotificationDeviceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceNotificationDevice>(
      where: where(DeviceNotificationDevice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceNotificationDeviceAttachRowRepository {
  const DeviceNotificationDeviceAttachRowRepository._();

  /// Creates a relation between the given [DeviceNotificationDevice] and [DeviceNotification]
  /// by setting the [DeviceNotificationDevice]'s foreign key `deviceNotificationId` to refer to the [DeviceNotification].
  Future<void> deviceNotification(
    _is.DatabaseSession session,
    DeviceNotificationDevice deviceNotificationDevice,
    _ixgsn4mm.DeviceNotification deviceNotification, {
    _is.Transaction? transaction,
  }) async {
    if (deviceNotificationDevice.id == null) {
      throw ArgumentError.notNull('deviceNotificationDevice.id');
    }
    if (deviceNotification.id == null) {
      throw ArgumentError.notNull('deviceNotification.id');
    }

    var $deviceNotificationDevice = deviceNotificationDevice.copyWith(
      deviceNotificationId: deviceNotification.id,
    );
    await session.db.updateRow<DeviceNotificationDevice>(
      $deviceNotificationDevice,
      columns: [DeviceNotificationDevice.t.deviceNotificationId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [DeviceNotificationDevice] and [Device]
  /// by setting the [DeviceNotificationDevice]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    DeviceNotificationDevice deviceNotificationDevice,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (deviceNotificationDevice.id == null) {
      throw ArgumentError.notNull('deviceNotificationDevice.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $deviceNotificationDevice = deviceNotificationDevice.copyWith(
      deviceId: device.id,
    );
    await session.db.updateRow<DeviceNotificationDevice>(
      $deviceNotificationDevice,
      columns: [DeviceNotificationDevice.t.deviceId],
      transaction: transaction,
    );
  }
}
