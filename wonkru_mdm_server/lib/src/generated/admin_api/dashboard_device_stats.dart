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

abstract class DashboardDeviceStats
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DashboardDeviceStats._({
    required this.totalDevices,
    required this.onlineDevices,
    required this.offlineDevices,
    required this.onlineMinutes,
  });

  factory DashboardDeviceStats({
    required int totalDevices,
    required int onlineDevices,
    required int offlineDevices,
    required int onlineMinutes,
  }) = _DashboardDeviceStatsImpl;

  factory DashboardDeviceStats.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DashboardDeviceStats(
      totalDevices: jsonSerialization['totalDevices'] as int,
      onlineDevices: jsonSerialization['onlineDevices'] as int,
      offlineDevices: jsonSerialization['offlineDevices'] as int,
      onlineMinutes: jsonSerialization['onlineMinutes'] as int,
    );
  }

  int totalDevices;

  /// Devices seen within [onlineMinutes].
  int onlineDevices;

  /// [totalDevices] minus [onlineDevices].
  int offlineDevices;

  /// Window the dashboard counted as online, from the `offline_timeout`
  /// setting.
  int onlineMinutes;

  /// Returns a shallow copy of this [DashboardDeviceStats]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DashboardDeviceStats copyWith({
    int? totalDevices,
    int? onlineDevices,
    int? offlineDevices,
    int? onlineMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DashboardDeviceStats',
      'totalDevices': totalDevices,
      'onlineDevices': onlineDevices,
      'offlineDevices': offlineDevices,
      'onlineMinutes': onlineMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DashboardDeviceStats',
      'totalDevices': totalDevices,
      'onlineDevices': onlineDevices,
      'offlineDevices': offlineDevices,
      'onlineMinutes': onlineMinutes,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DashboardDeviceStatsImpl extends DashboardDeviceStats {
  _DashboardDeviceStatsImpl({
    required int totalDevices,
    required int onlineDevices,
    required int offlineDevices,
    required int onlineMinutes,
  }) : super._(
         totalDevices: totalDevices,
         onlineDevices: onlineDevices,
         offlineDevices: offlineDevices,
         onlineMinutes: onlineMinutes,
       );

  /// Returns a shallow copy of this [DashboardDeviceStats]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DashboardDeviceStats copyWith({
    int? totalDevices,
    int? onlineDevices,
    int? offlineDevices,
    int? onlineMinutes,
  }) {
    return DashboardDeviceStats(
      totalDevices: totalDevices ?? this.totalDevices,
      onlineDevices: onlineDevices ?? this.onlineDevices,
      offlineDevices: offlineDevices ?? this.offlineDevices,
      onlineMinutes: onlineMinutes ?? this.onlineMinutes,
    );
  }
}
