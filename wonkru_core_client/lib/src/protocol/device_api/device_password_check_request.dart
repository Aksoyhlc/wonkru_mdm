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

/// Validates the admin password of the device's assigned policy.
abstract class DevicePasswordCheckRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DevicePasswordCheckRequest._({
    required this.deviceUuid,
    required this.token,
    required this.password,
  });

  factory DevicePasswordCheckRequest({
    required String deviceUuid,
    required String token,
    required String password,
  }) = _DevicePasswordCheckRequestImpl;

  factory DevicePasswordCheckRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DevicePasswordCheckRequest(
      deviceUuid: jsonSerialization['deviceUuid'] as String,
      token: jsonSerialization['token'] as String,
      password: jsonSerialization['password'] as String,
    );
  }

  String deviceUuid;

  String token;

  String password;

  /// Returns a shallow copy of this [DevicePasswordCheckRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DevicePasswordCheckRequest copyWith({
    String? deviceUuid,
    String? token,
    String? password,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DevicePasswordCheckRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'password': password,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DevicePasswordCheckRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'password': password,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DevicePasswordCheckRequestImpl extends DevicePasswordCheckRequest {
  _DevicePasswordCheckRequestImpl({
    required String deviceUuid,
    required String token,
    required String password,
  }) : super._(
         deviceUuid: deviceUuid,
         token: token,
         password: password,
       );

  /// Returns a shallow copy of this [DevicePasswordCheckRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DevicePasswordCheckRequest copyWith({
    String? deviceUuid,
    String? token,
    String? password,
  }) {
    return DevicePasswordCheckRequest(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      token: token ?? this.token,
      password: password ?? this.password,
    );
  }
}
