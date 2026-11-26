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

abstract class DeviceConfigResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceConfigResponse._({
    this.deviceCode,
    this.policy,
  });

  factory DeviceConfigResponse({
    String? deviceCode,
    String? policy,
  }) = _DeviceConfigResponseImpl;

  factory DeviceConfigResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceConfigResponse(
      deviceCode: jsonSerialization['deviceCode'] as String?,
      policy: jsonSerialization['policy'] as String?,
    );
  }

  String? deviceCode;

  /// Assigned policy payload as JSON; null when the device has no policy.
  String? policy;

  /// Returns a shallow copy of this [DeviceConfigResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceConfigResponse copyWith({
    String? deviceCode,
    String? policy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceConfigResponse',
      if (deviceCode != null) 'deviceCode': deviceCode,
      if (policy != null) 'policy': policy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceConfigResponse',
      if (deviceCode != null) 'deviceCode': deviceCode,
      if (policy != null) 'policy': policy,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceConfigResponseImpl extends DeviceConfigResponse {
  _DeviceConfigResponseImpl({
    String? deviceCode,
    String? policy,
  }) : super._(
         deviceCode: deviceCode,
         policy: policy,
       );

  /// Returns a shallow copy of this [DeviceConfigResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceConfigResponse copyWith({
    Object? deviceCode = _Undefined,
    Object? policy = _Undefined,
  }) {
    return DeviceConfigResponse(
      deviceCode: deviceCode is String? ? deviceCode : this.deviceCode,
      policy: policy is String? ? policy : this.policy,
    );
  }
}
