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

/// Thrown when an unauthenticated or device facing request carries a field
/// beyond its size limit (oversized strings, too many list entries).
abstract class DeviceRequestInvalidException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  DeviceRequestInvalidException._({
    required this.message,
    this.field,
  });

  factory DeviceRequestInvalidException({
    required String message,
    String? field,
  }) = _DeviceRequestInvalidExceptionImpl;

  factory DeviceRequestInvalidException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceRequestInvalidException(
      message: jsonSerialization['message'] as String,
      field: jsonSerialization['field'] as String?,
    );
  }

  String message;

  String? field;

  /// Returns a shallow copy of this [DeviceRequestInvalidException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceRequestInvalidException copyWith({
    String? message,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceRequestInvalidException',
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceRequestInvalidException',
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  String toString() {
    return 'DeviceRequestInvalidException(message: $message, field: $field)';
  }
}

class _Undefined {}

class _DeviceRequestInvalidExceptionImpl extends DeviceRequestInvalidException {
  _DeviceRequestInvalidExceptionImpl({
    required String message,
    String? field,
  }) : super._(
         message: message,
         field: field,
       );

  /// Returns a shallow copy of this [DeviceRequestInvalidException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceRequestInvalidException copyWith({
    String? message,
    Object? field = _Undefined,
  }) {
    return DeviceRequestInvalidException(
      message: message ?? this.message,
      field: field is String? ? field : this.field,
    );
  }
}
