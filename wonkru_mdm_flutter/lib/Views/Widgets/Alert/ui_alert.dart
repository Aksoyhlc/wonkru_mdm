import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Theme/design.dart';

class UiAlert extends StatelessWidget {
  const UiAlert({
    super.key,
    required this.message,
    this.tone = UiAlertTone.danger,
    this.toast = false,
  });

  final String message;
  final UiAlertTone tone;
  final bool toast;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // `info` is a neutral note, not a semantic tone, so it keeps the plain
    // surface instead of the soft/border pair.
    final (bg, fg, border) = tone == UiAlertTone.info
        ? (colors.muted, colors.carbon, colors.border)
        : (colors.toneSoft(tone), colors.toneFg(tone), colors.toneBorder(tone));
    final icon = switch (tone) {
      UiAlertTone.danger => LucideIcons.alertTriangle400,
      UiAlertTone.warning => LucideIcons.alertCircle400,
      UiAlertTone.info => LucideIcons.info,
      UiAlertTone.success => LucideIcons.checkCircle400,
    };

    final fontSize = toast ? 14.0 : 13.0;
    final iconSize = toast ? 20.0 : 16.0;

    return Container(
      width: double.infinity,
      constraints: toast ? const BoxConstraints(minHeight: 48) : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        boxShadow: [
          BoxShadow(
            color: fg.withValues(alpha: .07),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: toast
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Icon(icon, size: iconSize, color: fg),
          AppGap.h10,
          Expanded(
            child: SelectableText(
              message,
              style: AppText.body(
                context,
              ).copyWith(color: fg, fontSize: fontSize, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
