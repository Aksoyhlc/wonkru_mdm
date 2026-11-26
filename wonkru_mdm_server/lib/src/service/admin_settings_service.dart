import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../config/app_config.dart';
import '../config/mail_config.dart';
import '../enums/upload_limit.dart';
import '../generated/protocol.dart';
import '../util/json_utils.dart';
import 'alert_routing_settings.dart';
import 'backup_schedule_settings.dart';
import 'mdm_agent_service.dart';
import 'setting_service.dart';
import 'timezone_service.dart';
import 'upload_limit_settings.dart';

/// The `settings` table as a flat form record.
///
/// Reading and writing are kept in one place; each concern (alert routing,
/// backup schedules, upload limits, SMTP test) lives in its own collaborator.
class AdminSettingsService {
  const AdminSettingsService._();

  static const devicesUpdatedCheckDelayKey = 'policy_devices_updated_check_delay_minutes';

  static const maxDevicesUpdatedCheckDelayMinutes = 10080;

  static PanelTheme panelThemeFrom(String? raw) {
    for (final theme in PanelTheme.values) {
      if (theme.name == raw) {
        return theme;
      }
    }
    return PanelTheme.dark;
  }

  static SmtpEncryption smtpEncryptionFrom(String? raw) {
    final normalized = raw?.trim().toLowerCase() ?? '';
    if (normalized.isEmpty) {
      return SmtpEncryption.none;
    }
    for (final encryption in SmtpEncryption.values) {
      if (encryption.name == normalized) {
        return encryption;
      }
    }
    return SmtpEncryption.none;
  }

  static String smtpEncryptionToSetting(SmtpEncryption encryption) =>
      encryption == SmtpEncryption.none ? '' : encryption.name;

  static Future<SettingsFormState> read(
    Session session, {
    Transaction? transaction,
  }) async {
    Future<String?> raw(String key) => SettingService.raw(session, key, transaction: transaction);
    Future<int> number(String key, int fallback) async =>
        await SettingService.getInt(
          session,
          key,
          fallback: fallback,
          transaction: transaction,
        ) ??
        fallback;
    Future<bool> flag(String key, bool fallback) => SettingService.getBool(
      session,
      key,
      fallback: fallback,
      transaction: transaction,
    );

    return SettingsFormState(
      defaultPolicyId: int.tryParse(
        await raw(SettingService.defaultPolicyKey) ?? '',
      ),
      mdmApkPackageName: await MdmAgentService.packageName(
        session,
        transaction: transaction,
      ),
      deviceUploadMaxSizeKb: await number(
        'device_upload_max_size_kb',
        AppConfig.deviceUploadMaxSizeKb,
      ),
      uploadApkMaxSizeMb: await UploadLimit.apk.megabytes(
        session,
        transaction: transaction,
      ),
      uploadFileMaxSizeMb: await UploadLimit.file.megabytes(
        session,
        transaction: transaction,
      ),
      uploadCertificateMaxSizeMb: await UploadLimit.certificate.megabytes(
        session,
        transaction: transaction,
      ),
      uploadLauncherBackgroundMaxSizeMb: await UploadLimit.launcherBackground.megabytes(
        session,
        transaction: transaction,
      ),
      uploadCeilingMb: UploadLimit.ceilingMb(session),
      panelDefaultTheme: panelThemeFrom(await raw('panel_default_theme')),
      panelBrandName: await raw('panel_brand_name') ?? AppConfig.name,
      panelTimezone: await TimezoneService.name(
        session,
        transaction: transaction,
      ),
      smtpEnabled: await flag('smtp_enabled', false),
      smtpHost: await raw('smtp_host') ?? MailConfig.host,
      smtpPort: await number('smtp_port', MailConfig.port),
      smtpUsername: await raw('smtp_username') ?? MailConfig.username,
      smtpPassword: await raw('smtp_password') ?? MailConfig.password,
      smtpEncryption: smtpEncryptionFrom(
        await raw('smtp_encryption') ?? MailConfig.scheme,
      ),
      smtpFromAddress: await raw('smtp_from_address') ?? MailConfig.fromAddress,
      smtpFromName: await raw('smtp_from_name') ?? MailConfig.fromName,
      policyDefaultServerReportInterval: await number(
        'policy_default_server_report_interval',
        600,
      ),
      policyDefaultMinTimeMs: await number('policy_default_min_time_ms', 30000),
      policyDefaultMinDistanceMeters: await number(
        'policy_default_min_distance_meters',
        50,
      ),
      policyDevicesUpdatedCheckDelayMinutes: await number(
        devicesUpdatedCheckDelayKey,
        30,
      ),
      deviceAlertsOnlineMinutes: await number(
        'device_alerts_online_minutes',
        5,
      ),
      offlineTimeout: await number('offline_timeout', 5),
      deviceAlertsOfflineMinutes: await number(
        'device_alerts_offline_minutes',
        1440,
      ),
      deviceAlertsDuplicatePreventionHours: await number(
        'device_alerts_duplicate_prevention_hours',
        24,
      ),
      systemAlertTypeChannels: AlertRoutingSettings.normalizeRouting(
        decodeJsonValue(await raw(AlertRoutingSettings.key)),
      ),
      backupScheduleCleanTimes: BackupScheduleSettings.readTimes(
        decodeJsonValue(await raw(BackupScheduleSettings.cleanTimesKey)),
        await raw(BackupScheduleSettings.cleanAtKey),
        BackupScheduleSettings.defaultCleanTimes,
      ),
      backupScheduleRunTimes: BackupScheduleSettings.readTimes(
        decodeJsonValue(await raw(BackupScheduleSettings.runTimesKey)),
        await raw(BackupScheduleSettings.runAtKey),
        BackupScheduleSettings.defaultRunTimes,
      ),
      backupScheduleMonitorTimes: BackupScheduleSettings.readTimes(
        decodeJsonValue(await raw(BackupScheduleSettings.monitorTimesKey)),
        await raw(BackupScheduleSettings.monitorAtKey),
        BackupScheduleSettings.defaultMonitorTimes,
      ),
      backupNotifyUserIds: stringList(
        decodeJsonValue(await raw(BackupScheduleSettings.notifyUserIdsKey)),
      ),
      wlogConsoleMinLevel: await number('wlog_console_min_level', 2),
      wlogDbMinLevel: await number('wlog_db_min_level', 2),
      wlogRemoteMinLevel: await number('wlog_remote_min_level', 2),
      wlogMaxLocalEntries: await number('wlog_max_local_entries', 1000),
      wlogFlushThreshold: await number('wlog_flush_threshold', 50),
      wlogIdleFlushSeconds: await number('wlog_idle_flush_seconds', 60),
      wlogRetentionDays: await number('wlog_retention_days', 7),
      wlogRemoteEnabled: await flag('wlog_remote_enabled', false),
      wlogRemoteEndpoint: await raw('wlog_remote_endpoint') ?? '',
      wlogRemoteAuthToken: await raw('wlog_remote_auth_token') ?? '',
      wlogRemoteMaxRetries: await number('wlog_remote_max_retries', 3),
    );
  }

  static Future<void> persist(
    Session session,
    SettingsFormState state, {
    Transaction? transaction,
  }) async {
    Future<void> set(String key, String? value) => SettingService.save(session, key, value, transaction: transaction);

    String? boolean(bool value) => value ? '1' : '';

    // Validate before writing so an invalid limit cannot leave a partial record.
    UploadLimitSettings.validate(state, UploadLimit.ceilingMb(session));
    TimezoneService.validate(state.panelTimezone);
    final mdmPackage = state.mdmApkPackageName?.trim();
    if (mdmPackage != null) {
      final previous = await MdmAgentService.packageName(
        session,
        transaction: transaction,
      );
      if (mdmPackage != previous) {
        final application = await MdmAgentService.findApplication(
          session,
          mdmPackage,
          transaction: transaction,
        );
        if (application == null) {
          throw ArgumentError('Select an application from the catalog.');
        }
      }
      await set(MdmAgentService.packageSetting, mdmPackage);
    }

    await set(
      SettingService.defaultPolicyKey,
      state.defaultPolicyId?.toString(),
    );
    await set('offline_timeout', state.offlineTimeout.toString());
    await set(
      'device_alerts_online_minutes',
      state.deviceAlertsOnlineMinutes.toString(),
    );
    await set(
      'device_alerts_offline_minutes',
      state.deviceAlertsOfflineMinutes.toString(),
    );
    await set(
      'device_alerts_duplicate_prevention_hours',
      state.deviceAlertsDuplicatePreventionHours.toString(),
    );
    await set(
      'device_upload_max_size_kb',
      state.deviceUploadMaxSizeKb.toString(),
    );
    for (final (limit, value) in UploadLimitSettings.values(state)) {
      await set(limit.settingKey, value.toString());
    }
    await set('panel_default_theme', state.panelDefaultTheme.name);
    await set('panel_brand_name', state.panelBrandName);
    await set(TimezoneService.settingKey, state.panelTimezone);
    await set('smtp_enabled', boolean(state.smtpEnabled));
    await set('smtp_host', state.smtpHost);
    await set('smtp_port', state.smtpPort.toString());
    await set('smtp_username', state.smtpUsername);
    await set('smtp_password', state.smtpPassword);
    await set(
      'smtp_encryption',
      smtpEncryptionToSetting(state.smtpEncryption),
    );
    await set('smtp_from_address', state.smtpFromAddress);
    await set('smtp_from_name', state.smtpFromName);
    await set(
      'policy_default_server_report_interval',
      state.policyDefaultServerReportInterval.toString(),
    );
    await set(
      'policy_default_min_time_ms',
      state.policyDefaultMinTimeMs.toString(),
    );
    await set(
      'policy_default_min_distance_meters',
      state.policyDefaultMinDistanceMeters.toString(),
    );
    await set(
      devicesUpdatedCheckDelayKey,
      state.policyDevicesUpdatedCheckDelayMinutes.clamp(0, maxDevicesUpdatedCheckDelayMinutes).toString(),
    );
    await set(
      AlertRoutingSettings.key,
      jsonEncode({
        'type_channels': AlertRoutingSettings.encodeRouting(
          state.systemAlertTypeChannels,
        ),
      }),
    );

    final cleanTimes = BackupScheduleSettings.normalizeTimes(
      state.backupScheduleCleanTimes,
    );
    final runTimes = BackupScheduleSettings.normalizeTimes(
      state.backupScheduleRunTimes,
    );
    final monitorTimes = BackupScheduleSettings.normalizeTimes(
      state.backupScheduleMonitorTimes,
    );

    await set(
      BackupScheduleSettings.cleanTimesKey,
      jsonEncode(
        cleanTimes.isEmpty ? BackupScheduleSettings.defaultCleanTimes : cleanTimes,
      ),
    );
    await set(
      BackupScheduleSettings.runTimesKey,
      jsonEncode(
        runTimes.isEmpty ? BackupScheduleSettings.defaultRunTimes : runTimes,
      ),
    );
    await set(
      BackupScheduleSettings.monitorTimesKey,
      jsonEncode(
        monitorTimes.isEmpty ? BackupScheduleSettings.defaultMonitorTimes : monitorTimes,
      ),
    );
    await set(
      BackupScheduleSettings.notifyUserIdsKey,
      jsonEncode(state.backupNotifyUserIds),
    );

    await set('wlog_console_min_level', state.wlogConsoleMinLevel.toString());
    await set('wlog_db_min_level', state.wlogDbMinLevel.toString());
    await set('wlog_remote_min_level', state.wlogRemoteMinLevel.toString());
    await set('wlog_max_local_entries', state.wlogMaxLocalEntries.toString());
    await set('wlog_flush_threshold', state.wlogFlushThreshold.toString());
    await set('wlog_idle_flush_seconds', state.wlogIdleFlushSeconds.toString());
    await set('wlog_retention_days', state.wlogRetentionDays.toString());
    await set('wlog_remote_enabled', boolean(state.wlogRemoteEnabled));
    await set('wlog_remote_endpoint', state.wlogRemoteEndpoint);
    await set('wlog_remote_auth_token', state.wlogRemoteAuthToken);
    await set('wlog_remote_max_retries', state.wlogRemoteMaxRetries.toString());
  }

  static List<String> stringList(dynamic stored) {
    if (stored is! List) {
      return const [];
    }

    return [
      for (final value in stored)
        if (value != null) '$value',
    ];
  }
}
