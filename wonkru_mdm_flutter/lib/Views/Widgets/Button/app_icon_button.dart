import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconBuilder,
  });

  factory AppIconButton.back(BuildContext context) => AppIconButton(
    icon: LucideIcons.arrowLeft,
    tooltip: L.common.back,
    onPressed: () => context.back(),
  );

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  /// Wraps the icon so the button's hit area stays fixed while the icon moves.
  final Widget Function(Widget icon)? iconBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final enabled = onPressed != null;
    final iconWidget = Icon(
      icon,
      size: 15,
      color: enabled ? colors.carbon : colors.graphite,
    );
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r6),
        onTap: enabled ? onPressed : null,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: colors.outlined(radius: AppRadius.r6),
          child: iconBuilder?.call(iconWidget) ?? iconWidget,
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
