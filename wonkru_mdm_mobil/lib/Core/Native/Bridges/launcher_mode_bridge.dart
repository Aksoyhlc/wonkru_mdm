import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/launcher_mode_api.g.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';

class LauncherModeBridge extends BaseBridge {
  static final LauncherModeBridge _instance = LauncherModeBridge._internal();
  factory LauncherModeBridge() => _instance;
  LauncherModeBridge._internal();

  final _api = LauncherModeApi();

  @override
  String get bridgeName => 'LauncherModeBridge';

  bool isLauncherModeActive() {
    return BasicStorage.instance.getBool(Sk.launcher_mode_enabled.name) ?? false;
  }

  Future<Map<String, dynamic>> addHomeIntentHandler(String packageName) async {
    final result = await _api.addHomeIntentHandler(packageName);
    return Map<String, dynamic>.from(result);
  }

  Future<Map<String, dynamic>> clearHomeIntentHandler(String packageName) async {
    final result = await _api.clearHomeIntentHandler(packageName);
    return Map<String, dynamic>.from(result);
  }
}
