import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/L10n/Language.dart';
import '../../Data/Repositories/preferences_repository.dart';

class LocaleController extends GetxController {
  final locale = AppTranslations.fallbackLocale.obs;

  void setLocale(Locale value) {
    locale.value = value;
    Get.updateLocale(value);
    unawaited(PreferencesRepository.saveLocale(value.toLanguageTag()));
  }

  /// Called before the app renders. `Get.locale` is assigned directly here;
  /// `updateLocale` triggers a reassemble, so it is only used from the user
  /// action ([setLocale]).
  Future<void> loadPreferences() async {
    Get.addTranslations(AppTranslations().keys);
    Get.fallbackLocale = AppTranslations.fallbackLocale;

    final stored = await PreferencesRepository.locale();
    final resolved = AppTranslations.resolveLocale(
      storedTag: stored,
      deviceLocales: WidgetsBinding.instance.platformDispatcher.locales,
    );
    locale.value = resolved;
    Get.locale = resolved;
  }
}
