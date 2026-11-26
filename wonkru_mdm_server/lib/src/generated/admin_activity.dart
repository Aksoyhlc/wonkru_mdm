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

/// Audit record of an admin action.
///
/// Rows are immutable: never edited or deleted through the panel. Actor name
/// and email are stored as a snapshot so the record stays readable after the
/// account is deleted.
abstract class AdminActivity
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AdminActivity._({
    this.id,
    this.actorUserId,
    this.actorEmail,
    this.actorName,
    required this.action,
    this.targetType,
    this.targetId,
    this.data,
    this.ipAddress,
    required this.createdAt,
  });

  factory AdminActivity({
    int? id,
    _is.UuidValue? actorUserId,
    String? actorEmail,
    String? actorName,
    required String action,
    String? targetType,
    String? targetId,
    String? data,
    String? ipAddress,
    required DateTime createdAt,
  }) = _AdminActivityImpl;

  factory AdminActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminActivity(
      id: jsonSerialization['id'] as int?,
      actorUserId: jsonSerialization['actorUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['actorUserId'],
            ),
      actorEmail: jsonSerialization['actorEmail'] as String?,
      actorName: jsonSerialization['actorName'] as String?,
      action: jsonSerialization['action'] as String,
      targetType: jsonSerialization['targetType'] as String?,
      targetId: jsonSerialization['targetId'] as String?,
      data: jsonSerialization['data'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AdminActivityTable();

  static const db = AdminActivityRepository._();

  @override
  int? id;

  /// Auth user id of the actor; null for system or failed sign-ins.
  _is.UuidValue? actorUserId;

  /// Email at the time of the action; the attempted email on a failed sign-in.
  String? actorEmail;

  String? actorName;

  /// Action code `<domain>.<action>` (e.g. `device.delete`); the panel resolves
  /// its label via i18n.
  String action;

  String? targetType;

  String? targetId;

  /// Action-specific extra data as JSON.
  String? data;

  String? ipAddress;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AdminActivity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminActivity copyWith({
    int? id,
    _is.UuidValue? actorUserId = const _is.$UndefinedUuidValue(),
    String? actorEmail,
    String? actorName,
    String? action,
    String? targetType,
    String? targetId,
    String? data,
    String? ipAddress,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminActivity',
      if (id != null) 'id': id,
      if (actorUserId != null) 'actorUserId': actorUserId?.toJson(),
      if (actorEmail != null) 'actorEmail': actorEmail,
      if (actorName != null) 'actorName': actorName,
      'action': action,
      if (targetType != null) 'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (data != null) 'data': data,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminActivity',
      if (id != null) 'id': id,
      if (actorUserId != null) 'actorUserId': actorUserId?.toJson(),
      if (actorEmail != null) 'actorEmail': actorEmail,
      if (actorName != null) 'actorName': actorName,
      'action': action,
      if (targetType != null) 'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (data != null) 'data': data,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'createdAt': createdAt.toJson(),
    };
  }

  static AdminActivityInclude include() {
    return AdminActivityInclude._();
  }

  static AdminActivityIncludeList includeList({
    _is.WhereExpressionBuilder<AdminActivityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminActivityTable>? orderBy,
    _is.OrderByListBuilder<AdminActivityTable>? orderByList,
    AdminActivityInclude? include,
  }) {
    return AdminActivityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminActivity.t),
      orderByList: orderByList?.call(AdminActivity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminActivityImpl extends AdminActivity {
  _AdminActivityImpl({
    int? id,
    _is.UuidValue? actorUserId,
    String? actorEmail,
    String? actorName,
    required String action,
    String? targetType,
    String? targetId,
    String? data,
    String? ipAddress,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorUserId: actorUserId,
         actorEmail: actorEmail,
         actorName: actorName,
         action: action,
         targetType: targetType,
         targetId: targetId,
         data: data,
         ipAddress: ipAddress,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminActivity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminActivity copyWith({
    Object? id = _Undefined,
    _is.UuidValue? actorUserId = const _is.$UndefinedUuidValue(),
    Object? actorEmail = _Undefined,
    Object? actorName = _Undefined,
    String? action,
    Object? targetType = _Undefined,
    Object? targetId = _Undefined,
    Object? data = _Undefined,
    Object? ipAddress = _Undefined,
    DateTime? createdAt,
  }) {
    return AdminActivity(
      id: id is int? ? id : this.id,
      actorUserId: actorUserId is _is.UndefinedSentinel
          ? this.actorUserId
          : actorUserId,
      actorEmail: actorEmail is String? ? actorEmail : this.actorEmail,
      actorName: actorName is String? ? actorName : this.actorName,
      action: action ?? this.action,
      targetType: targetType is String? ? targetType : this.targetType,
      targetId: targetId is String? ? targetId : this.targetId,
      data: data is String? ? data : this.data,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminActivityUpdateTable extends _is.UpdateTable<AdminActivityTable> {
  AdminActivityUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> actorUserId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.actorUserId,
    value,
  );

  _is.ColumnValue<String, String> actorEmail(String? value) => _is.ColumnValue(
    table.actorEmail,
    value,
  );

  _is.ColumnValue<String, String> actorName(String? value) => _is.ColumnValue(
    table.actorName,
    value,
  );

  _is.ColumnValue<String, String> action(String value) => _is.ColumnValue(
    table.action,
    value,
  );

  _is.ColumnValue<String, String> targetType(String? value) => _is.ColumnValue(
    table.targetType,
    value,
  );

  _is.ColumnValue<String, String> targetId(String? value) => _is.ColumnValue(
    table.targetId,
    value,
  );

  _is.ColumnValue<String, String> data(String? value) => _is.ColumnValue(
    table.data,
    value,
  );

  _is.ColumnValue<String, String> ipAddress(String? value) => _is.ColumnValue(
    table.ipAddress,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AdminActivityTable extends _is.Table<int?> {
  AdminActivityTable({super.tableRelation})
    : super(tableName: 'admin_activities') {
    updateTable = AdminActivityUpdateTable(this);
    actorUserId = _is.ColumnUuid(
      'actorUserId',
      this,
    );
    actorEmail = _is.ColumnString(
      'actorEmail',
      this,
    );
    actorName = _is.ColumnString(
      'actorName',
      this,
    );
    action = _is.ColumnString(
      'action',
      this,
    );
    targetType = _is.ColumnString(
      'targetType',
      this,
    );
    targetId = _is.ColumnString(
      'targetId',
      this,
    );
    data = _is.ColumnString(
      'data',
      this,
    );
    ipAddress = _is.ColumnString(
      'ipAddress',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AdminActivityUpdateTable updateTable;

  /// Auth user id of the actor; null for system or failed sign-ins.
  late final _is.ColumnUuid actorUserId;

  /// Email at the time of the action; the attempted email on a failed sign-in.
  late final _is.ColumnString actorEmail;

  late final _is.ColumnString actorName;

  /// Action code `<domain>.<action>` (e.g. `device.delete`); the panel resolves
  /// its label via i18n.
  late final _is.ColumnString action;

  late final _is.ColumnString targetType;

  late final _is.ColumnString targetId;

  /// Action-specific extra data as JSON.
  late final _is.ColumnString data;

  late final _is.ColumnString ipAddress;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    actorUserId,
    actorEmail,
    actorName,
    action,
    targetType,
    targetId,
    data,
    ipAddress,
    createdAt,
  ];
}

class AdminActivityInclude extends _is.IncludeObject {
  AdminActivityInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AdminActivity.t;
}

class AdminActivityIncludeList extends _is.IncludeList {
  AdminActivityIncludeList._({
    _is.WhereExpressionBuilder<AdminActivityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminActivity.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AdminActivity.t;
}

class AdminActivityRepository {
  const AdminActivityRepository._();

  /// Returns a list of [AdminActivity]s matching the given query parameters.
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
  Future<List<AdminActivity>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminActivityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminActivityTable>? orderBy,
    _is.OrderByListBuilder<AdminActivityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminActivity>(
      where: where?.call(AdminActivity.t),
      orderBy: orderBy?.call(AdminActivity.t),
      orderByList: orderByList?.call(AdminActivity.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AdminActivity]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `AdminActivity.t`.
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
  _ida.Stream<List<AdminActivity>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminActivityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminActivityTable>? orderBy,
    _is.OrderByListBuilder<AdminActivityTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AdminActivity>(
      where: where?.call(AdminActivity.t),
      orderBy: orderBy?.call(AdminActivity.t),
      orderByList: orderByList?.call(AdminActivity.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AdminActivity] matching the given query parameters.
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
  Future<AdminActivity?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminActivityTable>? where,
    int? offset,
    _is.OrderByBuilder<AdminActivityTable>? orderBy,
    _is.OrderByListBuilder<AdminActivityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminActivity>(
      where: where?.call(AdminActivity.t),
      orderBy: orderBy?.call(AdminActivity.t),
      orderByList: orderByList?.call(AdminActivity.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminActivity] by its [id] or null if no such row exists.
  Future<AdminActivity?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminActivity>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminActivity]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminActivity]s will have their `id` fields set.
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
  Future<List<AdminActivity>> insert(
    _is.DatabaseSession session,
    List<AdminActivity> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AdminActivity>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AdminActivity] and returns the inserted row.
  ///
  /// The returned [AdminActivity] will have its `id` field set.
  Future<AdminActivity> insertRow(
    _is.DatabaseSession session,
    AdminActivity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminActivity>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AdminActivity]s in the list and returns the resulting rows.
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
  /// The returned [AdminActivity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminActivity>> upsert(
    _is.DatabaseSession session,
    List<AdminActivity> rows, {
    required _is.ColumnSelections<AdminActivityTable> conflictColumns,
    _is.ColumnSelections<AdminActivityTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminActivityTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AdminActivity>(
      rows,
      conflictColumns: conflictColumns(AdminActivity.t),
      updateColumns: updateColumns?.call(AdminActivity.t),
      updateWhere: updateWhere?.call(AdminActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AdminActivity] and returns the resulting row.
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
  /// The returned [AdminActivity] will have its `id` field set.
  Future<AdminActivity?> upsertRow(
    _is.DatabaseSession session,
    AdminActivity row, {
    required _is.ColumnSelections<AdminActivityTable> conflictColumns,
    _is.ColumnSelections<AdminActivityTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminActivityTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AdminActivity>(
      row,
      conflictColumns: conflictColumns(AdminActivity.t),
      updateColumns: updateColumns?.call(AdminActivity.t),
      updateWhere: updateWhere?.call(AdminActivity.t),
      transaction: transaction,
    );
  }

  /// Updates all [AdminActivity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminActivity>> update(
    _is.DatabaseSession session,
    List<AdminActivity> rows, {
    _is.ColumnSelections<AdminActivityTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AdminActivity>(
      rows,
      columns: columns?.call(AdminActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AdminActivity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminActivity> updateRow(
    _is.DatabaseSession session,
    AdminActivity row, {
    _is.ColumnSelections<AdminActivityTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminActivity>(
      row,
      columns: columns?.call(AdminActivity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminActivity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminActivity?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AdminActivityUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminActivity>(
      id,
      columnValues: columnValues(AdminActivity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminActivity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminActivity>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AdminActivityUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AdminActivityTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminActivityTable>? orderBy,
    _is.OrderByListBuilder<AdminActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AdminActivity>(
      columnValues: columnValues(AdminActivity.t.updateTable),
      where: where(AdminActivity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminActivity.t),
      orderByList: orderByList?.call(AdminActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AdminActivity]s in the list and returns the deleted rows.
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
  Future<List<AdminActivity>> delete(
    _is.DatabaseSession session,
    List<AdminActivity> rows, {
    _is.OrderByBuilder<AdminActivityTable>? orderBy,
    _is.OrderByListBuilder<AdminActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AdminActivity>(
      rows,
      orderBy: orderBy?.call(AdminActivity.t),
      orderByList: orderByList?.call(AdminActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AdminActivity].
  Future<AdminActivity> deleteRow(
    _is.DatabaseSession session,
    AdminActivity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminActivity>(
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
  Future<List<AdminActivity>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminActivityTable> where,
    _is.OrderByBuilder<AdminActivityTable>? orderBy,
    _is.OrderByListBuilder<AdminActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AdminActivity>(
      where: where(AdminActivity.t),
      orderBy: orderBy?.call(AdminActivity.t),
      orderByList: orderByList?.call(AdminActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminActivityTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AdminActivity>(
      where: where?.call(AdminActivity.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminActivity] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminActivityTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminActivity>(
      where: where(AdminActivity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
