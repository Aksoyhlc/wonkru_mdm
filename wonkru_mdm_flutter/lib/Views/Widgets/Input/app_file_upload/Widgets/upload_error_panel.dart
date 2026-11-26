import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../../Core/L10n/L.dart';
import '../../../../../Core/Theme/design.dart';
import '../../../Button/app_button.dart';
import 'upload_box.dart';

class UploadErrorPanel extends StatelessWidget {
  const UploadErrorPanel({
    super.key,
    required this.message,
    required this.canRetry,
    required this.onDiscard,
    required this.onRetry,
  });

  final String message;
  final bool canRetry;
  final VoidCallback onDiscard;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: AppInsets.all12,
      decoration: uploadBoxDecoration(context, colors.madder, false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.triangleAlert, size: 18, color: colors.madder),
              AppGap.h8,
              Expanded(
                child: Text(
                  message,
                  style: AppText.body(
                    context,
                  ).copyWith(fontSize: 12.5, color: colors.madder),
                ),
              ),
            ],
          ),
          AppGap.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: L.common.discard,
                variant: AppButtonVariant.ghost,
                compact: true,
                onPressed: onDiscard,
              ),
              AppGap.h8,
              AppButton(
                label: L.common.retryUpload,
                icon: LucideIcons.refreshCw,
                variant: AppButtonVariant.secondary,
                compact: true,
                onPressed: canRetry ? onRetry : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
