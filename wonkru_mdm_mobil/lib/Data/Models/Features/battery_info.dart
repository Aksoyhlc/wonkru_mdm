import 'package:wonkrumdm/Core/Constants/Enums/battery_enums.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';

class BatteryInfo {
  final int level;

  final BatteryChargingState state;

  final BatteryHealth? health;

  final bool? isPowerSaveMode;

  final DateTime timestamp;

  BatteryInfo({
    required this.level,
    required this.state,
    this.health,
    this.isPowerSaveMode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool isLow({int threshold = 20}) => level <= threshold;

  bool isCritical({int threshold = 10}) => level <= threshold;

  bool get isCharging => state == BatteryChargingState.charging;

  bool get isFull => state == BatteryChargingState.full || level >= 100;

  bool get isDischarging => state == BatteryChargingState.discharging;

  String get stateText {
    switch (state) {
      case BatteryChargingState.charging:
        return L.battery_state_charging;
      case BatteryChargingState.discharging:
        return L.battery_state_discharging;
      case BatteryChargingState.full:
        return L.battery_state_full;
      case BatteryChargingState.connectedNotCharging:
        return L.battery_state_connected_not_charging;
      case BatteryChargingState.unknown:
        return L.battery_state_unknown;
    }
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'state': state.name,
        'health': health?.name,
        'is_power_save_mode': isPowerSaveMode,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };

  @override
  String toString() => 'BatteryInfo(level: $level%, state: $stateText)';
}