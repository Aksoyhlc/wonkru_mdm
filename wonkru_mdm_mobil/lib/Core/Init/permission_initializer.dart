import 'package:permission_handler/permission_handler.dart';
import 'package:wonkrumdm/Core/Managers/audio_manager.dart';
import 'package:wonkrumdm/Core/Managers/display_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/system_settings_bridge.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';

const _tag = 'PermissionInitializer';

class PermissionInitializer {
  static final PermissionInitializer instance = PermissionInitializer._();
  PermissionInitializer._();

  final _settingsBridge = SystemSettingsBridge();

  Future<CriticalPermissionsStatus> checkCriticalManualPermissions() async {
    WLog.i(_tag, 'Checking manual permissions');

    final hasWriteSettings = await DisplayManager()
        .hasWriteSettingsPermission();
    final hasNotificationPolicy = await AudioManager()
        .hasNotificationPolicyAccess();
    final hasManageStorage = await _settingsBridge
        .hasManageExternalStoragePermission();
    final hasBatteryOptimization = await _settingsBridge
        .isBatteryOptimizationIgnored();
    final status = CriticalPermissionsStatus(
      hasWriteSettings: hasWriteSettings,
      hasNotificationPolicy: hasNotificationPolicy,
      hasManageStorage: hasManageStorage,
      hasBatteryOptimization: hasBatteryOptimization,
    );

    if (status.allGranted) {
      WLog.i(_tag, 'STATUS: ALL GRANTED');
    } else {
      final missing = status.missingPermissions;
      WLog.i(_tag, 'STATUS: MISSING → ${missing.join(", ")}');
    }
    return status;
  }

  Future<void> requestManualPermissions() async {
    WLog.i(_tag, 'Requesting manual permissions');
    final status = await checkCriticalManualPermissions();

    if (!status.hasWriteSettings) {
      await DisplayManager().requestWriteSettingsPermission();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!status.hasNotificationPolicy) {
      await AudioManager().requestNotificationPolicyAccess();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!status.hasManageStorage) {
      await requestStoragePermission();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!status.hasBatteryOptimization) {
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}

Future<void> requestStoragePermission() async {
  try {
    if (await Permission.manageExternalStorage.status.isDenied) {
      WLog.d(_tag, 'Requesting Manage External Storage permission');
      await Permission.manageExternalStorage.request();
    }

    if (await Permission.storage.status.isDenied) {
      WLog.d(_tag, 'Requesting Storage permission');
      await Permission.storage.request();
    }
  } catch (e, st) {
    WLog.e(_tag, 'Permission request error', error: e, stackTrace: st);
  }
}

class CriticalPermissionsStatus {
  final bool hasWriteSettings;
  final bool hasNotificationPolicy;
  final bool hasManageStorage;
  final bool hasBatteryOptimization;

  CriticalPermissionsStatus({
    required this.hasWriteSettings,
    required this.hasNotificationPolicy,
    required this.hasManageStorage,
    required this.hasBatteryOptimization,
  });

  bool get allGranted =>
      hasWriteSettings &&
      hasNotificationPolicy &&
      hasManageStorage &&
      hasBatteryOptimization;

  List<String> get missingPermissions {
    final missing = <String>[];
    if (!hasWriteSettings) missing.add('WRITE_SETTINGS');
    if (!hasNotificationPolicy) missing.add('NOTIFICATION_POLICY');
    if (!hasManageStorage) missing.add('MANAGE_STORAGE');
    if (!hasBatteryOptimization) missing.add('BATTERY_OPTIMIZATION');
    return missing;
  }
}