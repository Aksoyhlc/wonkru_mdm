import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

class UiSwitch extends StatelessWidget {
  const UiSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.fontSize,
    this.dense = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String title;
  final String? subtitle;
  final double? fontSize;

  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final enabled = onChanged != null;

    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppText.label(
            context,
          ).copyWith(fontSize: dense ? 12 : fontSize),
        ),
        if (subtitle != null) ...[
          AppGap.v2,
          Text(
            subtitle!,
            style: AppText.caption(context, size: dense ? 11 : 12),
          ),
        ],
      ],
    );

    final toggle = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: dense ? 34 : 40,
      height: dense ? 19 : 22,
      padding: AppInsets.all2,
      decoration: BoxDecoration(
        color: value ? colors.loomBlue : colors.muted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: value ? colors.loomBlue : colors.border),
      ),
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: dense ? 13 : 16,
        height: dense ? 13 : 16,
        decoration: BoxDecoration(
          color: colors.workshop,
          shape: BoxShape.circle,
          border: Border.all(color: colors.border),
        ),
      ),
    );

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(!value) : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: dense ? AppSpacing.s2 : AppSpacing.s8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: subtitle == null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (dense) ...[
                toggle,
                AppGap.h8,
                Flexible(child: label),
              ] else ...[
                Flexible(child: label),
                AppGap.h12,
                toggle,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
