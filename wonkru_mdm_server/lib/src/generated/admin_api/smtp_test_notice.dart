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

abstract class SmtpTestNotice
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SmtpTestNotice._({
    required this.status,
    required this.severity,
    this.detail,
  });

  factory SmtpTestNotice({
    required String status,
    required String severity,
    String? detail,
  }) = _SmtpTestNoticeImpl;

  factory SmtpTestNotice.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmtpTestNotice(
      status: jsonSerialization['status'] as String,
      severity: jsonSerialization['severity'] as String,
      detail: jsonSerialization['detail'] as String?,
    );
  }

  /// Stable key the panel localizes: `invalid_email`, `missing_host`,
  /// `mailer_not_smtp`, `sent` or `failed`.
  String status;

  /// `success`, `warning` or `danger`.
  String severity;

  String? detail;

  /// Returns a shallow copy of this [SmtpTestNotice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SmtpTestNotice copyWith({
    String? status,
    String? severity,
    String? detail,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SmtpTestNotice',
      'status': status,
      'severity': severity,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SmtpTestNotice',
      'status': status,
      'severity': severity,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmtpTestNoticeImpl extends SmtpTestNotice {
  _SmtpTestNoticeImpl({
    required String status,
    required String severity,
    String? detail,
  }) : super._(
         status: status,
         severity: severity,
         detail: detail,
       );

  /// Returns a shallow copy of this [SmtpTestNotice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SmtpTestNotice copyWith({
    String? status,
    String? severity,
    Object? detail = _Undefined,
  }) {
    return SmtpTestNotice(
      status: status ?? this.status,
      severity: severity ?? this.severity,
      detail: detail is String? ? detail : this.detail,
    );
  }
}
