import 'package:flutter/material.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Theme/design.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.tone = UiAlertTone.info,
    this.icon,
  });

  final String label;
  final UiAlertTone tone;

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bg = colors.toneSoft(tone);
    final fg = colors.toneFg(tone);
    final border = colors.toneBorder(tone);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: fg),
            AppGap.h4,
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.badge(context, fg),
            ),
          ),
        ],
      ),
    );
  }
}
