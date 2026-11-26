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

/// Thrown when a settings value is rejected; carries a message the panel can
/// show directly.
abstract class AdminSettingsException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  AdminSettingsException._({
    required this.message,
    this.field,
  });

  factory AdminSettingsException({
    required String message,
    String? field,
  }) = _AdminSettingsExceptionImpl;

  factory AdminSettingsException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminSettingsException(
      message: jsonSerialization['message'] as String,
      field: jsonSerialization['field'] as String?,
    );
  }

  String message;

  /// Name of the offending field in `SettingsFormState`; null when unknown.
  String? field;

  /// Returns a shallow copy of this [AdminSettingsException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminSettingsException copyWith({
    String? message,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminSettingsException',
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminSettingsException',
      'message': message,
      if (field != null) 'field': field,
    };
  }

  @override
  String toString() {
    return 'AdminSettingsException(message: $message, field: $field)';
  }
}

class _Undefined {}

class _AdminSettingsExceptionImpl extends AdminSettingsException {
  _AdminSettingsExceptionImpl({
    required String message,
    String? field,
  }) : super._(
         message: message,
         field: field,
       );

  /// Returns a shallow copy of this [AdminSettingsException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminSettingsException copyWith({
    String? message,
    Object? field = _Undefined,
  }) {
    return AdminSettingsException(
      message: message ?? this.message,
      field: field is String? ? field : this.field,
    );
  }
}
