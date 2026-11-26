import 'package:flutter/material.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';

/// Yes/no confirmation. Resolves to `true` on yes, `null` on no or dismiss.
Future<bool?> confirmDialog({
  required BuildContext context,
  required String message,
  String? title,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      final colors = ctx.appColors;
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            margin: AppInsets.h20,
            constraints: const BoxConstraints(maxWidth: 550),
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.s20,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              color: colors.workshop,
              borderRadius: BorderRadius.circular(AppRadius.r8),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: colors.carbon.withValues(alpha: 0.15),
                  offset: const Offset(0, 4),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                    child: Text(
                      title,
                      style: AppText.sectionTitle(
                        context,
                      ).copyWith(fontSize: 16),
                    ),
                  ),
                Text(
                  message,
                  style: AppText.bodyMuted(context).copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                AppGap.v20,
                Row(
                  children: [
                    Expanded(
                      child: _ConfirmButton(
                        label: L.common.no,
                        onTap: () => Navigator.pop(ctx),
                      ),
                    ),
                    AppGap.h10,
                    Expanded(
                      child: _ConfirmButton(
                        label: L.common.yes,
                        primary: true,
                        onTap: () => Navigator.pop(ctx, true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Taller than [AppButton] with a 14px label; the confirm dialog's own look.
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bg = primary ? colors.carbon : Colors.transparent;
    // `carbon` is light in the dark theme, so a fixed white foreground would
    // be unreadable; pick it from the background luminance.
    final fg = !primary
        ? colors.carbon
        : bg.computeLuminance() > 0.5
        ? colors.porcelain
        : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: double.infinity,
        padding: AppInsets.h14,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.r8),
          border: Border.all(color: primary ? bg : colors.border),
        ),
        child: Center(
          child: Text(
            label,
            style: AppText.button(
              context,
              fg,
            ).copyWith(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
