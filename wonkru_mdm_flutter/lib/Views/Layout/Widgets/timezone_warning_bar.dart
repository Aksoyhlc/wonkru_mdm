import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Core/Time/app_time.dart';

/// When no zone is set, all times render as UTC; this non-dismissible bar is
/// shown so that state is not misread. It disappears once a zone is set
/// ([AppTime.zoneName] is observed).
class TimezoneWarningBar extends StatelessWidget {
  const TimezoneWarningBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (AppTime.instance.isConfigured) return const SizedBox.shrink();

      final colors = context.appColors;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          color: colors.warningSoft,
          border: Border(bottom: BorderSide(color: colors.warningBorder)),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.triangleAlert, size: 14, color: colors.warning),
            AppGap.h8,
            Expanded(
              child: Text(
                L.common.timezoneNotSet,
                style: AppText.caption(context),
              ),
            ),
          ],
        ),
      );
    });
  }
}
