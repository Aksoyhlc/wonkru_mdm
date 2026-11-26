import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart' show DeviceAction;

import '../../L10n/L.dart';

export 'bulk_command_status.dart';
export 'package:wonkru_mdm_client/wonkru_mdm_client.dart' show DeviceAction;

extension DeviceActionPanel on DeviceAction {
  String get label => switch (this) {
    DeviceAction.send_notification => L.common.actionSendNotification,
    DeviceAction.enable_power_save => L.common.actionEnablePowerSave,
    DeviceAction.reduce_brightness => L.common.actionReduceBrightness,
    DeviceAction.disable_wifi => L.common.actionDisableWifi,
    DeviceAction.disable_bluetooth => L.common.actionDisableBluetooth,
    DeviceAction.lock_device => L.common.actionLockDevice,
    DeviceAction.clear_cache => L.common.actionClearCache,
    DeviceAction.disable_camera => L.common.actionDisableCamera,
    DeviceAction.clear_app_data => L.common.actionClearAppData,
    DeviceAction.launch_app => L.common.actionLaunchApp,
    DeviceAction.launch_intent => L.common.actionLaunchIntent,
    DeviceAction.uninstall_app => L.common.actionUninstallApp,
    DeviceAction.open_app_settings => L.common.actionOpenAppSettings,
    DeviceAction.update_policy => L.common.actionUpdatePolicy,
    DeviceAction.policy_change => L.common.actionPolicyChange,
    DeviceAction.get_installed_apps => L.common.actionGetInstalledApps,
    DeviceAction.get_logs => L.common.actionGetLogs,
    DeviceAction.device_data => L.common.actionDeviceData,
    DeviceAction.get_current_location => L.common.actionGetCurrentLocation,
    DeviceAction.reboot => L.common.actionReboot,
  };

  String? localizeResultMessage(String? rawMessage) {
    final message = rawMessage?.trim();
    if (message == null || message.isEmpty) return null;

    if (message == 'Action $name executed successfully') {
      return L.devices.commandsActionSucceeded.trParams({'action': label});
    }
    if (message == 'Failed to execute action: $name') {
      return L.devices.commandsActionFailed.trParams({'action': label});
    }
    return message;
  }

  bool get isBulk => switch (this) {
    DeviceAction.launch_app ||
    DeviceAction.uninstall_app ||
    DeviceAction.get_installed_apps ||
    DeviceAction.get_logs ||
    DeviceAction.device_data ||
    DeviceAction.get_current_location => false,
    _ => true,
  };

  bool get requiresConfirmation => switch (this) {
    DeviceAction.uninstall_app ||
    DeviceAction.clear_app_data ||
    DeviceAction.lock_device => true,
    _ => false,
  };

  String? get packageParamKey => switch (this) {
    DeviceAction.clear_app_data ||
    DeviceAction.launch_app ||
    DeviceAction.uninstall_app ||
    DeviceAction.open_app_settings => 'package_name',
    _ => null,
  };

  Map<String, String> get defaultParams => switch (this) {
    DeviceAction.send_notification => const {'title': '', 'body': ''},
    DeviceAction.clear_app_data => const {'package_name': ''},
    DeviceAction.launch_app => const {'package_name': ''},
    DeviceAction.launch_intent => const {
      'intent_action': '',
      'intent_package': '',
      'intent_component': '',
      'intent_data': '',
      'intent_type': '',
      'intent_categories': '',
      'intent_flags': '',
    },
    DeviceAction.uninstall_app => const {'package_name': ''},
    DeviceAction.open_app_settings => const {'package_name': ''},
    DeviceAction.reduce_brightness => const {'level': ''},
    DeviceAction.get_installed_apps => const {'include_system_apps': '0'},
    DeviceAction.policy_change => const {'policy_id': ''},
    _ => const {},
  };
}
