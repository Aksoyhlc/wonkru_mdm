import 'dart:async';

import 'package:wonkrumdm/Core/Interfaces/watchdog_interface.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/audio_bridge.dart';
import 'package:wonkrumdm/Data/Models/Features/audio_config.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

const _tag = 'AudioManager';

class AudioManager extends BaseManager<AudioConfig> implements IWatchdog {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() => _instance;

  AudioManager._internal() {}

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final musicVol = await getMusicVolume();
      final hasNotifAccess = await hasNotificationPolicyAccess();

      return {
        'volumes': {'music': musicVol},
        'hasNotificationPolicyAccess': hasNotifAccess,
      };
    }, defaultValue: {});
  }

  final _audioBridge = AudioBridge();

  AudioConfig? get _currentConfig => DeviceController.to.config.value.audioSettings;
  StreamSubscription? _watchdogSubscription;

  @override
  bool get isWatchdogRunning => _watchdogSubscription != null;

  @override
  Duration get initialDelay => Duration.zero;

  @override
  Future<void> checkNow() async {}

  @override
  Future<void> applyConfiguration(AudioConfig config) async {
    await safeExecute(() async {
      if ((config.fixedVolumePolicy ?? false) && config.fixedVolume != null) {
        await setMusicVolume(config.fixedVolume!);
      } else {
        final currentVol = await getMusicVolume();
        if (currentVol != null) {
          int? targetVol;

          if (config.minVolume != null && currentVol < config.minVolume!) {
            targetVol = config.minVolume;
          } else if (config.maxVolume != null && currentVol > config.maxVolume!) {
            targetVol = config.maxVolume;
          }

          WLog.i(
            _tag,
            'Volume check: current=$currentVol%, '
            'min=${config.minVolume}, max=${config.maxVolume}, target=$targetVol',
          );

          if (targetVol != null) {
            await setMusicVolume(targetVol);
          }
        }
      }
    }, logMessage: "AudioManager: Audio policies applied");
  }

  @override
  void startWatchdog() {
    _watchdogSubscription?.cancel();
    _watchdogSubscription = _audioBridge.volumeStream.listen((event) async {
      if (_currentConfig == null) return;

      final newVol = event.volumePercent ?? 0;
      await checkAndRevertVolume(newVol, _currentConfig!);
    });
  }

  @override
  void stopWatchdog() {
    _watchdogSubscription?.cancel();
    _watchdogSubscription = null;
  }

  Future<void> checkAndRevertVolume(int currentVol, AudioConfig config) async {
    if (config.fixedVolumePolicy == true && config.fixedVolume != null) {
      if ((currentVol - config.fixedVolume!).abs() > 2) {
        WLog.w(_tag, 'Watchdog: volume must be fixed at ${config.fixedVolume}%. Reverting');
        await _audioBridge.setMusicVolume(config.fixedVolume!);
      }
      return;
    }

    int? targetVol;

    if (config.minVolume != null && currentVol < config.minVolume!) {
      targetVol = config.minVolume;
      WLog.w(_tag, 'Watchdog: volume below minimum ($currentVol% < ${config.minVolume}%). Correcting');
    } else if (config.maxVolume != null && currentVol > config.maxVolume!) {
      targetVol = config.maxVolume;
      WLog.w(_tag, 'Watchdog: volume above maximum ($currentVol% > ${config.maxVolume}%). Correcting');
    }

    if (targetVol != null) {
      await _audioBridge.setMusicVolume(targetVol);
    }
  }

  Future<void> setMusicVolume(int volumePercent) async {
    await safeExecute(() async {
      await _audioBridge.setMusicVolume(volumePercent);
      WLog.d(_tag, 'Volume set to $volumePercent%');
    });
  }

  Future<int?> getMusicVolume() async {
    return _audioBridge.getMusicVolume();
  }

  Stream<dynamic> get volumeStream => _audioBridge.volumeStream;

  Future<bool> hasNotificationPolicyAccess() async {
    try {
      return await _audioBridge.hasNotificationPolicyAccess();
    } catch (e, st) {
      WLog.e(_tag, 'Notification policy access check failed', error: e, stackTrace: st);
      return false;
    }
  }

  Future<void> requestNotificationPolicyAccess() async {
    await safeExecute(() async {
      await _audioBridge.requestNotificationPolicyAccess();
      WLog.d(_tag, 'Notification policy access settings opened');
    });
  }

  void dispose() {
    stopWatchdog();
  }
}
