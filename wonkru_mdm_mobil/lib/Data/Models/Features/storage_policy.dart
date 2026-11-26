import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class StoragePolicy {
  final bool enabled;

  final int warningThreshold;

  final int criticalThreshold;

  StoragePolicy({
    this.enabled = true,
    this.warningThreshold = 20,
    this.criticalThreshold = 10,
  });

  factory StoragePolicy.fromJson(Map<String, dynamic> json) {
    return StoragePolicy(
      enabled: JsonParse.toBool(json['enabled']) ?? true,
      warningThreshold: JsonParse.toInt(json['warning_threshold']) ?? 20,
      criticalThreshold: JsonParse.toInt(json['critical_threshold']) ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'warning_threshold': warningThreshold,
    'critical_threshold': criticalThreshold,
  };

  StoragePolicy copyWith({
    bool? enabled,
    int? warningThreshold,
    int? criticalThreshold,
  }) {
    return StoragePolicy(
      enabled: enabled ?? this.enabled,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      criticalThreshold: criticalThreshold ?? this.criticalThreshold,
    );
  }
}