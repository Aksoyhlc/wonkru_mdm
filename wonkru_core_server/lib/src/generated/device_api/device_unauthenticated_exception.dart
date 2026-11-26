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

abstract class DeviceUnauthenticatedException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  DeviceUnauthenticatedException._({required this.message});

  factory DeviceUnauthenticatedException({required String message}) =
      _DeviceUnauthenticatedExceptionImpl;

  factory DeviceUnauthenticatedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceUnauthenticatedException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [DeviceUnauthenticatedException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceUnauthenticatedException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceUnauthenticatedException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceUnauthenticatedException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'DeviceUnauthenticatedException(message: $message)';
  }
}

class _DeviceUnauthenticatedExceptionImpl
    extends DeviceUnauthenticatedException {
  _DeviceUnauthenticatedExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [DeviceUnauthenticatedException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceUnauthenticatedException copyWith({String? message}) {
    return DeviceUnauthenticatedException(message: message ?? this.message);
  }
}
