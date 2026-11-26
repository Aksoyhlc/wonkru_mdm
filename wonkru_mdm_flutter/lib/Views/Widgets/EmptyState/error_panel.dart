import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../Button/app_button.dart';

class ErrorPanel extends StatelessWidget {
  const ErrorPanel({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel,
  });

  final String message;

  final VoidCallback? onRetry;

  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s14,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: colors.dangerSoft,
            borderRadius: BorderRadius.circular(AppRadius.r8),
            border: Border.all(color: colors.dangerBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.alertTriangle400,
                    size: 18,
                    color: colors.madder,
                  ),
                  AppGap.h10,
                  Expanded(
                    child: SelectableText(
                      message,
                      style: AppText.body(
                        context,
                      ).copyWith(color: context.appColors.madder, height: 1.35),
                    ),
                  ),
                ],
              ),
              if (onRetry != null) ...[
                AppGap.v12,
                AppButton(
                  label: retryLabel ?? L.common.retry,
                  variant: AppButtonVariant.danger,
                  icon: LucideIcons.refreshCw,
                  compact: true,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
