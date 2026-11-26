import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/Repositories/preferences_repository.dart';

/// Both the outer `ShadApp` and the inner `GetMaterialApp` read this mode, so
/// the Material and shadcn themes switch together. Mode and scale are persisted
/// per device; with nothing saved the app opens in `system` at default scale.
class ThemeController extends GetxController {
  final mode = ThemeMode.system.obs;

  /// Overall UI size, where `1.0` is the design size. Text, icons, and spacing
  /// scale together; `AppScaler` applies it at the root.
  final scale = defaultScale.obs;

  static const defaultScale = 1.1;

  static const scaleOptions = [0.9, 1.0, 1.1, 1.2, 1.25];

  void setMode(ThemeMode value) {
    mode.value = value;
    unawaited(PreferencesRepository.saveThemeMode(value.name));
  }

  /// Must run before the app draws, or the UI would flash the defaults first.
  Future<void> loadPreferences() async {
    final (savedMode, savedScale) = await (
      PreferencesRepository.themeMode(),
      PreferencesRepository.scale(),
    ).wait;

    for (final value in ThemeMode.values) {
      if (value.name == savedMode) mode.value = value;
    }
    if (savedScale != null && scaleOptions.contains(savedScale)) {
      scale.value = savedScale;
    }
  }

  void setScale(double value) {
    scale.value = value;
    unawaited(PreferencesRepository.saveScale(value));
  }

  void toggle() {
    final isDark = switch (mode.value) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        PlatformDispatcher.instance.platformBrightness == Brightness.dark,
    };
    setMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
