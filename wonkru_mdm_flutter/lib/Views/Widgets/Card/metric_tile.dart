import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Theme/design.dart';
import '../Motion/count_up_text.dart';

/// A single counter inside [MetricGroupCard]: icon + label, large value,
/// optional caption and ratio bar.
///
/// The caption and ratio rows keep their space when empty so tiles in the same
/// row stay equal height. With [onTap] the tile becomes clickable.
class MetricTile extends StatefulWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.tone = UiAlertTone.info,
    this.caption,
    this.ratio,
    this.onTap,
    this.numericValue,
    this.format,
  });

  final String label;
  final String value;
  final int? numericValue;
  final String Function(int?)? format;
  final IconData icon;
  final UiAlertTone tone;
  final String? caption;

  /// Fraction (0–1); when set, a thin bar is drawn under the value.
  final double? ratio;

  final VoidCallback? onTap;

  @override
  State<MetricTile> createState() => _MetricTileState();
}

class _MetricTileState extends State<MetricTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = colors.toneAccent(widget.tone);
    final interactive = widget.onTap != null;
    final ratio = widget.ratio;

    final content = AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.fast),
      curve: AppMotion.enter,
      transform: Matrix4.translationValues(
        0,
        interactive && _hover ? -AppMotion.hoverLift : 0,
        0,
      ),
      decoration: BoxDecoration(
        color: interactive && _hover ? colors.hover : Colors.transparent,
        border: Border.all(
          color: interactive && _hover ? colors.loomBlue : Colors.transparent,
        ),
        boxShadow: interactive && _hover
            ? [
                BoxShadow(
                  color: colors.carbon.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, AppSpacing.s4),
                ),
              ]
            : const [],
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.r6),
                ),
                child: Icon(widget.icon, size: 15, color: accent),
              ),
              AppGap.h10,
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label(
                    context,
                  ).copyWith(color: colors.graphite),
                ),
              ),
              if (interactive)
                AnimatedOpacity(
                  duration: AppMotion.of(context, AppMotion.fast),
                  opacity: _hover ? 1 : 0.35,
                  child: Icon(
                    LucideIcons.arrowUpRight,
                    size: 14,
                    color: colors.graphite,
                  ),
                ),
            ],
          ),
          AppGap.v14,
          (widget.numericValue != null || widget.format != null)
              ? CountUpText(
                  value: widget.numericValue,
                  format:
                      widget.format ??
                      (value) => value?.toString() ?? widget.value,
                  style: AppText.pageTitle(context).copyWith(
                    fontSize: 26,
                    height: 1.1,
                    letterSpacing: -0.5,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                )
              : Text(
                  widget.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.pageTitle(context).copyWith(
                    fontSize: 26,
                    height: 1.1,
                    letterSpacing: -0.5,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
          AppGap.v4,
          Text(
            widget.caption ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.caption(context),
          ),
          AppGap.v12,
          SizedBox(
            height: 4,
            child: ratio == null
                ? null
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r2),
                    child: Container(
                      color: colors.muted,
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: ratio.clamp(0.0, 1.0),
                        child: Container(color: accent),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );

    if (!interactive) return content;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(onTap: widget.onTap, child: content),
    );
  }
}
