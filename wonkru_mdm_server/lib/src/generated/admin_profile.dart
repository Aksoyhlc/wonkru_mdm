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
import 'enums/admin_account_status.dart' as _iejobxhm;

abstract class AdminProfile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AdminProfile._({
    this.id,
    required this.userId,
    _iejobxhm.AdminAccountStatus? status,
    this.totpSecret,
    this.recoveryCodes,
    this.totpLastUsedCounter,
    this.lastLoginAt,
    int? totpFailedAttempts,
    this.totpLockedUntil,
    this.createdAt,
    this.updatedAt,
  }) : status = status ?? _iejobxhm.AdminAccountStatus.disabled,
       totpFailedAttempts = totpFailedAttempts ?? 0;

  factory AdminProfile({
    int? id,
    required _is.UuidValue userId,
    _iejobxhm.AdminAccountStatus? status,
    String? totpSecret,
    String? recoveryCodes,
    int? totpLastUsedCounter,
    DateTime? lastLoginAt,
    int? totpFailedAttempts,
    DateTime? totpLockedUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AdminProfileImpl;

  factory AdminProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminProfile(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      status: jsonSerialization['status'] == null
          ? null
          : _iejobxhm.AdminAccountStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      totpSecret: jsonSerialization['totpSecret'] as String?,
      recoveryCodes: jsonSerialization['recoveryCodes'] as String?,
      totpLastUsedCounter: jsonSerialization['totpLastUsedCounter'] as int?,
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
            ),
      totpFailedAttempts: jsonSerialization['totpFailedAttempts'] as int?,
      totpLockedUntil: jsonSerialization['totpLockedUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['totpLockedUntil'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AdminProfileTable();

  static const db = AdminProfileRepository._();

  @override
  int? id;

  _is.UuidValue userId;

  /// Panel access is granted only while `active`; the fail-closed default is
  /// `disabled`.
  _iejobxhm.AdminAccountStatus status;

  String? totpSecret;

  /// JSON array of two-factor recovery codes.
  String? recoveryCodes;

  /// Last accepted TOTP time step; blocks code replay.
  int? totpLastUsedCounter;

  /// Last successful panel login; null if never.
  DateTime? lastLoginAt;

  /// Consecutive failed code attempts; drives lockout.
  int totpFailedAttempts;

  /// Attempts are rejected until this time; null when unlocked.
  DateTime? totpLockedUntil;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AdminProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminProfile copyWith({
    int? id,
    _is.UuidValue? userId,
    _iejobxhm.AdminAccountStatus? status,
    String? totpSecret,
    String? recoveryCodes,
    int? totpLastUsedCounter,
    DateTime? lastLoginAt = const _is.$UndefinedDateTime(),
    int? totpFailedAttempts,
    DateTime? totpLockedUntil = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminProfile',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'status': status.toJson(),
      if (totpSecret != null) 'totpSecret': totpSecret,
      if (recoveryCodes != null) 'recoveryCodes': recoveryCodes,
      if (totpLastUsedCounter != null)
        'totpLastUsedCounter': totpLastUsedCounter,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'totpFailedAttempts': totpFailedAttempts,
      if (totpLockedUntil != null) 'totpLockedUntil': totpLockedUntil?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminProfile',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'status': status.toJson(),
      if (totpSecret != null) 'totpSecret': totpSecret,
      if (recoveryCodes != null) 'recoveryCodes': recoveryCodes,
      if (totpLastUsedCounter != null)
        'totpLastUsedCounter': totpLastUsedCounter,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'totpFailedAttempts': totpFailedAttempts,
      if (totpLockedUntil != null) 'totpLockedUntil': totpLockedUntil?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static AdminProfileInclude include() {
    return AdminProfileInclude._();
  }

  static AdminProfileIncludeList includeList({
    _is.WhereExpressionBuilder<AdminProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminProfileTable>? orderBy,
    _is.OrderByListBuilder<AdminProfileTable>? orderByList,
    AdminProfileInclude? include,
  }) {
    return AdminProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminProfile.t),
      orderByList: orderByList?.call(AdminProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminProfileImpl extends AdminProfile {
  _AdminProfileImpl({
    int? id,
    required _is.UuidValue userId,
    _iejobxhm.AdminAccountStatus? status,
    String? totpSecret,
    String? recoveryCodes,
    int? totpLastUsedCounter,
    DateTime? lastLoginAt,
    int? totpFailedAttempts,
    DateTime? totpLockedUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         status: status,
         totpSecret: totpSecret,
         recoveryCodes: recoveryCodes,
         totpLastUsedCounter: totpLastUsedCounter,
         lastLoginAt: lastLoginAt,
         totpFailedAttempts: totpFailedAttempts,
         totpLockedUntil: totpLockedUntil,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AdminProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminProfile copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    _iejobxhm.AdminAccountStatus? status,
    Object? totpSecret = _Undefined,
    Object? recoveryCodes = _Undefined,
    Object? totpLastUsedCounter = _Undefined,
    DateTime? lastLoginAt = const _is.$UndefinedDateTime(),
    int? totpFailedAttempts,
    DateTime? totpLockedUntil = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return AdminProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      totpSecret: totpSecret is String? ? totpSecret : this.totpSecret,
      recoveryCodes: recoveryCodes is String?
          ? recoveryCodes
          : this.recoveryCodes,
      totpLastUsedCounter: totpLastUsedCounter is int?
          ? totpLastUsedCounter
          : this.totpLastUsedCounter,
      lastLoginAt: lastLoginAt is _is.UndefinedSentinel
          ? this.lastLoginAt
          : lastLoginAt,
      totpFailedAttempts: totpFailedAttempts ?? this.totpFailedAttempts,
      totpLockedUntil: totpLockedUntil is _is.UndefinedSentinel
          ? this.totpLockedUntil
          : totpLockedUntil,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class AdminProfileUpdateTable extends _is.UpdateTable<AdminProfileTable> {
  AdminProfileUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<_iejobxhm.AdminAccountStatus, _iejobxhm.AdminAccountStatus>
  status(_iejobxhm.AdminAccountStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> totpSecret(String? value) => _is.ColumnValue(
    table.totpSecret,
    value,
  );

  _is.ColumnValue<String, String> recoveryCodes(String? value) =>
      _is.ColumnValue(
        table.recoveryCodes,
        value,
      );

  _is.ColumnValue<int, int> totpLastUsedCounter(int? value) => _is.ColumnValue(
    table.totpLastUsedCounter,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastLoginAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastLoginAt,
        value,
      );

  _is.ColumnValue<int, int> totpFailedAttempts(int value) => _is.ColumnValue(
    table.totpFailedAttempts,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> totpLockedUntil(DateTime? value) =>
      _is.ColumnValue(
        table.totpLockedUntil,
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

class AdminProfileTable extends _is.Table<int?> {
  AdminProfileTable({super.tableRelation})
    : super(tableName: 'admin_profiles') {
    updateTable = AdminProfileUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    totpSecret = _is.ColumnString(
      'totpSecret',
      this,
    );
    recoveryCodes = _is.ColumnString(
      'recoveryCodes',
      this,
    );
    totpLastUsedCounter = _is.ColumnInt(
      'totpLastUsedCounter',
      this,
    );
    lastLoginAt = _is.ColumnDateTime(
      'lastLoginAt',
      this,
    );
    totpFailedAttempts = _is.ColumnInt(
      'totpFailedAttempts',
      this,
    );
    totpLockedUntil = _is.ColumnDateTime(
      'totpLockedUntil',
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

  late final AdminProfileUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  /// Panel access is granted only while `active`; the fail-closed default is
  /// `disabled`.
  late final _is.ColumnEnum<_iejobxhm.AdminAccountStatus> status;

  late final _is.ColumnString totpSecret;

  /// JSON array of two-factor recovery codes.
  late final _is.ColumnString recoveryCodes;

  /// Last accepted TOTP time step; blocks code replay.
  late final _is.ColumnInt totpLastUsedCounter;

  /// Last successful panel login; null if never.
  late final _is.ColumnDateTime lastLoginAt;

  /// Consecutive failed code attempts; drives lockout.
  late final _is.ColumnInt totpFailedAttempts;

  /// Attempts are rejected until this time; null when unlocked.
  late final _is.ColumnDateTime totpLockedUntil;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    status,
    totpSecret,
    recoveryCodes,
    totpLastUsedCounter,
    lastLoginAt,
    totpFailedAttempts,
    totpLockedUntil,
    createdAt,
    updatedAt,
  ];
}

class AdminProfileInclude extends _is.IncludeObject {
  AdminProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AdminProfile.t;
}

class AdminProfileIncludeList extends _is.IncludeList {
  AdminProfileIncludeList._({
    _is.WhereExpressionBuilder<AdminProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AdminProfile.t;
}

class AdminProfileRepository {
  const AdminProfileRepository._();

  /// Returns a list of [AdminProfile]s matching the given query parameters.
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
  Future<List<AdminProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminProfileTable>? orderBy,
    _is.OrderByListBuilder<AdminProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminProfile>(
      where: where?.call(AdminProfile.t),
      orderBy: orderBy?.call(AdminProfile.t),
      orderByList: orderByList?.call(AdminProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AdminProfile]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `AdminProfile.t`.
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
  _ida.Stream<List<AdminProfile>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminProfileTable>? orderBy,
    _is.OrderByListBuilder<AdminProfileTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AdminProfile>(
      where: where?.call(AdminProfile.t),
      orderBy: orderBy?.call(AdminProfile.t),
      orderByList: orderByList?.call(AdminProfile.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AdminProfile] matching the given query parameters.
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
  Future<AdminProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<AdminProfileTable>? orderBy,
    _is.OrderByListBuilder<AdminProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminProfile>(
      where: where?.call(AdminProfile.t),
      orderBy: orderBy?.call(AdminProfile.t),
      orderByList: orderByList?.call(AdminProfile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminProfile] by its [id] or null if no such row exists.
  Future<AdminProfile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminProfile]s will have their `id` fields set.
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
  Future<List<AdminProfile>> insert(
    _is.DatabaseSession session,
    List<AdminProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AdminProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AdminProfile] and returns the inserted row.
  ///
  /// The returned [AdminProfile] will have its `id` field set.
  Future<AdminProfile> insertRow(
    _is.DatabaseSession session,
    AdminProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AdminProfile]s in the list and returns the resulting rows.
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
  /// The returned [AdminProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminProfile>> upsert(
    _is.DatabaseSession session,
    List<AdminProfile> rows, {
    required _is.ColumnSelections<AdminProfileTable> conflictColumns,
    _is.ColumnSelections<AdminProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AdminProfile>(
      rows,
      conflictColumns: conflictColumns(AdminProfile.t),
      updateColumns: updateColumns?.call(AdminProfile.t),
      updateWhere: updateWhere?.call(AdminProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AdminProfile] and returns the resulting row.
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
  /// The returned [AdminProfile] will have its `id` field set.
  Future<AdminProfile?> upsertRow(
    _is.DatabaseSession session,
    AdminProfile row, {
    required _is.ColumnSelections<AdminProfileTable> conflictColumns,
    _is.ColumnSelections<AdminProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AdminProfile>(
      row,
      conflictColumns: conflictColumns(AdminProfile.t),
      updateColumns: updateColumns?.call(AdminProfile.t),
      updateWhere: updateWhere?.call(AdminProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [AdminProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminProfile>> update(
    _is.DatabaseSession session,
    List<AdminProfile> rows, {
    _is.ColumnSelections<AdminProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AdminProfile>(
      rows,
      columns: columns?.call(AdminProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AdminProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminProfile> updateRow(
    _is.DatabaseSession session,
    AdminProfile row, {
    _is.ColumnSelections<AdminProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminProfile>(
      row,
      columns: columns?.call(AdminProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminProfile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AdminProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminProfile>(
      id,
      columnValues: columnValues(AdminProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AdminProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AdminProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminProfileTable>? orderBy,
    _is.OrderByListBuilder<AdminProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AdminProfile>(
      columnValues: columnValues(AdminProfile.t.updateTable),
      where: where(AdminProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminProfile.t),
      orderByList: orderByList?.call(AdminProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AdminProfile]s in the list and returns the deleted rows.
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
  Future<List<AdminProfile>> delete(
    _is.DatabaseSession session,
    List<AdminProfile> rows, {
    _is.OrderByBuilder<AdminProfileTable>? orderBy,
    _is.OrderByListBuilder<AdminProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AdminProfile>(
      rows,
      orderBy: orderBy?.call(AdminProfile.t),
      orderByList: orderByList?.call(AdminProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AdminProfile].
  Future<AdminProfile> deleteRow(
    _is.DatabaseSession session,
    AdminProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminProfile>(
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
  Future<List<AdminProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminProfileTable> where,
    _is.OrderByBuilder<AdminProfileTable>? orderBy,
    _is.OrderByListBuilder<AdminProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AdminProfile>(
      where: where(AdminProfile.t),
      orderBy: orderBy?.call(AdminProfile.t),
      orderByList: orderByList?.call(AdminProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AdminProfile>(
      where: where?.call(AdminProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminProfile>(
      where: where(AdminProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
