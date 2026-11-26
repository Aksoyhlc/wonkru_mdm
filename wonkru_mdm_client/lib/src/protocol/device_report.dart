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

abstract class DeviceReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceReport._({
    this.id,
    required this.deviceId,
    this.device,
    required this.type,
    required this.payload,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceReport({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String type,
    required String payload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceReportImpl;

  factory DeviceReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceReport(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      type: jsonSerialization['type'] as String,
      payload: jsonSerialization['payload'] as String,
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

  /// Stored as a raw string because the value set is open: administrators can
  /// define arbitrary report types via the `send_report` action, so a typed enum
  /// would fail to deserialize unknown values. The module `DeviceReportType`
  /// enum remains the typed contract for known types.
  String type;

  /// JSON report payload.
  String payload;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [DeviceReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceReport copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceReport$device(),
    String? type,
    String? payload,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceReport',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'type': type,
      'payload': payload,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceReport',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'type': type,
      'payload': payload,
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

class _UndefinedDeviceReport$device extends _isc.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceReport$device();
}

class _DeviceReportImpl extends DeviceReport {
  _DeviceReportImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String type,
    required String payload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         type: type,
         payload: payload,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceReport copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceReport$device(),
    String? type,
    String? payload,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceReport(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _isc.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
