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
import 'file_asset.dart' as _i44ond0u;
import 'policy.dart' as _if7d246m;

abstract class PolicyFile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PolicyFile._({
    this.id,
    required this.policyId,
    this.policy,
    this.fileId,
    this.file,
    required this.usageType,
    this.destinationPath,
    bool? replaceIfExists,
    bool? openAfterDownload,
    this.createdAt,
    this.updatedAt,
  }) : replaceIfExists = replaceIfExists ?? true,
       openAfterDownload = openAfterDownload ?? false;

  factory PolicyFile({
    int? id,
    required int policyId,
    _if7d246m.Policy? policy,
    int? fileId,
    _i44ond0u.FileAsset? file,
    required _i3xu12wm.FileOperationType usageType,
    String? destinationPath,
    bool? replaceIfExists,
    bool? openAfterDownload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PolicyFileImpl;

  factory PolicyFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return PolicyFile(
      id: jsonSerialization['id'] as int?,
      policyId: jsonSerialization['policyId'] as int,
      policy: jsonSerialization['policy'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_if7d246m.Policy>(
              jsonSerialization['policy'],
            ),
      fileId: jsonSerialization['fileId'] as int?,
      file: jsonSerialization['file'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_i44ond0u.FileAsset>(
              jsonSerialization['file'],
            ),
      usageType: _i3xu12wm.FileOperationType.fromJson(
        (jsonSerialization['usageType'] as String),
      ),
      destinationPath: jsonSerialization['destinationPath'] as String?,
      replaceIfExists: jsonSerialization['replaceIfExists'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['replaceIfExists'],
            ),
      openAfterDownload: jsonSerialization['openAfterDownload'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['openAfterDownload'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = PolicyFileTable();

  static const db = PolicyFileRepository._();

  @override
  int? id;

  int policyId;

  _if7d246m.Policy? policy;

  int? fileId;

  /// Delete operations are fileless (only the device-side path is known), so
  /// the relation is optional.
  _i44ond0u.FileAsset? file;

  _i3xu12wm.FileOperationType usageType;

  String? destinationPath;

  bool replaceIfExists;

  bool openAfterDownload;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PolicyFile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PolicyFile copyWith({
    int? id,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedPolicyFile$policy(),
    int? fileId,
    _i44ond0u.FileAsset? file = const _UndefinedPolicyFile$file(),
    _i3xu12wm.FileOperationType? usageType,
    String? destinationPath,
    bool? replaceIfExists,
    bool? openAfterDownload,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PolicyFile',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      if (fileId != null) 'fileId': fileId,
      if (file != null) 'file': file?.toJson(),
      'usageType': usageType.toJson(),
      if (destinationPath != null) 'destinationPath': destinationPath,
      'replaceIfExists': replaceIfExists,
      'openAfterDownload': openAfterDownload,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PolicyFile',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      if (fileId != null) 'fileId': fileId,
      if (file != null) 'file': file?.toJsonForProtocol(),
      'usageType': usageType.toJson(),
      if (destinationPath != null) 'destinationPath': destinationPath,
      'replaceIfExists': replaceIfExists,
      'openAfterDownload': openAfterDownload,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static PolicyFileInclude include({
    _if7d246m.PolicyInclude? policy,
    _i44ond0u.FileAssetInclude? file,
  }) {
    return PolicyFileInclude._(
      policy: policy,
      file: file,
    );
  }

  static PolicyFileIncludeList includeList({
    _is.WhereExpressionBuilder<PolicyFileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyFileTable>? orderBy,
    _is.OrderByListBuilder<PolicyFileTable>? orderByList,
    PolicyFileInclude? include,
  }) {
    return PolicyFileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PolicyFile.t),
      orderByList: orderByList?.call(PolicyFile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedPolicyFile$policy extends _is.UndefinedSentinel
    implements _if7d246m.Policy {
  const _UndefinedPolicyFile$policy();
}

class _UndefinedPolicyFile$file extends _is.UndefinedSentinel
    implements _i44ond0u.FileAsset {
  const _UndefinedPolicyFile$file();
}

class _PolicyFileImpl extends PolicyFile {
  _PolicyFileImpl({
    int? id,
    required int policyId,
    _if7d246m.Policy? policy,
    int? fileId,
    _i44ond0u.FileAsset? file,
    required _i3xu12wm.FileOperationType usageType,
    String? destinationPath,
    bool? replaceIfExists,
    bool? openAfterDownload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         policyId: policyId,
         policy: policy,
         fileId: fileId,
         file: file,
         usageType: usageType,
         destinationPath: destinationPath,
         replaceIfExists: replaceIfExists,
         openAfterDownload: openAfterDownload,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PolicyFile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PolicyFile copyWith({
    Object? id = _Undefined,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedPolicyFile$policy(),
    Object? fileId = _Undefined,
    _i44ond0u.FileAsset? file = const _UndefinedPolicyFile$file(),
    _i3xu12wm.FileOperationType? usageType,
    Object? destinationPath = _Undefined,
    bool? replaceIfExists,
    bool? openAfterDownload,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return PolicyFile(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _is.UndefinedSentinel
          ? this.policy?.copyWith()
          : policy,
      fileId: fileId is int? ? fileId : this.fileId,
      file: file is _is.UndefinedSentinel ? this.file?.copyWith() : file,
      usageType: usageType ?? this.usageType,
      destinationPath: destinationPath is String?
          ? destinationPath
          : this.destinationPath,
      replaceIfExists: replaceIfExists ?? this.replaceIfExists,
      openAfterDownload: openAfterDownload ?? this.openAfterDownload,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class PolicyFileUpdateTable extends _is.UpdateTable<PolicyFileTable> {
  PolicyFileUpdateTable(super.table);

  _is.ColumnValue<int, int> policyId(int value) => _is.ColumnValue(
    table.policyId,
    value,
  );

  _is.ColumnValue<int, int> fileId(int? value) => _is.ColumnValue(
    table.fileId,
    value,
  );

  _is.ColumnValue<_i3xu12wm.FileOperationType, _i3xu12wm.FileOperationType>
  usageType(_i3xu12wm.FileOperationType value) => _is.ColumnValue(
    table.usageType,
    value,
  );

  _is.ColumnValue<String, String> destinationPath(String? value) =>
      _is.ColumnValue(
        table.destinationPath,
        value,
      );

  _is.ColumnValue<bool, bool> replaceIfExists(bool value) => _is.ColumnValue(
    table.replaceIfExists,
    value,
  );

  _is.ColumnValue<bool, bool> openAfterDownload(bool value) => _is.ColumnValue(
    table.openAfterDownload,
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

class PolicyFileTable extends _is.Table<int?> {
  PolicyFileTable({super.tableRelation}) : super(tableName: 'policy_files') {
    updateTable = PolicyFileUpdateTable(this);
    policyId = _is.ColumnInt(
      'policyId',
      this,
    );
    fileId = _is.ColumnInt(
      'fileId',
      this,
    );
    usageType = _is.ColumnEnum(
      'usageType',
      this,
      _is.EnumSerialization.byName,
    );
    destinationPath = _is.ColumnString(
      'destinationPath',
      this,
    );
    replaceIfExists = _is.ColumnBool(
      'replaceIfExists',
      this,
    );
    openAfterDownload = _is.ColumnBool(
      'openAfterDownload',
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

  late final PolicyFileUpdateTable updateTable;

  late final _is.ColumnInt policyId;

  _if7d246m.PolicyTable? _policy;

  late final _is.ColumnInt fileId;

  /// Delete operations are fileless (only the device-side path is known), so
  /// the relation is optional.
  _i44ond0u.FileAssetTable? _file;

  late final _is.ColumnEnum<_i3xu12wm.FileOperationType> usageType;

  late final _is.ColumnString destinationPath;

  late final _is.ColumnBool replaceIfExists;

  late final _is.ColumnBool openAfterDownload;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _if7d246m.PolicyTable get policy {
    if (_policy != null) return _policy!;
    _policy = _is.createRelationTable(
      relationFieldName: 'policy',
      field: PolicyFile.t.policyId,
      foreignField: _if7d246m.Policy.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _if7d246m.PolicyTable(tableRelation: foreignTableRelation),
    );
    return _policy!;
  }

  _i44ond0u.FileAssetTable get file {
    if (_file != null) return _file!;
    _file = _is.createRelationTable(
      relationFieldName: 'file',
      field: PolicyFile.t.fileId,
      foreignField: _i44ond0u.FileAsset.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i44ond0u.FileAssetTable(tableRelation: foreignTableRelation),
    );
    return _file!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    policyId,
    fileId,
    usageType,
    destinationPath,
    replaceIfExists,
    openAfterDownload,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'policy') {
      return policy;
    }
    if (relationField == 'file') {
      return file;
    }
    return null;
  }
}

class PolicyFileInclude extends _is.IncludeObject {
  PolicyFileInclude._({
    _if7d246m.PolicyInclude? policy,
    _i44ond0u.FileAssetInclude? file,
  }) {
    _policy = policy;
    _file = file;
  }

  _if7d246m.PolicyInclude? _policy;

  _i44ond0u.FileAssetInclude? _file;

  @override
  Map<String, _is.Include?> get includes => {
    'policy': _policy,
    'file': _file,
  };

  @override
  _is.Table<int?> get table => PolicyFile.t;
}

class PolicyFileIncludeList extends _is.IncludeList {
  PolicyFileIncludeList._({
    _is.WhereExpressionBuilder<PolicyFileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PolicyFile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PolicyFile.t;
}

class PolicyFileRepository {
  const PolicyFileRepository._();

  final attachRow = const PolicyFileAttachRowRepository._();

  final detachRow = const PolicyFileDetachRowRepository._();

  /// Returns a list of [PolicyFile]s matching the given query parameters.
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
  Future<List<PolicyFile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyFileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyFileTable>? orderBy,
    _is.OrderByListBuilder<PolicyFileTable>? orderByList,
    _is.Transaction? transaction,
    PolicyFileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PolicyFile>(
      where: where?.call(PolicyFile.t),
      orderBy: orderBy?.call(PolicyFile.t),
      orderByList: orderByList?.call(PolicyFile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [PolicyFile]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `PolicyFile.t`.
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
  _ida.Stream<List<PolicyFile>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyFileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyFileTable>? orderBy,
    _is.OrderByListBuilder<PolicyFileTable>? orderByList,
    PolicyFileInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<PolicyFile>(
      where: where?.call(PolicyFile.t),
      orderBy: orderBy?.call(PolicyFile.t),
      orderByList: orderByList?.call(PolicyFile.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [PolicyFile] matching the given query parameters.
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
  Future<PolicyFile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyFileTable>? where,
    int? offset,
    _is.OrderByBuilder<PolicyFileTable>? orderBy,
    _is.OrderByListBuilder<PolicyFileTable>? orderByList,
    _is.Transaction? transaction,
    PolicyFileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PolicyFile>(
      where: where?.call(PolicyFile.t),
      orderBy: orderBy?.call(PolicyFile.t),
      orderByList: orderByList?.call(PolicyFile.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PolicyFile] by its [id] or null if no such row exists.
  Future<PolicyFile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    PolicyFileInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PolicyFile>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PolicyFile]s in the list and returns the inserted rows.
  ///
  /// The returned [PolicyFile]s will have their `id` fields set.
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
  Future<List<PolicyFile>> insert(
    _is.DatabaseSession session,
    List<PolicyFile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PolicyFile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PolicyFile] and returns the inserted row.
  ///
  /// The returned [PolicyFile] will have its `id` field set.
  Future<PolicyFile> insertRow(
    _is.DatabaseSession session,
    PolicyFile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PolicyFile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PolicyFile]s in the list and returns the resulting rows.
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
  /// The returned [PolicyFile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyFile>> upsert(
    _is.DatabaseSession session,
    List<PolicyFile> rows, {
    required _is.ColumnSelections<PolicyFileTable> conflictColumns,
    _is.ColumnSelections<PolicyFileTable>? updateColumns,
    _is.WhereExpressionBuilder<PolicyFileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PolicyFile>(
      rows,
      conflictColumns: conflictColumns(PolicyFile.t),
      updateColumns: updateColumns?.call(PolicyFile.t),
      updateWhere: updateWhere?.call(PolicyFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PolicyFile] and returns the resulting row.
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
  /// The returned [PolicyFile] will have its `id` field set.
  Future<PolicyFile?> upsertRow(
    _is.DatabaseSession session,
    PolicyFile row, {
    required _is.ColumnSelections<PolicyFileTable> conflictColumns,
    _is.ColumnSelections<PolicyFileTable>? updateColumns,
    _is.WhereExpressionBuilder<PolicyFileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PolicyFile>(
      row,
      conflictColumns: conflictColumns(PolicyFile.t),
      updateColumns: updateColumns?.call(PolicyFile.t),
      updateWhere: updateWhere?.call(PolicyFile.t),
      transaction: transaction,
    );
  }

  /// Updates all [PolicyFile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyFile>> update(
    _is.DatabaseSession session,
    List<PolicyFile> rows, {
    _is.ColumnSelections<PolicyFileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PolicyFile>(
      rows,
      columns: columns?.call(PolicyFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PolicyFile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PolicyFile> updateRow(
    _is.DatabaseSession session,
    PolicyFile row, {
    _is.ColumnSelections<PolicyFileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PolicyFile>(
      row,
      columns: columns?.call(PolicyFile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PolicyFile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PolicyFile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PolicyFileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PolicyFile>(
      id,
      columnValues: columnValues(PolicyFile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PolicyFile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PolicyFile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PolicyFileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PolicyFileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PolicyFileTable>? orderBy,
    _is.OrderByListBuilder<PolicyFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PolicyFile>(
      columnValues: columnValues(PolicyFile.t.updateTable),
      where: where(PolicyFile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PolicyFile.t),
      orderByList: orderByList?.call(PolicyFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PolicyFile]s in the list and returns the deleted rows.
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
  Future<List<PolicyFile>> delete(
    _is.DatabaseSession session,
    List<PolicyFile> rows, {
    _is.OrderByBuilder<PolicyFileTable>? orderBy,
    _is.OrderByListBuilder<PolicyFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PolicyFile>(
      rows,
      orderBy: orderBy?.call(PolicyFile.t),
      orderByList: orderByList?.call(PolicyFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PolicyFile].
  Future<PolicyFile> deleteRow(
    _is.DatabaseSession session,
    PolicyFile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PolicyFile>(
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
  Future<List<PolicyFile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PolicyFileTable> where,
    _is.OrderByBuilder<PolicyFileTable>? orderBy,
    _is.OrderByListBuilder<PolicyFileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PolicyFile>(
      where: where(PolicyFile.t),
      orderBy: orderBy?.call(PolicyFile.t),
      orderByList: orderByList?.call(PolicyFile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PolicyFileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PolicyFile>(
      where: where?.call(PolicyFile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PolicyFile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PolicyFileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PolicyFile>(
      where: where(PolicyFile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PolicyFileAttachRowRepository {
  const PolicyFileAttachRowRepository._();

  /// Creates a relation between the given [PolicyFile] and [Policy]
  /// by setting the [PolicyFile]'s foreign key `policyId` to refer to the [Policy].
  Future<void> policy(
    _is.DatabaseSession session,
    PolicyFile policyFile,
    _if7d246m.Policy policy, {
    _is.Transaction? transaction,
  }) async {
    if (policyFile.id == null) {
      throw ArgumentError.notNull('policyFile.id');
    }
    if (policy.id == null) {
      throw ArgumentError.notNull('policy.id');
    }

    var $policyFile = policyFile.copyWith(policyId: policy.id);
    await session.db.updateRow<PolicyFile>(
      $policyFile,
      columns: [PolicyFile.t.policyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [PolicyFile] and [FileAsset]
  /// by setting the [PolicyFile]'s foreign key `fileId` to refer to the [FileAsset].
  Future<void> file(
    _is.DatabaseSession session,
    PolicyFile policyFile,
    _i44ond0u.FileAsset file, {
    _is.Transaction? transaction,
  }) async {
    if (policyFile.id == null) {
      throw ArgumentError.notNull('policyFile.id');
    }
    if (file.id == null) {
      throw ArgumentError.notNull('file.id');
    }

    var $policyFile = policyFile.copyWith(fileId: file.id);
    await session.db.updateRow<PolicyFile>(
      $policyFile,
      columns: [PolicyFile.t.fileId],
      transaction: transaction,
    );
  }
}

class PolicyFileDetachRowRepository {
  const PolicyFileDetachRowRepository._();

  /// Detaches the relation between this [PolicyFile] and the [FileAsset] set in `file`
  /// by setting the [PolicyFile]'s foreign key `fileId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> file(
    _is.DatabaseSession session,
    PolicyFile policyFile, {
    _is.Transaction? transaction,
  }) async {
    if (policyFile.id == null) {
      throw ArgumentError.notNull('policyFile.id');
    }

    var $policyFile = policyFile.copyWith(fileId: null);
    await session.db.updateRow<PolicyFile>(
      $policyFile,
      columns: [PolicyFile.t.fileId],
      transaction: transaction,
    );
  }
}
