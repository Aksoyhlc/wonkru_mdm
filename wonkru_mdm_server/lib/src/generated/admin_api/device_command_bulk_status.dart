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

/// Progress summary of a bulk command send. Not a table: `device_commands`
/// rows are grouped and counted by `bulkId`.
abstract class DeviceCommandBulkStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceCommandBulkStatus._({
    required this.bulkId,
    required this.total,
    required this.pending,
    required this.sent,
    required this.acked,
    required this.timeout,
    required this.error,
  });

  factory DeviceCommandBulkStatus({
    required String bulkId,
    required int total,
    required int pending,
    required int sent,
    required int acked,
    required int timeout,
    required int error,
  }) = _DeviceCommandBulkStatusImpl;

  factory DeviceCommandBulkStatus.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceCommandBulkStatus(
      bulkId: jsonSerialization['bulkId'] as String,
      total: jsonSerialization['total'] as int,
      pending: jsonSerialization['pending'] as int,
      sent: jsonSerialization['sent'] as int,
      acked: jsonSerialization['acked'] as int,
      timeout: jsonSerialization['timeout'] as int,
      error: jsonSerialization['error'] as int,
    );
  }

  String bulkId;

  int total;

  int pending;

  int sent;

  int acked;

  int timeout;

  int error;

  /// Returns a shallow copy of this [DeviceCommandBulkStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceCommandBulkStatus copyWith({
    String? bulkId,
    int? total,
    int? pending,
    int? sent,
    int? acked,
    int? timeout,
    int? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceCommandBulkStatus',
      'bulkId': bulkId,
      'total': total,
      'pending': pending,
      'sent': sent,
      'acked': acked,
      'timeout': timeout,
      'error': error,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceCommandBulkStatus',
      'bulkId': bulkId,
      'total': total,
      'pending': pending,
      'sent': sent,
      'acked': acked,
      'timeout': timeout,
      'error': error,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DeviceCommandBulkStatusImpl extends DeviceCommandBulkStatus {
  _DeviceCommandBulkStatusImpl({
    required String bulkId,
    required int total,
    required int pending,
    required int sent,
    required int acked,
    required int timeout,
    required int error,
  }) : super._(
         bulkId: bulkId,
         total: total,
         pending: pending,
         sent: sent,
         acked: acked,
         timeout: timeout,
         error: error,
       );

  /// Returns a shallow copy of this [DeviceCommandBulkStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceCommandBulkStatus copyWith({
    String? bulkId,
    int? total,
    int? pending,
    int? sent,
    int? acked,
    int? timeout,
    int? error,
  }) {
    return DeviceCommandBulkStatus(
      bulkId: bulkId ?? this.bulkId,
      total: total ?? this.total,
      pending: pending ?? this.pending,
      sent: sent ?? this.sent,
      acked: acked ?? this.acked,
      timeout: timeout ?? this.timeout,
      error: error ?? this.error,
    );
  }
}
