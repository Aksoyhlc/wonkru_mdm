import 'dart:async';

import 'package:battery_plus/battery_plus.dart' as bp;
import 'package:wonkrumdm/Core/Constants/Enums/battery_enums.dart';
import 'package:wonkrumdm/Core/Interfaces/watchdog_interface.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Data/Models/Features/battery_config.dart';
import 'package:wonkrumdm/Data/Models/Features/battery_info.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

const _tag = 'BatteryManager';

class BatteryManager extends BaseManager<BatteryConfig> implements IWatchdog {
  static final BatteryManager _instance = BatteryManager._internal();

  factory BatteryManager() => _instance;

  BatteryManager._internal();

  final bp.Battery _battery = bp.Battery();

  BatteryInfo? _lastBatteryInfo;

  BatteryConfig? get _currentConfig => DeviceController.to.config.value.batterySettings;
  StreamSubscription? _batterySubscription;

  bool _hasShownLowBatteryWarning = false;
  bool _hasShownCriticalBatteryWarning = false;

  final _batteryInfoController = StreamController<BatteryInfo>.broadcast();
  final _lowBatteryController = StreamController<BatteryInfo>.broadcast();
  final _criticalBatteryController = StreamController<BatteryInfo>.broadcast();
  final _chargingStateController = StreamController<BatteryChargingState>.broadcast();

  Stream<BatteryInfo> get batteryStream => _batteryInfoController.stream;

  Stream<BatteryInfo> get lowBatteryStream => _lowBatteryController.stream;

  Stream<BatteryInfo> get criticalBatteryStream => _criticalBatteryController.stream;

  Stream<BatteryChargingState> get chargingStateStream => _chargingStateController.stream;

  BatteryInfo? get lastBatteryInfo => _lastBatteryInfo;

  BatteryConfig? get currentConfig => _currentConfig;

  int? get level => _lastBatteryInfo?.level;

  BatteryChargingState? get chargingState => _lastBatteryInfo?.state;

  bool get isCharging => _lastBatteryInfo?.isCharging ?? false;

  Future<int> getBatteryLevel() async {
    return await _battery.batteryLevel;
  }

  Future<BatteryInfo> getBatteryInfo() async {
    final level = await _battery.batteryLevel;
    final state = await _battery.batteryState;
    final powerSave = await _battery.isInBatterySaveMode;

    final info = BatteryInfo(level: level, state: _mapBatteryState(state), isPowerSaveMode: powerSave);

    _lastBatteryInfo = info;
    return info;
  }

  @override
  bool get isWatchdogRunning => _batterySubscription != null;

  @override
  Duration get initialDelay => Duration.zero;

  @override
  Future<void> checkNow() async {
    final info = await getBatteryInfo();
    _processBatteryChange(info);
  }

  @override
  void startWatchdog() {
    if (_batterySubscription != null) return;

    if (currentConfig == null || !currentConfig!.enabled) {
      WLog.w(_tag, 'Watchdog not started: policy disabled');
      return;
    }

    WLog.i(_tag, 'Watchdog started');

    _batterySubscription = _battery.onBatteryStateChanged.listen((state) async {
      final level = await _battery.batteryLevel;
      final powerSave = await _battery.isInBatterySaveMode;

      final info = BatteryInfo(level: level, state: _mapBatteryState(state), isPowerSaveMode: powerSave);

      _processBatteryChange(info);
    });
  }

  @override
  void stopWatchdog() {
    _batterySubscription?.cancel();
    _batterySubscription = null;
    WLog.i(_tag, 'Watchdog stopped');
  }

  @override
  Future<void> applyConfiguration(BatteryConfig config) async {
    await safeExecute(() async {
      if (config.enabled) {
        WLog.i(_tag, 'Configuration applied');
      } else {
        WLog.i(_tag, 'Policy disabled');
      }
    }, logMessage: "BatteryManager: Configuration processed");
  }

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final info = await getBatteryInfo();
      return {'level': info.level, 'state': info.state.name, 'isPowerSaveMode': info.isPowerSaveMode};
    }, defaultValue: {'level': 0, 'state': 'unknown'});
  }

  void _processBatteryChange(BatteryInfo info) {
    final previousInfo = _lastBatteryInfo;
    _lastBatteryInfo = info;

    _batteryInfoController.add(info);

    if (previousInfo == null || previousInfo.state != info.state) {
      _chargingStateController.add(info.state);
    }

    final lowThreshold = _currentConfig?.lowBatteryThreshold ?? 20;
    final criticalThreshold = _currentConfig?.criticalBatteryThreshold ?? 10;

    if (info.isCharging) {
      _hasShownLowBatteryWarning = false;
      _hasShownCriticalBatteryWarning = false;
    }

    if (!info.isCharging && info.level <= lowThreshold) {
      if (!_hasShownLowBatteryWarning) {
        _lowBatteryController.add(info);
        _hasShownLowBatteryWarning = true;
        WLog.w(_tag, 'Low battery warning (${info.level}%)');
      }
    }

    if (!info.isCharging && info.level <= criticalThreshold) {
      if (!_hasShownCriticalBatteryWarning) {
        _criticalBatteryController.add(info);
        _hasShownCriticalBatteryWarning = true;
        WLog.w(_tag, 'Critical battery warning (${info.level}%)');
      }
    }

    WLog.v(_tag, '${info.level}% - ${info.stateText}');
  }

  BatteryChargingState _mapBatteryState(bp.BatteryState state) {
    switch (state) {
      case bp.BatteryState.charging:
        return BatteryChargingState.charging;
      case bp.BatteryState.discharging:
        return BatteryChargingState.discharging;
      case bp.BatteryState.full:
        return BatteryChargingState.full;
      case bp.BatteryState.connectedNotCharging:
        return BatteryChargingState.connectedNotCharging;
      case bp.BatteryState.unknown:
        return BatteryChargingState.unknown;
    }
  }

  void dispose() {
    stopWatchdog();
    _batteryInfoController.close();
    _lowBatteryController.close();
    _criticalBatteryController.close();
    _chargingStateController.close();
  }
}
