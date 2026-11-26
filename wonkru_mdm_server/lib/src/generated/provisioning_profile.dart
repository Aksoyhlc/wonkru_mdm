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

abstract class ProvisioningProfile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ProvisioningProfile._({
    this.id,
    required this.name,
    this.description,
    required this.config,
    bool? isActive,
    this.createdById,
    this.createdAt,
    this.updatedAt,
  }) : isActive = isActive ?? true;

  factory ProvisioningProfile({
    int? id,
    required String name,
    String? description,
    required String config,
    bool? isActive,
    _is.UuidValue? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProvisioningProfileImpl;

  factory ProvisioningProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProvisioningProfile(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      config: jsonSerialization['config'] as String,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdById: jsonSerialization['createdById'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['createdById'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ProvisioningProfileTable();

  static const db = ProvisioningProfileRepository._();

  @override
  int? id;

  String name;

  String? description;

  /// JSON configuration payload.
  String config;

  bool isActive;

  _is.UuidValue? createdById;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProvisioningProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProvisioningProfile copyWith({
    int? id,
    String? name,
    String? description,
    String? config,
    bool? isActive,
    _is.UuidValue? createdById = const _is.$UndefinedUuidValue(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProvisioningProfile',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'config': config,
      'isActive': isActive,
      if (createdById != null) 'createdById': createdById?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProvisioningProfile',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'config': config,
      'isActive': isActive,
      if (createdById != null) 'createdById': createdById?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static ProvisioningProfileInclude include() {
    return ProvisioningProfileInclude._();
  }

  static ProvisioningProfileIncludeList includeList({
    _is.WhereExpressionBuilder<ProvisioningProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProvisioningProfileTable>? orderBy,
    _is.OrderByListBuilder<ProvisioningProfileTable>? orderByList,
    ProvisioningProfileInclude? include,
  }) {
    return ProvisioningProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProvisioningProfile.t),
      orderByList: orderByList?.call(ProvisioningProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProvisioningProfileImpl extends ProvisioningProfile {
  _ProvisioningProfileImpl({
    int? id,
    required String name,
    String? description,
    required String config,
    bool? isActive,
    _is.UuidValue? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         config: config,
         isActive: isActive,
         createdById: createdById,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProvisioningProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProvisioningProfile copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? config,
    bool? isActive,
    _is.UuidValue? createdById = const _is.$UndefinedUuidValue(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return ProvisioningProfile(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      config: config ?? this.config,
      isActive: isActive ?? this.isActive,
      createdById: createdById is _is.UndefinedSentinel
          ? this.createdById
          : createdById,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class ProvisioningProfileUpdateTable
    extends _is.UpdateTable<ProvisioningProfileTable> {
  ProvisioningProfileUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> config(String value) => _is.ColumnValue(
    table.config,
    value,
  );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createdById(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.createdById,
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

class ProvisioningProfileTable extends _is.Table<int?> {
  ProvisioningProfileTable({super.tableRelation})
    : super(tableName: 'provisioning_profiles') {
    updateTable = ProvisioningProfileUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    config = _is.ColumnString(
      'config',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
    createdById = _is.ColumnUuid(
      'createdById',
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

  late final ProvisioningProfileUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  /// JSON configuration payload.
  late final _is.ColumnString config;

  late final _is.ColumnBool isActive;

  late final _is.ColumnUuid createdById;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    description,
    config,
    isActive,
    createdById,
    createdAt,
    updatedAt,
  ];
}

class ProvisioningProfileInclude extends _is.IncludeObject {
  ProvisioningProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ProvisioningProfile.t;
}

class ProvisioningProfileIncludeList extends _is.IncludeList {
  ProvisioningProfileIncludeList._({
    _is.WhereExpressionBuilder<ProvisioningProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProvisioningProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProvisioningProfile.t;
}

class ProvisioningProfileRepository {
  const ProvisioningProfileRepository._();

  /// Returns a list of [ProvisioningProfile]s matching the given query parameters.
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
  Future<List<ProvisioningProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProvisioningProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProvisioningProfileTable>? orderBy,
    _is.OrderByListBuilder<ProvisioningProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProvisioningProfile>(
      where: where?.call(ProvisioningProfile.t),
      orderBy: orderBy?.call(ProvisioningProfile.t),
      orderByList: orderByList?.call(ProvisioningProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ProvisioningProfile]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ProvisioningProfile.t`.
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
  _ida.Stream<List<ProvisioningProfile>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProvisioningProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProvisioningProfileTable>? orderBy,
    _is.OrderByListBuilder<ProvisioningProfileTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ProvisioningProfile>(
      where: where?.call(ProvisioningProfile.t),
      orderBy: orderBy?.call(ProvisioningProfile.t),
      orderByList: orderByList?.call(ProvisioningProfile.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ProvisioningProfile] matching the given query parameters.
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
  Future<ProvisioningProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProvisioningProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<ProvisioningProfileTable>? orderBy,
    _is.OrderByListBuilder<ProvisioningProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProvisioningProfile>(
      where: where?.call(ProvisioningProfile.t),
      orderBy: orderBy?.call(ProvisioningProfile.t),
      orderByList: orderByList?.call(ProvisioningProfile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProvisioningProfile] by its [id] or null if no such row exists.
  Future<ProvisioningProfile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProvisioningProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProvisioningProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [ProvisioningProfile]s will have their `id` fields set.
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
  Future<List<ProvisioningProfile>> insert(
    _is.DatabaseSession session,
    List<ProvisioningProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProvisioningProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProvisioningProfile] and returns the inserted row.
  ///
  /// The returned [ProvisioningProfile] will have its `id` field set.
  Future<ProvisioningProfile> insertRow(
    _is.DatabaseSession session,
    ProvisioningProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProvisioningProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProvisioningProfile]s in the list and returns the resulting rows.
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
  /// The returned [ProvisioningProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProvisioningProfile>> upsert(
    _is.DatabaseSession session,
    List<ProvisioningProfile> rows, {
    required _is.ColumnSelections<ProvisioningProfileTable> conflictColumns,
    _is.ColumnSelections<ProvisioningProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<ProvisioningProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProvisioningProfile>(
      rows,
      conflictColumns: conflictColumns(ProvisioningProfile.t),
      updateColumns: updateColumns?.call(ProvisioningProfile.t),
      updateWhere: updateWhere?.call(ProvisioningProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProvisioningProfile] and returns the resulting row.
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
  /// The returned [ProvisioningProfile] will have its `id` field set.
  Future<ProvisioningProfile?> upsertRow(
    _is.DatabaseSession session,
    ProvisioningProfile row, {
    required _is.ColumnSelections<ProvisioningProfileTable> conflictColumns,
    _is.ColumnSelections<ProvisioningProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<ProvisioningProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProvisioningProfile>(
      row,
      conflictColumns: conflictColumns(ProvisioningProfile.t),
      updateColumns: updateColumns?.call(ProvisioningProfile.t),
      updateWhere: updateWhere?.call(ProvisioningProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProvisioningProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProvisioningProfile>> update(
    _is.DatabaseSession session,
    List<ProvisioningProfile> rows, {
    _is.ColumnSelections<ProvisioningProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProvisioningProfile>(
      rows,
      columns: columns?.call(ProvisioningProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProvisioningProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProvisioningProfile> updateRow(
    _is.DatabaseSession session,
    ProvisioningProfile row, {
    _is.ColumnSelections<ProvisioningProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProvisioningProfile>(
      row,
      columns: columns?.call(ProvisioningProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProvisioningProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProvisioningProfile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProvisioningProfileUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProvisioningProfile>(
      id,
      columnValues: columnValues(ProvisioningProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProvisioningProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProvisioningProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProvisioningProfileUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProvisioningProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProvisioningProfileTable>? orderBy,
    _is.OrderByListBuilder<ProvisioningProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProvisioningProfile>(
      columnValues: columnValues(ProvisioningProfile.t.updateTable),
      where: where(ProvisioningProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProvisioningProfile.t),
      orderByList: orderByList?.call(ProvisioningProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProvisioningProfile]s in the list and returns the deleted rows.
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
  Future<List<ProvisioningProfile>> delete(
    _is.DatabaseSession session,
    List<ProvisioningProfile> rows, {
    _is.OrderByBuilder<ProvisioningProfileTable>? orderBy,
    _is.OrderByListBuilder<ProvisioningProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProvisioningProfile>(
      rows,
      orderBy: orderBy?.call(ProvisioningProfile.t),
      orderByList: orderByList?.call(ProvisioningProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProvisioningProfile].
  Future<ProvisioningProfile> deleteRow(
    _is.DatabaseSession session,
    ProvisioningProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProvisioningProfile>(
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
  Future<List<ProvisioningProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProvisioningProfileTable> where,
    _is.OrderByBuilder<ProvisioningProfileTable>? orderBy,
    _is.OrderByListBuilder<ProvisioningProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProvisioningProfile>(
      where: where(ProvisioningProfile.t),
      orderBy: orderBy?.call(ProvisioningProfile.t),
      orderByList: orderByList?.call(ProvisioningProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProvisioningProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProvisioningProfile>(
      where: where?.call(ProvisioningProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProvisioningProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProvisioningProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProvisioningProfile>(
      where: where(ProvisioningProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
