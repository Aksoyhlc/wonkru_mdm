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

abstract class DeviceLogStats
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceLogStats._({
    required this.totalLogs,
    required this.errorCount,
    required this.errorRate,
    required this.activeDevices,
    required this.hourlyTrend,
  });

  factory DeviceLogStats({
    required int totalLogs,
    required int errorCount,
    required double errorRate,
    required int activeDevices,
    required List<int> hourlyTrend,
  }) = _DeviceLogStatsImpl;

  factory DeviceLogStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLogStats(
      totalLogs: jsonSerialization['totalLogs'] as int,
      errorCount: jsonSerialization['errorCount'] as int,
      errorRate: (jsonSerialization['errorRate'] as num).toDouble(),
      activeDevices: jsonSerialization['activeDevices'] as int,
      hourlyTrend: _icclvb2d.Protocol().deserialize<List<int>>(
        jsonSerialization['hourlyTrend'],
      ),
    );
  }

  int totalLogs;

  /// ERROR and FATAL logs of the last 24 hours.
  int errorCount;

  /// [errorCount] as a percentage of [totalLogs], one decimal.
  double errorRate;

  int activeDevices;

  /// Log counts of the last seven hours, oldest first.
  List<int> hourlyTrend;

  /// Returns a shallow copy of this [DeviceLogStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceLogStats copyWith({
    int? totalLogs,
    int? errorCount,
    double? errorRate,
    int? activeDevices,
    List<int>? hourlyTrend,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceLogStats',
      'totalLogs': totalLogs,
      'errorCount': errorCount,
      'errorRate': errorRate,
      'activeDevices': activeDevices,
      'hourlyTrend': hourlyTrend.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceLogStats',
      'totalLogs': totalLogs,
      'errorCount': errorCount,
      'errorRate': errorRate,
      'activeDevices': activeDevices,
      'hourlyTrend': hourlyTrend.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeviceLogStatsImpl extends DeviceLogStats {
  _DeviceLogStatsImpl({
    required int totalLogs,
    required int errorCount,
    required double errorRate,
    required int activeDevices,
    required List<int> hourlyTrend,
  }) : super._(
         totalLogs: totalLogs,
         errorCount: errorCount,
         errorRate: errorRate,
         activeDevices: activeDevices,
         hourlyTrend: hourlyTrend,
       );

  /// Returns a shallow copy of this [DeviceLogStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceLogStats copyWith({
    int? totalLogs,
    int? errorCount,
    double? errorRate,
    int? activeDevices,
    List<int>? hourlyTrend,
  }) {
    return DeviceLogStats(
      totalLogs: totalLogs ?? this.totalLogs,
      errorCount: errorCount ?? this.errorCount,
      errorRate: errorRate ?? this.errorRate,
      activeDevices: activeDevices ?? this.activeDevices,
      hourlyTrend: hourlyTrend ?? this.hourlyTrend.map((e0) => e0).toList(),
    );
  }
}
