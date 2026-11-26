import 'package:flutter/material.dart';

import '../../../Core/Constants/app_sections.dart';
import '../../../Core/Theme/design.dart';
import '../../Widgets/Badge/status_badge.dart';

/// Off the spacing scale on purpose: tuned to the icon's optical width.
const _iconGap = SizedBox(width: 11);

class SidebarItem extends StatefulWidget {
  const SidebarItem({
    super.key,
    required this.section,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final AppSection section;
  final bool selected;
  final VoidCallback onTap;

  final int? badge;

  static const double height = 38;
  static const double gap = 2;

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final duration = AppMotion.of(context, AppMotion.fast);
    return SizedBox(
      height: SidebarItem.height,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: duration,
          curve: AppMotion.enter,
          decoration: BoxDecoration(
            color: _hover ? colors.hover : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r6),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.r6),
              hoverColor: Colors.transparent,
              onTap: widget.onTap,
              child: Padding(
                padding: AppInsets.h10,
                child: Row(
                  children: [
                    TweenAnimationBuilder<Color?>(
                      tween: ColorTween(
                        end: widget.selected ? colors.loomBlue : colors.graphite,
                      ),
                      duration: duration,
                      curve: AppMotion.enter,
                      builder: (context, color, _) => Icon(widget.section.icon, size: 17, color: color),
                    ),
                    _iconGap,
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: duration,
                        curve: AppMotion.enter,
                        style: AppText.label(context).copyWith(
                          fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
                          color: widget.selected ? colors.carbon : colors.graphite,
                        ),
                        child: Text(
                          widget.section.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (widget.badge != null) ...[
                      AppGap.h8,
                      StatusBadge(label: '${widget.badge}'),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
