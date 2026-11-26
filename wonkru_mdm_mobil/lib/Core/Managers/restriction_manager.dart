import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/restriction_bridge.dart';
import 'package:wonkrumdm/Data/Models/Features/restrict.dart';
import 'package:wonkrumdm/Data/Models/Features/restrict_model.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

const String _tag = 'RestrictionManager';

class RestrictionManager extends BaseManager<RestrictPolicy> {
  static final RestrictionManager _instance = RestrictionManager._internal();
  factory RestrictionManager() => _instance;
  RestrictionManager._internal();

  final _bridge = RestrictionBridge();

  RestrictPolicy? get _currentPolicy => DeviceController.to.config.value.restrictionSettings;

  RestrictPolicy? get currentPolicy => _currentPolicy;

  @override
  Future<void> applyConfiguration(RestrictPolicy config) async {
    await safeExecute(() async {
      WLog.d(_tag, "${config.restrictions?.length ?? 0} restrictions applying...");

      if (config.restrictions == null || config.restrictions!.isEmpty) {
        WLog.d(_tag, "Restriction list empty");
        return;
      }

      for (final restriction in config.restrictions!) {
        await _applyRestriction(restriction);
      }

      WLog.d(_tag, "Restrictions applied");
    }, logMessage: "RestrictionManager: Configuration completed");
  }

  Future<void> _applyRestriction(RestrictModel restriction) async {
    if (restriction.key == null || restriction.value == null) return;

    if (restriction.value == OnOff.def) {
      WLog.d(_tag, "${restriction.key} -> default (skipping)");
      return;
    }

    if (restriction.apiLevel != null) {
      final deviceApi = await _getDeviceApiLevel();
      if (deviceApi < restriction.apiLevel!) {
        WLog.d(_tag, "${restriction.key} -> API level insufficient (${restriction.apiLevel} required)");
        return;
      }
    }

    final shouldRestrict = restriction.value == OnOff.on;
    final success = await _bridge.setRestriction(restriction.key!, shouldRestrict);

    WLog.d(_tag, "${restriction.key} -> ${shouldRestrict ? 'restricted' : 'allowed'} (${success ? 'OK' : 'FAIL'})");
  }

  Future<bool> enableRestriction(String key) async {
    return await _bridge.setRestriction(key, true);
  }

  Future<int> _getDeviceApiLevel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.sdkInt;
      } catch (e, st) {
        WLog.e(_tag, 'Failed to get API level (DeviceInfoPlugin)', error: e, stackTrace: st);
      }
    }
    return 33;
  }

  @override
  Future<Map<String, dynamic>> getData() async {
    final restrictions = _currentPolicy?.restrictions ?? [];

    return {
      'restrictionCount': restrictions.length,
      'restrictions': restrictions.map((r) => {'key': r.key, 'value': r.value?.name, 'apiLevel': r.apiLevel}).toList(),
    };
  }
}
