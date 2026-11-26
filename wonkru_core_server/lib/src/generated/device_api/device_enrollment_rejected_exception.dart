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

/// Thrown by `device.register` when the enrollment key is missing or wrong.
///
/// Distinct from [DeviceUnauthenticatedException] so the agent stops automatic
/// re-enrollment instead of retrying.
abstract class DeviceEnrollmentRejectedException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  DeviceEnrollmentRejectedException._({required this.message});

  factory DeviceEnrollmentRejectedException({required String message}) =
      _DeviceEnrollmentRejectedExceptionImpl;

  factory DeviceEnrollmentRejectedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceEnrollmentRejectedException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [DeviceEnrollmentRejectedException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceEnrollmentRejectedException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceEnrollmentRejectedException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceEnrollmentRejectedException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'DeviceEnrollmentRejectedException(message: $message)';
  }
}

class _DeviceEnrollmentRejectedExceptionImpl
    extends DeviceEnrollmentRejectedException {
  _DeviceEnrollmentRejectedExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [DeviceEnrollmentRejectedException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceEnrollmentRejectedException copyWith({String? message}) {
    return DeviceEnrollmentRejectedException(message: message ?? this.message);
  }
}
