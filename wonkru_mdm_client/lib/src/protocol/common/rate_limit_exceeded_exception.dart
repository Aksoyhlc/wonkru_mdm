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

/// Thrown when an endpoint's rate limit is exceeded.
///
/// Kept under the neutral `common/` path because both device and panel
/// endpoints throw it, so the generated client exposes it to both the panel and
/// the mobile agent. Gives the client a typed error it can wait and retry on
/// instead of a generic 500.
abstract class RateLimitExceededException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  RateLimitExceededException._({
    required this.message,
    required this.retryAfterSeconds,
  });

  factory RateLimitExceededException({
    required String message,
    required int retryAfterSeconds,
  }) = _RateLimitExceededExceptionImpl;

  factory RateLimitExceededException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RateLimitExceededException(
      message: jsonSerialization['message'] as String,
      retryAfterSeconds: jsonSerialization['retryAfterSeconds'] as int,
    );
  }

  String message;

  /// Seconds to wait before retrying (at least 1).
  int retryAfterSeconds;

  /// Returns a shallow copy of this [RateLimitExceededException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RateLimitExceededException copyWith({
    String? message,
    int? retryAfterSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RateLimitExceededException',
      'message': message,
      'retryAfterSeconds': retryAfterSeconds,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RateLimitExceededException',
      'message': message,
      'retryAfterSeconds': retryAfterSeconds,
    };
  }

  @override
  String toString() {
    return 'RateLimitExceededException(message: $message, retryAfterSeconds: $retryAfterSeconds)';
  }
}

class _RateLimitExceededExceptionImpl extends RateLimitExceededException {
  _RateLimitExceededExceptionImpl({
    required String message,
    required int retryAfterSeconds,
  }) : super._(
         message: message,
         retryAfterSeconds: retryAfterSeconds,
       );

  /// Returns a shallow copy of this [RateLimitExceededException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RateLimitExceededException copyWith({
    String? message,
    int? retryAfterSeconds,
  }) {
    return RateLimitExceededException(
      message: message ?? this.message,
      retryAfterSeconds: retryAfterSeconds ?? this.retryAfterSeconds,
    );
  }
}
