import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/auth_controller.dart';
import '../../../Widgets/Alert/ui_alert.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Card/section_card.dart';

class AccessDeniedView extends StatelessWidget {
  const AccessDeniedView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.porcelain,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SectionCard(
            title: L.common.accessDeniedTitle,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UiAlert(
                  message: L.common.accessDeniedNoScope,
                  tone: UiAlertTone.danger,
                ),
                AppGap.v12,
                AppButton(
                  label: L.common.signOutAndSignIn,
                  icon: LucideIcons.logOut,
                  onPressed: () => Get.find<AuthController>().signOut(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
