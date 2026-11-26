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

/// A durable command queued for a device.
///
/// Commands are written as `pending` and pushed over the device stream when the
/// device is connected. Every row carries a `commandId` the agent echoes back
/// in its `ack`, so delivery is at-least-once and idempotent.
abstract class DeviceCommand
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceCommand._({
    this.id,
    required this.deviceId,
    this.device,
    required this.commandId,
    this.bulkId,
    required this.action,
    this.params,
    required this.status,
    int? attempts,
    this.response,
    this.createdAt,
    this.sentAt,
    this.ackedAt,
  }) : attempts = attempts ?? 0;

  factory DeviceCommand({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String commandId,
    String? bulkId,
    required _inc4d0tr.DeviceAction action,
    String? params,
    required _inc4d0tr.DeviceCommandStatus status,
    int? attempts,
    String? response,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? ackedAt,
  }) = _DeviceCommandImpl;

  factory DeviceCommand.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceCommand(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      commandId: jsonSerialization['commandId'] as String,
      bulkId: jsonSerialization['bulkId'] as String?,
      action: _inc4d0tr.DeviceAction.fromJson(
        (jsonSerialization['action'] as String),
      ),
      params: jsonSerialization['params'] as String?,
      status: _inc4d0tr.DeviceCommandStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      attempts: jsonSerialization['attempts'] as int?,
      response: jsonSerialization['response'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      ackedAt: jsonSerialization['ackedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['ackedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int deviceId;

  _ilo09f9g.Device? device;

  String commandId;

  /// Bulk-send id; null for single-device commands.
  String? bulkId;

  _inc4d0tr.DeviceAction action;

  /// JSON object with the action parameters.
  String? params;

  /// Delivery state: `pending`, `sent`, `acked`, `timeout` or `error`.
  _inc4d0tr.DeviceCommandStatus status;

  int attempts;

  /// JSON response returned with the ack.
  String? response;

  DateTime? createdAt;

  DateTime? sentAt;

  DateTime? ackedAt;

  /// Returns a shallow copy of this [DeviceCommand]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceCommand copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceCommand$device(),
    String? commandId,
    String? bulkId,
    _inc4d0tr.DeviceAction? action,
    String? params,
    _inc4d0tr.DeviceCommandStatus? status,
    int? attempts,
    String? response,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? sentAt = const _isc.$UndefinedDateTime(),
    DateTime? ackedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceCommand',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'commandId': commandId,
      if (bulkId != null) 'bulkId': bulkId,
      'action': action.toJson(),
      if (params != null) 'params': params,
      'status': status.toJson(),
      'attempts': attempts,
      if (response != null) 'response': response,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (ackedAt != null) 'ackedAt': ackedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceCommand',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'commandId': commandId,
      if (bulkId != null) 'bulkId': bulkId,
      'action': action.toJson(),
      if (params != null) 'params': params,
      'status': status.toJson(),
      'attempts': attempts,
      if (response != null) 'response': response,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (ackedAt != null) 'ackedAt': ackedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedDeviceCommand$device extends _isc.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceCommand$device();
}

class _DeviceCommandImpl extends DeviceCommand {
  _DeviceCommandImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    required String commandId,
    String? bulkId,
    required _inc4d0tr.DeviceAction action,
    String? params,
    required _inc4d0tr.DeviceCommandStatus status,
    int? attempts,
    String? response,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? ackedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         commandId: commandId,
         bulkId: bulkId,
         action: action,
         params: params,
         status: status,
         attempts: attempts,
         response: response,
         createdAt: createdAt,
         sentAt: sentAt,
         ackedAt: ackedAt,
       );

  /// Returns a shallow copy of this [DeviceCommand]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceCommand copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceCommand$device(),
    String? commandId,
    Object? bulkId = _Undefined,
    _inc4d0tr.DeviceAction? action,
    Object? params = _Undefined,
    _inc4d0tr.DeviceCommandStatus? status,
    int? attempts,
    Object? response = _Undefined,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? sentAt = const _isc.$UndefinedDateTime(),
    DateTime? ackedAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceCommand(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _isc.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      commandId: commandId ?? this.commandId,
      bulkId: bulkId is String? ? bulkId : this.bulkId,
      action: action ?? this.action,
      params: params is String? ? params : this.params,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      response: response is String? ? response : this.response,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      sentAt: sentAt is _isc.UndefinedSentinel ? this.sentAt : sentAt,
      ackedAt: ackedAt is _isc.UndefinedSentinel ? this.ackedAt : ackedAt,
    );
  }
}
