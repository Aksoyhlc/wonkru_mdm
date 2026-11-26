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
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;
import '../application.dart' as _inh16wtc;

/// Thrown when writing an application conflicts with an existing row. A
/// duplicate package name sets [existingApplication]; other conflicts (e.g. a
/// duplicate version code) leave it null.
abstract class ApplicationConflictException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  ApplicationConflictException._({
    required this.message,
    this.existingApplication,
  });

  factory ApplicationConflictException({
    required String message,
    _inh16wtc.Application? existingApplication,
  }) = _ApplicationConflictExceptionImpl;

  factory ApplicationConflictException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ApplicationConflictException(
      message: jsonSerialization['message'] as String,
      existingApplication: jsonSerialization['existingApplication'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_inh16wtc.Application>(
              jsonSerialization['existingApplication'],
            ),
    );
  }

  String message;

  _inh16wtc.Application? existingApplication;

  /// Returns a shallow copy of this [ApplicationConflictException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ApplicationConflictException copyWith({
    String? message,
    _inh16wtc.Application? existingApplication =
        const _UndefinedApplicationConflictException$existingApplication(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApplicationConflictException',
      'message': message,
      if (existingApplication != null)
        'existingApplication': existingApplication?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApplicationConflictException',
      'message': message,
      if (existingApplication != null)
        'existingApplication': existingApplication?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return 'ApplicationConflictException(message: $message, existingApplication: $existingApplication)';
  }
}

class _UndefinedApplicationConflictException$existingApplication
    extends _isc.UndefinedSentinel
    implements _inh16wtc.Application {
  const _UndefinedApplicationConflictException$existingApplication();
}

class _ApplicationConflictExceptionImpl extends ApplicationConflictException {
  _ApplicationConflictExceptionImpl({
    required String message,
    _inh16wtc.Application? existingApplication,
  }) : super._(
         message: message,
         existingApplication: existingApplication,
       );

  /// Returns a shallow copy of this [ApplicationConflictException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ApplicationConflictException copyWith({
    String? message,
    _inh16wtc.Application? existingApplication =
        const _UndefinedApplicationConflictException$existingApplication(),
  }) {
    return ApplicationConflictException(
      message: message ?? this.message,
      existingApplication: existingApplication is _isc.UndefinedSentinel
          ? this.existingApplication?.copyWith()
          : existingApplication,
    );
  }
}
