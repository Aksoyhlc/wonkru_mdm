import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Native/Generated/display_api.g.dart';

const _tag = 'DisplayEventHandler';

class DisplayEventHandler extends DisplayEventAPI {
  static final DisplayEventHandler _instance = DisplayEventHandler._internal();
  factory DisplayEventHandler() => _instance;
  DisplayEventHandler._internal();

  final _settingsController = StreamController<NativeSettingsEvent>.broadcast();

  Stream<NativeSettingsEvent> get settingsStream => _settingsController.stream;

  @override
  void onSettingsChanged(NativeSettingsEvent event) {
    _settingsController.add(event);
  }

  @override
  void onScreenOn() {
    debugPrint('[$_tag] onScreenOn received');
    WLog.d(_tag, 'onScreenOn received');
  }

  @override
  void onScreenOff() {
    debugPrint('[$_tag] onScreenOff received');
    WLog.d(_tag, 'onScreenOff received');
  }

  @override
  void onKeyguardUnlocked() {
    WLog.d(_tag, 'onKeyguardUnlocked');
  }

  @override
  void onUserUnlocked() {
    WLog.d(_tag, 'onUserUnlocked');
  }

  void dispose() {
    _settingsController.close();
  }
}