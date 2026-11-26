import 'package:package_info_plus/package_info_plus.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Init/app_bootstrap.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/launcher_mode_bridge.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Data/Models/Features/launcher_config.dart';

const _tag = 'LauncherModeManager';

class LauncherModeManager extends BaseManager<LauncherConfig> {
  static final LauncherModeManager _instance = LauncherModeManager._internal();

  factory LauncherModeManager() => _instance;

  LauncherModeManager._internal();

  final _bridge = LauncherModeBridge();

  @override
  Future<Map<String, dynamic>> getData() async {
    final isActive = _bridge.isLauncherModeActive();
    return {'isLauncherModeActive': isActive};
  }

  @override
  Future<void> applyConfiguration(LauncherConfig? config) async {
    WLog.d(
      _tag,
      'applyConfiguration starting. config=${config != null ? "LauncherConfig(isActive=${config.isActive})" : "null"}, isHeadless=${AppBootstrap.isHeadless}',
    );

    await safeExecute(() async {
      if (config == null) {
        WLog.d(_tag, 'config is null, calling disableLauncherMode');
        BasicStorage.instance.setBool(Sk.launcher_mode_enabled.name, false);
        await disableLauncherMode();
        WLog.d(_tag, 'disableLauncherMode completed');
        return;
      }

      final bool isActive = config.isActive;
      final bool launcherModeEnabledBefore = _bridge.isLauncherModeActive();
      WLog.d(
        _tag,
        'isActive=$isActive, launcherModeEnabledBefore=$launcherModeEnabledBefore',
      );

      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      WLog.d(_tag, 'packageName=$packageName');

      if (!isActive) {
        BasicStorage.instance.setBool(Sk.launcher_mode_enabled.name, false);
        WLog.d(_tag, 'LauncherMode disabled, clearing launcher');
        await _requireNativeSuccess(
          _bridge.clearHomeIntentHandler(packageName),
          'Launcher cleanup',
        );
        WLog.i(_tag, 'LauncherMode launcher fully stopped');
        return;
      }

      WLog.d(_tag, 'LauncherMode active, setting launcher + policy');
      await _requireNativeSuccess(
        _bridge.addHomeIntentHandler(packageName),
        'Launcher assignment',
      );
      BasicStorage.instance.setBool(Sk.launcher_mode_enabled.name, true);
      WLog.i(_tag, 'App set as launcher ($packageName)');
      WLog.i(_tag, 'applyConfiguration completed');
    }, logMessage: "LauncherModeManager: Configuration applied");
  }

  Future<void> disableLauncherMode() async {
    WLog.d(
      _tag,
      'disableLauncherMode starting. isHeadless=${AppBootstrap.isHeadless}',
    );
    if (AppBootstrap.isHeadless) {
      BasicStorage.instance.setBool(Sk.launcher_mode_enabled.name, false);
      return;
    }
    final packageInfo = await PackageInfo.fromPlatform();
    WLog.d(_tag, 'packageName=${packageInfo.packageName}');
    await _requireNativeSuccess(
      _bridge.clearHomeIntentHandler(packageInfo.packageName),
      'Launcher cleanup',
    );
    BasicStorage.instance.setBool(Sk.launcher_mode_enabled.name, false);
    WLog.i(_tag, 'LauncherMode disabled (launcher removed)');
  }

  /// Whether launcher mode is currently active (the agent is the home app).
  bool get isLauncherModeActive => _bridge.isLauncherModeActive();

  /// Assigns the agent as the home app again after [disableLauncherMode].
  Future<void> enableLauncherMode() async {
    final packageInfo = await PackageInfo.fromPlatform();
    await _requireNativeSuccess(
      _bridge.addHomeIntentHandler(packageInfo.packageName),
      'Launcher assignment',
    );
    BasicStorage.instance.setBool(Sk.launcher_mode_enabled.name, true);
    WLog.i(_tag, 'LauncherMode enabled (home assigned)');
  }

  Future<Map<String, dynamic>> _requireNativeSuccess(
    Future<Map<String, dynamic>> operation,
    String action,
  ) async {
    final result = await operation;
    if (result['success'] != true) {
      final message = result['message']?.toString() ?? 'Unknown native error';
      throw StateError('$action failed: $message');
    }
    return result;
  }
}
