import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/display_api.g.dart';

import '../../Init/app_bootstrap.dart';

const String _tag = 'DisplayBridge';

class DisplayBridge extends BaseBridge {
  static final DisplayBridge _instance = DisplayBridge._internal();
  factory DisplayBridge() => _instance;
  DisplayBridge._internal();

  final _api = DisplayAPI();

  @override
  String get bridgeName => "DisplayBridge";

  Stream<NativeSettingsEvent> get settingsStream => displayEventHandler.settingsStream;

  Future<void> startListening() async {
    WLog.d(_tag, 'startListening called - starting native observer...');
    await safeExecute(() async => await _api.startSettingsListener());
    WLog.d(_tag, 'Native observer started');
  }

  Future<void> stopListening() async {
    await safeExecute(() async => await _api.stopSettingsListener());
  }

  Future<bool> setScreenCaptureDisabled(bool disabled) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setScreenCaptureDisabled(disabled),
      logMessage: "$bridgeName: Screen capture ${disabled ? 'disabled' : 'enabled'}",
    );
    return success;
  }

  Future<bool> lockNow() async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.lockNow(),
      logMessage: "$bridgeName: Screen locked",
    );
    return success;
  }

  Future<bool> setLockScreenMessage(String? message) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setLockScreenMessage(message),
      logMessage: "$bridgeName: Lock screen message updated",
    );
    return success;
  }

  Future<bool> hasWriteSettingsPermission() async {
    return await safeCall<bool>(() async => await _api.hasWriteSettingsPermission(), defaultValue: false);
  }

  Future<void> requestWriteSettingsPermission() async {
    await safeExecute(() async => await _api.requestWriteSettingsPermission());
  }

  Future<Map<String, dynamic>> getDisplayInfo() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final result = await _api.getDisplayInfo();
      return result.cast<String, dynamic>();
    }, defaultValue: {});
  }
}
