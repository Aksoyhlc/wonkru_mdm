import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/device_action.dart';

void main() {
  group('DeviceAction', () {
    test('values mirror the server catalog in order.', () {
      expect(DeviceAction.values.map((action) => action.name), [
        'send_notification',
        'enable_power_save',
        'reduce_brightness',
        'disable_wifi',
        'disable_bluetooth',
        'lock_device',
        'clear_cache',
        'disable_camera',
        'clear_app_data',
        'launch_app',
        'launch_intent',
        'uninstall_app',
        'open_app_settings',
        'update_policy',
        'policy_change',
        'get_installed_apps',
        'get_logs',
        'device_data',
        'get_current_location',
        'reboot',
      ]);
    });

    test('labels are English and non-empty.', () {
      for (final action in DeviceAction.values) {
        expect(action.label, isNotEmpty, reason: action.name);
      }
      expect(DeviceAction.lock_device.label, 'Lock device');
    });

    test('only the per-device actions are excluded from bulk.', () {
      final single = DeviceAction.values
          .where((action) => !action.isBulk)
          .map((action) => action.name)
          .toSet();

      expect(single, {
        'launch_app',
        'uninstall_app',
        'get_installed_apps',
        'get_logs',
        'device_data',
        'get_current_location',
      });
    });

    test('destructive actions require confirmation.', () {
      final destructive = DeviceAction.values
          .where((action) => action.requiresConfirmation)
          .map((action) => action.name)
          .toSet();

      expect(destructive, {'uninstall_app', 'clear_app_data', 'lock_device'});
    });

    test('package actions expose the package parameter.', () {
      expect(DeviceAction.launch_app.packageParamKey, 'package_name');
      expect(DeviceAction.uninstall_app.packageParamKey, 'package_name');
      expect(DeviceAction.clear_app_data.packageParamKey, 'package_name');
      expect(DeviceAction.open_app_settings.packageParamKey, 'package_name');
      expect(DeviceAction.reboot.packageParamKey, isNull);
    });

    test('default parameters match the agent keys.', () {
      expect(DeviceAction.send_notification.defaultParams, {
        'title': '',
        'body': '',
      });
      expect(DeviceAction.launch_intent.defaultParams.keys, [
        'intent_action',
        'intent_package',
        'intent_component',
        'intent_data',
        'intent_type',
        'intent_categories',
        'intent_flags',
      ]);
      expect(DeviceAction.get_installed_apps.defaultParams, {
        'include_system_apps': '0',
      });
      expect(DeviceAction.policy_change.defaultParams, {'policy_id': ''});
      expect(DeviceAction.reboot.defaultParams, isEmpty);
    });
  });

  group('BulkCommandStatus', () {
    test('values mirror the server enum in order.', () {
      expect(BulkCommandStatus.values.map((status) => status.value), [
        'pending',
        'running',
        'completed',
        'success',
        'error',
        'no_response',
      ]);
    });

    test('labels are English and non-empty.', () {
      for (final status in BulkCommandStatus.values) {
        expect(status.label, isNotEmpty, reason: status.value);
      }
      expect(BulkCommandStatus.completed.label, 'Completed');
    });

    test('fromValue resolves known values only.', () {
      expect(BulkCommandStatus.fromValue('running'), BulkCommandStatus.running);
      expect(BulkCommandStatus.fromValue('nope'), isNull);
      expect(BulkCommandStatus.fromValue(null), isNull);
    });

    test('overallFrom derives the full status set.', () {
      expect(
        BulkCommandStatus.overallFrom(
          totalCount: 3,
          pendingCount: 3,
          sentCount: 0,
          ackedCount: 0,
          timeoutCount: 0,
          errorCount: 0,
        ),
        BulkCommandStatus.pending,
      );
      expect(
        BulkCommandStatus.overallFrom(
          totalCount: 3,
          pendingCount: 1,
          sentCount: 2,
          ackedCount: 0,
          timeoutCount: 0,
          errorCount: 0,
        ),
        BulkCommandStatus.running,
      );

      expect(
        BulkCommandStatus.overallFrom(
          totalCount: 3,
          pendingCount: 0,
          sentCount: 0,
          ackedCount: 3,
          timeoutCount: 0,
          errorCount: 0,
        ),
        BulkCommandStatus.success,
      );
      expect(
        BulkCommandStatus.overallFrom(
          totalCount: 3,
          pendingCount: 0,
          sentCount: 0,
          ackedCount: 1,
          timeoutCount: 1,
          errorCount: 1,
        ),
        BulkCommandStatus.error,
      );
      expect(
        BulkCommandStatus.overallFrom(
          totalCount: 3,
          pendingCount: 0,
          sentCount: 0,
          ackedCount: 0,
          timeoutCount: 3,
          errorCount: 0,
        ),
        BulkCommandStatus.noResponse,
      );
      // Partial ack (acked + timeout) counts as `completed`.
      expect(
        BulkCommandStatus.overallFrom(
          totalCount: 3,
          pendingCount: 0,
          sentCount: 0,
          ackedCount: 2,
          timeoutCount: 1,
          errorCount: 0,
        ),
        BulkCommandStatus.completed,
      );
    });

    test('isSuccessValue mirrors the legacy status test.', () {
      expect(BulkCommandStatus.isSuccessValue('success'), isTrue);
      expect(BulkCommandStatus.isSuccessValue(null), isTrue);
      expect(BulkCommandStatus.isSuccessValue('error'), isFalse);
    });
  });
}
