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

abstract class DeviceLogTrend
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceLogTrend._({
    required this.labels,
    required this.totals,
    required this.errors,
  });

  factory DeviceLogTrend({
    required List<String> labels,
    required List<int> totals,
    required List<int> errors,
  }) = _DeviceLogTrendImpl;

  factory DeviceLogTrend.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLogTrend(
      labels: _icclvb2d.Protocol().deserialize<List<String>>(
        jsonSerialization['labels'],
      ),
      totals: _icclvb2d.Protocol().deserialize<List<int>>(
        jsonSerialization['totals'],
      ),
      errors: _icclvb2d.Protocol().deserialize<List<int>>(
        jsonSerialization['errors'],
      ),
    );
  }

  /// Bucket labels, oldest first. Hourly for the 24 hour window, daily
  /// otherwise.
  List<String> labels;

  List<int> totals;

  /// ERROR and FATAL logs per bucket.
  List<int> errors;

  /// Returns a shallow copy of this [DeviceLogTrend]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceLogTrend copyWith({
    List<String>? labels,
    List<int>? totals,
    List<int>? errors,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceLogTrend',
      'labels': labels.toJson(),
      'totals': totals.toJson(),
      'errors': errors.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceLogTrend',
      'labels': labels.toJson(),
      'totals': totals.toJson(),
      'errors': errors.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceLogTrendImpl extends DeviceLogTrend {
  _DeviceLogTrendImpl({
    required List<String> labels,
    required List<int> totals,
    required List<int> errors,
  }) : super._(
         labels: labels,
         totals: totals,
         errors: errors,
       );

  /// Returns a shallow copy of this [DeviceLogTrend]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceLogTrend copyWith({
    List<String>? labels,
    List<int>? totals,
    List<int>? errors,
  }) {
    return DeviceLogTrend(
      labels: labels ?? this.labels.map((e0) => e0).toList(),
      totals: totals ?? this.totals.map((e0) => e0).toList(),
      errors: errors ?? this.errors.map((e0) => e0).toList(),
    );
  }
}
