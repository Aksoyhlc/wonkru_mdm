import 'package:wonkrumdm/Core/Constants/Enums/log_level.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';

class WLogConfig {
  const WLogConfig({
    this.consoleMinLevel = LogLevel.info,
    this.dbMinLevel = LogLevel.info,
    this.remoteMinLevel = LogLevel.warning,
    this.maxLocalEntries = 1000,
    this.flushThreshold = 50,
    this.idleFlushSeconds = 60,
    this.retentionDays = 7,
    this.remoteEnabled = false,
    this.remoteEndpoint = '',
    this.remoteAuthToken = '',
    this.remoteMaxRetries = 3,
  });

  final LogLevel consoleMinLevel;
  final LogLevel dbMinLevel;
  final LogLevel remoteMinLevel;
  final int maxLocalEntries;
  final int flushThreshold;
  final int idleFlushSeconds;
  final int retentionDays;
  final bool remoteEnabled;
  final String remoteEndpoint;
  final String remoteAuthToken;
  final int remoteMaxRetries;

  factory WLogConfig.fromJson(Map<String, dynamic> json) {
    int levelFrom(dynamic v) => (v is num) ? v.toInt() : LogLevel.info.value;
    return WLogConfig(
      consoleMinLevel: LogLevel.fromValue(levelFrom(json['consoleMinLevel'])),
      dbMinLevel: LogLevel.fromValue(levelFrom(json['dbMinLevel'])),
      remoteMinLevel: LogLevel.fromValue(levelFrom(json['remoteMinLevel'])),
      maxLocalEntries: (json['maxLocalEntries'] as num?)?.toInt() ?? 1000,
      flushThreshold: (json['flushThreshold'] as num?)?.toInt() ?? 50,
      idleFlushSeconds: (json['idleFlushSeconds'] as num?)?.toInt() ?? 60,
      retentionDays: (json['retentionDays'] as num?)?.toInt() ?? 7,
      remoteEnabled: json['remoteEnabled'] as bool? ?? false,
      remoteEndpoint: json['remoteEndpoint'] as String? ?? '',
      remoteAuthToken: json['remoteAuthToken'] as String? ?? '',
      remoteMaxRetries: (json['remoteMaxRetries'] as num?)?.toInt() ?? 3,
    );
  }

  Map<String, dynamic> toJson() => {
        'consoleMinLevel': consoleMinLevel.value,
        'dbMinLevel': dbMinLevel.value,
        'remoteMinLevel': remoteMinLevel.value,
        'maxLocalEntries': maxLocalEntries,
        'flushThreshold': flushThreshold,
        'idleFlushSeconds': idleFlushSeconds,
        'retentionDays': retentionDays,
        'remoteEnabled': remoteEnabled,
        'remoteEndpoint': remoteEndpoint,
        'remoteAuthToken': remoteAuthToken,
        'remoteMaxRetries': remoteMaxRetries,
      };

  static WLogConfig? loadLocal() {
    final raw = _storage.getJson(Sk.wlogConfig.name);
    if (raw == null || raw.isEmpty) return null;
    try {
      return WLogConfig.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  static void saveLocal(WLogConfig config) {
    _storage.setJson(Sk.wlogConfig.name, config.toJson());
  }

  static BasicStorage get _storage => BasicStorage.instance;

  WLogConfig copyWith({
    LogLevel? consoleMinLevel,
    LogLevel? dbMinLevel,
    LogLevel? remoteMinLevel,
    int? maxLocalEntries,
    int? flushThreshold,
    int? idleFlushSeconds,
    int? retentionDays,
    bool? remoteEnabled,
    String? remoteEndpoint,
    String? remoteAuthToken,
    int? remoteMaxRetries,
  }) =>
      WLogConfig(
        consoleMinLevel: consoleMinLevel ?? this.consoleMinLevel,
        dbMinLevel: dbMinLevel ?? this.dbMinLevel,
        remoteMinLevel: remoteMinLevel ?? this.remoteMinLevel,
        maxLocalEntries: maxLocalEntries ?? this.maxLocalEntries,
        flushThreshold: flushThreshold ?? this.flushThreshold,
        idleFlushSeconds: idleFlushSeconds ?? this.idleFlushSeconds,
        retentionDays: retentionDays ?? this.retentionDays,
        remoteEnabled: remoteEnabled ?? this.remoteEnabled,
        remoteEndpoint: remoteEndpoint ?? this.remoteEndpoint,
        remoteAuthToken: remoteAuthToken ?? this.remoteAuthToken,
        remoteMaxRetries: remoteMaxRetries ?? this.remoteMaxRetries,
      );
}