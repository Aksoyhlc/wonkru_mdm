import 'dart:async';

import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Native/Generated/system_settings_api.g.dart';

const _tag = 'SystemSettingsEventHandler';

class SystemSettingsEventHandler extends SystemSettingsEventAPI {
  SystemSettingsEventHandler._();
  static final SystemSettingsEventHandler instance =
      SystemSettingsEventHandler._();
  factory SystemSettingsEventHandler() => instance;

  final _accessibilityPackages = StreamController<List<String>>.broadcast();

  Stream<List<String>> get accessibilityEnabledPackagesStream =>
      _accessibilityPackages.stream;

  @override
  void onSettingChanged(SystemSettingsChangeEvent event) {
    WLog.v(_tag, 'onSettingChanged key=${event.key} value=${event.value}');
  }

  @override
  void onAccessibilityServicesChanged(AccessibilityServicesChangeEvent event) {
    final list = (event.enabledPackageNames ?? const <String?>[])
        .map((e) => e ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    WLog.v(_tag, 'onAccessibilityServicesChanged count=${list.length}');
    _accessibilityPackages.add(list);
  }

  void dispose() {
    _accessibilityPackages.close();
  }
}