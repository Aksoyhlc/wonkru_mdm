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

/// Thrown when a certificate file cannot be decoded; carries a user-facing
/// message.
abstract class CertificateParseException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  CertificateParseException._({required this.message});

  factory CertificateParseException({required String message}) =
      _CertificateParseExceptionImpl;

  factory CertificateParseException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CertificateParseException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [CertificateParseException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CertificateParseException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CertificateParseException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CertificateParseException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'CertificateParseException(message: $message)';
  }
}

class _CertificateParseExceptionImpl extends CertificateParseException {
  _CertificateParseExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [CertificateParseException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CertificateParseException copyWith({String? message}) {
    return CertificateParseException(message: message ?? this.message);
  }
}
