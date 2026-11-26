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

abstract class DeviceConfigRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceConfigRequest._({
    required this.deviceUuid,
    required this.token,
  });

  factory DeviceConfigRequest({
    required String deviceUuid,
    required String token,
  }) = _DeviceConfigRequestImpl;

  factory DeviceConfigRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceConfigRequest(
      deviceUuid: jsonSerialization['deviceUuid'] as String,
      token: jsonSerialization['token'] as String,
    );
  }

  String deviceUuid;

  String token;

  /// Returns a shallow copy of this [DeviceConfigRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceConfigRequest copyWith({
    String? deviceUuid,
    String? token,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceConfigRequest',
      'deviceUuid': deviceUuid,
      'token': token,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceConfigRequest',
      'deviceUuid': deviceUuid,
      'token': token,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceConfigRequestImpl extends DeviceConfigRequest {
  _DeviceConfigRequestImpl({
    required String deviceUuid,
    required String token,
  }) : super._(
         deviceUuid: deviceUuid,
         token: token,
       );

  /// Returns a shallow copy of this [DeviceConfigRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceConfigRequest copyWith({
    String? deviceUuid,
    String? token,
  }) {
    return DeviceConfigRequest(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      token: token ?? this.token,
    );
  }
}
