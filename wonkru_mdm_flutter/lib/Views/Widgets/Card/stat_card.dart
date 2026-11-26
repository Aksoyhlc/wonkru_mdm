import 'package:flutter/material.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Theme/design.dart';
import '../Motion/count_up_text.dart';

class StatCard extends StatefulWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.tone = UiAlertTone.info,
    this.caption,
    this.onTap,
    this.numericValue,
    this.format,
  });

  final String label;
  final String value;
  final int? numericValue;
  final String Function(int?)? format;
  final IconData? icon;
  final UiAlertTone tone;
  final String? caption;

  final VoidCallback? onTap;

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = _toneColor(context, widget.tone);
    final interactive = widget.onTap != null;

    final card = AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.fast),
      curve: AppMotion.enter,
      transform: Matrix4.translationValues(
        0,
        interactive && _hover ? -AppMotion.hoverLift : 0,
        0,
      ),
      padding: AppInsets.all16,
      decoration: BoxDecoration(
        boxShadow: interactive && _hover
            ? [
                BoxShadow(
                  color: colors.carbon.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, AppSpacing.s4),
                ),
              ]
            : const [],
        color: colors.workshop,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(
          color: interactive && _hover ? colors.loomBlue : colors.border,
        ),
      ),
      child: Row(
        children: [
          if (widget.icon != null)
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: Icon(widget.icon, size: 20, color: accent),
            ),
          if (widget.icon != null) AppGap.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption(context, size: 12),
                ),
                AppGap.v4,
                (widget.numericValue != null || widget.format != null)
                    ? CountUpText(
                        value: widget.numericValue,
                        format:
                            widget.format ??
                            (value) => value?.toString() ?? widget.value,
                        style: AppText.pageTitle(
                          context,
                        ).copyWith(fontSize: 22),
                      )
                    : Text(
                        widget.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.pageTitle(
                          context,
                        ).copyWith(fontSize: 22),
                      ),
                if (widget.caption != null)
                  Text(
                    widget.caption!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption(context, size: 11),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!interactive) return card;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          onTap: widget.onTap,
          child: card,
        ),
      ),
    );
  }

  Color _toneColor(BuildContext context, UiAlertTone tone) {
    final colors = context.appColors;
    return switch (tone) {
      UiAlertTone.success => colors.success,
      UiAlertTone.warning => colors.warning,
      UiAlertTone.danger => colors.madder,
      UiAlertTone.info => colors.loomBlue,
    };
  }
}
