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
import 'device_group.dart' as _i94jjjz5;
import 'policy.dart' as _if7d246m;

abstract class Device implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Device._({
    this.id,
    required this.code,
    this.uuid,
    this.name,
    this.authToken,
    this.policyId,
    this.policy,
    this.policyVersion,
    this.lastPolicyUpdate,
    this.groupId,
    this.group,
    this.userId,
    this.manufacturer,
    this.model,
    this.brand,
    this.serialNo,
    this.androidVersion,
    this.sdkVersion,
    this.agentVersionName,
    this.agentVersionCode,
    this.batteryLevel,
    this.ipAddress,
    bool? isRooted,
    bool? isLauncherMode,
    this.totalStorageBytes,
    this.freeStorageBytes,
    this.collectedAt,
    this.lastSeenAt,
    this.firstSeenAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.mustUseApplications,
  }) : isRooted = isRooted ?? false,
       isLauncherMode = isLauncherMode ?? false;

  factory Device({
    int? id,
    required String code,
    String? uuid,
    String? name,
    String? authToken,
    int? policyId,
    _if7d246m.Policy? policy,
    int? policyVersion,
    DateTime? lastPolicyUpdate,
    int? groupId,
    _i94jjjz5.DeviceGroup? group,
    _is.UuidValue? userId,
    String? manufacturer,
    String? model,
    String? brand,
    String? serialNo,
    String? androidVersion,
    int? sdkVersion,
    String? agentVersionName,
    int? agentVersionCode,
    int? batteryLevel,
    String? ipAddress,
    bool? isRooted,
    bool? isLauncherMode,
    int? totalStorageBytes,
    int? freeStorageBytes,
    DateTime? collectedAt,
    DateTime? lastSeenAt,
    DateTime? firstSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? mustUseApplications,
  }) = _DeviceImpl;

  factory Device.fromJson(Map<String, dynamic> jsonSerialization) {
    return Device(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      uuid: jsonSerialization['uuid'] as String?,
      name: jsonSerialization['name'] as String?,
      authToken: jsonSerialization['authToken'] as String?,
      policyId: jsonSerialization['policyId'] as int?,
      policy: jsonSerialization['policy'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_if7d246m.Policy>(
              jsonSerialization['policy'],
            ),
      policyVersion: jsonSerialization['policyVersion'] as int?,
      lastPolicyUpdate: jsonSerialization['lastPolicyUpdate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPolicyUpdate'],
            ),
      groupId: jsonSerialization['groupId'] as int?,
      group: jsonSerialization['group'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<_i94jjjz5.DeviceGroup>(
              jsonSerialization['group'],
            ),
      userId: jsonSerialization['userId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      manufacturer: jsonSerialization['manufacturer'] as String?,
      model: jsonSerialization['model'] as String?,
      brand: jsonSerialization['brand'] as String?,
      serialNo: jsonSerialization['serialNo'] as String?,
      androidVersion: jsonSerialization['androidVersion'] as String?,
      sdkVersion: jsonSerialization['sdkVersion'] as int?,
      agentVersionName: jsonSerialization['agentVersionName'] as String?,
      agentVersionCode: jsonSerialization['agentVersionCode'] as int?,
      batteryLevel: jsonSerialization['batteryLevel'] as int?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      isRooted: jsonSerialization['isRooted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isRooted']),
      isLauncherMode: jsonSerialization['isLauncherMode'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isLauncherMode']),
      totalStorageBytes: jsonSerialization['totalStorageBytes'] as int?,
      freeStorageBytes: jsonSerialization['freeStorageBytes'] as int?,
      collectedAt: jsonSerialization['collectedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['collectedAt'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
      firstSeenAt: jsonSerialization['firstSeenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstSeenAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      mustUseApplications: jsonSerialization['mustUseApplications'] as String?,
    );
  }

  static final t = DeviceTable();

  static const db = DeviceRepository._();

  @override
  int? id;

  String code;

  String? uuid;

  String? name;

  /// SHA-256 (hex) of the secret token authenticating the device.
  ///
  /// The plaintext token is returned once by `device.register` and never
  /// stored; see `DeviceAuthService.hashToken`. Server only: the panel never
  /// receives it.
  String? authToken;

  int? policyId;

  _if7d246m.Policy? policy;

  int? policyVersion;

  DateTime? lastPolicyUpdate;

  int? groupId;

  _i94jjjz5.DeviceGroup? group;

  /// Auth user that manages the device. The auth user table
  /// (`serverpod_auth_core_user`) belongs to a framework module, so no real FK
  /// relation can be declared here; the field stays a plain `UuidValue`,
  /// matching `admin_profiles.userId`.
  _is.UuidValue? userId;

  String? manufacturer;

  String? model;

  String? brand;

  String? serialNo;

  String? androidVersion;

  int? sdkVersion;

  String? agentVersionName;

  int? agentVersionCode;

  int? batteryLevel;

  String? ipAddress;

  bool isRooted;

  bool isLauncherMode;

  int? totalStorageBytes;

  int? freeStorageBytes;

  DateTime? collectedAt;

  DateTime? lastSeenAt;

  DateTime? firstSeenAt;

  DateTime? createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  /// JSON list of applications the user must keep running.
  String? mustUseApplications;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Device]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Device copyWith({
    int? id,
    String? code,
    String? uuid,
    String? name,
    String? authToken,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedDevice$policy(),
    int? policyVersion,
    DateTime? lastPolicyUpdate = const _is.$UndefinedDateTime(),
    int? groupId,
    _i94jjjz5.DeviceGroup? group = const _UndefinedDevice$group(),
    _is.UuidValue? userId = const _is.$UndefinedUuidValue(),
    String? manufacturer,
    String? model,
    String? brand,
    String? serialNo,
    String? androidVersion,
    int? sdkVersion,
    String? agentVersionName,
    int? agentVersionCode,
    int? batteryLevel,
    String? ipAddress,
    bool? isRooted,
    bool? isLauncherMode,
    int? totalStorageBytes,
    int? freeStorageBytes,
    DateTime? collectedAt = const _is.$UndefinedDateTime(),
    DateTime? lastSeenAt = const _is.$UndefinedDateTime(),
    DateTime? firstSeenAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
    DateTime? deletedAt = const _is.$UndefinedDateTime(),
    String? mustUseApplications,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Device',
      if (id != null) 'id': id,
      'code': code,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (authToken != null) 'authToken': authToken,
      if (policyId != null) 'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      if (policyVersion != null) 'policyVersion': policyVersion,
      if (lastPolicyUpdate != null)
        'lastPolicyUpdate': lastPolicyUpdate?.toJson(),
      if (groupId != null) 'groupId': groupId,
      if (group != null) 'group': group?.toJson(),
      if (userId != null) 'userId': userId?.toJson(),
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (brand != null) 'brand': brand,
      if (serialNo != null) 'serialNo': serialNo,
      if (androidVersion != null) 'androidVersion': androidVersion,
      if (sdkVersion != null) 'sdkVersion': sdkVersion,
      if (agentVersionName != null) 'agentVersionName': agentVersionName,
      if (agentVersionCode != null) 'agentVersionCode': agentVersionCode,
      if (batteryLevel != null) 'batteryLevel': batteryLevel,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'isRooted': isRooted,
      'isLauncherMode': isLauncherMode,
      if (totalStorageBytes != null) 'totalStorageBytes': totalStorageBytes,
      if (freeStorageBytes != null) 'freeStorageBytes': freeStorageBytes,
      if (collectedAt != null) 'collectedAt': collectedAt?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      if (firstSeenAt != null) 'firstSeenAt': firstSeenAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (mustUseApplications != null)
        'mustUseApplications': mustUseApplications,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Device',
      if (id != null) 'id': id,
      'code': code,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (policyId != null) 'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      if (policyVersion != null) 'policyVersion': policyVersion,
      if (lastPolicyUpdate != null)
        'lastPolicyUpdate': lastPolicyUpdate?.toJson(),
      if (groupId != null) 'groupId': groupId,
      if (group != null) 'group': group?.toJsonForProtocol(),
      if (userId != null) 'userId': userId?.toJson(),
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (brand != null) 'brand': brand,
      if (serialNo != null) 'serialNo': serialNo,
      if (androidVersion != null) 'androidVersion': androidVersion,
      if (sdkVersion != null) 'sdkVersion': sdkVersion,
      if (agentVersionName != null) 'agentVersionName': agentVersionName,
      if (agentVersionCode != null) 'agentVersionCode': agentVersionCode,
      if (batteryLevel != null) 'batteryLevel': batteryLevel,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'isRooted': isRooted,
      'isLauncherMode': isLauncherMode,
      if (totalStorageBytes != null) 'totalStorageBytes': totalStorageBytes,
      if (freeStorageBytes != null) 'freeStorageBytes': freeStorageBytes,
      if (collectedAt != null) 'collectedAt': collectedAt?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      if (firstSeenAt != null) 'firstSeenAt': firstSeenAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (mustUseApplications != null)
        'mustUseApplications': mustUseApplications,
    };
  }

  static DeviceInclude include({
    _if7d246m.PolicyInclude? policy,
    _i94jjjz5.DeviceGroupInclude? group,
  }) {
    return DeviceInclude._(
      policy: policy,
      group: group,
    );
  }

  static DeviceIncludeList includeList({
    _is.WhereExpressionBuilder<DeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceTable>? orderByList,
    DeviceInclude? include,
  }) {
    return DeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDevice$policy extends _is.UndefinedSentinel
    implements _if7d246m.Policy {
  const _UndefinedDevice$policy();
}

class _UndefinedDevice$group extends _is.UndefinedSentinel
    implements _i94jjjz5.DeviceGroup {
  const _UndefinedDevice$group();
}

class _DeviceImpl extends Device {
  _DeviceImpl({
    int? id,
    required String code,
    String? uuid,
    String? name,
    String? authToken,
    int? policyId,
    _if7d246m.Policy? policy,
    int? policyVersion,
    DateTime? lastPolicyUpdate,
    int? groupId,
    _i94jjjz5.DeviceGroup? group,
    _is.UuidValue? userId,
    String? manufacturer,
    String? model,
    String? brand,
    String? serialNo,
    String? androidVersion,
    int? sdkVersion,
    String? agentVersionName,
    int? agentVersionCode,
    int? batteryLevel,
    String? ipAddress,
    bool? isRooted,
    bool? isLauncherMode,
    int? totalStorageBytes,
    int? freeStorageBytes,
    DateTime? collectedAt,
    DateTime? lastSeenAt,
    DateTime? firstSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? mustUseApplications,
  }) : super._(
         id: id,
         code: code,
         uuid: uuid,
         name: name,
         authToken: authToken,
         policyId: policyId,
         policy: policy,
         policyVersion: policyVersion,
         lastPolicyUpdate: lastPolicyUpdate,
         groupId: groupId,
         group: group,
         userId: userId,
         manufacturer: manufacturer,
         model: model,
         brand: brand,
         serialNo: serialNo,
         androidVersion: androidVersion,
         sdkVersion: sdkVersion,
         agentVersionName: agentVersionName,
         agentVersionCode: agentVersionCode,
         batteryLevel: batteryLevel,
         ipAddress: ipAddress,
         isRooted: isRooted,
         isLauncherMode: isLauncherMode,
         totalStorageBytes: totalStorageBytes,
         freeStorageBytes: freeStorageBytes,
         collectedAt: collectedAt,
         lastSeenAt: lastSeenAt,
         firstSeenAt: firstSeenAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         mustUseApplications: mustUseApplications,
       );

  /// Returns a shallow copy of this [Device]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Device copyWith({
    Object? id = _Undefined,
    String? code,
    Object? uuid = _Undefined,
    Object? name = _Undefined,
    Object? authToken = _Undefined,
    Object? policyId = _Undefined,
    _if7d246m.Policy? policy = const _UndefinedDevice$policy(),
    Object? policyVersion = _Undefined,
    DateTime? lastPolicyUpdate = const _is.$UndefinedDateTime(),
    Object? groupId = _Undefined,
    _i94jjjz5.DeviceGroup? group = const _UndefinedDevice$group(),
    _is.UuidValue? userId = const _is.$UndefinedUuidValue(),
    Object? manufacturer = _Undefined,
    Object? model = _Undefined,
    Object? brand = _Undefined,
    Object? serialNo = _Undefined,
    Object? androidVersion = _Undefined,
    Object? sdkVersion = _Undefined,
    Object? agentVersionName = _Undefined,
    Object? agentVersionCode = _Undefined,
    Object? batteryLevel = _Undefined,
    Object? ipAddress = _Undefined,
    bool? isRooted,
    bool? isLauncherMode,
    Object? totalStorageBytes = _Undefined,
    Object? freeStorageBytes = _Undefined,
    DateTime? collectedAt = const _is.$UndefinedDateTime(),
    DateTime? lastSeenAt = const _is.$UndefinedDateTime(),
    DateTime? firstSeenAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt = const _is.$UndefinedDateTime(),
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
    DateTime? deletedAt = const _is.$UndefinedDateTime(),
    Object? mustUseApplications = _Undefined,
  }) {
    return Device(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      uuid: uuid is String? ? uuid : this.uuid,
      name: name is String? ? name : this.name,
      authToken: authToken is String? ? authToken : this.authToken,
      policyId: policyId is int? ? policyId : this.policyId,
      policy: policy is _is.UndefinedSentinel
          ? this.policy?.copyWith()
          : policy,
      policyVersion: policyVersion is int? ? policyVersion : this.policyVersion,
      lastPolicyUpdate: lastPolicyUpdate is _is.UndefinedSentinel
          ? this.lastPolicyUpdate
          : lastPolicyUpdate,
      groupId: groupId is int? ? groupId : this.groupId,
      group: group is _is.UndefinedSentinel ? this.group?.copyWith() : group,
      userId: userId is _is.UndefinedSentinel ? this.userId : userId,
      manufacturer: manufacturer is String? ? manufacturer : this.manufacturer,
      model: model is String? ? model : this.model,
      brand: brand is String? ? brand : this.brand,
      serialNo: serialNo is String? ? serialNo : this.serialNo,
      androidVersion: androidVersion is String?
          ? androidVersion
          : this.androidVersion,
      sdkVersion: sdkVersion is int? ? sdkVersion : this.sdkVersion,
      agentVersionName: agentVersionName is String?
          ? agentVersionName
          : this.agentVersionName,
      agentVersionCode: agentVersionCode is int?
          ? agentVersionCode
          : this.agentVersionCode,
      batteryLevel: batteryLevel is int? ? batteryLevel : this.batteryLevel,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      isRooted: isRooted ?? this.isRooted,
      isLauncherMode: isLauncherMode ?? this.isLauncherMode,
      totalStorageBytes: totalStorageBytes is int?
          ? totalStorageBytes
          : this.totalStorageBytes,
      freeStorageBytes: freeStorageBytes is int?
          ? freeStorageBytes
          : this.freeStorageBytes,
      collectedAt: collectedAt is _is.UndefinedSentinel
          ? this.collectedAt
          : collectedAt,
      lastSeenAt: lastSeenAt is _is.UndefinedSentinel
          ? this.lastSeenAt
          : lastSeenAt,
      firstSeenAt: firstSeenAt is _is.UndefinedSentinel
          ? this.firstSeenAt
          : firstSeenAt,
      createdAt: createdAt is _is.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
      deletedAt: deletedAt is _is.UndefinedSentinel
          ? this.deletedAt
          : deletedAt,
      mustUseApplications: mustUseApplications is String?
          ? mustUseApplications
          : this.mustUseApplications,
    );
  }
}

class DeviceUpdateTable extends _is.UpdateTable<DeviceTable> {
  DeviceUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> uuid(String? value) => _is.ColumnValue(
    table.uuid,
    value,
  );

  _is.ColumnValue<String, String> name(String? value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> authToken(String? value) => _is.ColumnValue(
    table.authToken,
    value,
  );

  _is.ColumnValue<int, int> policyId(int? value) => _is.ColumnValue(
    table.policyId,
    value,
  );

  _is.ColumnValue<int, int> policyVersion(int? value) => _is.ColumnValue(
    table.policyVersion,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastPolicyUpdate(DateTime? value) =>
      _is.ColumnValue(
        table.lastPolicyUpdate,
        value,
      );

  _is.ColumnValue<int, int> groupId(int? value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> manufacturer(String? value) =>
      _is.ColumnValue(
        table.manufacturer,
        value,
      );

  _is.ColumnValue<String, String> model(String? value) => _is.ColumnValue(
    table.model,
    value,
  );

  _is.ColumnValue<String, String> brand(String? value) => _is.ColumnValue(
    table.brand,
    value,
  );

  _is.ColumnValue<String, String> serialNo(String? value) => _is.ColumnValue(
    table.serialNo,
    value,
  );

  _is.ColumnValue<String, String> androidVersion(String? value) =>
      _is.ColumnValue(
        table.androidVersion,
        value,
      );

  _is.ColumnValue<int, int> sdkVersion(int? value) => _is.ColumnValue(
    table.sdkVersion,
    value,
  );

  _is.ColumnValue<String, String> agentVersionName(String? value) =>
      _is.ColumnValue(
        table.agentVersionName,
        value,
      );

  _is.ColumnValue<int, int> agentVersionCode(int? value) => _is.ColumnValue(
    table.agentVersionCode,
    value,
  );

  _is.ColumnValue<int, int> batteryLevel(int? value) => _is.ColumnValue(
    table.batteryLevel,
    value,
  );

  _is.ColumnValue<String, String> ipAddress(String? value) => _is.ColumnValue(
    table.ipAddress,
    value,
  );

  _is.ColumnValue<bool, bool> isRooted(bool value) => _is.ColumnValue(
    table.isRooted,
    value,
  );

  _is.ColumnValue<bool, bool> isLauncherMode(bool value) => _is.ColumnValue(
    table.isLauncherMode,
    value,
  );

  _is.ColumnValue<int, int> totalStorageBytes(int? value) => _is.ColumnValue(
    table.totalStorageBytes,
    value,
  );

  _is.ColumnValue<int, int> freeStorageBytes(int? value) => _is.ColumnValue(
    table.freeStorageBytes,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> collectedAt(DateTime? value) =>
      _is.ColumnValue(
        table.collectedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastSeenAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> firstSeenAt(DateTime? value) =>
      _is.ColumnValue(
        table.firstSeenAt,
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

  _is.ColumnValue<String, String> mustUseApplications(String? value) =>
      _is.ColumnValue(
        table.mustUseApplications,
        value,
      );
}

class DeviceTable extends _is.Table<int?> {
  DeviceTable({super.tableRelation}) : super(tableName: 'devices') {
    updateTable = DeviceUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    uuid = _is.ColumnString(
      'uuid',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    authToken = _is.ColumnString(
      'authToken',
      this,
    );
    policyId = _is.ColumnInt(
      'policyId',
      this,
    );
    policyVersion = _is.ColumnInt(
      'policyVersion',
      this,
    );
    lastPolicyUpdate = _is.ColumnDateTime(
      'lastPolicyUpdate',
      this,
    );
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    manufacturer = _is.ColumnString(
      'manufacturer',
      this,
    );
    model = _is.ColumnString(
      'model',
      this,
    );
    brand = _is.ColumnString(
      'brand',
      this,
    );
    serialNo = _is.ColumnString(
      'serialNo',
      this,
    );
    androidVersion = _is.ColumnString(
      'androidVersion',
      this,
    );
    sdkVersion = _is.ColumnInt(
      'sdkVersion',
      this,
    );
    agentVersionName = _is.ColumnString(
      'agentVersionName',
      this,
    );
    agentVersionCode = _is.ColumnInt(
      'agentVersionCode',
      this,
    );
    batteryLevel = _is.ColumnInt(
      'batteryLevel',
      this,
    );
    ipAddress = _is.ColumnString(
      'ipAddress',
      this,
    );
    isRooted = _is.ColumnBool(
      'isRooted',
      this,
    );
    isLauncherMode = _is.ColumnBool(
      'isLauncherMode',
      this,
    );
    totalStorageBytes = _is.ColumnInt(
      'totalStorageBytes',
      this,
    );
    freeStorageBytes = _is.ColumnInt(
      'freeStorageBytes',
      this,
    );
    collectedAt = _is.ColumnDateTime(
      'collectedAt',
      this,
    );
    lastSeenAt = _is.ColumnDateTime(
      'lastSeenAt',
      this,
    );
    firstSeenAt = _is.ColumnDateTime(
      'firstSeenAt',
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
    mustUseApplications = _is.ColumnString(
      'mustUseApplications',
      this,
    );
  }

  late final DeviceUpdateTable updateTable;

  late final _is.ColumnString code;

  late final _is.ColumnString uuid;

  late final _is.ColumnString name;

  /// SHA-256 (hex) of the secret token authenticating the device.
  ///
  /// The plaintext token is returned once by `device.register` and never
  /// stored; see `DeviceAuthService.hashToken`. Server only: the panel never
  /// receives it.
  late final _is.ColumnString authToken;

  late final _is.ColumnInt policyId;

  _if7d246m.PolicyTable? _policy;

  late final _is.ColumnInt policyVersion;

  late final _is.ColumnDateTime lastPolicyUpdate;

  late final _is.ColumnInt groupId;

  _i94jjjz5.DeviceGroupTable? _group;

  /// Auth user that manages the device. The auth user table
  /// (`serverpod_auth_core_user`) belongs to a framework module, so no real FK
  /// relation can be declared here; the field stays a plain `UuidValue`,
  /// matching `admin_profiles.userId`.
  late final _is.ColumnUuid userId;

  late final _is.ColumnString manufacturer;

  late final _is.ColumnString model;

  late final _is.ColumnString brand;

  late final _is.ColumnString serialNo;

  late final _is.ColumnString androidVersion;

  late final _is.ColumnInt sdkVersion;

  late final _is.ColumnString agentVersionName;

  late final _is.ColumnInt agentVersionCode;

  late final _is.ColumnInt batteryLevel;

  late final _is.ColumnString ipAddress;

  late final _is.ColumnBool isRooted;

  late final _is.ColumnBool isLauncherMode;

  late final _is.ColumnInt totalStorageBytes;

  late final _is.ColumnInt freeStorageBytes;

  late final _is.ColumnDateTime collectedAt;

  late final _is.ColumnDateTime lastSeenAt;

  late final _is.ColumnDateTime firstSeenAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime deletedAt;

  /// JSON list of applications the user must keep running.
  late final _is.ColumnString mustUseApplications;

  _if7d246m.PolicyTable get policy {
    if (_policy != null) return _policy!;
    _policy = _is.createRelationTable(
      relationFieldName: 'policy',
      field: Device.t.policyId,
      foreignField: _if7d246m.Policy.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _if7d246m.PolicyTable(tableRelation: foreignTableRelation),
    );
    return _policy!;
  }

  _i94jjjz5.DeviceGroupTable get group {
    if (_group != null) return _group!;
    _group = _is.createRelationTable(
      relationFieldName: 'group',
      field: Device.t.groupId,
      foreignField: _i94jjjz5.DeviceGroup.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i94jjjz5.DeviceGroupTable(tableRelation: foreignTableRelation),
    );
    return _group!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    code,
    uuid,
    name,
    authToken,
    policyId,
    policyVersion,
    lastPolicyUpdate,
    groupId,
    userId,
    manufacturer,
    model,
    brand,
    serialNo,
    androidVersion,
    sdkVersion,
    agentVersionName,
    agentVersionCode,
    batteryLevel,
    ipAddress,
    isRooted,
    isLauncherMode,
    totalStorageBytes,
    freeStorageBytes,
    collectedAt,
    lastSeenAt,
    firstSeenAt,
    createdAt,
    updatedAt,
    deletedAt,
    mustUseApplications,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'policy') {
      return policy;
    }
    if (relationField == 'group') {
      return group;
    }
    return null;
  }
}

class DeviceInclude extends _is.IncludeObject {
  DeviceInclude._({
    _if7d246m.PolicyInclude? policy,
    _i94jjjz5.DeviceGroupInclude? group,
  }) {
    _policy = policy;
    _group = group;
  }

  _if7d246m.PolicyInclude? _policy;

  _i94jjjz5.DeviceGroupInclude? _group;

  @override
  Map<String, _is.Include?> get includes => {
    'policy': _policy,
    'group': _group,
  };

  @override
  _is.Table<int?> get table => Device.t;
}

class DeviceIncludeList extends _is.IncludeList {
  DeviceIncludeList._({
    _is.WhereExpressionBuilder<DeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Device.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Device.t;
}

class DeviceRepository {
  const DeviceRepository._();

  final attachRow = const DeviceAttachRowRepository._();

  final detachRow = const DeviceDetachRowRepository._();

  /// Returns a list of [Device]s matching the given query parameters.
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
  Future<List<Device>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceTable>? orderByList,
    _is.Transaction? transaction,
    DeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Device>(
      where: where?.call(Device.t),
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Device]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Device.t`.
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
  _ida.Stream<List<Device>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceTable>? orderByList,
    DeviceInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Device>(
      where: where?.call(Device.t),
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Device] matching the given query parameters.
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
  Future<Device?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceTable>? where,
    int? offset,
    _is.OrderByBuilder<DeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceTable>? orderByList,
    _is.Transaction? transaction,
    DeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Device>(
      where: where?.call(Device.t),
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Device] by its [id] or null if no such row exists.
  Future<Device?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Device>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Device]s in the list and returns the inserted rows.
  ///
  /// The returned [Device]s will have their `id` fields set.
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
  Future<List<Device>> insert(
    _is.DatabaseSession session,
    List<Device> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Device>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Device] and returns the inserted row.
  ///
  /// The returned [Device] will have its `id` field set.
  Future<Device> insertRow(
    _is.DatabaseSession session,
    Device row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Device>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Device]s in the list and returns the resulting rows.
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
  /// The returned [Device]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Device>> upsert(
    _is.DatabaseSession session,
    List<Device> rows, {
    required _is.ColumnSelections<DeviceTable> conflictColumns,
    _is.ColumnSelections<DeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Device>(
      rows,
      conflictColumns: conflictColumns(Device.t),
      updateColumns: updateColumns?.call(Device.t),
      updateWhere: updateWhere?.call(Device.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Device] and returns the resulting row.
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
  /// The returned [Device] will have its `id` field set.
  Future<Device?> upsertRow(
    _is.DatabaseSession session,
    Device row, {
    required _is.ColumnSelections<DeviceTable> conflictColumns,
    _is.ColumnSelections<DeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<DeviceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Device>(
      row,
      conflictColumns: conflictColumns(Device.t),
      updateColumns: updateColumns?.call(Device.t),
      updateWhere: updateWhere?.call(Device.t),
      transaction: transaction,
    );
  }

  /// Updates all [Device]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Device>> update(
    _is.DatabaseSession session,
    List<Device> rows, {
    _is.ColumnSelections<DeviceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Device>(
      rows,
      columns: columns?.call(Device.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Device]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Device> updateRow(
    _is.DatabaseSession session,
    Device row, {
    _is.ColumnSelections<DeviceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Device>(
      row,
      columns: columns?.call(Device.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Device] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Device?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DeviceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Device>(
      id,
      columnValues: columnValues(Device.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Device]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Device>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeviceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DeviceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Device>(
      columnValues: columnValues(Device.t.updateTable),
      where: where(Device.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Device]s in the list and returns the deleted rows.
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
  Future<List<Device>> delete(
    _is.DatabaseSession session,
    List<Device> rows, {
    _is.OrderByBuilder<DeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Device>(
      rows,
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Device].
  Future<Device> deleteRow(
    _is.DatabaseSession session,
    Device row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Device>(
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
  Future<List<Device>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceTable> where,
    _is.OrderByBuilder<DeviceTable>? orderBy,
    _is.OrderByListBuilder<DeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Device>(
      where: where(Device.t),
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeviceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Device>(
      where: where?.call(Device.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Device] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeviceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Device>(
      where: where(Device.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DeviceAttachRowRepository {
  const DeviceAttachRowRepository._();

  /// Creates a relation between the given [Device] and [Policy]
  /// by setting the [Device]'s foreign key `policyId` to refer to the [Policy].
  Future<void> policy(
    _is.DatabaseSession session,
    Device device,
    _if7d246m.Policy policy, {
    _is.Transaction? transaction,
  }) async {
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }
    if (policy.id == null) {
      throw ArgumentError.notNull('policy.id');
    }

    var $device = device.copyWith(policyId: policy.id);
    await session.db.updateRow<Device>(
      $device,
      columns: [Device.t.policyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Device] and [DeviceGroup]
  /// by setting the [Device]'s foreign key `groupId` to refer to the [DeviceGroup].
  Future<void> group(
    _is.DatabaseSession session,
    Device device,
    _i94jjjz5.DeviceGroup group, {
    _is.Transaction? transaction,
  }) async {
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }
    if (group.id == null) {
      throw ArgumentError.notNull('group.id');
    }

    var $device = device.copyWith(groupId: group.id);
    await session.db.updateRow<Device>(
      $device,
      columns: [Device.t.groupId],
      transaction: transaction,
    );
  }
}

class DeviceDetachRowRepository {
  const DeviceDetachRowRepository._();

  /// Detaches the relation between this [Device] and the [Policy] set in `policy`
  /// by setting the [Device]'s foreign key `policyId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> policy(
    _is.DatabaseSession session,
    Device device, {
    _is.Transaction? transaction,
  }) async {
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $device = device.copyWith(policyId: null);
    await session.db.updateRow<Device>(
      $device,
      columns: [Device.t.policyId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Device] and the [DeviceGroup] set in `group`
  /// by setting the [Device]'s foreign key `groupId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> group(
    _is.DatabaseSession session,
    Device device, {
    _is.Transaction? transaction,
  }) async {
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $device = device.copyWith(groupId: null);
    await session.db.updateRow<Device>(
      $device,
      columns: [Device.t.groupId],
      transaction: transaction,
    );
  }
}
