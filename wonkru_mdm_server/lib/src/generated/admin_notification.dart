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

abstract class AdminNotification
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AdminNotification._({
    this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.readAt,
    required this.createdAt,
  });

  factory AdminNotification({
    int? id,
    required _is.UuidValue userId,
    required String type,
    required String title,
    required String message,
    String? data,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _AdminNotificationImpl;

  factory AdminNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminNotification(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      type: jsonSerialization['type'] as String,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      data: jsonSerialization['data'] as String?,
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AdminNotificationTable();

  static const db = AdminNotificationRepository._();

  @override
  int? id;

  _is.UuidValue userId;

  /// One of the `SystemAlertType` values.
  String type;

  String title;

  String message;

  /// Serialized JSON payload; null when absent.
  String? data;

  /// Set when read; null while unread.
  DateTime? readAt;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AdminNotification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminNotification copyWith({
    int? id,
    _is.UuidValue? userId,
    String? type,
    String? title,
    String? message,
    String? data,
    DateTime? readAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminNotification',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'type': type,
      'title': title,
      'message': message,
      if (data != null) 'data': data,
      if (readAt != null) 'readAt': readAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminNotification',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'type': type,
      'title': title,
      'message': message,
      if (data != null) 'data': data,
      if (readAt != null) 'readAt': readAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static AdminNotificationInclude include() {
    return AdminNotificationInclude._();
  }

  static AdminNotificationIncludeList includeList({
    _is.WhereExpressionBuilder<AdminNotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminNotificationTable>? orderBy,
    _is.OrderByListBuilder<AdminNotificationTable>? orderByList,
    AdminNotificationInclude? include,
  }) {
    return AdminNotificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminNotification.t),
      orderByList: orderByList?.call(AdminNotification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminNotificationImpl extends AdminNotification {
  _AdminNotificationImpl({
    int? id,
    required _is.UuidValue userId,
    required String type,
    required String title,
    required String message,
    String? data,
    DateTime? readAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         type: type,
         title: title,
         message: message,
         data: data,
         readAt: readAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminNotification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminNotification copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    String? type,
    String? title,
    String? message,
    Object? data = _Undefined,
    DateTime? readAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
  }) {
    return AdminNotification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data is String? ? data : this.data,
      readAt: readAt is _is.UndefinedSentinel ? this.readAt : readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminNotificationUpdateTable
    extends _is.UpdateTable<AdminNotificationTable> {
  AdminNotificationUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> type(String value) => _is.ColumnValue(
    table.type,
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

  _is.ColumnValue<String, String> data(String? value) => _is.ColumnValue(
    table.data,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> readAt(DateTime? value) =>
      _is.ColumnValue(
        table.readAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AdminNotificationTable extends _is.Table<int?> {
  AdminNotificationTable({super.tableRelation})
    : super(tableName: 'admin_notifications') {
    updateTable = AdminNotificationUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    type = _is.ColumnString(
      'type',
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
    data = _is.ColumnString(
      'data',
      this,
    );
    readAt = _is.ColumnDateTime(
      'readAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AdminNotificationUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  /// One of the `SystemAlertType` values.
  late final _is.ColumnString type;

  late final _is.ColumnString title;

  late final _is.ColumnString message;

  /// Serialized JSON payload; null when absent.
  late final _is.ColumnString data;

  /// Set when read; null while unread.
  late final _is.ColumnDateTime readAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    type,
    title,
    message,
    data,
    readAt,
    createdAt,
  ];
}

class AdminNotificationInclude extends _is.IncludeObject {
  AdminNotificationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AdminNotification.t;
}

class AdminNotificationIncludeList extends _is.IncludeList {
  AdminNotificationIncludeList._({
    _is.WhereExpressionBuilder<AdminNotificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminNotification.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AdminNotification.t;
}

class AdminNotificationRepository {
  const AdminNotificationRepository._();

  /// Returns a list of [AdminNotification]s matching the given query parameters.
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
  Future<List<AdminNotification>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminNotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminNotificationTable>? orderBy,
    _is.OrderByListBuilder<AdminNotificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminNotification>(
      where: where?.call(AdminNotification.t),
      orderBy: orderBy?.call(AdminNotification.t),
      orderByList: orderByList?.call(AdminNotification.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AdminNotification]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `AdminNotification.t`.
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
  _ida.Stream<List<AdminNotification>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminNotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminNotificationTable>? orderBy,
    _is.OrderByListBuilder<AdminNotificationTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AdminNotification>(
      where: where?.call(AdminNotification.t),
      orderBy: orderBy?.call(AdminNotification.t),
      orderByList: orderByList?.call(AdminNotification.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AdminNotification] matching the given query parameters.
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
  Future<AdminNotification?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminNotificationTable>? where,
    int? offset,
    _is.OrderByBuilder<AdminNotificationTable>? orderBy,
    _is.OrderByListBuilder<AdminNotificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminNotification>(
      where: where?.call(AdminNotification.t),
      orderBy: orderBy?.call(AdminNotification.t),
      orderByList: orderByList?.call(AdminNotification.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminNotification] by its [id] or null if no such row exists.
  Future<AdminNotification?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminNotification>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminNotification]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminNotification]s will have their `id` fields set.
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
  Future<List<AdminNotification>> insert(
    _is.DatabaseSession session,
    List<AdminNotification> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AdminNotification>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AdminNotification] and returns the inserted row.
  ///
  /// The returned [AdminNotification] will have its `id` field set.
  Future<AdminNotification> insertRow(
    _is.DatabaseSession session,
    AdminNotification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminNotification>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AdminNotification]s in the list and returns the resulting rows.
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
  /// The returned [AdminNotification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminNotification>> upsert(
    _is.DatabaseSession session,
    List<AdminNotification> rows, {
    required _is.ColumnSelections<AdminNotificationTable> conflictColumns,
    _is.ColumnSelections<AdminNotificationTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminNotificationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AdminNotification>(
      rows,
      conflictColumns: conflictColumns(AdminNotification.t),
      updateColumns: updateColumns?.call(AdminNotification.t),
      updateWhere: updateWhere?.call(AdminNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AdminNotification] and returns the resulting row.
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
  /// The returned [AdminNotification] will have its `id` field set.
  Future<AdminNotification?> upsertRow(
    _is.DatabaseSession session,
    AdminNotification row, {
    required _is.ColumnSelections<AdminNotificationTable> conflictColumns,
    _is.ColumnSelections<AdminNotificationTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminNotificationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AdminNotification>(
      row,
      conflictColumns: conflictColumns(AdminNotification.t),
      updateColumns: updateColumns?.call(AdminNotification.t),
      updateWhere: updateWhere?.call(AdminNotification.t),
      transaction: transaction,
    );
  }

  /// Updates all [AdminNotification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminNotification>> update(
    _is.DatabaseSession session,
    List<AdminNotification> rows, {
    _is.ColumnSelections<AdminNotificationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AdminNotification>(
      rows,
      columns: columns?.call(AdminNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AdminNotification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminNotification> updateRow(
    _is.DatabaseSession session,
    AdminNotification row, {
    _is.ColumnSelections<AdminNotificationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminNotification>(
      row,
      columns: columns?.call(AdminNotification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminNotification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminNotification?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AdminNotificationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminNotification>(
      id,
      columnValues: columnValues(AdminNotification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminNotification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminNotification>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AdminNotificationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AdminNotificationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminNotificationTable>? orderBy,
    _is.OrderByListBuilder<AdminNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AdminNotification>(
      columnValues: columnValues(AdminNotification.t.updateTable),
      where: where(AdminNotification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminNotification.t),
      orderByList: orderByList?.call(AdminNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AdminNotification]s in the list and returns the deleted rows.
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
  Future<List<AdminNotification>> delete(
    _is.DatabaseSession session,
    List<AdminNotification> rows, {
    _is.OrderByBuilder<AdminNotificationTable>? orderBy,
    _is.OrderByListBuilder<AdminNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AdminNotification>(
      rows,
      orderBy: orderBy?.call(AdminNotification.t),
      orderByList: orderByList?.call(AdminNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AdminNotification].
  Future<AdminNotification> deleteRow(
    _is.DatabaseSession session,
    AdminNotification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminNotification>(
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
  Future<List<AdminNotification>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminNotificationTable> where,
    _is.OrderByBuilder<AdminNotificationTable>? orderBy,
    _is.OrderByListBuilder<AdminNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AdminNotification>(
      where: where(AdminNotification.t),
      orderBy: orderBy?.call(AdminNotification.t),
      orderByList: orderByList?.call(AdminNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminNotificationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AdminNotification>(
      where: where?.call(AdminNotification.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminNotification] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminNotificationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminNotification>(
      where: where(AdminNotification.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
