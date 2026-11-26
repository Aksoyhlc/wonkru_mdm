import 'dart:convert';

import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Errors/server_error_message.dart';
import '../../Core/L10n/L.dart';
import '../../Core/Time/app_time.dart';
import '../../Data/Client/serverpod_client.dart';
import '../../Data/Repositories/application_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/provisioning_profile_repository.dart';
import '../../Data/Repositories/settings_repository.dart';
import '../UI/input_controller.dart';

/// Text/number/toggle fields live in [InputController] under `settings.<field>`
/// keys; list and map fields (times, notify users, alert channels) live in the
/// Rx fields here.
class SettingsController extends GetxController {
  final loading = true.obs;
  final saving = false.obs;
  final testing = false.obs;
  final error = RxnString();

  final optionsError = RxnString();

  /// Last state read from the server; also used as fallback defaults when
  /// building the save payload.
  final state = Rxn<SettingsFormState>();

  final enrollmentKey = RxnString();

  final enrollmentKeyError = RxnString();

  final rotatingEnrollmentKey = false.obs;

  final policyOptions = <Policy>[].obs;
  final applicationOptions = <Application>[].obs;

  static const defaultMdmApkPackageName = 'com.wonkrumdm';

  final systemAlertTypeChannels = <AlertTypeChannels>[].obs;
  final backupScheduleCleanTimes = <String>[].obs;
  final backupScheduleRunTimes = <String>[].obs;
  final backupScheduleMonitorTimes = <String>[].obs;
  final backupNotifyUserIds = <String>[].obs;

  /// Form fields bound one-to-one to a [SettingsFormState] field; the input
  /// key is `settings.<field>`. Values move through the model's JSON, so the
  /// field names below must match the model.
  static const _intFields = <String>[
    'deviceUploadMaxSizeKb',
    'uploadApkMaxSizeMb',
    'uploadFileMaxSizeMb',
    'uploadCertificateMaxSizeMb',
    'uploadLauncherBackgroundMaxSizeMb',
    'offlineTimeout',
    'deviceAlertsOfflineMinutes',
    'policyDevicesUpdatedCheckDelayMinutes',
    'deviceAlertsDuplicatePreventionHours',
    'wlogConsoleMinLevel',
    'wlogDbMinLevel',
    'wlogRemoteMinLevel',
    'wlogMaxLocalEntries',
    'wlogFlushThreshold',
    'wlogIdleFlushSeconds',
    'wlogRetentionDays',
    'wlogRemoteMaxRetries',
    'smtpPort',
  ];

  static const _textFields = <String>[
    'panelBrandName',
    'wlogRemoteEndpoint',
    'wlogRemoteAuthToken',
    'smtpHost',
    'smtpUsername',
    'smtpPassword',
    'smtpFromAddress',
    'smtpFromName',
  ];

  static const _boolFields = <String>['wlogRemoteEnabled', 'smtpEnabled'];

  static const _enumFields = <String>['smtpEncryption'];

  static const _key = 'settings.';

  static final inputKeys = <String>[
    '${_key}defaultPolicyId',
    '${_key}mdmApkPackageName',
    '${_key}panelTimezone',
    '${_key}smtpTestRecipient',
    for (final field in _intFields) '$_key$field',
    for (final field in _textFields) '$_key$field',
    for (final field in _boolFields) '$_key$field',
    for (final field in _enumFields) '$_key$field',
  ];

  static final intKeys = <String>[
    for (final field in _intFields) '$_key$field',
  ];

  static const _intBounds = <String, (int min, int? max)>{
    'settings.deviceUploadMaxSizeKb': (1, null),
    'settings.uploadApkMaxSizeMb': (1, null),
    'settings.uploadFileMaxSizeMb': (1, null),
    'settings.uploadCertificateMaxSizeMb': (1, null),
    'settings.uploadLauncherBackgroundMaxSizeMb': (1, null),
    'settings.smtpPort': (1, 65535),
    'settings.wlogMaxLocalEntries': (100, null),
  };

  /// Upload-limit keys, in MB; also bounded by the server ceiling.
  static const uploadLimitKeys = <String>[
    'settings.uploadApkMaxSizeMb',
    'settings.uploadFileMaxSizeMb',
    'settings.uploadCertificateMaxSizeMb',
    'settings.uploadLauncherBackgroundMaxSizeMb',
  ];

  @override
  void onInit() {
    super.onInit();
    _registerValidators();
  }

  void _registerValidators() {
    InputController.to.addValidators({
      for (final key in intKeys)
        key: (value) {
          final parsed = int.tryParse(value.trim());
          if (parsed == null) return L.common.validNumberRequired;
          if (parsed < 0) return L.common.cannotBeNegative;

          final bounds = _intBounds[key];
          if (bounds != null) {
            final (min, max) = bounds;
            if (parsed < min) {
              return L.common.minValue.trParams({'min': '$min'});
            }
            if (max != null && parsed > max) {
              return L.common.maxValue.trParams({'max': '$max'});
            }
          }

          // Upload limits cannot exceed the server's request-size ceiling.
          final ceiling = state.value?.uploadCeilingMb ?? 0;
          if (ceiling > 0 &&
              uploadLimitKeys.contains(key) &&
              parsed > ceiling) {
            return L.common.serverCeiling.trParams({'ceiling': '$ceiling'});
          }

          return '';
        },
    });

    InputController.to.addValidator(
      'settings.wlogRemoteEndpoint',
      _validateRemoteEndpoint,
    );
  }

  static String _validateRemoteEndpoint(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return L.common.validUrlRequired;
    }

    return '';
  }

  Future<void> load() async {
    loading.value = true;
    error.value = null;
    optionsError.value = null;

    final SettingsFormState loaded;
    try {
      loaded = await SettingsRepository.get();
    } catch (e) {
      error.value = serverErrorMessage(e);
      loading.value = false;
      return;
    }

    state.value = loaded;
    systemAlertTypeChannels.assignAll(
      _copyRouting(loaded.systemAlertTypeChannels),
    );
    backupScheduleCleanTimes.assignAll(loaded.backupScheduleCleanTimes);
    backupScheduleRunTimes.assignAll(loaded.backupScheduleRunTimes);
    backupScheduleMonitorTimes.assignAll(loaded.backupScheduleMonitorTimes);
    backupNotifyUserIds.assignAll(loaded.backupNotifyUserIds);

    final json = loaded.toJson();
    InputController.to.setValues({
      '${_key}defaultPolicyId': loaded.defaultPolicyId?.toString() ?? '',
      '${_key}mdmApkPackageName':
          loaded.mdmApkPackageName ?? defaultMdmApkPackageName,
      '${_key}panelTimezone': loaded.panelTimezone ?? '',
      for (final field in [
        ..._intFields,
        ..._textFields,
        ..._boolFields,
        ..._enumFields,
      ])
        '$_key$field': '${json[field]}',
    }, markAsDirty: false);

    _registerValidators();
    await Future.wait([_loadPolicies(), _loadApplications(), loadEnrollmentKey()]);

    loading.value = false;
  }

  Future<void> _loadPolicies() async {
    try {
      policyOptions.assignAll(await PolicyRepository.lookup());
    } catch (e) {
      optionsError.value = serverErrorMessage(e);
    }
  }

  Future<void> _loadApplications() async {
    try {
      applicationOptions.assignAll(await ApplicationRepository.lookup());
    } catch (e) {
      optionsError.value = serverErrorMessage(e);
    }
  }

  Future<void> loadEnrollmentKey() async {
    enrollmentKeyError.value = null;
    try {
      enrollmentKey.value = await SettingsRepository.enrollmentKey();
    } catch (e) {
      enrollmentKeyError.value = serverErrorMessage(e);
    }
  }

  /// JSON for the enrollment QR: the provisioning default config when it can be
  /// fetched, otherwise a minimal `{server_url, enrollment_key}` payload.
  Future<String> enrollmentQrPayload() async {
    try {
      return await ProvisioningProfileRepository.defaultConfig();
    } catch (_) {
      final key = enrollmentKey.value;
      return jsonEncode({
        'server_url': serverUrl,
        if (key != null && key.isNotEmpty) 'enrollment_key': key,
      });
    }
  }

  /// Rotates the key; old QR codes can no longer enroll.
  Future<void> rotateEnrollmentKey() async {
    rotatingEnrollmentKey.value = true;
    try {
      enrollmentKey.value = await SettingsRepository.rotateEnrollmentKey();
      enrollmentKeyError.value = null;
    } finally {
      rotatingEnrollmentKey.value = false;
    }
  }

  Future<void> save() async {
    saving.value = true;
    try {
      final state = buildState();
      await SettingsRepository.save(state);
      // Apply the zone immediately so the panel redraws and the warning bar
      // disappears without waiting for a reload.
      AppTime.instance.set(state.panelTimezone);
      await load();
    } finally {
      saving.value = false;
    }
  }

  Future<List<SmtpTestNotice>> sendTestMail(String? recipient) async {
    testing.value = true;
    try {
      return await SettingsRepository.sendSmtpTestMail(buildState(), recipient);
    } finally {
      testing.value = false;
    }
  }

  void setAlertChannels(List<AlertTypeChannels> value) =>
      systemAlertTypeChannels.assignAll(_copyRouting(value));

  static List<AlertTypeChannels> _copyRouting(
    List<AlertTypeChannels> routing,
  ) => [
    for (final entry in routing)
      AlertTypeChannels(
        type: entry.type,
        channels: List<String>.of(entry.channels),
      ),
  ];

  /// Empty input means "not set": null goes to the server, and the panel then
  /// shows UTC behind the warning bar.
  static String? _timezoneOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Falls back to [SmtpEncryption.none] for empty or unknown input; the server
  /// maps `none` back to an empty string in the persisted setting.
  static SmtpEncryption _smtpEncryptionFrom(String value) =>
      SmtpEncryption.values.firstWhere(
        (encryption) => encryption.name == value,
        orElse: () => SmtpEncryption.none,
      );

  void setCleanTimes(List<String> value) =>
      backupScheduleCleanTimes.assignAll(value);

  void setRunTimes(List<String> value) =>
      backupScheduleRunTimes.assignAll(value);

  void setMonitorTimes(List<String> value) =>
      backupScheduleMonitorTimes.assignAll(value);

  void setNotifyUserIds(List<String> value) =>
      backupNotifyUserIds.assignAll(value);

  SettingsFormState buildState() {
    final previous = state.value?.toJson() ?? const <String, dynamic>{};
    final input = InputController.to;
    String value(String field) => input.getValue('$_key$field');

    return SettingsFormState.fromJson({
      // Preserve non-editable values required by the settings API.
      'panelDefaultTheme':
          previous['panelDefaultTheme'] ?? PanelTheme.system.name,
      'deviceAlertsOnlineMinutes': previous['deviceAlertsOnlineMinutes'] ?? 0,
      'policyDefaultServerReportInterval':
          previous['policyDefaultServerReportInterval'] ?? 0,
      'policyDefaultMinTimeMs': previous['policyDefaultMinTimeMs'] ?? 0,
      'policyDefaultMinDistanceMeters':
          previous['policyDefaultMinDistanceMeters'] ?? 0,
      for (final field in _intFields)
        field: int.tryParse(value(field).trim()) ?? previous[field] ?? 0,
      for (final field in _textFields) field: value(field),
      for (final field in _boolFields) field: value(field) == 'true',
      'defaultPolicyId': int.tryParse(value('defaultPolicyId')),
      'mdmApkPackageName': value('mdmApkPackageName'),
      // Read-only; the server ignores it on save.
      'uploadCeilingMb': previous['uploadCeilingMb'] ?? 0,
      'panelTimezone': _timezoneOrNull(value('panelTimezone')),
      'smtpEncryption': _smtpEncryptionFrom(value('smtpEncryption')).name,
      'systemAlertTypeChannels': [
        for (final entry in _copyRouting(systemAlertTypeChannels))
          entry.toJson(),
      ],
      'backupScheduleCleanTimes': List<String>.of(backupScheduleCleanTimes),
      'backupScheduleRunTimes': List<String>.of(backupScheduleRunTimes),
      'backupScheduleMonitorTimes': List<String>.of(backupScheduleMonitorTimes),
      'backupNotifyUserIds': List<String>.of(backupNotifyUserIds),
    });
  }
}
