import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../../Core/L10n/L.dart';
import '../../../../../Core/Theme/design.dart';
import '../../../Button/app_button.dart';
import 'upload_box.dart';

class UploadIdlePanel extends StatelessWidget {
  const UploadIdlePanel({
    super.key,
    required this.dragging,
    required this.enabled,
    required this.onPick,
  });

  final bool dragging;
  final bool enabled;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final active = dragging && enabled;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s20,
      ),
      decoration: uploadBoxDecoration(
        context,
        active ? colors.loomBlue : colors.border,
        active,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.uploadCloud,
            size: 28,
            color: active ? colors.loomBlue : colors.graphite,
          ),
          AppGap.v8,
          Text(
            active ? L.common.drop : L.common.dropFilesHere,
            textAlign: TextAlign.center,
            style: AppText.body(context),
          ),
          AppGap.v12,
          AppButton(
            label: L.common.chooseFile,
            icon: LucideIcons.fileUp,
            variant: AppButtonVariant.secondary,
            onPressed: enabled ? onPick : null,
          ),
        ],
      ),
    );
  }
}
