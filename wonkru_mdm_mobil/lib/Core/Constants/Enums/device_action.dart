import 'package:wonkrumdm/Core/Extensions/enum.dart';

enum DeviceAction implements StringEnum {
  sendNotification('send_notification'),
  enablePowerSave('enable_power_save'),
  reduceBrightness('reduce_brightness'),
  disableWifi('disable_wifi'),
  disableBluetooth('disable_bluetooth'),
  reboot('reboot'),
  sendReport('send_report'),
  clearCache('clear_cache'),
  disableCamera('disable_camera'),
  clearAppData('clear_app_data'),
  launchApp('launch_app'),
  launchIntent('launch_intent'),
  uninstallApp('uninstall_app'),
  openAppSettings('open_app_settings'),
  updatePolicy('update_policy'),
  policyChange('policy_change'),
  getCurrentLocation('get_current_location'),
  getInstalledApps('get_installed_apps'),
  getLogs('get_logs'),
  deviceData('device_data'),
  lockNow('lock_device'),
  custom('custom');

  final String _value;

  const DeviceAction(this._value);

  @override
  String get value => _value;
}