import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';

/// Verifies `DeviceActionMetadata` mirrors the device action contract. The
/// golden lists pin all 20 actions in enum order by `(isBulkAction,
/// requiresConfirmation, expectedResponse, packageParamKey)` and `defaultParams`,
/// so a silent change to the metadata breaks the test.
void main() {
  group('Given the module device action metadata', () {
    test('when read then it carries the 20 actions in enum order', () {
      expect(DeviceActionMetadata.all, hasLength(20));
      expect(
        DeviceActionMetadata.all.map((info) => info.action).toList(),
        DeviceAction.values,
      );
    });

    test('when read then every action pins the exact flags', () {
      expect(
        DeviceActionMetadata.all
            .map(
              (info) => (
                info.action,
                info.isBulkAction,
                info.requiresConfirmation,
                info.expectedResponse,
                info.packageParamKey,
              ),
            )
            .toList(),
        goldenFlags,
      );
    });

    test('when read then every action pins the exact defaults', () {
      expect(
        DeviceActionMetadata.all.map((info) => info.defaultParams).toList(),
        goldenDefaults,
      );
    });

    test('when looked up then every action is addressable', () {
      for (final info in DeviceActionMetadata.all) {
        expect(DeviceActionMetadata.forAction(info.action), same(info));
      }
    });

    test('when checked then each action appears exactly once', () {
      expect(
        DeviceActionMetadata.all.map((info) => info.action).toSet(),
        hasLength(20),
      );
    });

    test('when mutated then the single source stays immutable', () {
      expect(
        () => DeviceActionMetadata.all.add(DeviceActionMetadata.all.first),
        throwsUnsupportedError,
      );
    });

    test('when a known action is read then the pinned values are kept', () {
      final launchIntent = DeviceActionMetadata.forAction(
        DeviceAction.launch_intent,
      );
      expect(launchIntent.isBulkAction, isTrue);
      expect(launchIntent.expectedResponse, 'message');
      expect(launchIntent.packageParamKey, isNull);
      expect(launchIntent.defaultParams, hasLength(7));

      final uninstall = DeviceActionMetadata.forAction(
        DeviceAction.uninstall_app,
      );
      expect(uninstall.isBulkAction, isFalse);
      expect(uninstall.requiresConfirmation, isTrue);
      expect(uninstall.packageParamKey, 'package_name');

      final logs = DeviceActionMetadata.forAction(DeviceAction.get_logs);
      expect(logs.expectedResponse, 'json');
      expect(logs.defaultParams, isEmpty);
    });
  });
}

/// All 20 actions, in enum order:
/// `(action, isBulkAction, requiresConfirmation, expectedResponse, packageParamKey)`.
const List<(DeviceAction, bool, bool, String, String?)> goldenFlags =
    <(DeviceAction, bool, bool, String, String?)>[
      (DeviceAction.send_notification, true, false, 'message', null),
      (DeviceAction.enable_power_save, true, false, 'message', null),
      (DeviceAction.reduce_brightness, true, false, 'message', null),
      (DeviceAction.disable_wifi, true, false, 'message', null),
      (DeviceAction.disable_bluetooth, true, false, 'message', null),
      (DeviceAction.lock_device, true, true, 'message', null),
      (DeviceAction.clear_cache, true, false, 'message', null),
      (DeviceAction.disable_camera, true, false, 'message', null),
      (DeviceAction.clear_app_data, true, true, 'message', 'package_name'),
      (DeviceAction.launch_app, false, false, 'message', 'package_name'),
      (DeviceAction.launch_intent, true, false, 'message', null),
      (DeviceAction.uninstall_app, false, true, 'message', 'package_name'),
      (DeviceAction.open_app_settings, true, false, 'message', 'package_name'),
      (DeviceAction.update_policy, true, false, 'message', null),
      (DeviceAction.policy_change, true, false, 'message', null),
      (DeviceAction.get_installed_apps, false, false, 'json', null),
      (DeviceAction.get_logs, false, false, 'json', null),
      (DeviceAction.device_data, false, false, 'json', null),
      (DeviceAction.get_current_location, false, false, 'json', null),
      (DeviceAction.reboot, true, false, 'message', null),
    ];

/// Default parameters of the 20 actions, in enum order.
const List<Map<String, String>> goldenDefaults = <Map<String, String>>[
  {'title': '', 'body': ''},
  <String, String>{},
  {'level': ''},
  <String, String>{},
  <String, String>{},
  <String, String>{},
  <String, String>{},
  <String, String>{},
  {'package_name': ''},
  {'package_name': ''},
  {
    'intent_action': '',
    'intent_package': '',
    'intent_component': '',
    'intent_data': '',
    'intent_type': '',
    'intent_categories': '',
    'intent_flags': '',
  },
  {'package_name': ''},
  {'package_name': ''},
  <String, String>{},
  {'policy_id': ''},
  {'include_system_apps': '0'},
  <String, String>{},
  <String, String>{},
  <String, String>{},
  <String, String>{},
];
