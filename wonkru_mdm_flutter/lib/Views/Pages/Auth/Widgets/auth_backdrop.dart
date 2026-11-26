import 'package:flutter/material.dart';

import '../../../../Core/Theme/design.dart';

class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: colors.porcelain),
        if (isDark) ...[
          _Glow(
            color: colors.loomBlue,
            alignment: const Alignment(-0.25, -0.75),
            diameter: 620,
            opacity: 0.07,
          ),
          _Glow(
            color: colors.info,
            alignment: const Alignment(0.55, 0.85),
            diameter: 520,
            opacity: 0.05,
          ),
        ],
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.color,
    required this.alignment,
    required this.diameter,
    required this.opacity,
  });

  final Color color;
  final Alignment alignment;
  final double diameter;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
