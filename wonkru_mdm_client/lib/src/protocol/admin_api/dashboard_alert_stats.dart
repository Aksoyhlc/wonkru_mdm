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

abstract class DashboardAlertStats
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DashboardAlertStats._({
    required this.criticalBatteryDevices,
    required this.criticalStorageDevices,
    required this.launcherModeDevices,
    required this.rootedDevices,
  });

  factory DashboardAlertStats({
    required int criticalBatteryDevices,
    required int criticalStorageDevices,
    required int launcherModeDevices,
    required int rootedDevices,
  }) = _DashboardAlertStatsImpl;

  factory DashboardAlertStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return DashboardAlertStats(
      criticalBatteryDevices:
          jsonSerialization['criticalBatteryDevices'] as int,
      criticalStorageDevices:
          jsonSerialization['criticalStorageDevices'] as int,
      launcherModeDevices: jsonSerialization['launcherModeDevices'] as int,
      rootedDevices: jsonSerialization['rootedDevices'] as int,
    );
  }

  /// Devices reporting less than 20 percent battery.
  int criticalBatteryDevices;

  /// Devices with less than 10 percent of their storage free.
  int criticalStorageDevices;

  int launcherModeDevices;

  int rootedDevices;

  /// Returns a shallow copy of this [DashboardAlertStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DashboardAlertStats copyWith({
    int? criticalBatteryDevices,
    int? criticalStorageDevices,
    int? launcherModeDevices,
    int? rootedDevices,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DashboardAlertStats',
      'criticalBatteryDevices': criticalBatteryDevices,
      'criticalStorageDevices': criticalStorageDevices,
      'launcherModeDevices': launcherModeDevices,
      'rootedDevices': rootedDevices,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DashboardAlertStats',
      'criticalBatteryDevices': criticalBatteryDevices,
      'criticalStorageDevices': criticalStorageDevices,
      'launcherModeDevices': launcherModeDevices,
      'rootedDevices': rootedDevices,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DashboardAlertStatsImpl extends DashboardAlertStats {
  _DashboardAlertStatsImpl({
    required int criticalBatteryDevices,
    required int criticalStorageDevices,
    required int launcherModeDevices,
    required int rootedDevices,
  }) : super._(
         criticalBatteryDevices: criticalBatteryDevices,
         criticalStorageDevices: criticalStorageDevices,
         launcherModeDevices: launcherModeDevices,
         rootedDevices: rootedDevices,
       );

  /// Returns a shallow copy of this [DashboardAlertStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DashboardAlertStats copyWith({
    int? criticalBatteryDevices,
    int? criticalStorageDevices,
    int? launcherModeDevices,
    int? rootedDevices,
  }) {
    return DashboardAlertStats(
      criticalBatteryDevices:
          criticalBatteryDevices ?? this.criticalBatteryDevices,
      criticalStorageDevices:
          criticalStorageDevices ?? this.criticalStorageDevices,
      launcherModeDevices: launcherModeDevices ?? this.launcherModeDevices,
      rootedDevices: rootedDevices ?? this.rootedDevices,
    );
  }
}
