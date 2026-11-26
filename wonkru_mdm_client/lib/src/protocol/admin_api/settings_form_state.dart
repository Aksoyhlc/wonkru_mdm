/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;
import '../admin_api/alert_type_channels.dart' as _ia4g46a8;
import '../enums/panel_theme.dart' as _ise865nb;
import '../enums/smtp_encryption.dart' as _i2o87riz;

abstract class SettingsFormState
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SettingsFormState._({
    this.defaultPolicyId,
    this.mdmApkPackageName,
    required this.deviceUploadMaxSizeKb,
    int? uploadApkMaxSizeMb,
    int? uploadFileMaxSizeMb,
    int? uploadCertificateMaxSizeMb,
    int? uploadLauncherBackgroundMaxSizeMb,
    int? uploadCeilingMb,
    required this.panelDefaultTheme,
    required this.panelBrandName,
    this.panelTimezone,
    required this.smtpEnabled,
    required this.smtpHost,
    required this.smtpPort,
    required this.smtpUsername,
    required this.smtpPassword,
    required this.smtpEncryption,
    required this.smtpFromAddress,
    required this.smtpFromName,
    required this.policyDefaultServerReportInterval,
    required this.policyDefaultMinTimeMs,
    required this.policyDefaultMinDistanceMeters,
    required this.policyDevicesUpdatedCheckDelayMinutes,
    required this.deviceAlertsOnlineMinutes,
    required this.offlineTimeout,
    required this.deviceAlertsOfflineMinutes,
    required this.deviceAlertsDuplicatePreventionHours,
    required this.systemAlertTypeChannels,
    required this.backupScheduleCleanTimes,
    required this.backupScheduleRunTimes,
    required this.backupScheduleMonitorTimes,
    required this.backupNotifyUserIds,
    required this.wlogConsoleMinLevel,
    required this.wlogDbMinLevel,
    required this.wlogRemoteMinLevel,
    required this.wlogMaxLocalEntries,
    required this.wlogFlushThreshold,
    required this.wlogIdleFlushSeconds,
    required this.wlogRetentionDays,
    required this.wlogRemoteEnabled,
    required this.wlogRemoteEndpoint,
    required this.wlogRemoteAuthToken,
    required this.wlogRemoteMaxRetries,
  }) : uploadApkMaxSizeMb = uploadApkMaxSizeMb ?? 256,
       uploadFileMaxSizeMb = uploadFileMaxSizeMb ?? 256,
       uploadCertificateMaxSizeMb = uploadCertificateMaxSizeMb ?? 10,
       uploadLauncherBackgroundMaxSizeMb =
           uploadLauncherBackgroundMaxSizeMb ?? 2,
       uploadCeilingMb = uploadCeilingMb ?? 0;

  factory SettingsFormState({
    int? defaultPolicyId,
    String? mdmApkPackageName,
    required int deviceUploadMaxSizeKb,
    int? uploadApkMaxSizeMb,
    int? uploadFileMaxSizeMb,
    int? uploadCertificateMaxSizeMb,
    int? uploadLauncherBackgroundMaxSizeMb,
    int? uploadCeilingMb,
    required _ise865nb.PanelTheme panelDefaultTheme,
    required String panelBrandName,
    String? panelTimezone,
    required bool smtpEnabled,
    required String smtpHost,
    required int smtpPort,
    required String smtpUsername,
    required String smtpPassword,
    required _i2o87riz.SmtpEncryption smtpEncryption,
    required String smtpFromAddress,
    required String smtpFromName,
    required int policyDefaultServerReportInterval,
    required int policyDefaultMinTimeMs,
    required int policyDefaultMinDistanceMeters,
    required int policyDevicesUpdatedCheckDelayMinutes,
    required int deviceAlertsOnlineMinutes,
    required int offlineTimeout,
    required int deviceAlertsOfflineMinutes,
    required int deviceAlertsDuplicatePreventionHours,
    required List<_ia4g46a8.AlertTypeChannels> systemAlertTypeChannels,
    required List<String> backupScheduleCleanTimes,
    required List<String> backupScheduleRunTimes,
    required List<String> backupScheduleMonitorTimes,
    required List<String> backupNotifyUserIds,
    required int wlogConsoleMinLevel,
    required int wlogDbMinLevel,
    required int wlogRemoteMinLevel,
    required int wlogMaxLocalEntries,
    required int wlogFlushThreshold,
    required int wlogIdleFlushSeconds,
    required int wlogRetentionDays,
    required bool wlogRemoteEnabled,
    required String wlogRemoteEndpoint,
    required String wlogRemoteAuthToken,
    required int wlogRemoteMaxRetries,
  }) = _SettingsFormStateImpl;

  factory SettingsFormState.fromJson(Map<String, dynamic> jsonSerialization) {
    return SettingsFormState(
      defaultPolicyId: jsonSerialization['defaultPolicyId'] as int?,
      mdmApkPackageName: jsonSerialization['mdmApkPackageName'] as String?,
      deviceUploadMaxSizeKb: jsonSerialization['deviceUploadMaxSizeKb'] as int,
      uploadApkMaxSizeMb: jsonSerialization['uploadApkMaxSizeMb'] as int?,
      uploadFileMaxSizeMb: jsonSerialization['uploadFileMaxSizeMb'] as int?,
      uploadCertificateMaxSizeMb:
          jsonSerialization['uploadCertificateMaxSizeMb'] as int?,
      uploadLauncherBackgroundMaxSizeMb:
          jsonSerialization['uploadLauncherBackgroundMaxSizeMb'] as int?,
      uploadCeilingMb: jsonSerialization['uploadCeilingMb'] as int?,
      panelDefaultTheme: _ise865nb.PanelTheme.fromJson(
        (jsonSerialization['panelDefaultTheme'] as String),
      ),
      panelBrandName: jsonSerialization['panelBrandName'] as String,
      panelTimezone: jsonSerialization['panelTimezone'] as String?,
      smtpEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['smtpEnabled'],
      ),
      smtpHost: jsonSerialization['smtpHost'] as String,
      smtpPort: jsonSerialization['smtpPort'] as int,
      smtpUsername: jsonSerialization['smtpUsername'] as String,
      smtpPassword: jsonSerialization['smtpPassword'] as String,
      smtpEncryption: _i2o87riz.SmtpEncryption.fromJson(
        (jsonSerialization['smtpEncryption'] as String),
      ),
      smtpFromAddress: jsonSerialization['smtpFromAddress'] as String,
      smtpFromName: jsonSerialization['smtpFromName'] as String,
      policyDefaultServerReportInterval:
          jsonSerialization['policyDefaultServerReportInterval'] as int,
      policyDefaultMinTimeMs:
          jsonSerialization['policyDefaultMinTimeMs'] as int,
      policyDefaultMinDistanceMeters:
          jsonSerialization['policyDefaultMinDistanceMeters'] as int,
      policyDevicesUpdatedCheckDelayMinutes:
          jsonSerialization['policyDevicesUpdatedCheckDelayMinutes'] as int,
      deviceAlertsOnlineMinutes:
          jsonSerialization['deviceAlertsOnlineMinutes'] as int,
      offlineTimeout: jsonSerialization['offlineTimeout'] as int,
      deviceAlertsOfflineMinutes:
          jsonSerialization['deviceAlertsOfflineMinutes'] as int,
      deviceAlertsDuplicatePreventionHours:
          jsonSerialization['deviceAlertsDuplicatePreventionHours'] as int,
      systemAlertTypeChannels: _icclvb2d.Protocol()
          .deserialize<List<_ia4g46a8.AlertTypeChannels>>(
            jsonSerialization['systemAlertTypeChannels'],
          ),
      backupScheduleCleanTimes: _icclvb2d.Protocol().deserialize<List<String>>(
        jsonSerialization['backupScheduleCleanTimes'],
      ),
      backupScheduleRunTimes: _icclvb2d.Protocol().deserialize<List<String>>(
        jsonSerialization['backupScheduleRunTimes'],
      ),
      backupScheduleMonitorTimes: _icclvb2d.Protocol()
          .deserialize<List<String>>(
            jsonSerialization['backupScheduleMonitorTimes'],
          ),
      backupNotifyUserIds: _icclvb2d.Protocol().deserialize<List<String>>(
        jsonSerialization['backupNotifyUserIds'],
      ),
      wlogConsoleMinLevel: jsonSerialization['wlogConsoleMinLevel'] as int,
      wlogDbMinLevel: jsonSerialization['wlogDbMinLevel'] as int,
      wlogRemoteMinLevel: jsonSerialization['wlogRemoteMinLevel'] as int,
      wlogMaxLocalEntries: jsonSerialization['wlogMaxLocalEntries'] as int,
      wlogFlushThreshold: jsonSerialization['wlogFlushThreshold'] as int,
      wlogIdleFlushSeconds: jsonSerialization['wlogIdleFlushSeconds'] as int,
      wlogRetentionDays: jsonSerialization['wlogRetentionDays'] as int,
      wlogRemoteEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['wlogRemoteEnabled'],
      ),
      wlogRemoteEndpoint: jsonSerialization['wlogRemoteEndpoint'] as String,
      wlogRemoteAuthToken: jsonSerialization['wlogRemoteAuthToken'] as String,
      wlogRemoteMaxRetries: jsonSerialization['wlogRemoteMaxRetries'] as int,
    );
  }

  int? defaultPolicyId;

  String? mdmApkPackageName;

  int deviceUploadMaxSizeKb;

  int uploadApkMaxSizeMb;

  int uploadFileMaxSizeMb;

  int uploadCertificateMaxSizeMb;

  int uploadLauncherBackgroundMaxSizeMb;

  /// Read-only: the server's `maxRequestSize` ceiling (MB). No upload limit
  /// may exceed it; ignored on save.
  int uploadCeilingMb;

  _ise865nb.PanelTheme panelDefaultTheme;

  String panelBrandName;

  /// IANA zone name (e.g. `Europe/Istanbul`). When empty, the panel and
  /// exports use UTC.
  String? panelTimezone;

  bool smtpEnabled;

  String smtpHost;

  int smtpPort;

  String smtpUsername;

  String smtpPassword;

  _i2o87riz.SmtpEncryption smtpEncryption;

  String smtpFromAddress;

  String smtpFromName;

  int policyDefaultServerReportInterval;

  int policyDefaultMinTimeMs;

  int policyDefaultMinDistanceMeters;

  /// Clamped to one week.
  int policyDevicesUpdatedCheckDelayMinutes;

  int deviceAlertsOnlineMinutes;

  int offlineTimeout;

  int deviceAlertsOfflineMinutes;

  int deviceAlertsDuplicatePreventionHours;

  /// One record per alert type; every registered type is present and always
  /// carries at least one channel.
  List<_ia4g46a8.AlertTypeChannels> systemAlertTypeChannels;

  /// `HH:mm` entries.
  List<String> backupScheduleCleanTimes;

  /// `HH:mm` entries.
  List<String> backupScheduleRunTimes;

  /// `HH:mm` entries.
  List<String> backupScheduleMonitorTimes;

  List<String> backupNotifyUserIds;

  int wlogConsoleMinLevel;

  int wlogDbMinLevel;

  int wlogRemoteMinLevel;

  int wlogMaxLocalEntries;

  int wlogFlushThreshold;

  int wlogIdleFlushSeconds;

  int wlogRetentionDays;

  bool wlogRemoteEnabled;

  String wlogRemoteEndpoint;

  String wlogRemoteAuthToken;

  int wlogRemoteMaxRetries;

  /// Returns a shallow copy of this [SettingsFormState]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SettingsFormState copyWith({
    int? defaultPolicyId,
    String? mdmApkPackageName,
    int? deviceUploadMaxSizeKb,
    int? uploadApkMaxSizeMb,
    int? uploadFileMaxSizeMb,
    int? uploadCertificateMaxSizeMb,
    int? uploadLauncherBackgroundMaxSizeMb,
    int? uploadCeilingMb,
    _ise865nb.PanelTheme? panelDefaultTheme,
    String? panelBrandName,
    String? panelTimezone,
    bool? smtpEnabled,
    String? smtpHost,
    int? smtpPort,
    String? smtpUsername,
    String? smtpPassword,
    _i2o87riz.SmtpEncryption? smtpEncryption,
    String? smtpFromAddress,
    String? smtpFromName,
    int? policyDefaultServerReportInterval,
    int? policyDefaultMinTimeMs,
    int? policyDefaultMinDistanceMeters,
    int? policyDevicesUpdatedCheckDelayMinutes,
    int? deviceAlertsOnlineMinutes,
    int? offlineTimeout,
    int? deviceAlertsOfflineMinutes,
    int? deviceAlertsDuplicatePreventionHours,
    List<_ia4g46a8.AlertTypeChannels>? systemAlertTypeChannels,
    List<String>? backupScheduleCleanTimes,
    List<String>? backupScheduleRunTimes,
    List<String>? backupScheduleMonitorTimes,
    List<String>? backupNotifyUserIds,
    int? wlogConsoleMinLevel,
    int? wlogDbMinLevel,
    int? wlogRemoteMinLevel,
    int? wlogMaxLocalEntries,
    int? wlogFlushThreshold,
    int? wlogIdleFlushSeconds,
    int? wlogRetentionDays,
    bool? wlogRemoteEnabled,
    String? wlogRemoteEndpoint,
    String? wlogRemoteAuthToken,
    int? wlogRemoteMaxRetries,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SettingsFormState',
      if (defaultPolicyId != null) 'defaultPolicyId': defaultPolicyId,
      if (mdmApkPackageName != null) 'mdmApkPackageName': mdmApkPackageName,
      'deviceUploadMaxSizeKb': deviceUploadMaxSizeKb,
      'uploadApkMaxSizeMb': uploadApkMaxSizeMb,
      'uploadFileMaxSizeMb': uploadFileMaxSizeMb,
      'uploadCertificateMaxSizeMb': uploadCertificateMaxSizeMb,
      'uploadLauncherBackgroundMaxSizeMb': uploadLauncherBackgroundMaxSizeMb,
      'uploadCeilingMb': uploadCeilingMb,
      'panelDefaultTheme': panelDefaultTheme.toJson(),
      'panelBrandName': panelBrandName,
      if (panelTimezone != null) 'panelTimezone': panelTimezone,
      'smtpEnabled': smtpEnabled,
      'smtpHost': smtpHost,
      'smtpPort': smtpPort,
      'smtpUsername': smtpUsername,
      'smtpPassword': smtpPassword,
      'smtpEncryption': smtpEncryption.toJson(),
      'smtpFromAddress': smtpFromAddress,
      'smtpFromName': smtpFromName,
      'policyDefaultServerReportInterval': policyDefaultServerReportInterval,
      'policyDefaultMinTimeMs': policyDefaultMinTimeMs,
      'policyDefaultMinDistanceMeters': policyDefaultMinDistanceMeters,
      'policyDevicesUpdatedCheckDelayMinutes':
          policyDevicesUpdatedCheckDelayMinutes,
      'deviceAlertsOnlineMinutes': deviceAlertsOnlineMinutes,
      'offlineTimeout': offlineTimeout,
      'deviceAlertsOfflineMinutes': deviceAlertsOfflineMinutes,
      'deviceAlertsDuplicatePreventionHours':
          deviceAlertsDuplicatePreventionHours,
      'systemAlertTypeChannels': systemAlertTypeChannels.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'backupScheduleCleanTimes': backupScheduleCleanTimes.toJson(),
      'backupScheduleRunTimes': backupScheduleRunTimes.toJson(),
      'backupScheduleMonitorTimes': backupScheduleMonitorTimes.toJson(),
      'backupNotifyUserIds': backupNotifyUserIds.toJson(),
      'wlogConsoleMinLevel': wlogConsoleMinLevel,
      'wlogDbMinLevel': wlogDbMinLevel,
      'wlogRemoteMinLevel': wlogRemoteMinLevel,
      'wlogMaxLocalEntries': wlogMaxLocalEntries,
      'wlogFlushThreshold': wlogFlushThreshold,
      'wlogIdleFlushSeconds': wlogIdleFlushSeconds,
      'wlogRetentionDays': wlogRetentionDays,
      'wlogRemoteEnabled': wlogRemoteEnabled,
      'wlogRemoteEndpoint': wlogRemoteEndpoint,
      'wlogRemoteAuthToken': wlogRemoteAuthToken,
      'wlogRemoteMaxRetries': wlogRemoteMaxRetries,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SettingsFormState',
      if (defaultPolicyId != null) 'defaultPolicyId': defaultPolicyId,
      if (mdmApkPackageName != null) 'mdmApkPackageName': mdmApkPackageName,
      'deviceUploadMaxSizeKb': deviceUploadMaxSizeKb,
      'uploadApkMaxSizeMb': uploadApkMaxSizeMb,
      'uploadFileMaxSizeMb': uploadFileMaxSizeMb,
      'uploadCertificateMaxSizeMb': uploadCertificateMaxSizeMb,
      'uploadLauncherBackgroundMaxSizeMb': uploadLauncherBackgroundMaxSizeMb,
      'uploadCeilingMb': uploadCeilingMb,
      'panelDefaultTheme': panelDefaultTheme.toJson(),
      'panelBrandName': panelBrandName,
      if (panelTimezone != null) 'panelTimezone': panelTimezone,
      'smtpEnabled': smtpEnabled,
      'smtpHost': smtpHost,
      'smtpPort': smtpPort,
      'smtpUsername': smtpUsername,
      'smtpPassword': smtpPassword,
      'smtpEncryption': smtpEncryption.toJson(),
      'smtpFromAddress': smtpFromAddress,
      'smtpFromName': smtpFromName,
      'policyDefaultServerReportInterval': policyDefaultServerReportInterval,
      'policyDefaultMinTimeMs': policyDefaultMinTimeMs,
      'policyDefaultMinDistanceMeters': policyDefaultMinDistanceMeters,
      'policyDevicesUpdatedCheckDelayMinutes':
          policyDevicesUpdatedCheckDelayMinutes,
      'deviceAlertsOnlineMinutes': deviceAlertsOnlineMinutes,
      'offlineTimeout': offlineTimeout,
      'deviceAlertsOfflineMinutes': deviceAlertsOfflineMinutes,
      'deviceAlertsDuplicatePreventionHours':
          deviceAlertsDuplicatePreventionHours,
      'systemAlertTypeChannels': systemAlertTypeChannels.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'backupScheduleCleanTimes': backupScheduleCleanTimes.toJson(),
      'backupScheduleRunTimes': backupScheduleRunTimes.toJson(),
      'backupScheduleMonitorTimes': backupScheduleMonitorTimes.toJson(),
      'backupNotifyUserIds': backupNotifyUserIds.toJson(),
      'wlogConsoleMinLevel': wlogConsoleMinLevel,
      'wlogDbMinLevel': wlogDbMinLevel,
      'wlogRemoteMinLevel': wlogRemoteMinLevel,
      'wlogMaxLocalEntries': wlogMaxLocalEntries,
      'wlogFlushThreshold': wlogFlushThreshold,
      'wlogIdleFlushSeconds': wlogIdleFlushSeconds,
      'wlogRetentionDays': wlogRetentionDays,
      'wlogRemoteEnabled': wlogRemoteEnabled,
      'wlogRemoteEndpoint': wlogRemoteEndpoint,
      'wlogRemoteAuthToken': wlogRemoteAuthToken,
      'wlogRemoteMaxRetries': wlogRemoteMaxRetries,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SettingsFormStateImpl extends SettingsFormState {
  _SettingsFormStateImpl({
    int? defaultPolicyId,
    String? mdmApkPackageName,
    required int deviceUploadMaxSizeKb,
    int? uploadApkMaxSizeMb,
    int? uploadFileMaxSizeMb,
    int? uploadCertificateMaxSizeMb,
    int? uploadLauncherBackgroundMaxSizeMb,
    int? uploadCeilingMb,
    required _ise865nb.PanelTheme panelDefaultTheme,
    required String panelBrandName,
    String? panelTimezone,
    required bool smtpEnabled,
    required String smtpHost,
    required int smtpPort,
    required String smtpUsername,
    required String smtpPassword,
    required _i2o87riz.SmtpEncryption smtpEncryption,
    required String smtpFromAddress,
    required String smtpFromName,
    required int policyDefaultServerReportInterval,
    required int policyDefaultMinTimeMs,
    required int policyDefaultMinDistanceMeters,
    required int policyDevicesUpdatedCheckDelayMinutes,
    required int deviceAlertsOnlineMinutes,
    required int offlineTimeout,
    required int deviceAlertsOfflineMinutes,
    required int deviceAlertsDuplicatePreventionHours,
    required List<_ia4g46a8.AlertTypeChannels> systemAlertTypeChannels,
    required List<String> backupScheduleCleanTimes,
    required List<String> backupScheduleRunTimes,
    required List<String> backupScheduleMonitorTimes,
    required List<String> backupNotifyUserIds,
    required int wlogConsoleMinLevel,
    required int wlogDbMinLevel,
    required int wlogRemoteMinLevel,
    required int wlogMaxLocalEntries,
    required int wlogFlushThreshold,
    required int wlogIdleFlushSeconds,
    required int wlogRetentionDays,
    required bool wlogRemoteEnabled,
    required String wlogRemoteEndpoint,
    required String wlogRemoteAuthToken,
    required int wlogRemoteMaxRetries,
  }) : super._(
         defaultPolicyId: defaultPolicyId,
         mdmApkPackageName: mdmApkPackageName,
         deviceUploadMaxSizeKb: deviceUploadMaxSizeKb,
         uploadApkMaxSizeMb: uploadApkMaxSizeMb,
         uploadFileMaxSizeMb: uploadFileMaxSizeMb,
         uploadCertificateMaxSizeMb: uploadCertificateMaxSizeMb,
         uploadLauncherBackgroundMaxSizeMb: uploadLauncherBackgroundMaxSizeMb,
         uploadCeilingMb: uploadCeilingMb,
         panelDefaultTheme: panelDefaultTheme,
         panelBrandName: panelBrandName,
         panelTimezone: panelTimezone,
         smtpEnabled: smtpEnabled,
         smtpHost: smtpHost,
         smtpPort: smtpPort,
         smtpUsername: smtpUsername,
         smtpPassword: smtpPassword,
         smtpEncryption: smtpEncryption,
         smtpFromAddress: smtpFromAddress,
         smtpFromName: smtpFromName,
         policyDefaultServerReportInterval: policyDefaultServerReportInterval,
         policyDefaultMinTimeMs: policyDefaultMinTimeMs,
         policyDefaultMinDistanceMeters: policyDefaultMinDistanceMeters,
         policyDevicesUpdatedCheckDelayMinutes:
             policyDevicesUpdatedCheckDelayMinutes,
         deviceAlertsOnlineMinutes: deviceAlertsOnlineMinutes,
         offlineTimeout: offlineTimeout,
         deviceAlertsOfflineMinutes: deviceAlertsOfflineMinutes,
         deviceAlertsDuplicatePreventionHours:
             deviceAlertsDuplicatePreventionHours,
         systemAlertTypeChannels: systemAlertTypeChannels,
         backupScheduleCleanTimes: backupScheduleCleanTimes,
         backupScheduleRunTimes: backupScheduleRunTimes,
         backupScheduleMonitorTimes: backupScheduleMonitorTimes,
         backupNotifyUserIds: backupNotifyUserIds,
         wlogConsoleMinLevel: wlogConsoleMinLevel,
         wlogDbMinLevel: wlogDbMinLevel,
         wlogRemoteMinLevel: wlogRemoteMinLevel,
         wlogMaxLocalEntries: wlogMaxLocalEntries,
         wlogFlushThreshold: wlogFlushThreshold,
         wlogIdleFlushSeconds: wlogIdleFlushSeconds,
         wlogRetentionDays: wlogRetentionDays,
         wlogRemoteEnabled: wlogRemoteEnabled,
         wlogRemoteEndpoint: wlogRemoteEndpoint,
         wlogRemoteAuthToken: wlogRemoteAuthToken,
         wlogRemoteMaxRetries: wlogRemoteMaxRetries,
       );

  /// Returns a shallow copy of this [SettingsFormState]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SettingsFormState copyWith({
    Object? defaultPolicyId = _Undefined,
    Object? mdmApkPackageName = _Undefined,
    int? deviceUploadMaxSizeKb,
    int? uploadApkMaxSizeMb,
    int? uploadFileMaxSizeMb,
    int? uploadCertificateMaxSizeMb,
    int? uploadLauncherBackgroundMaxSizeMb,
    int? uploadCeilingMb,
    _ise865nb.PanelTheme? panelDefaultTheme,
    String? panelBrandName,
    Object? panelTimezone = _Undefined,
    bool? smtpEnabled,
    String? smtpHost,
    int? smtpPort,
    String? smtpUsername,
    String? smtpPassword,
    _i2o87riz.SmtpEncryption? smtpEncryption,
    String? smtpFromAddress,
    String? smtpFromName,
    int? policyDefaultServerReportInterval,
    int? policyDefaultMinTimeMs,
    int? policyDefaultMinDistanceMeters,
    int? policyDevicesUpdatedCheckDelayMinutes,
    int? deviceAlertsOnlineMinutes,
    int? offlineTimeout,
    int? deviceAlertsOfflineMinutes,
    int? deviceAlertsDuplicatePreventionHours,
    List<_ia4g46a8.AlertTypeChannels>? systemAlertTypeChannels,
    List<String>? backupScheduleCleanTimes,
    List<String>? backupScheduleRunTimes,
    List<String>? backupScheduleMonitorTimes,
    List<String>? backupNotifyUserIds,
    int? wlogConsoleMinLevel,
    int? wlogDbMinLevel,
    int? wlogRemoteMinLevel,
    int? wlogMaxLocalEntries,
    int? wlogFlushThreshold,
    int? wlogIdleFlushSeconds,
    int? wlogRetentionDays,
    bool? wlogRemoteEnabled,
    String? wlogRemoteEndpoint,
    String? wlogRemoteAuthToken,
    int? wlogRemoteMaxRetries,
  }) {
    return SettingsFormState(
      defaultPolicyId: defaultPolicyId is int?
          ? defaultPolicyId
          : this.defaultPolicyId,
      mdmApkPackageName: mdmApkPackageName is String?
          ? mdmApkPackageName
          : this.mdmApkPackageName,
      deviceUploadMaxSizeKb:
          deviceUploadMaxSizeKb ?? this.deviceUploadMaxSizeKb,
      uploadApkMaxSizeMb: uploadApkMaxSizeMb ?? this.uploadApkMaxSizeMb,
      uploadFileMaxSizeMb: uploadFileMaxSizeMb ?? this.uploadFileMaxSizeMb,
      uploadCertificateMaxSizeMb:
          uploadCertificateMaxSizeMb ?? this.uploadCertificateMaxSizeMb,
      uploadLauncherBackgroundMaxSizeMb:
          uploadLauncherBackgroundMaxSizeMb ??
          this.uploadLauncherBackgroundMaxSizeMb,
      uploadCeilingMb: uploadCeilingMb ?? this.uploadCeilingMb,
      panelDefaultTheme: panelDefaultTheme ?? this.panelDefaultTheme,
      panelBrandName: panelBrandName ?? this.panelBrandName,
      panelTimezone: panelTimezone is String?
          ? panelTimezone
          : this.panelTimezone,
      smtpEnabled: smtpEnabled ?? this.smtpEnabled,
      smtpHost: smtpHost ?? this.smtpHost,
      smtpPort: smtpPort ?? this.smtpPort,
      smtpUsername: smtpUsername ?? this.smtpUsername,
      smtpPassword: smtpPassword ?? this.smtpPassword,
      smtpEncryption: smtpEncryption ?? this.smtpEncryption,
      smtpFromAddress: smtpFromAddress ?? this.smtpFromAddress,
      smtpFromName: smtpFromName ?? this.smtpFromName,
      policyDefaultServerReportInterval:
          policyDefaultServerReportInterval ??
          this.policyDefaultServerReportInterval,
      policyDefaultMinTimeMs:
          policyDefaultMinTimeMs ?? this.policyDefaultMinTimeMs,
      policyDefaultMinDistanceMeters:
          policyDefaultMinDistanceMeters ?? this.policyDefaultMinDistanceMeters,
      policyDevicesUpdatedCheckDelayMinutes:
          policyDevicesUpdatedCheckDelayMinutes ??
          this.policyDevicesUpdatedCheckDelayMinutes,
      deviceAlertsOnlineMinutes:
          deviceAlertsOnlineMinutes ?? this.deviceAlertsOnlineMinutes,
      offlineTimeout: offlineTimeout ?? this.offlineTimeout,
      deviceAlertsOfflineMinutes:
          deviceAlertsOfflineMinutes ?? this.deviceAlertsOfflineMinutes,
      deviceAlertsDuplicatePreventionHours:
          deviceAlertsDuplicatePreventionHours ??
          this.deviceAlertsDuplicatePreventionHours,
      systemAlertTypeChannels:
          systemAlertTypeChannels ??
          this.systemAlertTypeChannels.map((e0) => e0.copyWith()).toList(),
      backupScheduleCleanTimes:
          backupScheduleCleanTimes ??
          this.backupScheduleCleanTimes.map((e0) => e0).toList(),
      backupScheduleRunTimes:
          backupScheduleRunTimes ??
          this.backupScheduleRunTimes.map((e0) => e0).toList(),
      backupScheduleMonitorTimes:
          backupScheduleMonitorTimes ??
          this.backupScheduleMonitorTimes.map((e0) => e0).toList(),
      backupNotifyUserIds:
          backupNotifyUserIds ??
          this.backupNotifyUserIds.map((e0) => e0).toList(),
      wlogConsoleMinLevel: wlogConsoleMinLevel ?? this.wlogConsoleMinLevel,
      wlogDbMinLevel: wlogDbMinLevel ?? this.wlogDbMinLevel,
      wlogRemoteMinLevel: wlogRemoteMinLevel ?? this.wlogRemoteMinLevel,
      wlogMaxLocalEntries: wlogMaxLocalEntries ?? this.wlogMaxLocalEntries,
      wlogFlushThreshold: wlogFlushThreshold ?? this.wlogFlushThreshold,
      wlogIdleFlushSeconds: wlogIdleFlushSeconds ?? this.wlogIdleFlushSeconds,
      wlogRetentionDays: wlogRetentionDays ?? this.wlogRetentionDays,
      wlogRemoteEnabled: wlogRemoteEnabled ?? this.wlogRemoteEnabled,
      wlogRemoteEndpoint: wlogRemoteEndpoint ?? this.wlogRemoteEndpoint,
      wlogRemoteAuthToken: wlogRemoteAuthToken ?? this.wlogRemoteAuthToken,
      wlogRemoteMaxRetries: wlogRemoteMaxRetries ?? this.wlogRemoteMaxRetries,
    );
  }
}
