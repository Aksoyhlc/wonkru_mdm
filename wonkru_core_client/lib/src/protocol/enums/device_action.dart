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

enum DeviceAction implements _isc.SerializableModel {
  send_notification,
  enable_power_save,
  reduce_brightness,
  disable_wifi,
  disable_bluetooth,
  lock_device,
  clear_cache,
  disable_camera,
  clear_app_data,
  launch_app,
  launch_intent,
  uninstall_app,
  open_app_settings,
  update_policy,
  policy_change,
  get_installed_apps,
  get_logs,
  device_data,
  get_current_location,
  reboot;

  static DeviceAction fromJson(String name) {
    switch (name) {
      case 'send_notification':
        return DeviceAction.send_notification;
      case 'enable_power_save':
        return DeviceAction.enable_power_save;
      case 'reduce_brightness':
        return DeviceAction.reduce_brightness;
      case 'disable_wifi':
        return DeviceAction.disable_wifi;
      case 'disable_bluetooth':
        return DeviceAction.disable_bluetooth;
      case 'lock_device':
        return DeviceAction.lock_device;
      case 'clear_cache':
        return DeviceAction.clear_cache;
      case 'disable_camera':
        return DeviceAction.disable_camera;
      case 'clear_app_data':
        return DeviceAction.clear_app_data;
      case 'launch_app':
        return DeviceAction.launch_app;
      case 'launch_intent':
        return DeviceAction.launch_intent;
      case 'uninstall_app':
        return DeviceAction.uninstall_app;
      case 'open_app_settings':
        return DeviceAction.open_app_settings;
      case 'update_policy':
        return DeviceAction.update_policy;
      case 'policy_change':
        return DeviceAction.policy_change;
      case 'get_installed_apps':
        return DeviceAction.get_installed_apps;
      case 'get_logs':
        return DeviceAction.get_logs;
      case 'device_data':
        return DeviceAction.device_data;
      case 'get_current_location':
        return DeviceAction.get_current_location;
      case 'reboot':
        return DeviceAction.reboot;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DeviceAction"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
