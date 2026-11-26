import 'package:wonkrumdm/Core/Constants/Enums/log_level.dart';

class LogEntry {
  LogEntry({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
    this.stacktrace,
    this.deviceId,
    this.sessionId,
    this.synced = 0,
  });

  final String id;
  final String timestamp;
  final int level;
  final String tag;
  final String message;
  final String? stacktrace;
  final String? deviceId;
  final String? sessionId;
  final int synced;

  Map<String, dynamic> toMap() => {
        'id': id,
        'timestamp': timestamp,
        'level': level,
        'tag': tag,
        'message': message,
        'stacktrace': stacktrace,
        'device_id': deviceId,
        'session_id': sessionId,
        'synced': synced,
      };

  Map<String, dynamic> toRemoteEntryMap() => {
        'id': id,
        'timestamp': timestamp,
        // The wire value is the `LogLevel` member name (`info`); the local
        // display label (`INFO`) is separate.
        'level': LogLevel.fromValue(level).name,
        'tag': tag,
        'message': message,
        'stacktrace': stacktrace,
      };

  factory LogEntry.fromMap(Map<dynamic, dynamic> map) => LogEntry(
        id: map['id'] as String? ?? '',
        timestamp: map['timestamp'] as String? ?? '',
        level: (map['level'] as num?)?.toInt() ?? LogLevel.info.value,
        tag: map['tag'] as String? ?? '',
        message: map['message'] as String? ?? '',
        stacktrace: map['stacktrace'] as String?,
        deviceId: map['device_id'] as String?,
        sessionId: map['session_id'] as String?,
        synced: (map['synced'] as num?)?.toInt() ?? 0,
      );
}