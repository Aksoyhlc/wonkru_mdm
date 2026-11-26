import 'package:serverpod/serverpod.dart';

import 'setting_service.dart';

class WlogConfigService {
  const WlogConfigService._();

  static const _defaultLevel = 2;

  static Future<Map<String, dynamic>> build(
    Session session, {
    Transaction? transaction,
  }) async {
    return {
      'consoleMinLevel': await _level(
        session,
        'wlog_console_min_level',
        transaction: transaction,
      ),
      'dbMinLevel': await _level(
        session,
        'wlog_db_min_level',
        transaction: transaction,
      ),
      'remoteMinLevel': await _level(
        session,
        'wlog_remote_min_level',
        transaction: transaction,
      ),
      'maxLocalEntries': await SettingService.getInt(
        session,
        'wlog_max_local_entries',
        fallback: 1000,
        transaction: transaction,
      ),
      'flushThreshold': await SettingService.getInt(
        session,
        'wlog_flush_threshold',
        fallback: 50,
        transaction: transaction,
      ),
      'idleFlushSeconds': await SettingService.getInt(
        session,
        'wlog_idle_flush_seconds',
        fallback: 60,
        transaction: transaction,
      ),
      'retentionDays': await SettingService.getInt(
        session,
        'wlog_retention_days',
        fallback: 7,
        transaction: transaction,
      ),
      'remoteEnabled': await SettingService.getBool(
        session,
        'wlog_remote_enabled',
        transaction: transaction,
      ),
      'remoteEndpoint':
          await SettingService.raw(
            session,
            'wlog_remote_endpoint',
            transaction: transaction,
          ) ??
          '',
      'remoteAuthToken':
          await SettingService.raw(
            session,
            'wlog_remote_auth_token',
            transaction: transaction,
          ) ??
          '',
      'remoteMaxRetries': await SettingService.getInt(
        session,
        'wlog_remote_max_retries',
        fallback: 3,
        transaction: transaction,
      ),
    };
  }

  static Future<int?> _level(
    Session session,
    String key, {
    Transaction? transaction,
  }) {
    return SettingService.getInt(
      session,
      key,
      fallback: _defaultLevel,
      transaction: transaction,
    );
  }
}
