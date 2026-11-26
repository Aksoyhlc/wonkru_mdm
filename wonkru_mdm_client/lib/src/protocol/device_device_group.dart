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
import 'device_group.dart' as _i94jjjz5;

abstract class DeviceDeviceGroup
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceDeviceGroup._({
    this.id,
    required this.deviceId,
    this.device,
    required this.deviceGroupId,
    this.deviceGroup,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceDeviceGroup({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required int deviceGroupId,
    _i94jjjz5.DeviceGroup? deviceGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceDeviceGroupImpl;

  factory DeviceDeviceGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceDeviceGroup(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      deviceGroupId: jsonSerialization['deviceGroupId'] as int,
      deviceGroup: jsonSerialization['deviceGroup'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_i94jjjz5.DeviceGroup>(
              jsonSerialization['deviceGroup'],
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

  int deviceGroupId;

  _i94jjjz5.DeviceGroup? deviceGroup;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [DeviceDeviceGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceDeviceGroup copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceDeviceGroup$device(),
    int? deviceGroupId,
    _i94jjjz5.DeviceGroup? deviceGroup =
        const _UndefinedDeviceDeviceGroup$deviceGroup(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceDeviceGroup',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'deviceGroupId': deviceGroupId,
      if (deviceGroup != null) 'deviceGroup': deviceGroup?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceDeviceGroup',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'deviceGroupId': deviceGroupId,
      if (deviceGroup != null) 'deviceGroup': deviceGroup?.toJsonForProtocol(),
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

class _UndefinedDeviceDeviceGroup$device extends _isc.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceDeviceGroup$device();
}

class _UndefinedDeviceDeviceGroup$deviceGroup extends _isc.UndefinedSentinel
    implements _i94jjjz5.DeviceGroup {
  const _UndefinedDeviceDeviceGroup$deviceGroup();
}

class _DeviceDeviceGroupImpl extends DeviceDeviceGroup {
  _DeviceDeviceGroupImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required int deviceGroupId,
    _i94jjjz5.DeviceGroup? deviceGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         deviceGroupId: deviceGroupId,
         deviceGroup: deviceGroup,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceDeviceGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceDeviceGroup copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceDeviceGroup$device(),
    int? deviceGroupId,
    _i94jjjz5.DeviceGroup? deviceGroup =
        const _UndefinedDeviceDeviceGroup$deviceGroup(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceDeviceGroup(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _isc.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      deviceGroupId: deviceGroupId ?? this.deviceGroupId,
      deviceGroup: deviceGroup is _isc.UndefinedSentinel
          ? this.deviceGroup?.copyWith()
          : deviceGroup,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
