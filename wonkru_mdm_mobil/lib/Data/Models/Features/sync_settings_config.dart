import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class SyncSettingsConfig {
  final String? fullSyncCron;

  final int maxIntervalMinutes;

  SyncSettingsConfig({this.fullSyncCron, this.maxIntervalMinutes = 60});

  factory SyncSettingsConfig.fromJson(Map<String, dynamic> json) {
    return SyncSettingsConfig(
      fullSyncCron: JsonParse.toStr(json['full_sync_cron']),
      maxIntervalMinutes: JsonParse.toInt(json['max_interval_minutes']) ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_sync_cron': fullSyncCron,
      'max_interval_minutes': maxIntervalMinutes,
    };
  }
}