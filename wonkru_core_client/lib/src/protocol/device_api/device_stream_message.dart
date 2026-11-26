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

abstract class DeviceStreamMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceStreamMessage._({
    required this.type,
    this.commandId,
    this.payload,
    this.sentAt,
  });

  factory DeviceStreamMessage({
    required String type,
    String? commandId,
    String? payload,
    DateTime? sentAt,
  }) = _DeviceStreamMessageImpl;

  factory DeviceStreamMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceStreamMessage(
      type: jsonSerialization['type'] as String,
      commandId: jsonSerialization['commandId'] as String?,
      payload: jsonSerialization['payload'] as String?,
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
    );
  }

  /// Message kind: `welcome`, `heartbeat`, `ack` or `command`.
  String type;

  String? commandId;

  String? payload;

  DateTime? sentAt;

  /// Returns a shallow copy of this [DeviceStreamMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceStreamMessage copyWith({
    String? type,
    String? commandId,
    String? payload,
    DateTime? sentAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceStreamMessage',
      'type': type,
      if (commandId != null) 'commandId': commandId,
      if (payload != null) 'payload': payload,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceStreamMessage',
      'type': type,
      if (commandId != null) 'commandId': commandId,
      if (payload != null) 'payload': payload,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceStreamMessageImpl extends DeviceStreamMessage {
  _DeviceStreamMessageImpl({
    required String type,
    String? commandId,
    String? payload,
    DateTime? sentAt,
  }) : super._(
         type: type,
         commandId: commandId,
         payload: payload,
         sentAt: sentAt,
       );

  /// Returns a shallow copy of this [DeviceStreamMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceStreamMessage copyWith({
    String? type,
    Object? commandId = _Undefined,
    Object? payload = _Undefined,
    DateTime? sentAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceStreamMessage(
      type: type ?? this.type,
      commandId: commandId is String? ? commandId : this.commandId,
      payload: payload is String? ? payload : this.payload,
      sentAt: sentAt is _isc.UndefinedSentinel ? this.sentAt : sentAt,
    );
  }
}
