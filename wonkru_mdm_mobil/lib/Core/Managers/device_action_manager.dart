import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wonkrumdm/Core/Constants/Enums/config_apply_result.dart';
import 'package:wonkrumdm/Core/Constants/Enums/device_action.dart';
import 'package:wonkrumdm/Core/Constants/Enums/restriction.dart';
import 'package:wonkrumdm/Core/Constants/ext.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/app_manager.dart';
import 'package:wonkrumdm/Core/Managers/config_manager.dart';
import 'package:wonkrumdm/Core/Managers/display_manager.dart';
import 'package:wonkrumdm/Core/Managers/keyguard_manager.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Managers/restriction_manager.dart';
import 'package:wonkrumdm/Core/Managers/system_settings_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/system_notification_bridge.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_notification_api.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/report_api.dart';
import 'package:wonkrumdm/Data/Repositories/device_repository.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

const _tag = 'DeviceActionManager';

class DeviceActionManager {
  static final DeviceActionManager _instance = DeviceActionManager._internal();

  factory DeviceActionManager() => _instance;

  DeviceActionManager._internal();

  final _displayManager = DisplayManager();
  final _networkManager = NetworkManager();
  final _systemSettingsManager = SystemSettingsManager();
  final _appManager = AppManager();
  final _systemNotificationBridge = SystemNotificationBridge();

  final Map<String, Future<bool> Function(Map<String, dynamic>?)> _customActions = {};

  @visibleForTesting
  Future<ConfigApplyResult> Function()? policyApplierOverride;

  @visibleForTesting
  Future<bool> Function()? lockNowOverride;

  Future<(bool, Map<String, dynamic>)?> executeAction(DeviceAction action, {Map<String, dynamic>? params}) async {
    WLog.d(_tag, 'Executing action -> ${action.value}');
    try {
      switch (action) {
        case DeviceAction.enablePowerSave:
          return (await _enablePowerSave(), <String, dynamic>{});
        case DeviceAction.reduceBrightness:
          final level = parseParamInt(params?['level'], 50);
          return (await _reduceBrightness(level), <String, dynamic>{});
        case DeviceAction.disableWifi:
          return (await _disableWifi(), <String, dynamic>{});
        case DeviceAction.disableBluetooth:
          return (await _disableBluetooth(), <String, dynamic>{});
        case DeviceAction.reboot:
          return (await _reboot(), <String, dynamic>{});
        case DeviceAction.sendNotification:
          return (await _sendNotification(params ?? {}), <String, dynamic>{});
        case DeviceAction.sendReport:
          final explicitType = (params?['action_type'] as String?)?.trim();
          final sourceAsType = (params?['source'] as String?)?.trim();
          final reportType = (explicitType != null && explicitType.isNotEmpty)
              ? explicitType
              : (sourceAsType != null && sourceAsType.isNotEmpty)
              ? sourceAsType
              : null;
          if (reportType == null) {
            return (false, <String, dynamic>{'message': "'action_type' or 'source' parameter required for sendReport"});
          }
          return (await _sendReport(type: reportType, params: params), <String, dynamic>{});
        case DeviceAction.clearCache:
          return (await _clearCache(), <String, dynamic>{});
        case DeviceAction.disableCamera:
          return (await _disableCamera(), <String, dynamic>{});
        case DeviceAction.clearAppData:
          final success = await _executeForSinglePackage(params: params, action: _appManager.clearAppData);
          return (success, <String, dynamic>{});
        case DeviceAction.launchApp:
          final success = await _executeForSinglePackage(params: params, action: _appManager.launchApp);
          return (success, <String, dynamic>{});
        case DeviceAction.launchIntent:
          return (await _systemSettingsManager.launchIntent(params), <String, dynamic>{});
        case DeviceAction.lockNow:
          final locked = await (lockNowOverride ?? _displayManager.lockDeviceNow)();
          return (locked, <String, dynamic>{});
        case DeviceAction.uninstallApp:
          final success = await _executeForSinglePackage(params: params, action: _appManager.uninstallApp);
          return (success, <String, dynamic>{});
        case DeviceAction.openAppSettings:
          final success = await _executeForSinglePackage(params: params, action: _appManager.openAppSettings);
          return (success, <String, dynamic>{});
        case DeviceAction.updatePolicy:
          return await _updatePolicy();
        case DeviceAction.policyChange:
          // Server may send policy_id as a JSON number.
          final policyIdRaw = params?['policy_id'];
          return await _policyChange(policyIdRaw?.toString());
        case DeviceAction.getCurrentLocation:
          return await _getCurrentLocation(params);
        case DeviceAction.getInstalledApps:
          return await _getInstalledApps(params);
        case DeviceAction.getLogs:
          return await _getLogs();
        case DeviceAction.deviceData:
          return await _deviceData();
        case DeviceAction.custom:
          final actionId = params?['action_id'] as String?;
          if (actionId != null && _customActions.containsKey(actionId)) {
            final result = await _customActions[actionId]!(params);
            return (result, <String, dynamic>{});
          }
          return (false, <String, dynamic>{});
      }
    } catch (e, st) {
      WLog.e(_tag, 'Action error -> ${action.value}', error: e, stackTrace: st);
      return (false, <String, dynamic>{});
    }
  }

  Future<Map<DeviceAction, bool>> executeActions(List<DeviceAction> actions, {dynamic params}) async {
    if (params is! Map<String, dynamic>?) {
      params = null;
    }
    final results = <DeviceAction, bool>{};
    for (final action in actions) {
      final result = await executeAction(action, params: params);
      results[action] = result?.$1 ?? false;
    }
    return results;
  }

  Future<bool> _executeForSinglePackage({
    required Map<String, dynamic>? params,
    required Future<dynamic> Function(String) action,
  }) async {
    final pkg = (params?['package_name'] as String?)?.trim();
    if (pkg == null || pkg.isEmpty) {
      return false;
    }
    await action(pkg);
    return true;
  }

  Future<(bool, Map<String, dynamic>)> _deviceData() async {
    try {
      await DeviceRepository().fullSync();
      return (true, <String, dynamic>{'status': 'synced'});
    } catch (e, st) {
      WLog.e(_tag, 'deviceData (fullSync) error', error: e, stackTrace: st);
      return (false, <String, dynamic>{'message': 'Operation failed'});
    }
  }

  Future<(bool, Map<String, dynamic>)> _getLogs() async {
    try {
      await WLog.flush(force: true);
      return (true, <String, dynamic>{'status': 'flushed'});
    } catch (e, st) {
      WLog.e(_tag, 'getLogs error', error: e, stackTrace: st);
      return (false, <String, dynamic>{'message': 'Operation failed'});
    }
  }

  Future<(bool, Map<String, dynamic>)> _getInstalledApps(Map<String, dynamic>? params) async {
    final includeSystemApps = parseParamInt(params?['include_system_apps'], 0) == 1;
    try {
      final apps = await _appManager.getInstalledAppsList(includeSystemApps: includeSystemApps);
      return (true, <String, dynamic>{'apps': apps, 'count': apps.length});
    } catch (e, st) {
      WLog.e(_tag, 'getInstalledApps error', error: e, stackTrace: st);
      return (false, <String, dynamic>{'message': 'Operation failed'});
    }
  }

  Future<(bool, Map<String, dynamic>)> _getCurrentLocation(Map<String, dynamic>? params) async {
    try {
      var enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        // Device owner can enable location without a user prompt; the setting does not apply instantly, so poll briefly.
        if (await _systemSettingsManager.setLocationEnabled(true)) {
          for (var i = 0; i < 10 && !enabled; i++) {
            await Future<void>.delayed(const Duration(milliseconds: 500));
            enabled = await Geolocator.isLocationServiceEnabled();
          }
        }
      }
      if (!enabled) {
        return (false, <String, dynamic>{'message': 'Location service disabled'});
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return (false, <String, dynamic>{'message': 'Location permission denied'});
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return (false, <String, dynamic>{'message': 'Location permission permanently denied'});
      }
      // Without a time limit the command would hang until the server times out; bound the wait and fall back to the last known position.
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } on TimeoutException {
        position = await Geolocator.getLastKnownPosition();
      }
      if (position == null) {
        return (false, <String, dynamic>{
          'message': 'Location unavailable (timeout, no last known location)',
        });
      }
      return (
        true,
        <String, dynamic>{
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'timestamp': position.timestamp.toUtc().toIso8601String(),
          'provider': 'geolocator',
          'isMocked': position.isMocked,
        },
      );
    } catch (e, st) {
      WLog.e(_tag, 'getCurrentLocation error', error: e, stackTrace: st);
      return (false, <String, dynamic>{'message': 'Operation failed'});
    }
  }

  Future<bool> _enablePowerSave() async {
    final opened = await _systemSettingsManager.openPowerSaveSettings();
    if (!opened) WLog.w(_tag, 'Failed to open power save settings');
    return opened;
  }

  Future<bool> _reduceBrightness(int level) async {
    final clamped = level.clamp(0, 100);
    await _displayManager.setBrightnessLevel(clamped);
    return true;
  }

  Future<bool> _disableWifi() async {
    return await _networkManager.toggleWifi(false);
  }

  Future<bool> _disableBluetooth() async {
    return await RestrictionManager().enableRestriction(Restriction.DISALLOW_BLUETOOTH.value);
  }

  Future<bool> _reboot() async {
    await _systemSettingsManager.reboot();
    return true;
  }

  /// Reboot happens after the ack ([rebootAfterAck]), so a reboot that is
  /// already known to fail is rejected here rather than acked as "success".
  Future<(bool, Map<String, dynamic>)> checkRebootAllowed() async {
    try {
      final isOwner = await KeyguardManager().isDeviceOwner;
      if (!isOwner) {
        return (false, <String, dynamic>{'message': 'Reboot requires device owner'});
      }
      return (true, <String, dynamic>{});
    } catch (e, st) {
      WLog.e(_tag, 'Reboot precondition check failed', error: e, stackTrace: st);
      return (false, <String, dynamic>{'message': 'Reboot precondition check failed'});
    }
  }

  /// A successful reboot kills the process and never returns; an error is only
  /// logged because the ack has already been sent.
  Future<void> rebootAfterAck() async {
    try {
      await _systemSettingsManager.reboot();
    } catch (e, st) {
      WLog.e(_tag, 'Reboot after ack failed', error: e, stackTrace: st);
    }
  }

  Future<bool> _sendNotification(Map<String, dynamic> params) async {
    final title = (params['title'] as String?)?.trim();
    final body = (params['body'] as String?)?.trim();
    final notificationUuid = (params['notification_uuid'] as String?)?.trim();
    try {
      await _systemNotificationBridge.showNotification(
        title: (title == null || title.isEmpty) ? L.mdm_notification_default : title,
        message: body ?? '',
      );
      if (notificationUuid != null && notificationUuid.isNotEmpty) {
        final acked = await DeviceNotificationApi().ack(notificationUuid);
        WLog.d(_tag, 'Notification ack -> $notificationUuid ($acked)');
      }
      return true;
    } catch (e, st) {
      WLog.e(_tag, 'sendNotification error', error: e, stackTrace: st);
      return false;
    }
  }

  Future<bool> _sendReport({required String type, Map<String, dynamic>? params}) async {
    try {
      final api = ReportRemoteDataSource();
      final (ok, message) = await api.sendReportRaw(type: type, payload: params);
      if (!ok) {
        WLog.w(_tag, 'sendReport failed: $message');
      }
      return ok;
    } catch (e, st) {
      WLog.e(_tag, 'sendReport error', error: e, stackTrace: st);
      return false;
    }
  }

  Future<bool> _clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
      return true;
    } catch (e, st) {
      WLog.e(_tag, 'Cache clear error', error: e, stackTrace: st);
      return false;
    }
  }

  Future<bool> _disableCamera() async {
    return await RestrictionManager().enableRestriction(Restriction.DISALLOW_CAMERA.value);
  }

  Future<(bool, Map<String, dynamic>)> _updatePolicy() async {
    try {
      final applier = policyApplierOverride ?? DeviceController.to.applyLatestConfigForCommand;
      final result = await applier();
      final failed = result == ConfigApplyResult.partial ? ConfigManager().lastFailedManagers : const <String>[];
      return policyAckFor(result, failedManagers: failed);
    } catch (e, st) {
      WLog.e(_tag, 'Policy update failed', error: e, stackTrace: st);
      return policyAckFor(ConfigApplyResult.failed);
    }
  }

  Future<(bool, Map<String, dynamic>)> _policyChange(String? policyId) async {
    int? expectedId;
    if (policyId != null && policyId.isNotEmpty) {
      expectedId = int.tryParse(policyId);
      if (expectedId == null) {
        return (false, <String, dynamic>{'message': 'Invalid policy_id: $policyId'});
      }
    }
    final (ok, data) = await _updatePolicy();
    if (expectedId == null) return (ok, data);
    return (ok, <String, dynamic>{...data, 'expected_policy_id': expectedId});
  }

  static (bool, Map<String, dynamic>) policyAckFor(ConfigApplyResult result, {List<String> failedManagers = const []}) {
    final data = <String, dynamic>{'policy_result': result.name};
    switch (result) {
      case ConfigApplyResult.applied:
        data['message'] = 'Policy applied';
      case ConfigApplyResult.inactive:
        data['message'] = 'Policy fetched but not active now';
      case ConfigApplyResult.throttled:
        data['message'] = 'Policy already applied';
      case ConfigApplyResult.partial:
        data['message'] = 'Policy applied with errors';
        data['failed_managers'] = failedManagers;
      case ConfigApplyResult.busy:
        data['message'] = 'Another policy apply in progress';
      case ConfigApplyResult.fetchFailed:
        data['message'] = 'Policy could not be fetched';
      case ConfigApplyResult.noPolicy:
        data['message'] = 'No policy assigned';
      case ConfigApplyResult.invalidPolicy:
        data['message'] = 'Policy could not be parsed; last valid policy kept';
      case ConfigApplyResult.failed:
        data['message'] = 'Policy apply failed';
    }
    return (result.isSuccess, data);
  }

  void registerCustomAction(String actionId, Future<bool> Function(Map<String, dynamic>?) callback) {
    _customActions[actionId] = callback;
  }

  void unregisterCustomAction(String actionId) {
    _customActions.remove(actionId);
  }

  List<String> get registeredCustomActions => _customActions.keys.toList();
}
