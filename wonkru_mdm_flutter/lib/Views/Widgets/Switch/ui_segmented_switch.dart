import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

class UiSegmentedSwitch<T> extends StatelessWidget {
  const UiSegmentedSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  /// Selected value; if it is not among [items], no segment appears selected.
  final T value;

  /// Value → segment label (display order is map order).
  final Map<T, String> items;

  final ValueChanged<T>? onChanged;

  static const double _stackBelowWidth = 420;

  @override
  Widget build(BuildContext context) {
    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppText.label(context)),
        if (subtitle != null) ...[
          AppGap.v2,
          Text(subtitle!, style: AppText.caption(context, size: 12)),
        ],
      ],
    );

    return Padding(
      padding: AppInsets.v8,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segments = _segments(context);
          if (constraints.maxWidth < _stackBelowWidth) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                label,
                AppGap.v8,
                segments,
              ],
            );
          }
          return Row(
            crossAxisAlignment: subtitle == null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Expanded(child: label),
              AppGap.h16,
              segments,
            ],
          );
        },
      ),
    );
  }

  Widget _segments(BuildContext context) {
    final colors = context.appColors;
    final entries = items.entries.toList();
    return Container(
      decoration: colors.outlined(fill: colors.muted, radius: AppRadius.r6),
      padding: AppInsets.all2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in entries)
            _Segment(
              label: entry.value,
              selected: entry.key == value,
              onTap: onChanged == null ? null : () => onChanged!(entry.key),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final enabled = onTap != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s10,
            vertical: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.workshop : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r4),
            border: Border.all(
              color: selected ? colors.border : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: AppText.label(context).copyWith(
              fontSize: 12,
              color: selected ? colors.loomBlue : colors.graphite,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
