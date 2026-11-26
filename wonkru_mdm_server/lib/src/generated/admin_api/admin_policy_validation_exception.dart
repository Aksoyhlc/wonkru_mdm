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

/// Thrown when a policy setting is inconsistent; carries the dotted path of the
/// offending field (e.g. `display_settings.min_brightness`).
abstract class AdminPolicyValidationException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  AdminPolicyValidationException._({
    required this.message,
    this.field,
  });

  factory AdminPolicyValidationException({
    required String message,
    String? field,
  }) = _AdminPolicyValidationExceptionImpl;

  factory AdminPolicyValidationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminPolicyValidationException(
      message: jsonSerialization['message'] as String,
      field: jsonSerialization['field'] as String?,
    );
  }

  /// Developer-facing message; the panel translates it by [field].
  String message;

  String? field;

  /// Returns a shallow copy of this [AdminPolicyValidationException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminPolicyValidationException copyWith({
    String? message,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminPolicyValidationException',
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminPolicyValidationException',
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  String toString() {
    return 'AdminPolicyValidationException(message: $message, field: $field)';
  }
}

class _Undefined {}

class _AdminPolicyValidationExceptionImpl
    extends AdminPolicyValidationException {
  _AdminPolicyValidationExceptionImpl({
    required String message,
    String? field,
  }) : super._(
         message: message,
         field: field,
       );

  /// Returns a shallow copy of this [AdminPolicyValidationException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminPolicyValidationException copyWith({
    String? message,
    Object? field = _Undefined,
  }) {
    return AdminPolicyValidationException(
      message: message ?? this.message,
      field: field is String? ? field : this.field,
    );
  }
}
