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
import '../device_sync.dart' as _iflbyewe;

abstract class DeviceSyncRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceSyncRow._({
    required this.deviceSync,
    required this.deviceCode,
    this.deviceName,
    this.policyName,
    this.policyVersion,
    this.brand,
    this.androidVersion,
    this.batteryLevel,
    required this.appsCount,
  });

  factory DeviceSyncRow({
    required _iflbyewe.DeviceSync deviceSync,
    required String deviceCode,
    String? deviceName,
    String? policyName,
    int? policyVersion,
    String? brand,
    String? androidVersion,
    int? batteryLevel,
    required int appsCount,
  }) = _DeviceSyncRowImpl;

  factory DeviceSyncRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceSyncRow(
      deviceSync: _icclvb2d.Protocol().deserialize<_iflbyewe.DeviceSync>(
        jsonSerialization['deviceSync'],
      ),
      deviceCode: jsonSerialization['deviceCode'] as String,
      deviceName: jsonSerialization['deviceName'] as String?,
      policyName: jsonSerialization['policyName'] as String?,
      policyVersion: jsonSerialization['policyVersion'] as int?,
      brand: jsonSerialization['brand'] as String?,
      androidVersion: jsonSerialization['androidVersion'] as String?,
      batteryLevel: jsonSerialization['batteryLevel'] as int?,
      appsCount: jsonSerialization['appsCount'] as int,
    );
  }

  _iflbyewe.DeviceSync deviceSync;

  /// `code` of the device, or `#id` when it has no code.
  String deviceCode;

  String? deviceName;

  String? policyName;

  int? policyVersion;

  String? brand;

  String? androidVersion;

  int? batteryLevel;

  /// `apps_info.totalInstalled` of this snapshot.
  int appsCount;

  /// Returns a shallow copy of this [DeviceSyncRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceSyncRow copyWith({
    _iflbyewe.DeviceSync? deviceSync,
    String? deviceCode,
    String? deviceName,
    String? policyName,
    int? policyVersion,
    String? brand,
    String? androidVersion,
    int? batteryLevel,
    int? appsCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceSyncRow',
      'deviceSync': deviceSync.toJson(),
      'deviceCode': deviceCode,
      if (deviceName != null) 'deviceName': deviceName,
      if (policyName != null) 'policyName': policyName,
      if (policyVersion != null) 'policyVersion': policyVersion,
      if (brand != null) 'brand': brand,
      if (androidVersion != null) 'androidVersion': androidVersion,
      if (batteryLevel != null) 'batteryLevel': batteryLevel,
      'appsCount': appsCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceSyncRow',
      'deviceSync': deviceSync.toJsonForProtocol(),
      'deviceCode': deviceCode,
      if (deviceName != null) 'deviceName': deviceName,
      if (policyName != null) 'policyName': policyName,
      if (policyVersion != null) 'policyVersion': policyVersion,
      if (brand != null) 'brand': brand,
      if (androidVersion != null) 'androidVersion': androidVersion,
      if (batteryLevel != null) 'batteryLevel': batteryLevel,
      'appsCount': appsCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceSyncRowImpl extends DeviceSyncRow {
  _DeviceSyncRowImpl({
    required _iflbyewe.DeviceSync deviceSync,
    required String deviceCode,
    String? deviceName,
    String? policyName,
    int? policyVersion,
    String? brand,
    String? androidVersion,
    int? batteryLevel,
    required int appsCount,
  }) : super._(
         deviceSync: deviceSync,
         deviceCode: deviceCode,
         deviceName: deviceName,
         policyName: policyName,
         policyVersion: policyVersion,
         brand: brand,
         androidVersion: androidVersion,
         batteryLevel: batteryLevel,
         appsCount: appsCount,
       );

  /// Returns a shallow copy of this [DeviceSyncRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceSyncRow copyWith({
    _iflbyewe.DeviceSync? deviceSync,
    String? deviceCode,
    Object? deviceName = _Undefined,
    Object? policyName = _Undefined,
    Object? policyVersion = _Undefined,
    Object? brand = _Undefined,
    Object? androidVersion = _Undefined,
    Object? batteryLevel = _Undefined,
    int? appsCount,
  }) {
    return DeviceSyncRow(
      deviceSync: deviceSync ?? this.deviceSync.copyWith(),
      deviceCode: deviceCode ?? this.deviceCode,
      deviceName: deviceName is String? ? deviceName : this.deviceName,
      policyName: policyName is String? ? policyName : this.policyName,
      policyVersion: policyVersion is int? ? policyVersion : this.policyVersion,
      brand: brand is String? ? brand : this.brand,
      androidVersion: androidVersion is String?
          ? androidVersion
          : this.androidVersion,
      batteryLevel: batteryLevel is int? ? batteryLevel : this.batteryLevel,
      appsCount: appsCount ?? this.appsCount,
    );
  }
}
