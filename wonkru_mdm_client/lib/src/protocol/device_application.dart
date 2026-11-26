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
import 'device.dart' as _ilo09f9g;

abstract class DeviceApplication
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceApplication._({
    this.id,
    required this.deviceId,
    this.device,
    required this.packageName,
    required this.appName,
    this.versionName,
    this.versionCode,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    this.isPowerSaveWhitelisted,
    this.lastSeenAt,
    this.createdAt,
    this.updatedAt,
  }) : isSystemApp = isSystemApp ?? false,
       isUninstallBlocked = isUninstallBlocked ?? false;

  factory DeviceApplication({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String packageName,
    required String appName,
    String? versionName,
    int? versionCode,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    bool? isPowerSaveWhitelisted,
    DateTime? lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceApplicationImpl;

  factory DeviceApplication.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceApplication(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      packageName: jsonSerialization['packageName'] as String,
      appName: jsonSerialization['appName'] as String,
      versionName: jsonSerialization['versionName'] as String?,
      versionCode: jsonSerialization['versionCode'] as int?,
      isSystemApp: jsonSerialization['isSystemApp'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSystemApp']),
      isUninstallBlocked: jsonSerialization['isUninstallBlocked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isUninstallBlocked'],
            ),
      isPowerSaveWhitelisted:
          jsonSerialization['isPowerSaveWhitelisted'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isPowerSaveWhitelisted'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSeenAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  String packageName;

  String appName;

  String? versionName;

  int? versionCode;

  bool isSystemApp;

  bool isUninstallBlocked;

  bool? isPowerSaveWhitelisted;

  DateTime? lastSeenAt;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [DeviceApplication]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceApplication copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceApplication$device(),
    String? packageName,
    String? appName,
    String? versionName,
    int? versionCode,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    bool? isPowerSaveWhitelisted,
    DateTime? lastSeenAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceApplication',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'packageName': packageName,
      'appName': appName,
      if (versionName != null) 'versionName': versionName,
      if (versionCode != null) 'versionCode': versionCode,
      'isSystemApp': isSystemApp,
      'isUninstallBlocked': isUninstallBlocked,
      if (isPowerSaveWhitelisted != null)
        'isPowerSaveWhitelisted': isPowerSaveWhitelisted,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceApplication',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'packageName': packageName,
      'appName': appName,
      if (versionName != null) 'versionName': versionName,
      if (versionCode != null) 'versionCode': versionCode,
      'isSystemApp': isSystemApp,
      'isUninstallBlocked': isUninstallBlocked,
      if (isPowerSaveWhitelisted != null)
        'isPowerSaveWhitelisted': isPowerSaveWhitelisted,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceApplication$device extends _isc.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceApplication$device();
}

class _DeviceApplicationImpl extends DeviceApplication {
  _DeviceApplicationImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String packageName,
    required String appName,
    String? versionName,
    int? versionCode,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    bool? isPowerSaveWhitelisted,
    DateTime? lastSeenAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         packageName: packageName,
         appName: appName,
         versionName: versionName,
         versionCode: versionCode,
         isSystemApp: isSystemApp,
         isUninstallBlocked: isUninstallBlocked,
         isPowerSaveWhitelisted: isPowerSaveWhitelisted,
         lastSeenAt: lastSeenAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceApplication]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceApplication copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceApplication$device(),
    String? packageName,
    String? appName,
    Object? versionName = _Undefined,
    Object? versionCode = _Undefined,
    bool? isSystemApp,
    bool? isUninstallBlocked,
    Object? isPowerSaveWhitelisted = _Undefined,
    DateTime? lastSeenAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceApplication(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _isc.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      versionName: versionName is String? ? versionName : this.versionName,
      versionCode: versionCode is int? ? versionCode : this.versionCode,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      isUninstallBlocked: isUninstallBlocked ?? this.isUninstallBlocked,
      isPowerSaveWhitelisted: isPowerSaveWhitelisted is bool?
          ? isPowerSaveWhitelisted
          : this.isPowerSaveWhitelisted,
      lastSeenAt: lastSeenAt is _isc.UndefinedSentinel
          ? this.lastSeenAt
          : lastSeenAt,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
