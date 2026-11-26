import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/audio_api.g.dart';

import '../../Init/app_bootstrap.dart';

class AudioBridge extends BaseBridge {
  static final AudioBridge _instance = AudioBridge._internal();
  factory AudioBridge() => _instance;
  AudioBridge._internal();

  final _api = AudioPig();

  @override
  String get bridgeName => "AudioBridge";

  Stream<NativeVolumeEvent> get volumeStream => audioEventHandler.volumeStream;

  Future<bool> setMusicVolume(int volumePercent) async {
    final safePercent = volumePercent.clamp(0, 100);

    final (success, _) = await mdmResultSafeCall<Object>(() async => await _api.setMusicVolume(safePercent));
    return success;
  }

  Future<int?> getMusicVolume() async {
    return await safeCall<int?>(() async => await _api.getMusicVolume(), defaultValue: null);
  }

  Future<bool> hasNotificationPolicyAccess() async {
    return await safeCall<bool>(() async => await _api.hasNotificationPolicyAccess(), defaultValue: false);
  }

  Future<void> requestNotificationPolicyAccess() async {
    await safeExecute(() async => await _api.requestNotificationPolicyAccess());
  }
}
