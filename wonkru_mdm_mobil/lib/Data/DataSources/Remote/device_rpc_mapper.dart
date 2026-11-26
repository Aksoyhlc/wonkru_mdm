import 'dart:convert';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Data/Models/Core/log_entry.dart';

class DeviceRpcMapper {
  const DeviceRpcMapper._();

  static DeviceSyncRequest syncRequest({
    required String deviceUuid,
    required String token,
    required String syncType,
    required Map<String, dynamic> data,
  }) {
    final payload = Map<String, dynamic>.from(data)
      ..remove('device_uuid')
      ..remove('device_code')
      ..remove('sync_type');
    return DeviceSyncRequest(
      deviceUuid: deviceUuid,
      token: token,
      syncType: syncType,
      payload: jsonEncode(payload),
    );
  }

  static DeviceReportRequest reportRequest({
    required String deviceUuid,
    required String token,
    required String type,
    Map<String, dynamic>? payload,
  }) {
    return DeviceReportRequest(
      deviceUuid: deviceUuid,
      token: token,
      type: type,
      payload: jsonEncode(payload ?? <String, dynamic>{}),
    );
  }

  static List<DeviceLogEntry> logEntries(List<LogEntry> entries) {
    return [
      for (final entry in entries)
        DeviceLogEntry(
          id: entry.id,
          timestamp: entry.timestamp,
          // `toRemoteEntryMap` sends the level name (`info`); the module enum
          // uses the same names.
          level: LogLevel.fromJson(
            entry.toRemoteEntryMap()['level'] as String,
          ),
          tag: entry.tag,
          message: entry.message,
          stacktrace: entry.stacktrace,
          sessionId: entry.sessionId,
        ),
    ];
  }
}
