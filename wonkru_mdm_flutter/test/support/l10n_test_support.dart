import 'package:get/get.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Language.dart';

/// Called once by `flutter_test_config.dart`; tests whose `tearDown` runs
/// `Get.reset()` must call this again in `setUp`.
void installTestTranslations() {
  Get.testMode = true;
  Get.addTranslations(AppTranslations().keys);
  Get.fallbackLocale = AppTranslations.fallbackLocale;
  Get.locale = AppTranslations.en;
}
