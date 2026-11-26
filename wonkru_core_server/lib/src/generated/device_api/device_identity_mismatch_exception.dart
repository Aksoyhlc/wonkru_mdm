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

/// Thrown by device RPCs when the token is valid but the request carries a
/// different `deviceUuid` than the token was issued for.
///
/// Distinct from [DeviceUnauthenticatedException]: the enrollment is still
/// valid, so the agent must not re-register (that would create a ghost device).
/// It adopts the server's identity from [deviceUuid] / [deviceCode] and retries.
abstract class DeviceIdentityMismatchException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  DeviceIdentityMismatchException._({
    required this.message,
    this.deviceUuid,
    this.deviceCode,
  });

  factory DeviceIdentityMismatchException({
    required String message,
    String? deviceUuid,
    String? deviceCode,
  }) = _DeviceIdentityMismatchExceptionImpl;

  factory DeviceIdentityMismatchException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceIdentityMismatchException(
      message: jsonSerialization['message'] as String,
      deviceUuid: jsonSerialization['deviceUuid'] as String?,
      deviceCode: jsonSerialization['deviceCode'] as String?,
    );
  }

  String message;

  String? deviceUuid;

  String? deviceCode;

  /// Returns a shallow copy of this [DeviceIdentityMismatchException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceIdentityMismatchException copyWith({
    String? message,
    String? deviceUuid,
    String? deviceCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceIdentityMismatchException',
      'message': message,
      if (deviceUuid != null) 'deviceUuid': deviceUuid,
      if (deviceCode != null) 'deviceCode': deviceCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceIdentityMismatchException',
      'message': message,
      if (deviceUuid != null) 'deviceUuid': deviceUuid,
      if (deviceCode != null) 'deviceCode': deviceCode,
    };
  }

  @override
  String toString() {
    return 'DeviceIdentityMismatchException(message: $message, deviceUuid: $deviceUuid, deviceCode: $deviceCode)';
  }
}

class _Undefined {}

class _DeviceIdentityMismatchExceptionImpl
    extends DeviceIdentityMismatchException {
  _DeviceIdentityMismatchExceptionImpl({
    required String message,
    String? deviceUuid,
    String? deviceCode,
  }) : super._(
         message: message,
         deviceUuid: deviceUuid,
         deviceCode: deviceCode,
       );

  /// Returns a shallow copy of this [DeviceIdentityMismatchException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceIdentityMismatchException copyWith({
    String? message,
    Object? deviceUuid = _Undefined,
    Object? deviceCode = _Undefined,
  }) {
    return DeviceIdentityMismatchException(
      message: message ?? this.message,
      deviceUuid: deviceUuid is String? ? deviceUuid : this.deviceUuid,
      deviceCode: deviceCode is String? ? deviceCode : this.deviceCode,
    );
  }
}
