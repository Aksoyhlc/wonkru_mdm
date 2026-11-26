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
import 'file_asset.dart' as _i44ond0u;
import 'file_group.dart' as _i8zsj03n;

abstract class FileGroupMember
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  FileGroupMember._({
    this.id,
    required this.fileId,
    this.file,
    required this.fileGroupId,
    this.fileGroup,
    this.createdAt,
    this.updatedAt,
  });

  factory FileGroupMember({
    int? id,
    required int fileId,
    _i44ond0u.FileAsset? file,
    required int fileGroupId,
    _i8zsj03n.FileGroup? fileGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FileGroupMemberImpl;

  factory FileGroupMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return FileGroupMember(
      id: jsonSerialization['id'] as int?,
      fileId: jsonSerialization['fileId'] as int,
      file: jsonSerialization['file'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_i44ond0u.FileAsset>(
              jsonSerialization['file'],
            ),
      fileGroupId: jsonSerialization['fileGroupId'] as int,
      fileGroup: jsonSerialization['fileGroup'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_i8zsj03n.FileGroup>(
              jsonSerialization['fileGroup'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = FileGroupMemberTable();

  static const db = FileGroupMemberRepository._();

  @override
  int? id;

  int fileId;

  _i44ond0u.FileAsset? file;

  int fileGroupId;

  _i8zsj03n.FileGroup? fileGroup;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FileGroupMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FileGroupMember copyWith({
    int? id,
    int? fileId,
    _i44ond0u.FileAsset? file = const _UndefinedFileGroupMember$file(),
    int? fileGroupId,
    _i8zsj03n.FileGroup? fileGroup =
        const _UndefinedFileGroupMember$fileGroup(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileGroupMember',
      if (id != null) 'id': id,
      'fileId': fileId,
      if (file != null) 'file': file?.toJson(),
      'fileGroupId': fileGroupId,
      if (fileGroup != null) 'fileGroup': fileGroup?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileGroupMember',
      if (id != null) 'id': id,
      'fileId': fileId,
      if (file != null) 'file': file?.toJsonForProtocol(),
      'fileGroupId': fileGroupId,
      if (fileGroup != null) 'fileGroup': fileGroup?.toJsonForProtocol(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static FileGroupMemberInclude include({
    _i44ond0u.FileAssetInclude? file,
    _i8zsj03n.FileGroupInclude? fileGroup,
  }) {
    return FileGroupMemberInclude._(
      file: file,
      fileGroup: fileGroup,
    );
  }

  static FileGroupMemberIncludeList includeList({
    _is.WhereExpressionBuilder<FileGroupMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileGroupMemberTable>? orderBy,
    _is.OrderByListBuilder<FileGroupMemberTable>? orderByList,
    FileGroupMemberInclude? include,
  }) {
    return FileGroupMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FileGroupMember.t),
      orderByList: orderByList?.call(FileGroupMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedFileGroupMember$file extends _is.UndefinedSentinel
    implements _i44ond0u.FileAsset {
  const _UndefinedFileGroupMember$file();
}

class _UndefinedFileGroupMember$fileGroup extends _is.UndefinedSentinel
    implements _i8zsj03n.FileGroup {
  const _UndefinedFileGroupMember$fileGroup();
}

class _FileGroupMemberImpl extends FileGroupMember {
  _FileGroupMemberImpl({
    int? id,
    required int fileId,
    _i44ond0u.FileAsset? file,
    required int fileGroupId,
    _i8zsj03n.FileGroup? fileGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         fileId: fileId,
         file: file,
         fileGroupId: fileGroupId,
         fileGroup: fileGroup,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FileGroupMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FileGroupMember copyWith({
    Object? id = _Undefined,
    int? fileId,
    _i44ond0u.FileAsset? file = const _UndefinedFileGroupMember$file(),
    int? fileGroupId,
    _i8zsj03n.FileGroup? fileGroup =
        const _UndefinedFileGroupMember$fileGroup(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return FileGroupMember(
      id: id is int? ? id : this.id,
      fileId: fileId ?? this.fileId,
      file: file is _is.UndefinedSentinel ? this.file?.copyWith() : file,
      fileGroupId: fileGroupId ?? this.fileGroupId,
      fileGroup: fileGroup is _is.UndefinedSentinel
          ? this.fileGroup?.copyWith()
          : fileGroup,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class FileGroupMemberUpdateTable extends _is.UpdateTable<FileGroupMemberTable> {
  FileGroupMemberUpdateTable(super.table);

  _is.ColumnValue<int, int> fileId(int value) => _is.ColumnValue(
    table.fileId,
    value,
  );

  _is.ColumnValue<int, int> fileGroupId(int value) => _is.ColumnValue(
    table.fileGroupId,
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

class FileGroupMemberTable extends _is.Table<int?> {
  FileGroupMemberTable({super.tableRelation})
    : super(tableName: 'file_group_members') {
    updateTable = FileGroupMemberUpdateTable(this);
    fileId = _is.ColumnInt(
      'fileId',
      this,
    );
    fileGroupId = _is.ColumnInt(
      'fileGroupId',
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

  late final FileGroupMemberUpdateTable updateTable;

  late final _is.ColumnInt fileId;

  _i44ond0u.FileAssetTable? _file;

  late final _is.ColumnInt fileGroupId;

  _i8zsj03n.FileGroupTable? _fileGroup;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _i44ond0u.FileAssetTable get file {
    if (_file != null) return _file!;
    _file = _is.createRelationTable(
      relationFieldName: 'file',
      field: FileGroupMember.t.fileId,
      foreignField: _i44ond0u.FileAsset.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i44ond0u.FileAssetTable(tableRelation: foreignTableRelation),
    );
    return _file!;
  }

  _i8zsj03n.FileGroupTable get fileGroup {
    if (_fileGroup != null) return _fileGroup!;
    _fileGroup = _is.createRelationTable(
      relationFieldName: 'fileGroup',
      field: FileGroupMember.t.fileGroupId,
      foreignField: _i8zsj03n.FileGroup.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i8zsj03n.FileGroupTable(tableRelation: foreignTableRelation),
    );
    return _fileGroup!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    fileId,
    fileGroupId,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'file') {
      return file;
    }
    if (relationField == 'fileGroup') {
      return fileGroup;
    }
    return null;
  }
}

class FileGroupMemberInclude extends _is.IncludeObject {
  FileGroupMemberInclude._({
    _i44ond0u.FileAssetInclude? file,
    _i8zsj03n.FileGroupInclude? fileGroup,
  }) {
    _file = file;
    _fileGroup = fileGroup;
  }

  _i44ond0u.FileAssetInclude? _file;

  _i8zsj03n.FileGroupInclude? _fileGroup;

  @override
  Map<String, _is.Include?> get includes => {
    'file': _file,
    'fileGroup': _fileGroup,
  };

  @override
  _is.Table<int?> get table => FileGroupMember.t;
}

class FileGroupMemberIncludeList extends _is.IncludeList {
  FileGroupMemberIncludeList._({
    _is.WhereExpressionBuilder<FileGroupMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FileGroupMember.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FileGroupMember.t;
}

class FileGroupMemberRepository {
  const FileGroupMemberRepository._();

  final attachRow = const FileGroupMemberAttachRowRepository._();

  /// Returns a list of [FileGroupMember]s matching the given query parameters.
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
  Future<List<FileGroupMember>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileGroupMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileGroupMemberTable>? orderBy,
    _is.OrderByListBuilder<FileGroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    FileGroupMemberInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FileGroupMember>(
      where: where?.call(FileGroupMember.t),
      orderBy: orderBy?.call(FileGroupMember.t),
      orderByList: orderByList?.call(FileGroupMember.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [FileGroupMember]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `FileGroupMember.t`.
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
  _ida.Stream<List<FileGroupMember>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileGroupMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileGroupMemberTable>? orderBy,
    _is.OrderByListBuilder<FileGroupMemberTable>? orderByList,
    FileGroupMemberInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<FileGroupMember>(
      where: where?.call(FileGroupMember.t),
      orderBy: orderBy?.call(FileGroupMember.t),
      orderByList: orderByList?.call(FileGroupMember.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [FileGroupMember] matching the given query parameters.
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
  Future<FileGroupMember?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileGroupMemberTable>? where,
    int? offset,
    _is.OrderByBuilder<FileGroupMemberTable>? orderBy,
    _is.OrderByListBuilder<FileGroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    FileGroupMemberInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FileGroupMember>(
      where: where?.call(FileGroupMember.t),
      orderBy: orderBy?.call(FileGroupMember.t),
      orderByList: orderByList?.call(FileGroupMember.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FileGroupMember] by its [id] or null if no such row exists.
  Future<FileGroupMember?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    FileGroupMemberInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FileGroupMember>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FileGroupMember]s in the list and returns the inserted rows.
  ///
  /// The returned [FileGroupMember]s will have their `id` fields set.
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
  Future<List<FileGroupMember>> insert(
    _is.DatabaseSession session,
    List<FileGroupMember> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FileGroupMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FileGroupMember] and returns the inserted row.
  ///
  /// The returned [FileGroupMember] will have its `id` field set.
  Future<FileGroupMember> insertRow(
    _is.DatabaseSession session,
    FileGroupMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FileGroupMember>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FileGroupMember]s in the list and returns the resulting rows.
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
  /// The returned [FileGroupMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileGroupMember>> upsert(
    _is.DatabaseSession session,
    List<FileGroupMember> rows, {
    required _is.ColumnSelections<FileGroupMemberTable> conflictColumns,
    _is.ColumnSelections<FileGroupMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<FileGroupMemberTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FileGroupMember>(
      rows,
      conflictColumns: conflictColumns(FileGroupMember.t),
      updateColumns: updateColumns?.call(FileGroupMember.t),
      updateWhere: updateWhere?.call(FileGroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FileGroupMember] and returns the resulting row.
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
  /// The returned [FileGroupMember] will have its `id` field set.
  Future<FileGroupMember?> upsertRow(
    _is.DatabaseSession session,
    FileGroupMember row, {
    required _is.ColumnSelections<FileGroupMemberTable> conflictColumns,
    _is.ColumnSelections<FileGroupMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<FileGroupMemberTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FileGroupMember>(
      row,
      conflictColumns: conflictColumns(FileGroupMember.t),
      updateColumns: updateColumns?.call(FileGroupMember.t),
      updateWhere: updateWhere?.call(FileGroupMember.t),
      transaction: transaction,
    );
  }

  /// Updates all [FileGroupMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileGroupMember>> update(
    _is.DatabaseSession session,
    List<FileGroupMember> rows, {
    _is.ColumnSelections<FileGroupMemberTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FileGroupMember>(
      rows,
      columns: columns?.call(FileGroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FileGroupMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FileGroupMember> updateRow(
    _is.DatabaseSession session,
    FileGroupMember row, {
    _is.ColumnSelections<FileGroupMemberTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FileGroupMember>(
      row,
      columns: columns?.call(FileGroupMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FileGroupMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FileGroupMember?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FileGroupMemberUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FileGroupMember>(
      id,
      columnValues: columnValues(FileGroupMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FileGroupMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileGroupMember>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FileGroupMemberUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<FileGroupMemberTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileGroupMemberTable>? orderBy,
    _is.OrderByListBuilder<FileGroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FileGroupMember>(
      columnValues: columnValues(FileGroupMember.t.updateTable),
      where: where(FileGroupMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FileGroupMember.t),
      orderByList: orderByList?.call(FileGroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FileGroupMember]s in the list and returns the deleted rows.
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
  Future<List<FileGroupMember>> delete(
    _is.DatabaseSession session,
    List<FileGroupMember> rows, {
    _is.OrderByBuilder<FileGroupMemberTable>? orderBy,
    _is.OrderByListBuilder<FileGroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FileGroupMember>(
      rows,
      orderBy: orderBy?.call(FileGroupMember.t),
      orderByList: orderByList?.call(FileGroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FileGroupMember].
  Future<FileGroupMember> deleteRow(
    _is.DatabaseSession session,
    FileGroupMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FileGroupMember>(
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
  Future<List<FileGroupMember>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FileGroupMemberTable> where,
    _is.OrderByBuilder<FileGroupMemberTable>? orderBy,
    _is.OrderByListBuilder<FileGroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FileGroupMember>(
      where: where(FileGroupMember.t),
      orderBy: orderBy?.call(FileGroupMember.t),
      orderByList: orderByList?.call(FileGroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileGroupMemberTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FileGroupMember>(
      where: where?.call(FileGroupMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FileGroupMember] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FileGroupMemberTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FileGroupMember>(
      where: where(FileGroupMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FileGroupMemberAttachRowRepository {
  const FileGroupMemberAttachRowRepository._();

  /// Creates a relation between the given [FileGroupMember] and [FileAsset]
  /// by setting the [FileGroupMember]'s foreign key `fileId` to refer to the [FileAsset].
  Future<void> file(
    _is.DatabaseSession session,
    FileGroupMember fileGroupMember,
    _i44ond0u.FileAsset file, {
    _is.Transaction? transaction,
  }) async {
    if (fileGroupMember.id == null) {
      throw ArgumentError.notNull('fileGroupMember.id');
    }
    if (file.id == null) {
      throw ArgumentError.notNull('file.id');
    }

    var $fileGroupMember = fileGroupMember.copyWith(fileId: file.id);
    await session.db.updateRow<FileGroupMember>(
      $fileGroupMember,
      columns: [FileGroupMember.t.fileId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [FileGroupMember] and [FileGroup]
  /// by setting the [FileGroupMember]'s foreign key `fileGroupId` to refer to the [FileGroup].
  Future<void> fileGroup(
    _is.DatabaseSession session,
    FileGroupMember fileGroupMember,
    _i8zsj03n.FileGroup fileGroup, {
    _is.Transaction? transaction,
  }) async {
    if (fileGroupMember.id == null) {
      throw ArgumentError.notNull('fileGroupMember.id');
    }
    if (fileGroup.id == null) {
      throw ArgumentError.notNull('fileGroup.id');
    }

    var $fileGroupMember = fileGroupMember.copyWith(fileGroupId: fileGroup.id);
    await session.db.updateRow<FileGroupMember>(
      $fileGroupMember,
      columns: [FileGroupMember.t.fileGroupId],
      transaction: transaction,
    );
  }
}
