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

/// Thrown when an upload is rejected; carries the size numbers so the panel
/// can explain the refusal.
abstract class AdminUploadException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  AdminUploadException._({
    required this.message,
    required this.purpose,
    this.maxSizeBytes,
    this.sizeBytes,
  });

  factory AdminUploadException({
    required String message,
    required String purpose,
    int? maxSizeBytes,
    int? sizeBytes,
  }) = _AdminUploadExceptionImpl;

  factory AdminUploadException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminUploadException(
      message: jsonSerialization['message'] as String,
      purpose: jsonSerialization['purpose'] as String,
      maxSizeBytes: jsonSerialization['maxSizeBytes'] as int?,
      sizeBytes: jsonSerialization['sizeBytes'] as int?,
    );
  }

  String message;

  /// Upload purpose the request was for, e.g. `apk`.
  String purpose;

  /// Size cap in bytes; null when the refusal is not about size.
  int? maxSizeBytes;

  int? sizeBytes;

  /// Returns a shallow copy of this [AdminUploadException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUploadException copyWith({
    String? message,
    String? purpose,
    int? maxSizeBytes,
    int? sizeBytes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUploadException',
      'message': message,
      'purpose': purpose,
      if (maxSizeBytes != null) 'maxSizeBytes': maxSizeBytes,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUploadException',
      'message': message,
      'purpose': purpose,
      if (maxSizeBytes != null) 'maxSizeBytes': maxSizeBytes,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
    };
  }

  @override
  String toString() {
    return 'AdminUploadException(message: $message, purpose: $purpose, maxSizeBytes: $maxSizeBytes, sizeBytes: $sizeBytes)';
  }
}

class _Undefined {}

class _AdminUploadExceptionImpl extends AdminUploadException {
  _AdminUploadExceptionImpl({
    required String message,
    required String purpose,
    int? maxSizeBytes,
    int? sizeBytes,
  }) : super._(
         message: message,
         purpose: purpose,
         maxSizeBytes: maxSizeBytes,
         sizeBytes: sizeBytes,
       );

  /// Returns a shallow copy of this [AdminUploadException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUploadException copyWith({
    String? message,
    String? purpose,
    Object? maxSizeBytes = _Undefined,
    Object? sizeBytes = _Undefined,
  }) {
    return AdminUploadException(
      message: message ?? this.message,
      purpose: purpose ?? this.purpose,
      maxSizeBytes: maxSizeBytes is int? ? maxSizeBytes : this.maxSizeBytes,
      sizeBytes: sizeBytes is int? ? sizeBytes : this.sizeBytes,
    );
  }
}
