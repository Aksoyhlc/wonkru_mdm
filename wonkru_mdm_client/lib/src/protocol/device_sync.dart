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

abstract class DeviceSync
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      collectedAt: _isc.DateTimeJsonExtension.fromJson(
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
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  /// Returns a shallow copy of this [DeviceSync]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceSync$device extends _isc.UndefinedSentinel
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
  @_isc.useResult
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
      device: device is _isc.UndefinedSentinel
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
