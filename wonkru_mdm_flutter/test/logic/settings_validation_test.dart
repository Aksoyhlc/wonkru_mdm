import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/settings_controller.dart';
import 'package:wonkru_mdm_flutter/Logic/UI/input_controller.dart';

import '../support/l10n_test_support.dart';

void main() {
  late InputController input;

  setUp(() {
    installTestTranslations();
    // Get.put is required: onInit is what registers the validators.
    Get.put<InputController>(InputController());
    Get.put<SettingsController>(SettingsController());
    input = Get.find<InputController>();
  });

  tearDown(() => Get.reset());

  void set(String key, String value) => input.getController(key).text = value;

  String? error(String key) => input.getValidationError(key);

  group('numeric limits', () {
    test('device_upload_max_size_kb must be at least 1', () {
      set('settings.deviceUploadMaxSizeKb', '0');
      expect(error('settings.deviceUploadMaxSizeKb'), 'Must be at least 1');

      set('settings.deviceUploadMaxSizeKb', '1');
      expect(error('settings.deviceUploadMaxSizeKb'), isNull);

      set('settings.deviceUploadMaxSizeKb', 'abc');
      expect(error('settings.deviceUploadMaxSizeKb'), 'Enter a valid number');

      set('settings.deviceUploadMaxSizeKb', '-3');
      expect(error('settings.deviceUploadMaxSizeKb'), 'Cannot be negative');
    });

    test('smtp_port must be in the 1-65535 range', () {
      set('settings.smtpPort', '0');
      expect(error('settings.smtpPort'), 'Must be at least 1');

      set('settings.smtpPort', '65536');
      expect(error('settings.smtpPort'), 'Must be at most 65535');

      set('settings.smtpPort', '65535');
      expect(error('settings.smtpPort'), isNull);

      set('settings.smtpPort', '587');
      expect(error('settings.smtpPort'), isNull);
    });

    test('policy_default_server_report_interval must be at least 20', () {
      set('settings.policyDefaultServerReportInterval', '19');
      expect(
        error('settings.policyDefaultServerReportInterval'),
        'Must be at least 20',
      );

      set('settings.policyDefaultServerReportInterval', '20');
      expect(error('settings.policyDefaultServerReportInterval'), isNull);
    });

    test('policy_default_min_time_ms must be at least 1000', () {
      set('settings.policyDefaultMinTimeMs', '999');
      expect(error('settings.policyDefaultMinTimeMs'), 'Must be at least 1000');

      set('settings.policyDefaultMinTimeMs', '1000');
      expect(error('settings.policyDefaultMinTimeMs'), isNull);
    });

    test('wlog_max_local_entries must be at least 100', () {
      set('settings.wlogMaxLocalEntries', '99');
      expect(error('settings.wlogMaxLocalEntries'), 'Must be at least 100');

      set('settings.wlogMaxLocalEntries', '100');
      expect(error('settings.wlogMaxLocalEntries'), isNull);
    });

    test('a field without a limit follows only the number/negative rule', () {
      set('settings.offlineTimeout', '0');
      expect(error('settings.offlineTimeout'), isNull);

      set('settings.offlineTimeout', '-1');
      expect(error('settings.offlineTimeout'), 'Cannot be negative');
    });
  });

  group('wlog_remote_endpoint', () {
    test('empty value is valid', () {
      set('settings.wlogRemoteEndpoint', 'https://logs.example.com');
      expect(error('settings.wlogRemoteEndpoint'), isNull);

      set('settings.wlogRemoteEndpoint', '');
      expect(error('settings.wlogRemoteEndpoint'), isNull);
    });

    test('a value that is not http(s) is rejected', () {
      set('settings.wlogRemoteEndpoint', 'logs.example.com');
      expect(error('settings.wlogRemoteEndpoint'), 'Enter a valid address');

      set('settings.wlogRemoteEndpoint', 'ftp://logs.example.com');
      expect(error('settings.wlogRemoteEndpoint'), 'Enter a valid address');
    });

    test('an http(s) address is accepted', () {
      set('settings.wlogRemoteEndpoint', 'https://logs.example.com/ingest');
      expect(error('settings.wlogRemoteEndpoint'), isNull);
    });
  });
}
