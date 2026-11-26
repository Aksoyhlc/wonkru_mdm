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

abstract class Certificate
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Certificate._({
    this.id,
    required this.name,
    this.description,
    required this.certificateType,
    required this.certificateData,
    this.privateKeyData,
    required this.format,
    this.issuer,
    this.subject,
    this.serialNumber,
    this.fingerprintSha256,
    this.validFrom,
    this.validUntil,
    bool? isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.filePath,
    this.fileHash,
    this.password,
  }) : isActive = isActive ?? true;

  factory Certificate({
    int? id,
    required String name,
    String? description,
    required _i3xu12wm.CertificateType certificateType,
    required String certificateData,
    String? privateKeyData,
    required _i3xu12wm.CertificateFormat format,
    String? issuer,
    String? subject,
    String? serialNumber,
    String? fingerprintSha256,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? filePath,
    String? fileHash,
    String? password,
  }) = _CertificateImpl;

  factory Certificate.fromJson(Map<String, dynamic> jsonSerialization) {
    return Certificate(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      certificateType: _i3xu12wm.CertificateType.fromJson(
        (jsonSerialization['certificateType'] as String),
      ),
      certificateData: jsonSerialization['certificateData'] as String,
      privateKeyData: jsonSerialization['privateKeyData'] as String?,
      format: _i3xu12wm.CertificateFormat.fromJson(
        (jsonSerialization['format'] as String),
      ),
      issuer: jsonSerialization['issuer'] as String?,
      subject: jsonSerialization['subject'] as String?,
      serialNumber: jsonSerialization['serialNumber'] as String?,
      fingerprintSha256: jsonSerialization['fingerprintSha256'] as String?,
      validFrom: jsonSerialization['validFrom'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['validFrom']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['validUntil']),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      filePath: jsonSerialization['filePath'] as String?,
      fileHash: jsonSerialization['fileHash'] as String?,
      password: jsonSerialization['password'] as String?,
    );
  }

  static final t = CertificateTable();

  static const db = CertificateRepository._();

  @override
  int? id;

  String name;

  String? description;

  _i3xu12wm.CertificateType certificateType;

  /// PEM encoded.
  String certificateData;

  /// PEM encoded.
  String? privateKeyData;

  _i3xu12wm.CertificateFormat format;

  String? issuer;

  String? subject;

  String? serialNumber;

  String? fingerprintSha256;

  DateTime? validFrom;

  DateTime? validUntil;

  bool isActive;

  DateTime? createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  String? filePath;

  String? fileHash;

  String? password;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Certificate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Certificate copyWith({
    int? id,
    String? name,
    String? description,
    _i3xu12wm.CertificateType? certificateType,
    String? certificateData,
    String? privateKeyData,
    _i3xu12wm.CertificateFormat? format,
    String? issuer,
    String? subject,
    String? serialNumber,
    String? fingerprintSha256,
    DateTime? validFrom = const _is.$UndefinedDateTime(),
    DateTime? validUntil = const _is.$UndefinedDateTime(),
    bool? isActive,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
    DateTime? deletedAt = const _is.$UndefinedDateTime(),
    String? filePath,
    String? fileHash,
    String? password,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Certificate',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'certificateType': certificateType.toJson(),
      'certificateData': certificateData,
      if (privateKeyData != null) 'privateKeyData': privateKeyData,
      'format': format.toJson(),
      if (issuer != null) 'issuer': issuer,
      if (subject != null) 'subject': subject,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (fingerprintSha256 != null) 'fingerprintSha256': fingerprintSha256,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (filePath != null) 'filePath': filePath,
      if (fileHash != null) 'fileHash': fileHash,
      if (password != null) 'password': password,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Certificate',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'certificateType': certificateType.toJson(),
      'certificateData': certificateData,
      if (privateKeyData != null) 'privateKeyData': privateKeyData,
      'format': format.toJson(),
      if (issuer != null) 'issuer': issuer,
      if (subject != null) 'subject': subject,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (fingerprintSha256 != null) 'fingerprintSha256': fingerprintSha256,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (filePath != null) 'filePath': filePath,
      if (fileHash != null) 'fileHash': fileHash,
      if (password != null) 'password': password,
    };
  }

  static CertificateInclude include() {
    return CertificateInclude._();
  }

  static CertificateIncludeList includeList({
    _is.WhereExpressionBuilder<CertificateTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CertificateTable>? orderBy,
    _is.OrderByListBuilder<CertificateTable>? orderByList,
    CertificateInclude? include,
  }) {
    return CertificateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Certificate.t),
      orderByList: orderByList?.call(Certificate.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CertificateImpl extends Certificate {
  _CertificateImpl({
    int? id,
    required String name,
    String? description,
    required _i3xu12wm.CertificateType certificateType,
    required String certificateData,
    String? privateKeyData,
    required _i3xu12wm.CertificateFormat format,
    String? issuer,
    String? subject,
    String? serialNumber,
    String? fingerprintSha256,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? filePath,
    String? fileHash,
    String? password,
  }) : super._(
         id: id,
         name: name,
         description: description,
         certificateType: certificateType,
         certificateData: certificateData,
         privateKeyData: privateKeyData,
         format: format,
         issuer: issuer,
         subject: subject,
         serialNumber: serialNumber,
         fingerprintSha256: fingerprintSha256,
         validFrom: validFrom,
         validUntil: validUntil,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         filePath: filePath,
         fileHash: fileHash,
         password: password,
       );

  /// Returns a shallow copy of this [Certificate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Certificate copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    _i3xu12wm.CertificateType? certificateType,
    String? certificateData,
    Object? privateKeyData = _Undefined,
    _i3xu12wm.CertificateFormat? format,
    Object? issuer = _Undefined,
    Object? subject = _Undefined,
    Object? serialNumber = _Undefined,
    Object? fingerprintSha256 = _Undefined,
    DateTime? validFrom = const _is.$UndefinedDateTime(),
    DateTime? validUntil = const _is.$UndefinedDateTime(),
    bool? isActive,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
    DateTime? deletedAt = const _is.$UndefinedDateTime(),
    Object? filePath = _Undefined,
    Object? fileHash = _Undefined,
    Object? password = _Undefined,
  }) {
    return Certificate(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      certificateType: certificateType ?? this.certificateType,
      certificateData: certificateData ?? this.certificateData,
      privateKeyData: privateKeyData is String?
          ? privateKeyData
          : this.privateKeyData,
      format: format ?? this.format,
      issuer: issuer is String? ? issuer : this.issuer,
      subject: subject is String? ? subject : this.subject,
      serialNumber: serialNumber is String? ? serialNumber : this.serialNumber,
      fingerprintSha256: fingerprintSha256 is String?
          ? fingerprintSha256
          : this.fingerprintSha256,
      validFrom: validFrom is _is.UndefinedSentinel
          ? this.validFrom
          : validFrom,
      validUntil: validUntil is _is.UndefinedSentinel
          ? this.validUntil
          : validUntil,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
      deletedAt: deletedAt is _is.UndefinedSentinel
          ? this.deletedAt
          : deletedAt,
      filePath: filePath is String? ? filePath : this.filePath,
      fileHash: fileHash is String? ? fileHash : this.fileHash,
      password: password is String? ? password : this.password,
    );
  }
}

class CertificateUpdateTable extends _is.UpdateTable<CertificateTable> {
  CertificateUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<_i3xu12wm.CertificateType, _i3xu12wm.CertificateType>
  certificateType(_i3xu12wm.CertificateType value) => _is.ColumnValue(
    table.certificateType,
    value,
  );

  _is.ColumnValue<String, String> certificateData(String value) =>
      _is.ColumnValue(
        table.certificateData,
        value,
      );

  _is.ColumnValue<String, String> privateKeyData(String? value) =>
      _is.ColumnValue(
        table.privateKeyData,
        value,
      );

  _is.ColumnValue<_i3xu12wm.CertificateFormat, _i3xu12wm.CertificateFormat>
  format(_i3xu12wm.CertificateFormat value) => _is.ColumnValue(
    table.format,
    value,
  );

  _is.ColumnValue<String, String> issuer(String? value) => _is.ColumnValue(
    table.issuer,
    value,
  );

  _is.ColumnValue<String, String> subject(String? value) => _is.ColumnValue(
    table.subject,
    value,
  );

  _is.ColumnValue<String, String> serialNumber(String? value) =>
      _is.ColumnValue(
        table.serialNumber,
        value,
      );

  _is.ColumnValue<String, String> fingerprintSha256(String? value) =>
      _is.ColumnValue(
        table.fingerprintSha256,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> validFrom(DateTime? value) =>
      _is.ColumnValue(
        table.validFrom,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> validUntil(DateTime? value) =>
      _is.ColumnValue(
        table.validUntil,
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

  _is.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _is.ColumnValue(
        table.deletedAt,
        value,
      );

  _is.ColumnValue<String, String> filePath(String? value) => _is.ColumnValue(
    table.filePath,
    value,
  );

  _is.ColumnValue<String, String> fileHash(String? value) => _is.ColumnValue(
    table.fileHash,
    value,
  );

  _is.ColumnValue<String, String> password(String? value) => _is.ColumnValue(
    table.password,
    value,
  );
}

class CertificateTable extends _is.Table<int?> {
  CertificateTable({super.tableRelation}) : super(tableName: 'certificates') {
    updateTable = CertificateUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    certificateType = _is.ColumnEnum(
      'certificateType',
      this,
      _is.EnumSerialization.byName,
    );
    certificateData = _is.ColumnString(
      'certificateData',
      this,
    );
    privateKeyData = _is.ColumnString(
      'privateKeyData',
      this,
    );
    format = _is.ColumnEnum(
      'format',
      this,
      _is.EnumSerialization.byName,
    );
    issuer = _is.ColumnString(
      'issuer',
      this,
    );
    subject = _is.ColumnString(
      'subject',
      this,
    );
    serialNumber = _is.ColumnString(
      'serialNumber',
      this,
    );
    fingerprintSha256 = _is.ColumnString(
      'fingerprintSha256',
      this,
    );
    validFrom = _is.ColumnDateTime(
      'validFrom',
      this,
    );
    validUntil = _is.ColumnDateTime(
      'validUntil',
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
    deletedAt = _is.ColumnDateTime(
      'deletedAt',
      this,
    );
    filePath = _is.ColumnString(
      'filePath',
      this,
    );
    fileHash = _is.ColumnString(
      'fileHash',
      this,
    );
    password = _is.ColumnString(
      'password',
      this,
    );
  }

  late final CertificateUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  late final _is.ColumnEnum<_i3xu12wm.CertificateType> certificateType;

  /// PEM encoded.
  late final _is.ColumnString certificateData;

  /// PEM encoded.
  late final _is.ColumnString privateKeyData;

  late final _is.ColumnEnum<_i3xu12wm.CertificateFormat> format;

  late final _is.ColumnString issuer;

  late final _is.ColumnString subject;

  late final _is.ColumnString serialNumber;

  late final _is.ColumnString fingerprintSha256;

  late final _is.ColumnDateTime validFrom;

  late final _is.ColumnDateTime validUntil;

  late final _is.ColumnBool isActive;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime deletedAt;

  late final _is.ColumnString filePath;

  late final _is.ColumnString fileHash;

  late final _is.ColumnString password;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    description,
    certificateType,
    certificateData,
    privateKeyData,
    format,
    issuer,
    subject,
    serialNumber,
    fingerprintSha256,
    validFrom,
    validUntil,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    filePath,
    fileHash,
    password,
  ];
}

class CertificateInclude extends _is.IncludeObject {
  CertificateInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Certificate.t;
}

class CertificateIncludeList extends _is.IncludeList {
  CertificateIncludeList._({
    _is.WhereExpressionBuilder<CertificateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Certificate.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Certificate.t;
}

class CertificateRepository {
  const CertificateRepository._();

  /// Returns a list of [Certificate]s matching the given query parameters.
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
  Future<List<Certificate>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CertificateTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CertificateTable>? orderBy,
    _is.OrderByListBuilder<CertificateTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Certificate>(
      where: where?.call(Certificate.t),
      orderBy: orderBy?.call(Certificate.t),
      orderByList: orderByList?.call(Certificate.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Certificate]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Certificate.t`.
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
  _ida.Stream<List<Certificate>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CertificateTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CertificateTable>? orderBy,
    _is.OrderByListBuilder<CertificateTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Certificate>(
      where: where?.call(Certificate.t),
      orderBy: orderBy?.call(Certificate.t),
      orderByList: orderByList?.call(Certificate.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Certificate] matching the given query parameters.
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
  Future<Certificate?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CertificateTable>? where,
    int? offset,
    _is.OrderByBuilder<CertificateTable>? orderBy,
    _is.OrderByListBuilder<CertificateTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Certificate>(
      where: where?.call(Certificate.t),
      orderBy: orderBy?.call(Certificate.t),
      orderByList: orderByList?.call(Certificate.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Certificate] by its [id] or null if no such row exists.
  Future<Certificate?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Certificate>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Certificate]s in the list and returns the inserted rows.
  ///
  /// The returned [Certificate]s will have their `id` fields set.
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
  Future<List<Certificate>> insert(
    _is.DatabaseSession session,
    List<Certificate> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Certificate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Certificate] and returns the inserted row.
  ///
  /// The returned [Certificate] will have its `id` field set.
  Future<Certificate> insertRow(
    _is.DatabaseSession session,
    Certificate row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Certificate>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Certificate]s in the list and returns the resulting rows.
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
  /// The returned [Certificate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Certificate>> upsert(
    _is.DatabaseSession session,
    List<Certificate> rows, {
    required _is.ColumnSelections<CertificateTable> conflictColumns,
    _is.ColumnSelections<CertificateTable>? updateColumns,
    _is.WhereExpressionBuilder<CertificateTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Certificate>(
      rows,
      conflictColumns: conflictColumns(Certificate.t),
      updateColumns: updateColumns?.call(Certificate.t),
      updateWhere: updateWhere?.call(Certificate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Certificate] and returns the resulting row.
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
  /// The returned [Certificate] will have its `id` field set.
  Future<Certificate?> upsertRow(
    _is.DatabaseSession session,
    Certificate row, {
    required _is.ColumnSelections<CertificateTable> conflictColumns,
    _is.ColumnSelections<CertificateTable>? updateColumns,
    _is.WhereExpressionBuilder<CertificateTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Certificate>(
      row,
      conflictColumns: conflictColumns(Certificate.t),
      updateColumns: updateColumns?.call(Certificate.t),
      updateWhere: updateWhere?.call(Certificate.t),
      transaction: transaction,
    );
  }

  /// Updates all [Certificate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Certificate>> update(
    _is.DatabaseSession session,
    List<Certificate> rows, {
    _is.ColumnSelections<CertificateTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Certificate>(
      rows,
      columns: columns?.call(Certificate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Certificate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Certificate> updateRow(
    _is.DatabaseSession session,
    Certificate row, {
    _is.ColumnSelections<CertificateTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Certificate>(
      row,
      columns: columns?.call(Certificate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Certificate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Certificate?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CertificateUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Certificate>(
      id,
      columnValues: columnValues(Certificate.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Certificate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Certificate>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CertificateUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CertificateTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CertificateTable>? orderBy,
    _is.OrderByListBuilder<CertificateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Certificate>(
      columnValues: columnValues(Certificate.t.updateTable),
      where: where(Certificate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Certificate.t),
      orderByList: orderByList?.call(Certificate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Certificate]s in the list and returns the deleted rows.
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
  Future<List<Certificate>> delete(
    _is.DatabaseSession session,
    List<Certificate> rows, {
    _is.OrderByBuilder<CertificateTable>? orderBy,
    _is.OrderByListBuilder<CertificateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Certificate>(
      rows,
      orderBy: orderBy?.call(Certificate.t),
      orderByList: orderByList?.call(Certificate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Certificate].
  Future<Certificate> deleteRow(
    _is.DatabaseSession session,
    Certificate row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Certificate>(
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
  Future<List<Certificate>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CertificateTable> where,
    _is.OrderByBuilder<CertificateTable>? orderBy,
    _is.OrderByListBuilder<CertificateTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Certificate>(
      where: where(Certificate.t),
      orderBy: orderBy?.call(Certificate.t),
      orderByList: orderByList?.call(Certificate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CertificateTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Certificate>(
      where: where?.call(Certificate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Certificate] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CertificateTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Certificate>(
      where: where(Certificate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
