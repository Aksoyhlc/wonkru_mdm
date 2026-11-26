import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Constants/Enums/system_settings_key.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/system_settings_bridge.dart';
import 'package:wonkrumdm/Data/Models/Features/other_settings_config.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

const _tag = 'OtherSettingsManager';

class OtherSettingsManager extends BaseManager<OtherSettingsConfig> {
  static final OtherSettingsManager _instance = OtherSettingsManager._internal();

  factory OtherSettingsManager() => _instance;

  OtherSettingsManager._internal();

  final _systemSettingsBridge = SystemSettingsBridge();

  OtherSettingsConfig? get _currentConfig => DeviceController.to.config.value.otherSettings;

  OtherSettingsConfig? get currentConfig => _currentConfig;

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final deviceTime1224 = await _systemSettingsBridge.getStringSetting(SystemSettingsKey.time1224, type: 'system');
      return {
        'dateTime': {
          'autoTime': _currentConfig?.autoTime?.value,
          'autoTimeZone': _currentConfig?.autoTimeZone?.value,
          'timeZone': _currentConfig?.timeZone,
          'time1224': _currentConfig?.time1224,
          'deviceTime1224': deviceTime1224,
          // UTC with offset: a server would interpret an offset-less time in its own timezone.
          'currentDateTime': DateTime.now().toUtc().toIso8601String(),
          'deviceTimeZoneName': DateTime.now().timeZoneName,
          'deviceTimeZoneOffset': DateTime.now().timeZoneOffset.inHours,
        },
      };
    }, defaultValue: {});
  }

  @override
  Future<void> applyConfiguration(OtherSettingsConfig config) async {
    await safeExecute(() async {
      final autoTimeZone = config.autoTimeZone;
      if (autoTimeZone != null && autoTimeZone != OnOff.def) {
        final enabled = autoTimeZone == OnOff.on;
        await _systemSettingsBridge.setAutoTimeZone(enabled);
        WLog.d(_tag, 'Auto Time Zone -> $enabled');
      } else {
        WLog.d(_tag, 'Auto Time Zone -> default (skipping)');
      }

      final autoZoneEnabled = autoTimeZone == OnOff.on;
      if (config.timeZone != null && config.timeZone!.isNotEmpty) {
        if (!autoZoneEnabled) {
          await _systemSettingsBridge.setTimeZone(config.timeZone!);
          WLog.d(_tag, 'Time Zone set -> ${config.timeZone}');
        } else {
          WLog.d(_tag, 'Auto Time Zone enabled, skipping specific timezone ("${config.timeZone}")');
        }
      }

      final autoTime = config.autoTime;
      if (autoTime == null || autoTime == OnOff.def) {
        WLog.d(_tag, 'Auto Time -> default (skipping)');
      } else {
        final enabled = autoTime == OnOff.on;
        await _systemSettingsBridge.setAutoTimeRequired(enabled);
        WLog.d(_tag, 'Auto Time Required -> $enabled');

        await _systemSettingsBridge.setAutoTime(enabled);
        WLog.d(_tag, 'Auto Time -> $enabled');
      }

      if (config.time1224 != null) {
        final h = config.time1224!;
        if (h == 12 || h == 24) {
          final ok = await _systemSettingsBridge.setTime1224(h);
          WLog.d(_tag, 'Time 12/24 -> $h (${ok ? "ok" : "failed"})');
        } else {
          WLog.w(_tag, 'Invalid time_12_24 ($h), must be 12 or 24');
        }
      }
    }, logMessage: "OtherSettingsManager: Configuration applied (Date/Time included)");
  }
}
