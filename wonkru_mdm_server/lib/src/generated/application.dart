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
import 'enums/app_source_type.dart' as _iroy7u8c;

abstract class Application
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Application._({
    this.id,
    required this.packageName,
    required this.appName,
    this.developerName,
    this.iconUrl,
    this.category,
    this.sourceType,
    bool? isSystemApp,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : isSystemApp = isSystemApp ?? false;

  factory Application({
    int? id,
    required String packageName,
    required String appName,
    String? developerName,
    String? iconUrl,
    String? category,
    _iroy7u8c.AppSourceType? sourceType,
    bool? isSystemApp,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _ApplicationImpl;

  factory Application.fromJson(Map<String, dynamic> jsonSerialization) {
    return Application(
      id: jsonSerialization['id'] as int?,
      packageName: jsonSerialization['packageName'] as String,
      appName: jsonSerialization['appName'] as String,
      developerName: jsonSerialization['developerName'] as String?,
      iconUrl: jsonSerialization['iconUrl'] as String?,
      category: jsonSerialization['category'] as String?,
      sourceType: jsonSerialization['sourceType'] == null
          ? null
          : _iroy7u8c.AppSourceType.fromJson(
              (jsonSerialization['sourceType'] as String),
            ),
      isSystemApp: jsonSerialization['isSystemApp'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isSystemApp']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = ApplicationTable();

  static const db = ApplicationRepository._();

  @override
  int? id;

  String packageName;

  String appName;

  String? developerName;

  String? iconUrl;

  String? category;

  _iroy7u8c.AppSourceType? sourceType;

  bool isSystemApp;

  DateTime? createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Application]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Application copyWith({
    int? id,
    String? packageName,
    String? appName,
    String? developerName,
    String? iconUrl,
    String? category,
    _iroy7u8c.AppSourceType? sourceType,
    bool? isSystemApp,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
    DateTime? deletedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Application',
      if (id != null) 'id': id,
      'packageName': packageName,
      'appName': appName,
      if (developerName != null) 'developerName': developerName,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (category != null) 'category': category,
      if (sourceType != null) 'sourceType': sourceType?.toJson(),
      'isSystemApp': isSystemApp,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Application',
      if (id != null) 'id': id,
      'packageName': packageName,
      'appName': appName,
      if (developerName != null) 'developerName': developerName,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (category != null) 'category': category,
      if (sourceType != null) 'sourceType': sourceType?.toJson(),
      'isSystemApp': isSystemApp,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static ApplicationInclude include() {
    return ApplicationInclude._();
  }

  static ApplicationIncludeList includeList({
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    ApplicationInclude? include,
  }) {
    return ApplicationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApplicationImpl extends Application {
  _ApplicationImpl({
    int? id,
    required String packageName,
    required String appName,
    String? developerName,
    String? iconUrl,
    String? category,
    _iroy7u8c.AppSourceType? sourceType,
    bool? isSystemApp,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         packageName: packageName,
         appName: appName,
         developerName: developerName,
         iconUrl: iconUrl,
         category: category,
         sourceType: sourceType,
         isSystemApp: isSystemApp,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Application]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Application copyWith({
    Object? id = _Undefined,
    String? packageName,
    String? appName,
    Object? developerName = _Undefined,
    Object? iconUrl = _Undefined,
    Object? category = _Undefined,
    Object? sourceType = _Undefined,
    bool? isSystemApp,
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
    DateTime? deletedAt = const _is.$UndefinedDateTime(),
  }) {
    return Application(
      id: id is int? ? id : this.id,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      developerName: developerName is String?
          ? developerName
          : this.developerName,
      iconUrl: iconUrl is String? ? iconUrl : this.iconUrl,
      category: category is String? ? category : this.category,
      sourceType: sourceType is _iroy7u8c.AppSourceType?
          ? sourceType
          : this.sourceType,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
      deletedAt: deletedAt is _is.UndefinedSentinel
          ? this.deletedAt
          : deletedAt,
    );
  }
}

class ApplicationUpdateTable extends _is.UpdateTable<ApplicationTable> {
  ApplicationUpdateTable(super.table);

  _is.ColumnValue<String, String> packageName(String value) => _is.ColumnValue(
    table.packageName,
    value,
  );

  _is.ColumnValue<String, String> appName(String value) => _is.ColumnValue(
    table.appName,
    value,
  );

  _is.ColumnValue<String, String> developerName(String? value) =>
      _is.ColumnValue(
        table.developerName,
        value,
      );

  _is.ColumnValue<String, String> iconUrl(String? value) => _is.ColumnValue(
    table.iconUrl,
    value,
  );

  _is.ColumnValue<String, String> category(String? value) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<_iroy7u8c.AppSourceType, _iroy7u8c.AppSourceType> sourceType(
    _iroy7u8c.AppSourceType? value,
  ) => _is.ColumnValue(
    table.sourceType,
    value,
  );

  _is.ColumnValue<bool, bool> isSystemApp(bool value) => _is.ColumnValue(
    table.isSystemApp,
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
}

class ApplicationTable extends _is.Table<int?> {
  ApplicationTable({super.tableRelation}) : super(tableName: 'applications') {
    updateTable = ApplicationUpdateTable(this);
    packageName = _is.ColumnString(
      'packageName',
      this,
    );
    appName = _is.ColumnString(
      'appName',
      this,
    );
    developerName = _is.ColumnString(
      'developerName',
      this,
    );
    iconUrl = _is.ColumnString(
      'iconUrl',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    sourceType = _is.ColumnEnum(
      'sourceType',
      this,
      _is.EnumSerialization.byName,
    );
    isSystemApp = _is.ColumnBool(
      'isSystemApp',
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
  }

  late final ApplicationUpdateTable updateTable;

  late final _is.ColumnString packageName;

  late final _is.ColumnString appName;

  late final _is.ColumnString developerName;

  late final _is.ColumnString iconUrl;

  late final _is.ColumnString category;

  late final _is.ColumnEnum<_iroy7u8c.AppSourceType> sourceType;

  late final _is.ColumnBool isSystemApp;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime deletedAt;

  @override
  List<_is.Column> get columns => [
    id,
    packageName,
    appName,
    developerName,
    iconUrl,
    category,
    sourceType,
    isSystemApp,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

class ApplicationInclude extends _is.IncludeObject {
  ApplicationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Application.t;
}

class ApplicationIncludeList extends _is.IncludeList {
  ApplicationIncludeList._({
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Application.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Application.t;
}

class ApplicationRepository {
  const ApplicationRepository._();

  /// Returns a list of [Application]s matching the given query parameters.
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
  Future<List<Application>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Application>(
      where: where?.call(Application.t),
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Application]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Application.t`.
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
  _ida.Stream<List<Application>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Application>(
      where: where?.call(Application.t),
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Application] matching the given query parameters.
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
  Future<Application?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Application>(
      where: where?.call(Application.t),
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Application] by its [id] or null if no such row exists.
  Future<Application?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Application>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Application]s in the list and returns the inserted rows.
  ///
  /// The returned [Application]s will have their `id` fields set.
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
  Future<List<Application>> insert(
    _is.DatabaseSession session,
    List<Application> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Application>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Application] and returns the inserted row.
  ///
  /// The returned [Application] will have its `id` field set.
  Future<Application> insertRow(
    _is.DatabaseSession session,
    Application row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Application>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Application]s in the list and returns the resulting rows.
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
  /// The returned [Application]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> upsert(
    _is.DatabaseSession session,
    List<Application> rows, {
    required _is.ColumnSelections<ApplicationTable> conflictColumns,
    _is.ColumnSelections<ApplicationTable>? updateColumns,
    _is.WhereExpressionBuilder<ApplicationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Application>(
      rows,
      conflictColumns: conflictColumns(Application.t),
      updateColumns: updateColumns?.call(Application.t),
      updateWhere: updateWhere?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Application] and returns the resulting row.
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
  /// The returned [Application] will have its `id` field set.
  Future<Application?> upsertRow(
    _is.DatabaseSession session,
    Application row, {
    required _is.ColumnSelections<ApplicationTable> conflictColumns,
    _is.ColumnSelections<ApplicationTable>? updateColumns,
    _is.WhereExpressionBuilder<ApplicationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Application>(
      row,
      conflictColumns: conflictColumns(Application.t),
      updateColumns: updateColumns?.call(Application.t),
      updateWhere: updateWhere?.call(Application.t),
      transaction: transaction,
    );
  }

  /// Updates all [Application]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> update(
    _is.DatabaseSession session,
    List<Application> rows, {
    _is.ColumnSelections<ApplicationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Application>(
      rows,
      columns: columns?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Application]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Application> updateRow(
    _is.DatabaseSession session,
    Application row, {
    _is.ColumnSelections<ApplicationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Application>(
      row,
      columns: columns?.call(Application.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Application] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Application?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ApplicationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Application>(
      id,
      columnValues: columnValues(Application.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Application]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Application>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ApplicationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ApplicationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Application>(
      columnValues: columnValues(Application.t.updateTable),
      where: where(Application.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Application]s in the list and returns the deleted rows.
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
  Future<List<Application>> delete(
    _is.DatabaseSession session,
    List<Application> rows, {
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Application>(
      rows,
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Application].
  Future<Application> deleteRow(
    _is.DatabaseSession session,
    Application row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Application>(
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
  Future<List<Application>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ApplicationTable> where,
    _is.OrderByBuilder<ApplicationTable>? orderBy,
    _is.OrderByListBuilder<ApplicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Application>(
      where: where(Application.t),
      orderBy: orderBy?.call(Application.t),
      orderByList: orderByList?.call(Application.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ApplicationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Application>(
      where: where?.call(Application.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Application] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ApplicationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Application>(
      where: where(Application.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
