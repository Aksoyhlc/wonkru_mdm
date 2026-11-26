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

abstract class DeviceReportRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceReportRequest._({
    required this.deviceUuid,
    required this.token,
    required this.type,
    required this.payload,
  });

  factory DeviceReportRequest({
    required String deviceUuid,
    required String token,
    required String type,
    required String payload,
  }) = _DeviceReportRequestImpl;

  factory DeviceReportRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceReportRequest(
      deviceUuid: jsonSerialization['deviceUuid'] as String,
      token: jsonSerialization['token'] as String,
      type: jsonSerialization['type'] as String,
      payload: jsonSerialization['payload'] as String,
    );
  }

  String deviceUuid;

  String token;

  String type;

  /// Serialized JSON report payload.
  String payload;

  /// Returns a shallow copy of this [DeviceReportRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceReportRequest copyWith({
    String? deviceUuid,
    String? token,
    String? type,
    String? payload,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceReportRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'type': type,
      'payload': payload,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceReportRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'type': type,
      'payload': payload,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceReportRequestImpl extends DeviceReportRequest {
  _DeviceReportRequestImpl({
    required String deviceUuid,
    required String token,
    required String type,
    required String payload,
  }) : super._(
         deviceUuid: deviceUuid,
         token: token,
         type: type,
         payload: payload,
       );

  /// Returns a shallow copy of this [DeviceReportRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceReportRequest copyWith({
    String? deviceUuid,
    String? token,
    String? type,
    String? payload,
  }) {
    return DeviceReportRequest(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      token: token ?? this.token,
      type: type ?? this.type,
      payload: payload ?? this.payload,
    );
  }
}
