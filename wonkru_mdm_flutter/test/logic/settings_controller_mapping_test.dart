import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/settings_controller.dart';
import 'package:wonkru_mdm_flutter/Logic/UI/input_controller.dart';

import '../support/l10n_test_support.dart';

SettingsFormState _loadedState() => SettingsFormState(
  defaultPolicyId: 42,
  deviceUploadMaxSizeKb: 1024,
  panelDefaultTheme: PanelTheme.dark,
  panelBrandName: 'Wonkru',
  smtpEnabled: false,
  smtpHost: 'smtp.example.com',
  smtpPort: 587,
  smtpUsername: 'user',
  smtpPassword: 'secret',
  smtpEncryption: SmtpEncryption.tls,
  smtpFromAddress: 'no-reply@example.com',
  smtpFromName: 'Wonkru MDM',
  policyDefaultServerReportInterval: 60,
  policyDefaultMinTimeMs: 5000,
  policyDefaultMinDistanceMeters: 25,
  policyDevicesUpdatedCheckDelayMinutes: 5,
  deviceAlertsOnlineMinutes: 15,
  offlineTimeout: 30,
  deviceAlertsOfflineMinutes: 120,
  deviceAlertsDuplicatePreventionHours: 6,
  systemAlertTypeChannels: [
    AlertTypeChannels(
      type: SystemAlertType.device_offline,
      channels: const ['email'],
    ),
  ],
  backupScheduleCleanTimes: const ['03:00'],
  backupScheduleRunTimes: const ['02:00'],
  backupScheduleMonitorTimes: const ['01:00'],
  backupNotifyUserIds: const ['admin-1'],
  wlogConsoleMinLevel: 2,
  wlogDbMinLevel: 3,
  wlogRemoteMinLevel: 1,
  wlogMaxLocalEntries: 1000,
  wlogFlushThreshold: 50,
  wlogIdleFlushSeconds: 10,
  wlogRetentionDays: 30,
  wlogRemoteEnabled: false,
  wlogRemoteEndpoint: 'https://logs.example.com',
  wlogRemoteAuthToken: 'token',
  wlogRemoteMaxRetries: 4,
);

void main() {
  late InputController input;

  setUp(() {
    installTestTranslations();
    input = InputController();
    Get.put<InputController>(input);
  });

  tearDown(() => Get.reset());

  void set(String key, String value) => input.getController(key).text = value;

  group('SettingsController.buildState', () {
    test('maps text, number and bool fields from InputController', () {
      final controller = SettingsController()..state.value = _loadedState();

      set('settings.defaultPolicyId', '7');
      set('settings.deviceUploadMaxSizeKb', '2048');
      set('settings.panelDefaultTheme', 'light');
      set('settings.panelBrandName', 'New Panel');
      set('settings.smtpEnabled', 'true');
      set('settings.smtpHost', 'mail.test');
      set('settings.smtpPort', '465');
      set('settings.smtpEncryption', 'ssl');
      set('settings.smtpFromName', 'Test');
      set('settings.offlineTimeout', '99');
      set('settings.wlogRemoteEnabled', 'true');
      set('settings.wlogRemoteEndpoint', 'https://x.test');
      set('settings.wlogRemoteMaxRetries', '9');
      set('settings.wlogRetentionDays', '365');

      final state = controller.buildState();

      expect(state.defaultPolicyId, 7);
      expect(state.deviceUploadMaxSizeKb, 2048);
      expect(state.panelDefaultTheme, PanelTheme.light);
      expect(state.panelBrandName, 'New Panel');
      expect(state.smtpEnabled, isTrue);
      expect(state.smtpHost, 'mail.test');
      expect(state.smtpPort, 465);
      expect(state.smtpEncryption, SmtpEncryption.ssl);
      expect(state.smtpFromName, 'Test');
      expect(state.offlineTimeout, 99);
      expect(state.wlogRemoteEnabled, isTrue);
      expect(state.wlogRemoteEndpoint, 'https://x.test');
      expect(state.wlogRemoteMaxRetries, 9);
      expect(state.wlogRetentionDays, 365);
    });

    test('empty/invalid number fields fall back to the loaded state', () {
      final controller = SettingsController()..state.value = _loadedState();

      set('settings.smtpPort', 'abc');
      set('settings.deviceUploadMaxSizeKb', '');
      set('settings.wlogMaxLocalEntries', '   ');

      final state = controller.buildState();

      expect(state.smtpPort, 587);
      expect(state.deviceUploadMaxSizeKb, 1024);
      expect(state.wlogMaxLocalEntries, 1000);
    });

    test('number fields become 0 when there is no loaded state', () {
      final controller = SettingsController();

      set('settings.smtpPort', 'invalid');

      expect(controller.buildState().smtpPort, 0);
    });

    test('defaultPolicyId is null when empty and parsed when filled', () {
      final controller = SettingsController();

      set('settings.defaultPolicyId', '');
      expect(controller.buildState().defaultPolicyId, isNull);

      set('settings.defaultPolicyId', '13');
      expect(controller.buildState().defaultPolicyId, 13);

      set('settings.defaultPolicyId', 'not a number');
      expect(controller.buildState().defaultPolicyId, isNull);
    });

    test('bool fields are true only for the exact "true" text', () {
      final controller = SettingsController();

      set('settings.smtpEnabled', 'TRUE');
      set('settings.wlogRemoteEnabled', 'false');

      final state = controller.buildState();

      expect(state.smtpEnabled, isFalse);
      expect(state.wlogRemoteEnabled, isFalse);
    });

    test('list and map fields are copied (references are not shared)', () {
      final controller = SettingsController()
        ..setAlertChannels([
          AlertTypeChannels(
            type: SystemAlertType.device_offline,
            channels: const ['email', 'sms'],
          ),
        ])
        ..setCleanTimes(['03:00'])
        ..setRunTimes(['02:00'])
        ..setMonitorTimes(['01:00'])
        ..setNotifyUserIds(['admin-1']);

      final state = controller.buildState();

      expect(
        state.systemAlertTypeChannels
            .firstWhere((entry) => entry.type.name == 'device_offline')
            .channels,
        ['email', 'sms'],
      );
      expect(state.backupScheduleCleanTimes, ['03:00']);
      expect(state.backupScheduleRunTimes, ['02:00']);
      expect(state.backupScheduleMonitorTimes, ['01:00']);
      expect(state.backupNotifyUserIds, ['admin-1']);

      controller.setCleanTimes(['09:00']);
      controller.setNotifyUserIds(['other']);

      expect(state.backupScheduleCleanTimes, ['03:00']);
      expect(state.backupNotifyUserIds, ['admin-1']);
    });
  });
}
