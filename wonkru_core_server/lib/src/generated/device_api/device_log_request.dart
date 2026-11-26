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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:wonkru_core_server/src/generated/protocol.dart' as _isn6ihzf;
import '../device_api/device_log_entry.dart' as _ibiu6drt;

abstract class DeviceLogRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceLogRequest._({
    required this.deviceUuid,
    required this.token,
    this.sessionId,
    required this.entries,
  });

  factory DeviceLogRequest({
    required String deviceUuid,
    required String token,
    String? sessionId,
    required List<_ibiu6drt.DeviceLogEntry> entries,
  }) = _DeviceLogRequestImpl;

  factory DeviceLogRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLogRequest(
      deviceUuid: jsonSerialization['deviceUuid'] as String,
      token: jsonSerialization['token'] as String,
      sessionId: jsonSerialization['sessionId'] as String?,
      entries: _isn6ihzf.Protocol().deserialize<List<_ibiu6drt.DeviceLogEntry>>(
        jsonSerialization['entries'],
      ),
    );
  }

  String deviceUuid;

  String token;

  String? sessionId;

  List<_ibiu6drt.DeviceLogEntry> entries;

  /// Returns a shallow copy of this [DeviceLogRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceLogRequest copyWith({
    String? deviceUuid,
    String? token,
    String? sessionId,
    List<_ibiu6drt.DeviceLogEntry>? entries,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceLogRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      if (sessionId != null) 'sessionId': sessionId,
      'entries': entries.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceLogRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      if (sessionId != null) 'sessionId': sessionId,
      'entries': entries.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceLogRequestImpl extends DeviceLogRequest {
  _DeviceLogRequestImpl({
    required String deviceUuid,
    required String token,
    String? sessionId,
    required List<_ibiu6drt.DeviceLogEntry> entries,
  }) : super._(
         deviceUuid: deviceUuid,
         token: token,
         sessionId: sessionId,
         entries: entries,
       );

  /// Returns a shallow copy of this [DeviceLogRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceLogRequest copyWith({
    String? deviceUuid,
    String? token,
    Object? sessionId = _Undefined,
    List<_ibiu6drt.DeviceLogEntry>? entries,
  }) {
    return DeviceLogRequest(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      token: token ?? this.token,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      entries: entries ?? this.entries.map((e0) => e0.copyWith()).toList(),
    );
  }
}
