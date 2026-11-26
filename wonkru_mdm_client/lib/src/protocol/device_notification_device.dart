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
import 'package:wonkru_core_client/wonkru_core_client.dart' as _inc4d0tr;
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;
import 'device.dart' as _ilo09f9g;
import 'device_notification.dart' as _ixgsn4mm;

abstract class DeviceNotificationDevice
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceNotificationDevice._({
    this.id,
    required this.deviceNotificationId,
    this.deviceNotification,
    required this.deviceId,
    this.device,
    required this.status,
    this.sentAt,
    this.receivedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceNotificationDevice({
    int? id,
    required int deviceNotificationId,
    _ixgsn4mm.DeviceNotification? deviceNotification,
    required int deviceId,
    _ilo09f9g.Device? device,
    required _inc4d0tr.NotificationDeliveryStatus status,
    DateTime? sentAt,
    DateTime? receivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceNotificationDeviceImpl;

  factory DeviceNotificationDevice.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceNotificationDevice(
      id: jsonSerialization['id'] as int?,
      deviceNotificationId: jsonSerialization['deviceNotificationId'] as int,
      deviceNotification: jsonSerialization['deviceNotification'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ixgsn4mm.DeviceNotification>(
              jsonSerialization['deviceNotification'],
            ),
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      status: _inc4d0tr.NotificationDeliveryStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['receivedAt'],
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

  int deviceNotificationId;

  _ixgsn4mm.DeviceNotification? deviceNotification;

  int deviceId;

  _ilo09f9g.Device? device;

  _inc4d0tr.NotificationDeliveryStatus status;

  DateTime? sentAt;

  DateTime? receivedAt;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [DeviceNotificationDevice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceNotificationDevice copyWith({
    int? id,
    int? deviceNotificationId,
    _ixgsn4mm.DeviceNotification? deviceNotification =
        const _UndefinedDeviceNotificationDevice$deviceNotification(),
    int? deviceId,
    _ilo09f9g.Device? device =
        const _UndefinedDeviceNotificationDevice$device(),
    _inc4d0tr.NotificationDeliveryStatus? status,
    DateTime? sentAt = const _isc.$UndefinedDateTime(),
    DateTime? receivedAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceNotificationDevice',
      if (id != null) 'id': id,
      'deviceNotificationId': deviceNotificationId,
      if (deviceNotification != null)
        'deviceNotification': deviceNotification?.toJson(),
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'status': status.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceNotificationDevice',
      if (id != null) 'id': id,
      'deviceNotificationId': deviceNotificationId,
      if (deviceNotification != null)
        'deviceNotification': deviceNotification?.toJsonForProtocol(),
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'status': status.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
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

class _UndefinedDeviceNotificationDevice$deviceNotification
    extends _isc.UndefinedSentinel
    implements _ixgsn4mm.DeviceNotification {
  const _UndefinedDeviceNotificationDevice$deviceNotification();
}

class _UndefinedDeviceNotificationDevice$device extends _isc.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceNotificationDevice$device();
}

class _DeviceNotificationDeviceImpl extends DeviceNotificationDevice {
  _DeviceNotificationDeviceImpl({
    int? id,
    required int deviceNotificationId,
    _ixgsn4mm.DeviceNotification? deviceNotification,
    required int deviceId,
    _ilo09f9g.Device? device,
    required _inc4d0tr.NotificationDeliveryStatus status,
    DateTime? sentAt,
    DateTime? receivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceNotificationId: deviceNotificationId,
         deviceNotification: deviceNotification,
         deviceId: deviceId,
         device: device,
         status: status,
         sentAt: sentAt,
         receivedAt: receivedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceNotificationDevice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceNotificationDevice copyWith({
    Object? id = _Undefined,
    int? deviceNotificationId,
    _ixgsn4mm.DeviceNotification? deviceNotification =
        const _UndefinedDeviceNotificationDevice$deviceNotification(),
    int? deviceId,
    _ilo09f9g.Device? device =
        const _UndefinedDeviceNotificationDevice$device(),
    _inc4d0tr.NotificationDeliveryStatus? status,
    DateTime? sentAt = const _isc.$UndefinedDateTime(),
    DateTime? receivedAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceNotificationDevice(
      id: id is int? ? id : this.id,
      deviceNotificationId: deviceNotificationId ?? this.deviceNotificationId,
      deviceNotification: deviceNotification is _isc.UndefinedSentinel
          ? this.deviceNotification?.copyWith()
          : deviceNotification,
      deviceId: deviceId ?? this.deviceId,
      device: device is _isc.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      status: status ?? this.status,
      sentAt: sentAt is _isc.UndefinedSentinel ? this.sentAt : sentAt,
      receivedAt: receivedAt is _isc.UndefinedSentinel
          ? this.receivedAt
          : receivedAt,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
