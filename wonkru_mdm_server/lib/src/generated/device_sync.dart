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

abstract class DeviceSync
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeviceSync._({
    this.id,
    required this.deviceId,
    this.device,
    required this.collectedAt,
    this.syncType,
    this.deviceInfo,
    this.mdmAppInfo,
    this.appsInfo,
    this.audioInfo,
    this.batteryInfo,
    this.certificatesInfo,
    this.displayInfo,
    this.networkInfo,
    this.notificationInfo,
    this.restrictionsInfo,
    this.securityInfo,
    this.storageInfo,
    this.systemInfo,
    this.otherInfo,
    this.bsInfo,
    this.stInfo,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DeviceSync({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required DateTime collectedAt,
    String? syncType,
    String? deviceInfo,
    String? mdmAppInfo,
    String? appsInfo,
    String? audioInfo,
    String? batteryInfo,
    String? certificatesInfo,
    String? displayInfo,
    String? networkInfo,
    String? notificationInfo,
    String? restrictionsInfo,
    String? securityInfo,
    String? storageInfo,
    String? systemInfo,
    String? otherInfo,
    String? bsInfo,
    String? stInfo,
    DateTime? createdAt,
  }) = _DeviceSyncImpl;

  factory DeviceSync.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceSync(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      collectedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['collectedAt'],
      ),
      syncType: jsonSerialization['syncType'] as String?,
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      mdmAppInfo: jsonSerialization['mdmAppInfo'] as String?,
      appsInfo: jsonSerialization['appsInfo'] as String?,
      audioInfo: jsonSerialization['audioInfo'] as String?,
      batteryInfo: jsonSerialization['batteryInfo'] as String?,
      certificatesInfo: jsonSerialization['certificatesInfo'] as String?,
      displayInfo: jsonSerialization['displayInfo'] as String?,
      networkInfo: jsonSerialization['networkInfo'] as String?,
      notificationInfo: jsonSerialization['notificationInfo'] as String?,
      restrictionsInfo: jsonSerialization['restrictionsInfo'] as String?,
      securityInfo: jsonSerialization['securityInfo'] as String?,
      storageInfo: jsonSerialization['storageInfo'] as String?,
      systemInfo: jsonSerialization['systemInfo'] as String?,
      otherInfo: jsonSerialization['otherInfo'] as String?,
      bsInfo: jsonSerialization['bsInfo'] as String?,
      stInfo: jsonSerialization['stInfo'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = DeviceSyncTable();

  static const db = DeviceSyncRepository._();

  @override
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  DateTime collectedAt;

  String? syncType;

  /// JSON payloads, one per state section.
  String? deviceInfo;

  String? mdmAppInfo;

  String? appsInfo;

  String? audioInfo;

  String? batteryInfo;

  String? certificatesInfo;

  String? displayInfo;

  String? networkInfo;

  String? notificationInfo;

  String? restrictionsInfo;

  String? securityInfo;

  String? storageInfo;

  String? systemInfo;

  String? otherInfo;

  String? bsInfo;

  String? stInfo;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceSync]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceSync copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceSync$device(),
    DateTime? collectedAt,
    String? syncType,
    String? deviceInfo,
    String? mdmAppInfo,
    String? appsInfo,
    String? audioInfo,
    String? batteryInfo,
    String? certificatesInfo,
    String? displayInfo,
    String? networkInfo,
    String? notificationInfo,
    String? restrictionsInfo,
    String? securityInfo,
    String? storageInfo,
    String? systemInfo,
    String? otherInfo,
    String? bsInfo,
    String? stInfo,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceSync',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'collectedAt': collectedAt.toJson(),
      if (syncType != null) 'syncType': syncType,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (mdmAppInfo != null) 'mdmAppInfo': mdmAppInfo,
      if (appsInfo != null) 'appsInfo': appsInfo,
      if (audioInfo != null) 'audioInfo': audioInfo,
      if (batteryInfo != null) 'batteryInfo': batteryInfo,
      if (certificatesInfo != null) 'certificatesInfo': certificatesInfo,
      if (displayInfo != null) 'displayInfo': displayInfo,
      if (networkInfo != null) 'networkInfo': networkInfo,
      if (notificationInfo != null) 'notificationInfo': notificationInfo,
      if (restrictionsInfo != null) 'restrictionsInfo': restrictionsInfo,
      if (securityInfo != null) 'securityInfo': securityInfo,
      if (storageInfo != null) 'storageInfo': storageInfo,
      if (systemInfo != null) 'systemInfo': systemInfo,
      if (otherInfo != null) 'otherInfo': otherInfo,
      if (bsInfo != null) 'bsInfo': bsInfo,
      if (stInfo != null) 'stInfo': stInfo,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceSync',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'collectedAt': collectedAt.toJson(),
      if (syncType != null) 'syncType': syncType,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (mdmAppInfo != null) 'mdmAppInfo': mdmAppInfo,
      if (appsInfo != null) 'appsInfo': appsInfo,
      if (audioInfo != null) 'audioInfo': audioInfo,
      if (batteryInfo != null) 'batteryInfo': batteryInfo,
      if (certificatesInfo != null) 'certificatesInfo': certificatesInfo,
      if (displayInfo != null) 'displayInfo': displayInfo,
      if (networkInfo != null) 'networkInfo': networkInfo,
      if (notificationInfo != null) 'notificationInfo': notificationInfo,
      if (restrictionsInfo != null) 'restrictionsInfo': restrictionsInfo,
      if (securityInfo != null) 'securityInfo': securityInfo,
      if (storageInfo != null) 'storageInfo': storageInfo,
      if (systemInfo != null) 'systemInfo': systemInfo,
      if (otherInfo != null) 'otherInfo': otherInfo,
      if (bsInfo != null) 'bsInfo': bsInfo,
      if (stInfo != null) 'stInfo': stInfo,
      'createdAt': createdAt.toJson(),
    };
  }

  static DeviceSyncInclude include({_ilo09f9g.DeviceInclude? device}) {
    return DeviceSyncInclude._(device: device);
  }

  static DeviceSyncIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceSyncTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceSyncTable>? orderBy,
    _is.OrderByListBuilder<DeviceSyncTable>? orderByList,
    DeviceSyncInclude? include,
  }) {
    return DeviceSyncIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceSync.t),
      orderByList: orderByList?.call(DeviceSync.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceSync$device extends _is.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceSync$device();
}

class _DeviceSyncImpl extends DeviceSync {
  _DeviceSyncImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required DateTime collectedAt,
    String? syncType,
    String? deviceInfo,
    String? mdmAppInfo,
    String? appsInfo,
    String? audioInfo,
    String? batteryInfo,
    String? certificatesInfo,
    String? displayInfo,
    String? networkInfo,
    String? notificationInfo,
    String? restrictionsInfo,
    String? securityInfo,
    String? storageInfo,
    String? systemInfo,
    String? otherInfo,
    String? bsInfo,
    String? stInfo,
    DateTime? createdAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         collectedAt: collectedAt,
         syncType: syncType,
         deviceInfo: deviceInfo,
         mdmAppInfo: mdmAppInfo,
         appsInfo: appsInfo,
         audioInfo: audioInfo,
         batteryInfo: batteryInfo,
         certificatesInfo: certificatesInfo,
         displayInfo: displayInfo,
         networkInfo: networkInfo,
         notificationInfo: notificationInfo,
         restrictionsInfo: restrictionsInfo,
         securityInfo: securityInfo,
         storageInfo: storageInfo,
         systemInfo: systemInfo,
         otherInfo: otherInfo,
         bsInfo: bsInfo,
         stInfo: stInfo,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DeviceSync]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceSync copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceSync$device(),
    DateTime? collectedAt,
    Object? syncType = _Undefined,
    Object? deviceInfo = _Undefined,
    Object? mdmAppInfo = _Undefined,
    Object? appsInfo = _Undefined,
    Object? audioInfo = _Undefined,
    Object? batteryInfo = _Undefined,
    Object? certificatesInfo = _Undefined,
    Object? displayInfo = _Undefined,
    Object? networkInfo = _Undefined,
    Object? notificationInfo = _Undefined,
    Object? restrictionsInfo = _Undefined,
    Object? securityInfo = _Undefined,
    Object? storageInfo = _Undefined,
    Object? systemInfo = _Undefined,
    Object? otherInfo = _Undefined,
    Object? bsInfo = _Undefined,
    Object? stInfo = _Undefined,
    DateTime? createdAt,
  }) {
    return DeviceSync(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _is.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      collectedAt: collectedAt ?? this.collectedAt,
      syncType: syncType is String? ? syncType : this.syncType,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      mdmAppInfo: mdmAppInfo is String? ? mdmAppInfo : this.mdmAppInfo,
      appsInfo: appsInfo is String? ? appsInfo : this.appsInfo,
      audioInfo: audioInfo is String? ? audioInfo : this.audioInfo,
      batteryInfo: batteryInfo is String? ? batteryInfo : this.batteryInfo,
      certificatesInfo: certificatesInfo is String?
          ? certificatesInfo
          : this.certificatesInfo,
      displayInfo: displayInfo is String? ? displayInfo : this.displayInfo,
      networkInfo: networkInfo is String? ? networkInfo : this.networkInfo,
      notificationInfo: notificationInfo is String?
          ? notificationInfo
          : this.notificationInfo,
      restrictionsInfo: restrictionsInfo is String?
          ? restrictionsInfo
          : this.restrictionsInfo,
      securityInfo: securityInfo is String? ? securityInfo : this.securityInfo,
      storageInfo: storageInfo is String? ? storageInfo : this.storageInfo,
      systemInfo: systemInfo is String? ? systemInfo : this.systemInfo,
      otherInfo: otherInfo is String? ? otherInfo : this.otherInfo,
      bsInfo: bsInfo is String? ? bsInfo : this.bsInfo,
      stInfo: stInfo is String? ? stInfo : this.stInfo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DeviceSyncUpdateTable extends _is.UpdateTable<DeviceSyncTable> {
  DeviceSyncUpdateTable(super.table);

  _is.ColumnValue<int, int> deviceId(int value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> collectedAt(DateTime value) =>
      _is.ColumnValue(
        table.collectedAt,
        value,
      );

  _is.ColumnValue<String, String> syncType(String? value) => _is.ColumnValue(
    table.syncType,
    value,
  );

  _is.ColumnValue<String, String> deviceInfo(String? value) => _is.ColumnValue(
    table.deviceInfo,
    value,
  );

  _is.ColumnValue<String, String> mdmAppInfo(String? value) => _is.ColumnValue(
    table.mdmAppInfo,
    value,
  );

  _is.ColumnValue<String, String> appsInfo(String? value) => _is.ColumnValue(
    table.appsInfo,
    value,
  );

  _is.ColumnValue<String, String> audioInfo(String? value) => _is.ColumnValue(
    table.audioInfo,
    value,
  );

  _is.ColumnValue<String, String> batteryInfo(String? value) => _is.ColumnValue(
    table.batteryInfo,
    value,
  );

  _is.ColumnValue<String, String> certificatesInfo(String? value) =>
      _is.ColumnValue(
        table.certificatesInfo,
        value,
      );

  _is.ColumnValue<String, String> displayInfo(String? value) => _is.ColumnValue(
    table.displayInfo,
    value,
  );

  _is.ColumnValue<String, String> networkInfo(String? value) => _is.ColumnValue(
    table.networkInfo,
    value,
  );

  _is.ColumnValue<String, String> notificationInfo(String? value) =>
      _is.ColumnValue(
        table.notificationInfo,
        value,
      );

  _is.ColumnValue<String, String> restrictionsInfo(String? value) =>
      _is.ColumnValue(
        table.restrictionsInfo,
        value,
      );

  _is.ColumnValue<String, String> securityInfo(String? value) =>
      _is.ColumnValue(
        table.securityInfo,
        value,
      );

  _is.ColumnValue<String, String> storageInfo(String? value) => _is.ColumnValue(
    table.storageInfo,
    value,
  );

  _is.ColumnValue<String, String> systemInfo(String? value) => _is.ColumnValue(
    table.systemInfo,
    value,
  );

  _is.ColumnValue<String, String> otherInfo(String? value) => _is.ColumnValue(
    table.otherInfo,
    value,
  );

  _is.ColumnValue<String, String> bsInfo(String? value) => _is.ColumnValue(
    table.bsInfo,
    value,
  );

  _is.ColumnValue<String, String> stInfo(String? value) => _is.ColumnValue(
    table.stInfo,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class DeviceSyncTable extends _is.Table<int?> {
  DeviceSyncTable({super.tableRelation}) : super(tableName: 'device_syncs') {
    updateTable = DeviceSyncUpdateTable(this);
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    collectedAt = _is.ColumnDateTime(
      'collectedAt',
      this,
    );
    syncType = _is.ColumnString(
      'syncType',
      this,
    );
    deviceInfo = _is.ColumnString(
      'deviceInfo',
      this,
    );
    mdmAppInfo = _is.ColumnString(
      'mdmAppInfo',
      this,
    );
    appsInfo = _is.ColumnString(
      'appsInfo',
      this,
    );
    audioInfo = _is.ColumnString(
      'audioInfo',
      this,
    );
    batteryInfo = _is.ColumnString(
      'batteryInfo',
      this,
    );
    certificatesInfo = _is.ColumnString(
      'certificatesInfo',
      this,
    );
    displayInfo = _is.ColumnString(
      'displayInfo',
      this,
    );
    networkInfo = _is.ColumnString(
      'networkInfo',
      this,
    );
    notificationInfo = _is.ColumnString(
      'notificationInfo',
      this,
    );
    restrictionsInfo = _is.ColumnString(
      'restrictionsInfo',
      this,
    );
    securityInfo = _is.ColumnString(
      'securityInfo',
      this,
    );
    storageInfo = _is.ColumnString(
      'storageInfo',
      this,
    );
    systemInfo = _is.ColumnString(
      'systemInfo',
      this,
    );
    otherInfo = _is.ColumnString(
      'otherInfo',
      this,
    );
    bsInfo = _is.ColumnString(
      'bsInfo',
      this,
    );
    stInfo = _is.ColumnString(
      'stInfo',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final DeviceSyncUpdateTable updateTable;

  late final _is.ColumnInt deviceId;

  _ilo09f9g.DeviceTable? _device;

  late final _is.ColumnDateTime collectedAt;

  late final _is.ColumnString syncType;

  /// JSON payloads, one per state section.
  late final _is.ColumnString deviceInfo;

  late final _is.ColumnString mdmAppInfo;

  late final _is.ColumnString appsInfo;

  late final _is.ColumnString audioInfo;

  late final _is.ColumnString batteryInfo;

  late final _is.ColumnString certificatesInfo;

  late final _is.ColumnString displayInfo;

  late final _is.ColumnString networkInfo;

  late final _is.ColumnString notificationInfo;

  late final _is.ColumnString restrictionsInfo;

  late final _is.ColumnString securityInfo;

  late final _is.ColumnString storageInfo;

  late final _is.ColumnString systemInfo;

  late final _is.ColumnString otherInfo;

  late final _is.ColumnString bsInfo;

  late final _is.ColumnString stInfo;

  late final _is.ColumnDateTime createdAt;

  _ilo09f9g.DeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: DeviceSync.t.deviceId,
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
    deviceId,
    collectedAt,
    syncType,
    deviceInfo,
    mdmAppInfo,
    appsInfo,
    audioInfo,
    batteryInfo,
    certificatesInfo,
    displayInfo,
    networkInfo,
    notificationInfo,
    restrictionsInfo,
    securityInfo,
    storageInfo,
    systemInfo,
    otherInfo,
    bsInfo,
    stInfo,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'device') {
      return device;
    }
    return null;
  }
}

class DeviceSyncInclude extends _is.IncludeObject {
  DeviceSyncInclude._({_ilo09f9g.DeviceInclude? device}) {
    _device = device;
  }

  _ilo09f9g.DeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {'device': _device};

  @override
  _is.Table<int?> get table => DeviceSync.t;
}

class DeviceSyncIncludeList extends _is.IncludeList {
  DeviceSyncIncludeList._({
    _is.WhereExpressionBuilder<DeviceSyncTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceSync.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeviceSync.t;
}

class DeviceSyncRepository {
  const DeviceSyncRepository._();

  final attachRow = const DeviceSyncAttachRowRepository._();

  /// Returns a list of [DeviceSync]s matching the given query parameters.
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
  Future<List<DeviceSync>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceSyncTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceSyncTable>? orderBy,
    _is.OrderByListBuilder<DeviceSyncTable>? orderByList,
    _is.Transaction? transaction,
    DeviceSyncInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceSync>(
      where: where?.call(DeviceSync.t),
      orderBy: orderBy?.call(DeviceSync.t),
      orderByList: orderByList?.call(DeviceSync.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [DeviceSync]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `DeviceSync.t`.
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
  _ida.Stream<List<DeviceSync>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceSyncTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceSyncTable>? orderBy,
    _is.OrderByListBuilder<DeviceSyncTable>? orderByList,
    DeviceSyncInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<DeviceSync>(
      where: where?.call(DeviceSync.t),
      orderBy: orderBy?.call(DeviceSync.t),
      orderByList: orderByList?.call(DeviceSync.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [DeviceSync] matching the given query parameters.
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
  Future<DeviceSync?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceSyncTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceSyncTable>? orderBy,
    _is.OrderByListBuilder<DeviceSyncTable>? orderByList,
    _is.Transaction? transaction,
    DeviceSyncInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceSync>(
      where: where?.call(DeviceSync.t),
      orderBy: orderBy?.call(DeviceSync.t),
      orderByList: orderByList?.call(DeviceSync.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceSync] by its [id] or null if no such row exists.
  Future<DeviceSync?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceSyncInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceSync>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceSync]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceSync]s will have their `id` fields set.
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
  Future<List<DeviceSync>> insert(
    _is.DatabaseSession session,
    List<DeviceSync> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeviceSync>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeviceSync] and returns the inserted row.
  ///
  /// The returned [DeviceSync] will have its `id` field set.
  Future<DeviceSync> insertRow(
    _is.DatabaseSession session,
    DeviceSync row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceSync>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeviceSync]s in the list and returns the resulting rows.
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
  /// The returned [DeviceSync]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceSync>> upsert(
    _is.DatabaseSession session,
    List<DeviceSync> rows, {
    required _is.ColumnSelections<DeviceSyncTable> conflictColumns,
    _is.ColumnSelections<DeviceSyncTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceSyncTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeviceSync>(
      rows,
      conflictColumns: conflictColumns(DeviceSync.t),
      updateColumns: updateColumns?.call(DeviceSync.t),
      updateWhere: updateWhere?.call(DeviceSync.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeviceSync] and returns the resulting row.
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
  /// The returned [DeviceSync] will have its `id` field set.
  Future<DeviceSync?> upsertRow(
    _is.DatabaseSession session,
    DeviceSync row, {
    required _is.ColumnSelections<DeviceSyncTable> conflictColumns,
    _is.ColumnSelections<DeviceSyncTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceSyncTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeviceSync>(
      row,
      conflictColumns: conflictColumns(DeviceSync.t),
      updateColumns: updateColumns?.call(DeviceSync.t),
      updateWhere: updateWhere?.call(DeviceSync.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceSync]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceSync>> update(
    _is.DatabaseSession session,
    List<DeviceSync> rows, {
    _is.ColumnSelections<DeviceSyncTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeviceSync>(
      rows,
      columns: columns?.call(DeviceSync.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeviceSync]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceSync> updateRow(
    _is.DatabaseSession session,
    DeviceSync row, {
    _is.ColumnSelections<DeviceSyncTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceSync>(
      row,
      columns: columns?.call(DeviceSync.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceSync] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceSync?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceSyncUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceSync>(
      id,
      columnValues: columnValues(DeviceSync.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceSync]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeviceSync>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceSyncUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DeviceSyncTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceSyncTable>? orderBy,
    _is.OrderByListBuilder<DeviceSyncTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeviceSync>(
      columnValues: columnValues(DeviceSync.t.updateTable),
      where: where(DeviceSync.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceSync.t),
      orderByList: orderByList?.call(DeviceSync.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeviceSync]s in the list and returns the deleted rows.
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
  Future<List<DeviceSync>> delete(
    _is.DatabaseSession session,
    List<DeviceSync> rows, {
    _is.OrderByBuilder<DeviceSyncTable>? orderBy,
    _is.OrderByListBuilder<DeviceSyncTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeviceSync>(
      rows,
      orderBy: orderBy?.call(DeviceSync.t),
      orderByList: orderByList?.call(DeviceSync.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeviceSync].
  Future<DeviceSync> deleteRow(
    _is.DatabaseSession session,
    DeviceSync row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceSync>(
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
  Future<List<DeviceSync>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceSyncTable> where,
    _is.OrderByBuilder<DeviceSyncTable>? orderBy,
    _is.OrderByListBuilder<DeviceSyncTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeviceSync>(
      where: where(DeviceSync.t),
      orderBy: orderBy?.call(DeviceSync.t),
      orderByList: orderByList?.call(DeviceSync.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceSyncTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeviceSync>(
      where: where?.call(DeviceSync.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceSync] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceSyncTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceSync>(
      where: where(DeviceSync.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceSyncAttachRowRepository {
  const DeviceSyncAttachRowRepository._();

  /// Creates a relation between the given [DeviceSync] and [Device]
  /// by setting the [DeviceSync]'s foreign key `deviceId` to refer to the [Device].
  Future<void> device(
    _is.DatabaseSession session,
    DeviceSync deviceSync,
    _ilo09f9g.Device device, {
    _is.Transaction? transaction,
  }) async {
    if (deviceSync.id == null) {
      throw ArgumentError.notNull('deviceSync.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $deviceSync = deviceSync.copyWith(deviceId: device.id);
    await session.db.updateRow<DeviceSync>(
      $deviceSync,
      columns: [DeviceSync.t.deviceId],
      transaction: transaction,
    );
  }
}
