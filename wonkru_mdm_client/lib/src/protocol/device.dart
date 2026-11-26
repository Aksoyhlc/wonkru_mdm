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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;
import 'device_group.dart' as _i94jjjz5;
import 'policy.dart' as _if7d246m;

abstract class Device
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Device._({
    this.id,
    required this.code,
    this.uuid,
    this.name,
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
    int? policyId,
    _if7d246m.Policy? policy,
    int? policyVersion,
    DateTime? lastPolicyUpdate,
    int? groupId,
    _i94jjjz5.DeviceGroup? group,
    _isc.UuidValue? userId,
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
      policyId: jsonSerialization['policyId'] as int?,
      policy: jsonSerialization['policy'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_if7d246m.Policy>(
              jsonSerialization['policy'],
            ),
      policyVersion: jsonSerialization['policyVersion'] as int?,
      lastPolicyUpdate: jsonSerialization['lastPolicyUpdate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPolicyUpdate'],
            ),
      groupId: jsonSerialization['groupId'] as int?,
      group: jsonSerialization['group'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_i94jjjz5.DeviceGroup>(
              jsonSerialization['group'],
            ),
      userId: jsonSerialization['userId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
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
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isRooted']),
      isLauncherMode: jsonSerialization['isLauncherMode'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isLauncherMode'],
            ),
      totalStorageBytes: jsonSerialization['totalStorageBytes'] as int?,
      freeStorageBytes: jsonSerialization['freeStorageBytes'] as int?,
      collectedAt: jsonSerialization['collectedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['collectedAt'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSeenAt'],
            ),
      firstSeenAt: jsonSerialization['firstSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstSeenAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      mustUseApplications: jsonSerialization['mustUseApplications'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String? uuid;

  String? name;

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
  _isc.UuidValue? userId;

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

  /// Returns a shallow copy of this [Device]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Device copyWith({
    int? id,
    String? code,
    String? uuid,
    String? name,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedDevice$policy(),
    int? policyVersion,
    DateTime? lastPolicyUpdate = const _isc.$UndefinedDateTime(),
    int? groupId,
    _i94jjjz5.DeviceGroup? group = const _UndefinedDevice$group(),
    _isc.UuidValue? userId = const _isc.$UndefinedUuidValue(),
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
    DateTime? collectedAt = const _isc.$UndefinedDateTime(),
    DateTime? lastSeenAt = const _isc.$UndefinedDateTime(),
    DateTime? firstSeenAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDevice$policy extends _isc.UndefinedSentinel
    implements _if7d246m.Policy {
  const _UndefinedDevice$policy();
}

class _UndefinedDevice$group extends _isc.UndefinedSentinel
    implements _i94jjjz5.DeviceGroup {
  const _UndefinedDevice$group();
}

class _DeviceImpl extends Device {
  _DeviceImpl({
    int? id,
    required String code,
    String? uuid,
    String? name,
    int? policyId,
    _if7d246m.Policy? policy,
    int? policyVersion,
    DateTime? lastPolicyUpdate,
    int? groupId,
    _i94jjjz5.DeviceGroup? group,
    _isc.UuidValue? userId,
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
  @_isc.useResult
  @override
  Device copyWith({
    Object? id = _Undefined,
    String? code,
    Object? uuid = _Undefined,
    Object? name = _Undefined,
    Object? policyId = _Undefined,
    _if7d246m.Policy? policy = const _UndefinedDevice$policy(),
    Object? policyVersion = _Undefined,
    DateTime? lastPolicyUpdate = const _isc.$UndefinedDateTime(),
    Object? groupId = _Undefined,
    _i94jjjz5.DeviceGroup? group = const _UndefinedDevice$group(),
    _isc.UuidValue? userId = const _isc.$UndefinedUuidValue(),
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
    DateTime? collectedAt = const _isc.$UndefinedDateTime(),
    DateTime? lastSeenAt = const _isc.$UndefinedDateTime(),
    DateTime? firstSeenAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
    Object? mustUseApplications = _Undefined,
  }) {
    return Device(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      uuid: uuid is String? ? uuid : this.uuid,
      name: name is String? ? name : this.name,
      policyId: policyId is int? ? policyId : this.policyId,
      policy: policy is _isc.UndefinedSentinel
          ? this.policy?.copyWith()
          : policy,
      policyVersion: policyVersion is int? ? policyVersion : this.policyVersion,
      lastPolicyUpdate: lastPolicyUpdate is _isc.UndefinedSentinel
          ? this.lastPolicyUpdate
          : lastPolicyUpdate,
      groupId: groupId is int? ? groupId : this.groupId,
      group: group is _isc.UndefinedSentinel ? this.group?.copyWith() : group,
      userId: userId is _isc.UndefinedSentinel ? this.userId : userId,
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
      collectedAt: collectedAt is _isc.UndefinedSentinel
          ? this.collectedAt
          : collectedAt,
      lastSeenAt: lastSeenAt is _isc.UndefinedSentinel
          ? this.lastSeenAt
          : lastSeenAt,
      firstSeenAt: firstSeenAt is _isc.UndefinedSentinel
          ? this.firstSeenAt
          : firstSeenAt,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
      deletedAt: deletedAt is _isc.UndefinedSentinel
          ? this.deletedAt
          : deletedAt,
      mustUseApplications: mustUseApplications is String?
          ? mustUseApplications
          : this.mustUseApplications,
    );
  }
}
