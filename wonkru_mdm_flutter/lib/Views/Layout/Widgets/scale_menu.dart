import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/theme_controller.dart';
import '../../Widgets/Menu/app_menu.dart';
import '../../Widgets/Menu/app_menu_item.dart';

class ScaleMenu extends StatelessWidget {
  const ScaleMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final colors = context.appColors;

    return Obx(() {
      final current = theme.scale.value;
      return AppMenu(
        tooltip: L.common.interfaceScale,
        header: L.common.interfaceScale,
        minWidth: 150,
        items: [
          for (final option in ThemeController.scaleOptions)
            AppMenuItem(
              label: '%${(option * 100).round()}',
              icon: option == current ? LucideIcons.check : LucideIcons.dot,
              onTap: () => theme.setScale(option),
            ),
        ],

        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: colors.outlined(radius: AppRadius.r6),
          child: Icon(LucideIcons.aLargeSmall, size: 15, color: colors.carbon),
        ),
      );
    });
  }
}
