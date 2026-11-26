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
import 'package:wonkru_core_server/wonkru_core_server.dart' as _i3xu12wm;

abstract class DeviceNotification
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceNotification._({
    this.id,
    this.uuid,
    required this.title,
    required this.message,
    required this.type,
    this.extra,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceNotification({
    int? id,
    String? uuid,
    required String title,
    required String message,
    required _i3xu12wm.NotificationType type,
    String? extra,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceNotificationImpl;

  factory DeviceNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceNotification(
      id: jsonSerialization['id'] as int?,
      uuid: jsonSerialization['uuid'] as String?,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      type: _i3xu12wm.NotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      extra: jsonSerialization['extra'] as String?,
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DeviceNotificationTable();

  static const db = DeviceNotificationRepository._();

  @override
  int? id;

  String? uuid;

  String title;

  String message;

  _i3xu12wm.NotificationType type;

  /// Serialized JSON payload with additional notification data.
  String? extra;

  DateTime? sentAt;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceNotification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceNotification copyWith({
    int? id,
    String? uuid,
    String? title,
    String? message,
    _i3xu12wm.NotificationType? type,
    String? extra,
    DateTime? sentAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceNotification',
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      'title': title,
      'message': message,
      'type': type.toJson(),
      if (extra != null) 'extra': extra,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceNotification',
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      'title': title,
      'message': message,
      'type': type.toJson(),
      if (extra != null) 'extra': extra,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static DeviceNotificationInclude include() {
    return DeviceNotificationInclude._();
  }

  static DeviceNotificationIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceNotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationTable>? orderByList,
    DeviceNotificationInclude? include,
  }) {
    return DeviceNotificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceNotification.t),
      orderByList: orderByList?.call(DeviceNotification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceNotificationImpl extends DeviceNotification {
  _DeviceNotificationImpl({
    int? id,
    String? uuid,
    required String title,
    required String message,
    required _i3xu12wm.NotificationType type,
    String? extra,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         uuid: uuid,
         title: title,
         message: message,
         type: type,
         extra: extra,
         sentAt: sentAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceNotification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceNotification copyWith({
    Object? id = _Undefined,
    Object? uuid = _Undefined,
    String? title,
    String? message,
    _i3xu12wm.NotificationType? type,
    Object? extra = _Undefined,
    DateTime? sentAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return DeviceNotification(
      id: id is int? ? id : this.id,
      uuid: uuid is String? ? uuid : this.uuid,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      extra: extra is String? ? extra : this.extra,
      sentAt: sentAt is _is.UndefinedSentinel ? this.sentAt : sentAt,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class DeviceNotificationUpdateTable
    extends _is.UpdateTable<DeviceNotificationTable> {
  DeviceNotificationUpdateTable(super.table);

  _is.ColumnValue<String, String> uuid(String? value) => _is.ColumnValue(
    table.uuid,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> message(String value) => _is.ColumnValue(
    table.message,
    value,
  );

  _is.ColumnValue<_i3xu12wm.NotificationType, _i3xu12wm.NotificationType> type(
    _i3xu12wm.NotificationType value,
  ) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<String, String> extra(String? value) => _is.ColumnValue(
    table.extra,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> sentAt(DateTime? value) =>
      _is.ColumnValue(
        table.sentAt,
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

class DeviceNotificationTable extends _is.Table<int?> {
  DeviceNotificationTable({super.tableRelation})
    : super(tableName: 'device_notifications') {
    updateTable = DeviceNotificationUpdateTable(this);
    uuid = _is.ColumnString(
      'uuid',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    message = _is.ColumnString(
      'message',
      this,
    );
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
    extra = _is.ColumnString(
      'extra',
      this,
    );
    sentAt = _is.ColumnDateTime(
      'sentAt',
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

  late final DeviceNotificationUpdateTable updateTable;

  late final _is.ColumnString uuid;

  late final _is.ColumnString title;

  late final _is.ColumnString message;

  late final _is.ColumnEnum<_i3xu12wm.NotificationType> type;

  /// Serialized JSON payload with additional notification data.
  late final _is.ColumnString extra;

  late final _is.ColumnDateTime sentAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    uuid,
    title,
    message,
    type,
    extra,
    sentAt,
    createdAt,
    updatedAt,
  ];
}

class DeviceNotificationInclude extends _is.IncludeObject {
  DeviceNotificationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DeviceNotification.t;
}

class DeviceNotificationIncludeList extends _is.IncludeList {
  DeviceNotificationIncludeList._({
    _is.WhereExpressionBuilder<DeviceNotificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceNotification.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceNotification.t;
}

class DeviceNotificationRepository {
  const DeviceNotificationRepository._();

  /// Returns a list of [DeviceNotification]s matching the given query parameters.
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
  Future<List<DeviceNotification>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceNotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceNotification>(
      where: where?.call(DeviceNotification.t),
      orderBy: orderBy?.call(DeviceNotification.t),
      orderByList: orderByList?.call(DeviceNotification.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceNotification]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeviceNotification.t`.
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
  _ida.Stream<List<DeviceNotification>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceNotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceNotification>(
      where: where?.call(DeviceNotification.t),
      orderBy: orderBy?.call(DeviceNotification.t),
      orderByList: orderByList?.call(DeviceNotification.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceNotification] matching the given query parameters.
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
  Future<DeviceNotification?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceNotificationTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceNotification>(
      where: where?.call(DeviceNotification.t),
      orderBy: orderBy?.call(DeviceNotification.t),
      orderByList: orderByList?.call(DeviceNotification.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceNotification] by its [id] or null if no such row exists.
  Future<DeviceNotification?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceNotification>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceNotification]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceNotification]s will have their `id` fields set.
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
  Future<List<DeviceNotification>> insert(
    _is.DatabaseSession session,
    List<DeviceNotification> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceNotification>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceNotification] and returns the inserted row.
  ///
  /// The returned [DeviceNotification] will have its `id` field set.
  Future<DeviceNotification> insertRow(
    _is.DatabaseSession session,
    DeviceNotification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceNotification>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceNotification]s in the list and returns the resulting rows.
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
  /// The returned [DeviceNotification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceNotification>> upsert(
    _is.DatabaseSession session,
    List<DeviceNotification> rows, {
    required _is.ColumnSelections<DeviceNotificationTable> conflictColumns,
    _is.ColumnSelections<DeviceNotificationTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceNotificationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceNotification>(
      rows,
      conflictColumns: conflictColumns(DeviceNotification.t),
      updateColumns: updateColumns?.call(DeviceNotification.t),
      updateWhere: updateWhere?.call(DeviceNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceNotification] and returns the resulting row.
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
  /// The returned [DeviceNotification] will have its `id` field set.
  Future<DeviceNotification?> upsertRow(
    _is.DatabaseSession session,
    DeviceNotification row, {
    required _is.ColumnSelections<DeviceNotificationTable> conflictColumns,
    _is.ColumnSelections<DeviceNotificationTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceNotificationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceNotification>(
      row,
      conflictColumns: conflictColumns(DeviceNotification.t),
      updateColumns: updateColumns?.call(DeviceNotification.t),
      updateWhere: updateWhere?.call(DeviceNotification.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceNotification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceNotification>> update(
    _is.DatabaseSession session,
    List<DeviceNotification> rows, {
    _is.ColumnSelections<DeviceNotificationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceNotification>(
      rows,
      columns: columns?.call(DeviceNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceNotification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceNotification> updateRow(
    _is.DatabaseSession session,
    DeviceNotification row, {
    _is.ColumnSelections<DeviceNotificationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceNotification>(
      row,
      columns: columns?.call(DeviceNotification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceNotification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceNotification?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceNotificationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceNotification>(
      id,
      columnValues: columnValues(DeviceNotification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceNotification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceNotification>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceNotificationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DeviceNotificationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceNotificationTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceNotification>(
      columnValues: columnValues(DeviceNotification.t.updateTable),
      where: where(DeviceNotification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceNotification.t),
      orderByList: orderByList?.call(DeviceNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceNotification]s in the list and returns the deleted rows.
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
  Future<List<DeviceNotification>> delete(
    _is.DatabaseSession session,
    List<DeviceNotification> rows, {
    _is.OrderByBuilder<DeviceNotificationTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceNotification>(
      rows,
      orderBy: orderBy?.call(DeviceNotification.t),
      orderByList: orderByList?.call(DeviceNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceNotification].
  Future<DeviceNotification> deleteRow(
    _is.DatabaseSession session,
    DeviceNotification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceNotification>(
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
  Future<List<DeviceNotification>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceNotificationTable> where,
    _is.OrderByBuilder<DeviceNotificationTable>? orderBy,
    _is.OrderByListBuilder<DeviceNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceNotification>(
      where: where(DeviceNotification.t),
      orderBy: orderBy?.call(DeviceNotification.t),
      orderByList: orderByList?.call(DeviceNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceNotificationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceNotification>(
      where: where?.call(DeviceNotification.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceNotification] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceNotificationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceNotification>(
      where: where(DeviceNotification.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
