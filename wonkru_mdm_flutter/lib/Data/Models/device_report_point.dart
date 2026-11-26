import 'dart:convert';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

class DeviceReportPoint {
  const DeviceReportPoint({
    required this.moment,
    this.type,
    this.batteryLevel,
    this.freeStoragePercent,
    this.online,
  });

  final DateTime? moment;

  final String? type;

  /// Battery percentage (0-100).
  final int? batteryLevel;

  /// Free storage percentage (0-100).
  final int? freeStoragePercent;

  final bool? online;

  static DeviceReportPoint fromReport(DeviceReport report) {
    final payload = _decode(report.payload);

    return DeviceReportPoint(
      moment: _moment(payload) ?? report.createdAt,
      type: report.type,
      batteryLevel: _battery(payload),
      freeStoragePercent: _freeStoragePercent(payload),
      online: _online(payload),
    );
  }

  static Map<String, dynamic> _decode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
    }
  }

  static int? _battery(Map<String, dynamic> payload) {
    final nested = _nested(payload, const [
      'battery_info',
      'batteryInfo',
      'battery',
    ]);
    final source = nested ?? payload;

    final level = _asInt(
      _pick(source, const [
        'level',
        'levelPercent',
        'level_percent',
        'battery_level',
        'batteryLevel',
        'battery',
        'percent',
      ]),
    );

    return level?.clamp(0, 100);
  }

  static int? _freeStoragePercent(Map<String, dynamic> payload) {
    final direct = _asInt(
      _pick(payload, const [
        'free_storage_percent',
        'freeStoragePercent',
        'free_storage_pct',
        'freeStoragePct',
      ]),
    );
    if (direct != null) return direct.clamp(0, 100);

    final storage = _nested(payload, const [
      'storage_info',
      'storageInfo',
      'storage',
    ]);
    final source = storage ?? payload;

    final used = _asInt(
      _pick(source, const [
        'usage_percentage',
        'usagePercentage',
        'used_percentage',
        'usedPercentage',
      ]),
    );
    if (used != null) return (100 - used).clamp(0, 100);

    final free = _asInt(
      _pick(source, const [
        'free_storage_bytes',
        'freeStorageBytes',
        'free_bytes',
        'freeBytes',
      ]),
    );
    final total = _asInt(
      _pick(source, const [
        'total_storage_bytes',
        'totalStorageBytes',
        'total_bytes',
        'totalBytes',
      ]),
    );
    if (free != null && total != null && total > 0) {
      return (free * 100 / total).round().clamp(0, 100);
    }

    return null;
  }

  static bool? _online(Map<String, dynamic> payload) {
    return _asBool(
      _pick(payload, const [
        'online',
        'is_online',
        'isOnline',
        'is_connected',
        'isConnected',
      ]),
    );
  }

  static DateTime? _moment(Map<String, dynamic> payload) {
    final value = _pick(payload, const [
      'collected_at',
      'collectedAt',
      'created_at',
      'createdAt',
      'timestamp',
      'time',
    ]);

    return value is String ? DateTime.tryParse(value) : null;
  }

  static Object? _pick(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value != null) return value;
    }

    return null;
  }

  static Map<String, dynamic>? _nested(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    final value = _pick(map, keys);
    return value is Map ? value.cast<String, dynamic>() : null;
  }

  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value.trim());

    return null;
  }

  static bool? _asBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      switch (value.trim().toLowerCase()) {
        case '1':
        case 'true':
        case 'yes':
        case 'online':
          return true;
        case '0':
        case 'false':
        case 'no':
        case 'offline':
          return false;
      }
    }

    return null;
  }
}
