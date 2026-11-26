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

abstract class FileGroup
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  FileGroup._({
    this.id,
    required this.name,
    this.description,
    this.color,
    bool? isActive,
    this.createdAt,
    this.updatedAt,
  }) : isActive = isActive ?? true;

  factory FileGroup({
    int? id,
    required String name,
    String? description,
    String? color,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FileGroupImpl;

  factory FileGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return FileGroup(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      color: jsonSerialization['color'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = FileGroupTable();

  static const db = FileGroupRepository._();

  @override
  int? id;

  String name;

  String? description;

  String? color;

  bool isActive;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FileGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FileGroup copyWith({
    int? id,
    String? name,
    String? description,
    String? color,
    bool? isActive,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileGroup',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileGroup',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static FileGroupInclude include() {
    return FileGroupInclude._();
  }

  static FileGroupIncludeList includeList({
    _is.WhereExpressionBuilder<FileGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileGroupTable>? orderBy,
    _is.OrderByListBuilder<FileGroupTable>? orderByList,
    FileGroupInclude? include,
  }) {
    return FileGroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FileGroup.t),
      orderByList: orderByList?.call(FileGroup.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FileGroupImpl extends FileGroup {
  _FileGroupImpl({
    int? id,
    required String name,
    String? description,
    String? color,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         color: color,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FileGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FileGroup copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    Object? color = _Undefined,
    bool? isActive,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return FileGroup(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      color: color is String? ? color : this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class FileGroupUpdateTable extends _is.UpdateTable<FileGroupTable> {
  FileGroupUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> color(String? value) => _is.ColumnValue(
    table.color,
    value,
  );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
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

class FileGroupTable extends _is.Table<int?> {
  FileGroupTable({super.tableRelation}) : super(tableName: 'file_groups') {
    updateTable = FileGroupUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    color = _is.ColumnString(
      'color',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
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

  late final FileGroupUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  late final _is.ColumnString color;

  late final _is.ColumnBool isActive;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    description,
    color,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class FileGroupInclude extends _is.IncludeObject {
  FileGroupInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => FileGroup.t;
}

class FileGroupIncludeList extends _is.IncludeList {
  FileGroupIncludeList._({
    _is.WhereExpressionBuilder<FileGroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FileGroup.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FileGroup.t;
}

class FileGroupRepository {
  const FileGroupRepository._();

  /// Returns a list of [FileGroup]s matching the given query parameters.
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
  Future<List<FileGroup>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileGroupTable>? orderBy,
    _is.OrderByListBuilder<FileGroupTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FileGroup>(
      where: where?.call(FileGroup.t),
      orderBy: orderBy?.call(FileGroup.t),
      orderByList: orderByList?.call(FileGroup.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [FileGroup]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `FileGroup.t`.
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
  _ida.Stream<List<FileGroup>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileGroupTable>? orderBy,
    _is.OrderByListBuilder<FileGroupTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<FileGroup>(
      where: where?.call(FileGroup.t),
      orderBy: orderBy?.call(FileGroup.t),
      orderByList: orderByList?.call(FileGroup.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [FileGroup] matching the given query parameters.
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
  Future<FileGroup?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileGroupTable>? where,
    int? offset,
    _is.OrderByBuilder<FileGroupTable>? orderBy,
    _is.OrderByListBuilder<FileGroupTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FileGroup>(
      where: where?.call(FileGroup.t),
      orderBy: orderBy?.call(FileGroup.t),
      orderByList: orderByList?.call(FileGroup.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FileGroup] by its [id] or null if no such row exists.
  Future<FileGroup?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FileGroup>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FileGroup]s in the list and returns the inserted rows.
  ///
  /// The returned [FileGroup]s will have their `id` fields set.
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
  Future<List<FileGroup>> insert(
    _is.DatabaseSession session,
    List<FileGroup> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FileGroup>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FileGroup] and returns the inserted row.
  ///
  /// The returned [FileGroup] will have its `id` field set.
  Future<FileGroup> insertRow(
    _is.DatabaseSession session,
    FileGroup row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FileGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FileGroup]s in the list and returns the resulting rows.
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
  /// The returned [FileGroup]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileGroup>> upsert(
    _is.DatabaseSession session,
    List<FileGroup> rows, {
    required _is.ColumnSelections<FileGroupTable> conflictColumns,
    _is.ColumnSelections<FileGroupTable>? updateColumns,
    _is.WhereExpressionBuilder<FileGroupTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FileGroup>(
      rows,
      conflictColumns: conflictColumns(FileGroup.t),
      updateColumns: updateColumns?.call(FileGroup.t),
      updateWhere: updateWhere?.call(FileGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FileGroup] and returns the resulting row.
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
  /// The returned [FileGroup] will have its `id` field set.
  Future<FileGroup?> upsertRow(
    _is.DatabaseSession session,
    FileGroup row, {
    required _is.ColumnSelections<FileGroupTable> conflictColumns,
    _is.ColumnSelections<FileGroupTable>? updateColumns,
    _is.WhereExpressionBuilder<FileGroupTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FileGroup>(
      row,
      conflictColumns: conflictColumns(FileGroup.t),
      updateColumns: updateColumns?.call(FileGroup.t),
      updateWhere: updateWhere?.call(FileGroup.t),
      transaction: transaction,
    );
  }

  /// Updates all [FileGroup]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileGroup>> update(
    _is.DatabaseSession session,
    List<FileGroup> rows, {
    _is.ColumnSelections<FileGroupTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FileGroup>(
      rows,
      columns: columns?.call(FileGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FileGroup]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FileGroup> updateRow(
    _is.DatabaseSession session,
    FileGroup row, {
    _is.ColumnSelections<FileGroupTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FileGroup>(
      row,
      columns: columns?.call(FileGroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FileGroup] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FileGroup?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FileGroupUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FileGroup>(
      id,
      columnValues: columnValues(FileGroup.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FileGroup]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileGroup>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FileGroupUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FileGroupTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileGroupTable>? orderBy,
    _is.OrderByListBuilder<FileGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FileGroup>(
      columnValues: columnValues(FileGroup.t.updateTable),
      where: where(FileGroup.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FileGroup.t),
      orderByList: orderByList?.call(FileGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FileGroup]s in the list and returns the deleted rows.
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
  Future<List<FileGroup>> delete(
    _is.DatabaseSession session,
    List<FileGroup> rows, {
    _is.OrderByBuilder<FileGroupTable>? orderBy,
    _is.OrderByListBuilder<FileGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FileGroup>(
      rows,
      orderBy: orderBy?.call(FileGroup.t),
      orderByList: orderByList?.call(FileGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FileGroup].
  Future<FileGroup> deleteRow(
    _is.DatabaseSession session,
    FileGroup row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FileGroup>(
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
  Future<List<FileGroup>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FileGroupTable> where,
    _is.OrderByBuilder<FileGroupTable>? orderBy,
    _is.OrderByListBuilder<FileGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FileGroup>(
      where: where(FileGroup.t),
      orderBy: orderBy?.call(FileGroup.t),
      orderByList: orderByList?.call(FileGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileGroupTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FileGroup>(
      where: where?.call(FileGroup.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FileGroup] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FileGroupTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FileGroup>(
      where: where(FileGroup.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
