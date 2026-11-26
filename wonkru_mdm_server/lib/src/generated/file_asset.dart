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
import 'device.dart' as _ilo09f9g;
import 'enums/storage_disk.dart' as _ixm72k6o;

abstract class FileAsset
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  FileAsset._({
    this.id,
    required this.name,
    this.customName,
    this.fileExtension,
    required this.filePath,
    this.publicUrl,
    this.mimeType,
    required this.sizeBytes,
    this.fileHashSha256,
    this.disk,
    this.deviceId,
    this.device,
    this.createdAt,
    this.updatedAt,
  });

  factory FileAsset({
    int? id,
    required String name,
    String? customName,
    String? fileExtension,
    required String filePath,
    String? publicUrl,
    String? mimeType,
    required int sizeBytes,
    String? fileHashSha256,
    _ixm72k6o.StorageDisk? disk,
    int? deviceId,
    _ilo09f9g.Device? device,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FileAssetImpl;

  factory FileAsset.fromJson(Map<String, dynamic> jsonSerialization) {
    return FileAsset(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      customName: jsonSerialization['customName'] as String?,
      fileExtension: jsonSerialization['fileExtension'] as String?,
      filePath: jsonSerialization['filePath'] as String,
      publicUrl: jsonSerialization['publicUrl'] as String?,
      mimeType: jsonSerialization['mimeType'] as String?,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      fileHashSha256: jsonSerialization['fileHashSha256'] as String?,
      disk: jsonSerialization['disk'] == null
          ? null
          : _ixm72k6o.StorageDisk.fromJson(
              (jsonSerialization['disk'] as String),
            ),
      deviceId: jsonSerialization['deviceId'] as int?,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = FileAssetTable();

  static const db = FileAssetRepository._();

  @override
  int? id;

  String name;

  String? customName;

  String? fileExtension;

  String filePath;

  String? publicUrl;

  String? mimeType;

  int sizeBytes;

  String? fileHashSha256;

  _ixm72k6o.StorageDisk? disk;

  int? deviceId;

  /// Set for files uploaded by the device agent; null for panel files.
  _ilo09f9g.Device? device;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FileAsset]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FileAsset copyWith({
    int? id,
    String? name,
    String? customName,
    String? fileExtension,
    String? filePath,
    String? publicUrl,
    String? mimeType,
    int? sizeBytes,
    String? fileHashSha256,
    _ixm72k6o.StorageDisk? disk,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedFileAsset$device(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileAsset',
      if (id != null) 'id': id,
      'name': name,
      if (customName != null) 'customName': customName,
      if (fileExtension != null) 'fileExtension': fileExtension,
      'filePath': filePath,
      if (publicUrl != null) 'publicUrl': publicUrl,
      if (mimeType != null) 'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (fileHashSha256 != null) 'fileHashSha256': fileHashSha256,
      if (disk != null) 'disk': disk?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileAsset',
      if (id != null) 'id': id,
      'name': name,
      if (customName != null) 'customName': customName,
      if (fileExtension != null) 'fileExtension': fileExtension,
      'filePath': filePath,
      if (publicUrl != null) 'publicUrl': publicUrl,
      if (mimeType != null) 'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (fileHashSha256 != null) 'fileHashSha256': fileHashSha256,
      if (disk != null) 'disk': disk?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static FileAssetInclude include({_ilo09f9g.DeviceInclude? device}) {
    return FileAssetInclude._(device: device);
  }

  static FileAssetIncludeList includeList({
    _is.WhereExpressionBuilder<FileAssetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileAssetTable>? orderBy,
    _is.OrderByListBuilder<FileAssetTable>? orderByList,
    FileAssetInclude? include,
  }) {
    return FileAssetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FileAsset.t),
      orderByList: orderByList?.call(FileAsset.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedFileAsset$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedFileAsset$device();
}

class _FileAssetImpl extends FileAsset {
  _FileAssetImpl({
    int? id,
    required String name,
    String? customName,
    String? fileExtension,
    required String filePath,
    String? publicUrl,
    String? mimeType,
    required int sizeBytes,
    String? fileHashSha256,
    _ixm72k6o.StorageDisk? disk,
    int? deviceId,
    _ilo09f9g.Device? device,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         customName: customName,
         fileExtension: fileExtension,
         filePath: filePath,
         publicUrl: publicUrl,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         fileHashSha256: fileHashSha256,
         disk: disk,
         deviceId: deviceId,
         device: device,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FileAsset]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FileAsset copyWith({
    Object? id = _Undefined,
    String? name,
    Object? customName = _Undefined,
    Object? fileExtension = _Undefined,
    String? filePath,
    Object? publicUrl = _Undefined,
    Object? mimeType = _Undefined,
    int? sizeBytes,
    Object? fileHashSha256 = _Undefined,
    Object? disk = _Undefined,
    Object? deviceId = _Undefined,
    _ilo09f9g.Device? device = const _UndefinedFileAsset$device(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return FileAsset(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      customName: customName is String? ? customName : this.customName,
      fileExtension: fileExtension is String?
          ? fileExtension
          : this.fileExtension,
      filePath: filePath ?? this.filePath,
      publicUrl: publicUrl is String? ? publicUrl : this.publicUrl,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      fileHashSha256: fileHashSha256 is String?
          ? fileHashSha256
          : this.fileHashSha256,
      disk: disk is _ixm72k6o.StorageDisk? ? disk : this.disk,
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}

class FileAssetUpdateTable extends _is.UpdateTable<FileAssetTable> {
  FileAssetUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> customName(String? value) => _is.ColumnValue(
    table.customName,
    value,
  );

  _is.ColumnValue<String, String> fileExtension(String? value) =>
      _is.ColumnValue(
        table.fileExtension,
        value,
      );

  _is.ColumnValue<String, String> filePath(String value) => _is.ColumnValue(
    table.filePath,
    value,
  );

  _is.ColumnValue<String, String> publicUrl(String? value) => _is.ColumnValue(
    table.publicUrl,
    value,
  );

  _is.ColumnValue<String, String> mimeType(String? value) => _is.ColumnValue(
    table.mimeType,
    value,
  );

  _is.ColumnValue<int, int> sizeBytes(int value) => _is.ColumnValue(
    table.sizeBytes,
    value,
  );

  _is.ColumnValue<String, String> fileHashSha256(String? value) =>
      _is.ColumnValue(
        table.fileHashSha256,
        value,
      );

  _is.ColumnValue<_ixm72k6o.StorageDisk, _ixm72k6o.StorageDisk> disk(
    _ixm72k6o.StorageDisk? value,
  ) => _is.ColumnValue(
    table.disk,
    value,
  );

  _is.ColumnValue<int, int> deviceId(int? value) => _is.ColumnValue(
    table.deviceId,
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

class FileAssetTable extends _is.Table<int?> {
  FileAssetTable({super.tableRelation}) : super(tableName: 'files') {
    updateTable = FileAssetUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    customName = _is.ColumnString(
      'customName',
      this,
    );
    fileExtension = _is.ColumnString(
      'fileExtension',
      this,
    );
    filePath = _is.ColumnString(
      'filePath',
      this,
    );
    publicUrl = _is.ColumnString(
      'publicUrl',
      this,
    );
    mimeType = _is.ColumnString(
      'mimeType',
      this,
    );
    sizeBytes = _is.ColumnInt(
      'sizeBytes',
      this,
    );
    fileHashSha256 = _is.ColumnString(
      'fileHashSha256',
      this,
    );
    disk = _is.ColumnEnum(
      'disk',
      this,
      _is.EnumSerialization.byName,
    );
    deviceId = _is.ColumnInt(
      'deviceId',
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

  late final FileAssetUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString customName;

  late final _is.ColumnString fileExtension;

  late final _is.ColumnString filePath;

  late final _is.ColumnString publicUrl;

  late final _is.ColumnString mimeType;

  late final _is.ColumnInt sizeBytes;

  late final _is.ColumnString fileHashSha256;

  late final _is.ColumnEnum<_ixm72k6o.StorageDisk> disk;

  late final _is.ColumnInt deviceId;

  /// Set for files uploaded by the device agent; null for panel files.
  _ilo09f9g.DeviceTable? _device;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: FileAsset.t.deviceId,
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
    name,
    customName,
    fileExtension,
    filePath,
    publicUrl,
    mimeType,
    sizeBytes,
    fileHashSha256,
    disk,
    deviceId,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'device') {
      return device;
    }
    return null;
  }
}

class FileAssetInclude extends _is.IncludeObject {
  FileAssetInclude._({_ilo09f9g.DeviceInclude? device}) {
    _device = device;
  }

  _ilo09f9g.DeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {'device': _device};

  @override
  _is.Table<int?> get table => FileAsset.t;
}

class FileAssetIncludeList extends _is.IncludeList {
  FileAssetIncludeList._({
    _is.WhereExpressionBuilder<FileAssetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FileAsset.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FileAsset.t;
}

class FileAssetRepository {
  const FileAssetRepository._();

  final attachRow = const FileAssetAttachRowRepository._();

  final detachRow = const FileAssetDetachRowRepository._();

  /// Returns a list of [FileAsset]s matching the given query parameters.
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
  Future<List<FileAsset>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileAssetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileAssetTable>? orderBy,
    _is.OrderByListBuilder<FileAssetTable>? orderByList,
    _is.Transaction? transaction,
    FileAssetInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FileAsset>(
      where: where?.call(FileAsset.t),
      orderBy: orderBy?.call(FileAsset.t),
      orderByList: orderByList?.call(FileAsset.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [FileAsset]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `FileAsset.t`.
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
  _ida.Stream<List<FileAsset>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileAssetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileAssetTable>? orderBy,
    _is.OrderByListBuilder<FileAssetTable>? orderByList,
    FileAssetInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<FileAsset>(
      where: where?.call(FileAsset.t),
      orderBy: orderBy?.call(FileAsset.t),
      orderByList: orderByList?.call(FileAsset.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [FileAsset] matching the given query parameters.
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
  Future<FileAsset?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileAssetTable>? where,
    int? offset,
    _is.OrderByBuilder<FileAssetTable>? orderBy,
    _is.OrderByListBuilder<FileAssetTable>? orderByList,
    _is.Transaction? transaction,
    FileAssetInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FileAsset>(
      where: where?.call(FileAsset.t),
      orderBy: orderBy?.call(FileAsset.t),
      orderByList: orderByList?.call(FileAsset.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FileAsset] by its [id] or null if no such row exists.
  Future<FileAsset?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    FileAssetInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FileAsset>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FileAsset]s in the list and returns the inserted rows.
  ///
  /// The returned [FileAsset]s will have their `id` fields set.
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
  Future<List<FileAsset>> insert(
    _is.DatabaseSession session,
    List<FileAsset> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FileAsset>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FileAsset] and returns the inserted row.
  ///
  /// The returned [FileAsset] will have its `id` field set.
  Future<FileAsset> insertRow(
    _is.DatabaseSession session,
    FileAsset row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FileAsset>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FileAsset]s in the list and returns the resulting rows.
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
  /// The returned [FileAsset]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileAsset>> upsert(
    _is.DatabaseSession session,
    List<FileAsset> rows, {
    required _is.ColumnSelections<FileAssetTable> conflictColumns,
    _is.ColumnSelections<FileAssetTable>? updateColumns,
    _is.WhereExpressionBuilder<FileAssetTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FileAsset>(
      rows,
      conflictColumns: conflictColumns(FileAsset.t),
      updateColumns: updateColumns?.call(FileAsset.t),
      updateWhere: updateWhere?.call(FileAsset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FileAsset] and returns the resulting row.
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
  /// The returned [FileAsset] will have its `id` field set.
  Future<FileAsset?> upsertRow(
    _is.DatabaseSession session,
    FileAsset row, {
    required _is.ColumnSelections<FileAssetTable> conflictColumns,
    _is.ColumnSelections<FileAssetTable>? updateColumns,
    _is.WhereExpressionBuilder<FileAssetTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FileAsset>(
      row,
      conflictColumns: conflictColumns(FileAsset.t),
      updateColumns: updateColumns?.call(FileAsset.t),
      updateWhere: updateWhere?.call(FileAsset.t),
      transaction: transaction,
    );
  }

  /// Updates all [FileAsset]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileAsset>> update(
    _is.DatabaseSession session,
    List<FileAsset> rows, {
    _is.ColumnSelections<FileAssetTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FileAsset>(
      rows,
      columns: columns?.call(FileAsset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FileAsset]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FileAsset> updateRow(
    _is.DatabaseSession session,
    FileAsset row, {
    _is.ColumnSelections<FileAssetTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FileAsset>(
      row,
      columns: columns?.call(FileAsset.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FileAsset] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FileAsset?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FileAssetUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FileAsset>(
      id,
      columnValues: columnValues(FileAsset.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FileAsset]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FileAsset>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FileAssetUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FileAssetTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FileAssetTable>? orderBy,
    _is.OrderByListBuilder<FileAssetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FileAsset>(
      columnValues: columnValues(FileAsset.t.updateTable),
      where: where(FileAsset.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FileAsset.t),
      orderByList: orderByList?.call(FileAsset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FileAsset]s in the list and returns the deleted rows.
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
  Future<List<FileAsset>> delete(
    _is.DatabaseSession session,
    List<FileAsset> rows, {
    _is.OrderByBuilder<FileAssetTable>? orderBy,
    _is.OrderByListBuilder<FileAssetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FileAsset>(
      rows,
      orderBy: orderBy?.call(FileAsset.t),
      orderByList: orderByList?.call(FileAsset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FileAsset].
  Future<FileAsset> deleteRow(
    _is.DatabaseSession session,
    FileAsset row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FileAsset>(
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
  Future<List<FileAsset>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FileAssetTable> where,
    _is.OrderByBuilder<FileAssetTable>? orderBy,
    _is.OrderByListBuilder<FileAssetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FileAsset>(
      where: where(FileAsset.t),
      orderBy: orderBy?.call(FileAsset.t),
      orderByList: orderByList?.call(FileAsset.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FileAssetTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FileAsset>(
      where: where?.call(FileAsset.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FileAsset] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FileAssetTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FileAsset>(
      where: where(FileAsset.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FileAssetAttachRowRepository {
  const FileAssetAttachRowRepository._();

  /// Creates a relation between the given [FileAsset] and [Device]
  /// by setting the [FileAsset]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    FileAsset fileAsset,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (fileAsset.id == null) {
      throw ArgumentError.notNull('fileAsset.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $fileAsset = fileAsset.copyWith(deviceId: device.id);
    await session.db.updateRow<FileAsset>(
      $fileAsset,
      columns: [FileAsset.t.deviceId],
      transaction: transaction,
    );
  }
}

class FileAssetDetachRowRepository {
  const FileAssetDetachRowRepository._();

  /// Detaches the relation between this [FileAsset] and the [Device] set in `device`
  /// by setting the [FileAsset]'s foreign key `deviceId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> device(
    _is.DatabaseSession session,
    FileAsset fileAsset, {
    _is.Transaction? transaction,
  }) async {
    if (fileAsset.id == null) {
      throw ArgumentError.notNull('fileAsset.id');
    }

    var $fileAsset = fileAsset.copyWith(deviceId: null);
    await session.db.updateRow<FileAsset>(
      $fileAsset,
      columns: [FileAsset.t.deviceId],
      transaction: transaction,
    );
  }
}
