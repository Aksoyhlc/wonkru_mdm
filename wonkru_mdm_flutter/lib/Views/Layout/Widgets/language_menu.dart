import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/L10n/Language.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/locale_controller.dart';
import '../../Widgets/Menu/app_menu.dart';
import '../../Widgets/Menu/app_menu_item.dart';

class LanguageMenu extends StatelessWidget {
  const LanguageMenu({super.key});

  String _labelFor(Locale locale) => switch (locale.languageCode) {
    'tr' => L.common.languageTurkish,
    _ => L.common.languageEnglish,
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocaleController>();
    final colors = context.appColors;

    return Obx(() {
      final current = controller.locale.value;
      return AppMenu(
        tooltip: L.common.language,
        header: L.common.language,
        minWidth: 150,
        items: [
          for (final locale in AppTranslations.supportedLocales)
            AppMenuItem(
              label: _labelFor(locale),
              icon: locale.languageCode == current.languageCode
                  ? LucideIcons.check
                  : LucideIcons.dot,
              onTap: () => controller.setLocale(locale),
            ),
        ],
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: colors.outlined(radius: AppRadius.r6),
          child: Icon(LucideIcons.languages, size: 15, color: colors.carbon),
        ),
      );
    });
  }
}
