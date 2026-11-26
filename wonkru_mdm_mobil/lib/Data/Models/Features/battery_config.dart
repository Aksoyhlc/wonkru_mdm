import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class BatteryConfig {
  final bool enabled;

  final int lowBatteryThreshold;

  final int criticalBatteryThreshold;

  BatteryConfig({
    this.enabled = true,
    this.lowBatteryThreshold = 20,
    this.criticalBatteryThreshold = 10,
  });

  factory BatteryConfig.fromJson(Map<String, dynamic> json) {
    return BatteryConfig(
      enabled: JsonParse.toBool(json['enabled']) ?? true,
      lowBatteryThreshold: JsonParse.toInt(json['low_battery_threshold']) ?? 20,
      criticalBatteryThreshold: JsonParse.toInt(json['critical_battery_threshold']) ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'low_battery_threshold': lowBatteryThreshold,
    'critical_battery_threshold': criticalBatteryThreshold,
  };
}