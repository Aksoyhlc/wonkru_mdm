import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Button/app_button.dart';

/// Amber banner shown when the policy selector/pivot lists failed to load, with
/// a retry action.
class PolicyLoadWarningBanner extends StatelessWidget {
  const PolicyLoadWarningBanner({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: colors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.triangleAlert, size: 16, color: colors.warning),
          AppGap.h10,
          Expanded(
            child: Text(message, style: AppText.body(context)),
          ),
          AppGap.h12,
          AppButton(
            label: L.policies.retry,
            compact: true,
            variant: AppButtonVariant.secondary,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
