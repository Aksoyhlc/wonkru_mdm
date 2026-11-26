import '../generated/protocol.dart';

class DeviceActionMetadata {
  const DeviceActionMetadata._();

  static final List<DeviceActionInfo> all = List<DeviceActionInfo>.unmodifiable(
    <DeviceActionInfo>[
      DeviceActionInfo(
        action: DeviceAction.send_notification,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {'title': '', 'body': ''},
      ),
      DeviceActionInfo(
        action: DeviceAction.enable_power_save,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.reduce_brightness,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {'level': ''},
      ),
      DeviceActionInfo(
        action: DeviceAction.disable_wifi,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.disable_bluetooth,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.lock_device,
        isBulkAction: true,
        requiresConfirmation: true,
        expectedResponse: 'message',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.clear_cache,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.disable_camera,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.clear_app_data,
        isBulkAction: true,
        requiresConfirmation: true,
        expectedResponse: 'message',
        packageParamKey: 'package_name',
        defaultParams: const {'package_name': ''},
      ),
      DeviceActionInfo(
        action: DeviceAction.launch_app,
        isBulkAction: false,
        requiresConfirmation: false,
        expectedResponse: 'message',
        packageParamKey: 'package_name',
        defaultParams: const {'package_name': ''},
      ),
      DeviceActionInfo(
        action: DeviceAction.launch_intent,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {
          'intent_action': '',
          'intent_package': '',
          'intent_component': '',
          'intent_data': '',
          'intent_type': '',
          'intent_categories': '',
          'intent_flags': '',
        },
      ),
      DeviceActionInfo(
        action: DeviceAction.uninstall_app,
        isBulkAction: false,
        requiresConfirmation: true,
        expectedResponse: 'message',
        packageParamKey: 'package_name',
        defaultParams: const {'package_name': ''},
      ),
      DeviceActionInfo(
        action: DeviceAction.open_app_settings,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        packageParamKey: 'package_name',
        defaultParams: const {'package_name': ''},
      ),
      DeviceActionInfo(
        action: DeviceAction.update_policy,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.policy_change,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {'policy_id': ''},
      ),
      DeviceActionInfo(
        action: DeviceAction.get_installed_apps,
        isBulkAction: false,
        requiresConfirmation: false,
        expectedResponse: 'json',
        defaultParams: const {'include_system_apps': '0'},
      ),
      DeviceActionInfo(
        action: DeviceAction.get_logs,
        isBulkAction: false,
        requiresConfirmation: false,
        expectedResponse: 'json',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.device_data,
        isBulkAction: false,
        requiresConfirmation: false,
        expectedResponse: 'json',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.get_current_location,
        isBulkAction: false,
        requiresConfirmation: false,
        expectedResponse: 'json',
        defaultParams: const {},
      ),
      DeviceActionInfo(
        action: DeviceAction.reboot,
        isBulkAction: true,
        requiresConfirmation: false,
        expectedResponse: 'message',
        defaultParams: const {},
      ),
    ],
  );

  static final Map<DeviceAction, DeviceActionInfo> _byAction =
      Map<DeviceAction, DeviceActionInfo>.unmodifiable({
        for (final info in all) info.action: info,
      });

  static DeviceActionInfo forAction(DeviceAction action) {
    final info = _byAction[action];
    if (info == null) {
      throw ArgumentError.value(action, 'action', 'No metadata for $action.');
    }

    return info;
  }
}
