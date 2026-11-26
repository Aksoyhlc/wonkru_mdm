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

/// Two-factor verification state for one admin session.
///
/// Verification is session-bound: the row matches the session id ([sessionId])
/// and counts only until [verifiedUntil], so verifying on one device does not
/// open another session. [userId] lets disabling 2FA drop the verification of
/// all sessions at once; otherwise old sessions would count as verified under
/// the new secret.
abstract class AdminTotpSession
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AdminTotpSession._({
    this.id,
    required this.userId,
    required this.sessionId,
    required this.verifiedUntil,
    required this.createdAt,
  });

  factory AdminTotpSession({
    int? id,
    required _is.UuidValue userId,
    required String sessionId,
    required DateTime verifiedUntil,
    required DateTime createdAt,
  }) = _AdminTotpSessionImpl;

  factory AdminTotpSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminTotpSession(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      sessionId: jsonSerialization['sessionId'] as String,
      verifiedUntil: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['verifiedUntil'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AdminTotpSessionTable();

  static const db = AdminTotpSessionRepository._();

  @override
  int? id;

  _is.UuidValue userId;

  /// `AuthenticationInfo.authId` (the JWT refresh token).
  String sessionId;

  DateTime verifiedUntil;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AdminTotpSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminTotpSession copyWith({
    int? id,
    _is.UuidValue? userId,
    String? sessionId,
    DateTime? verifiedUntil,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminTotpSession',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'sessionId': sessionId,
      'verifiedUntil': verifiedUntil.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminTotpSession',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'sessionId': sessionId,
      'verifiedUntil': verifiedUntil.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static AdminTotpSessionInclude include() {
    return AdminTotpSessionInclude._();
  }

  static AdminTotpSessionIncludeList includeList({
    _is.WhereExpressionBuilder<AdminTotpSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminTotpSessionTable>? orderBy,
    _is.OrderByListBuilder<AdminTotpSessionTable>? orderByList,
    AdminTotpSessionInclude? include,
  }) {
    return AdminTotpSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminTotpSession.t),
      orderByList: orderByList?.call(AdminTotpSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminTotpSessionImpl extends AdminTotpSession {
  _AdminTotpSessionImpl({
    int? id,
    required _is.UuidValue userId,
    required String sessionId,
    required DateTime verifiedUntil,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         sessionId: sessionId,
         verifiedUntil: verifiedUntil,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminTotpSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminTotpSession copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    String? sessionId,
    DateTime? verifiedUntil,
    DateTime? createdAt,
  }) {
    return AdminTotpSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      verifiedUntil: verifiedUntil ?? this.verifiedUntil,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AdminTotpSessionUpdateTable
    extends _is.UpdateTable<AdminTotpSessionTable> {
  AdminTotpSessionUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> sessionId(String value) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> verifiedUntil(DateTime value) =>
      _is.ColumnValue(
        table.verifiedUntil,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AdminTotpSessionTable extends _is.Table<int?> {
  AdminTotpSessionTable({super.tableRelation})
    : super(tableName: 'admin_totp_sessions') {
    updateTable = AdminTotpSessionUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    sessionId = _is.ColumnString(
      'sessionId',
      this,
    );
    verifiedUntil = _is.ColumnDateTime(
      'verifiedUntil',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AdminTotpSessionUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  /// `AuthenticationInfo.authId` (the JWT refresh token).
  late final _is.ColumnString sessionId;

  late final _is.ColumnDateTime verifiedUntil;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    sessionId,
    verifiedUntil,
    createdAt,
  ];
}

class AdminTotpSessionInclude extends _is.IncludeObject {
  AdminTotpSessionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AdminTotpSession.t;
}

class AdminTotpSessionIncludeList extends _is.IncludeList {
  AdminTotpSessionIncludeList._({
    _is.WhereExpressionBuilder<AdminTotpSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminTotpSession.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AdminTotpSession.t;
}

class AdminTotpSessionRepository {
  const AdminTotpSessionRepository._();

  /// Returns a list of [AdminTotpSession]s matching the given query parameters.
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
  Future<List<AdminTotpSession>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminTotpSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminTotpSessionTable>? orderBy,
    _is.OrderByListBuilder<AdminTotpSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminTotpSession>(
      where: where?.call(AdminTotpSession.t),
      orderBy: orderBy?.call(AdminTotpSession.t),
      orderByList: orderByList?.call(AdminTotpSession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AdminTotpSession]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `AdminTotpSession.t`.
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
  _ida.Stream<List<AdminTotpSession>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminTotpSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminTotpSessionTable>? orderBy,
    _is.OrderByListBuilder<AdminTotpSessionTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AdminTotpSession>(
      where: where?.call(AdminTotpSession.t),
      orderBy: orderBy?.call(AdminTotpSession.t),
      orderByList: orderByList?.call(AdminTotpSession.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AdminTotpSession] matching the given query parameters.
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
  Future<AdminTotpSession?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminTotpSessionTable>? where,
    int? offset,
    _is.OrderByBuilder<AdminTotpSessionTable>? orderBy,
    _is.OrderByListBuilder<AdminTotpSessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminTotpSession>(
      where: where?.call(AdminTotpSession.t),
      orderBy: orderBy?.call(AdminTotpSession.t),
      orderByList: orderByList?.call(AdminTotpSession.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminTotpSession] by its [id] or null if no such row exists.
  Future<AdminTotpSession?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminTotpSession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminTotpSession]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminTotpSession]s will have their `id` fields set.
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
  Future<List<AdminTotpSession>> insert(
    _is.DatabaseSession session,
    List<AdminTotpSession> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AdminTotpSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AdminTotpSession] and returns the inserted row.
  ///
  /// The returned [AdminTotpSession] will have its `id` field set.
  Future<AdminTotpSession> insertRow(
    _is.DatabaseSession session,
    AdminTotpSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminTotpSession>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AdminTotpSession]s in the list and returns the resulting rows.
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
  /// The returned [AdminTotpSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminTotpSession>> upsert(
    _is.DatabaseSession session,
    List<AdminTotpSession> rows, {
    required _is.ColumnSelections<AdminTotpSessionTable> conflictColumns,
    _is.ColumnSelections<AdminTotpSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminTotpSessionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AdminTotpSession>(
      rows,
      conflictColumns: conflictColumns(AdminTotpSession.t),
      updateColumns: updateColumns?.call(AdminTotpSession.t),
      updateWhere: updateWhere?.call(AdminTotpSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AdminTotpSession] and returns the resulting row.
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
  /// The returned [AdminTotpSession] will have its `id` field set.
  Future<AdminTotpSession?> upsertRow(
    _is.DatabaseSession session,
    AdminTotpSession row, {
    required _is.ColumnSelections<AdminTotpSessionTable> conflictColumns,
    _is.ColumnSelections<AdminTotpSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminTotpSessionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AdminTotpSession>(
      row,
      conflictColumns: conflictColumns(AdminTotpSession.t),
      updateColumns: updateColumns?.call(AdminTotpSession.t),
      updateWhere: updateWhere?.call(AdminTotpSession.t),
      transaction: transaction,
    );
  }

  /// Updates all [AdminTotpSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminTotpSession>> update(
    _is.DatabaseSession session,
    List<AdminTotpSession> rows, {
    _is.ColumnSelections<AdminTotpSessionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AdminTotpSession>(
      rows,
      columns: columns?.call(AdminTotpSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AdminTotpSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminTotpSession> updateRow(
    _is.DatabaseSession session,
    AdminTotpSession row, {
    _is.ColumnSelections<AdminTotpSessionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminTotpSession>(
      row,
      columns: columns?.call(AdminTotpSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminTotpSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminTotpSession?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AdminTotpSessionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminTotpSession>(
      id,
      columnValues: columnValues(AdminTotpSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminTotpSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminTotpSession>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AdminTotpSessionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AdminTotpSessionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminTotpSessionTable>? orderBy,
    _is.OrderByListBuilder<AdminTotpSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AdminTotpSession>(
      columnValues: columnValues(AdminTotpSession.t.updateTable),
      where: where(AdminTotpSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminTotpSession.t),
      orderByList: orderByList?.call(AdminTotpSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AdminTotpSession]s in the list and returns the deleted rows.
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
  Future<List<AdminTotpSession>> delete(
    _is.DatabaseSession session,
    List<AdminTotpSession> rows, {
    _is.OrderByBuilder<AdminTotpSessionTable>? orderBy,
    _is.OrderByListBuilder<AdminTotpSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AdminTotpSession>(
      rows,
      orderBy: orderBy?.call(AdminTotpSession.t),
      orderByList: orderByList?.call(AdminTotpSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AdminTotpSession].
  Future<AdminTotpSession> deleteRow(
    _is.DatabaseSession session,
    AdminTotpSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminTotpSession>(
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
  Future<List<AdminTotpSession>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminTotpSessionTable> where,
    _is.OrderByBuilder<AdminTotpSessionTable>? orderBy,
    _is.OrderByListBuilder<AdminTotpSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AdminTotpSession>(
      where: where(AdminTotpSession.t),
      orderBy: orderBy?.call(AdminTotpSession.t),
      orderByList: orderByList?.call(AdminTotpSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminTotpSessionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AdminTotpSession>(
      where: where?.call(AdminTotpSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminTotpSession] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminTotpSessionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminTotpSession>(
      where: where(AdminTotpSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
