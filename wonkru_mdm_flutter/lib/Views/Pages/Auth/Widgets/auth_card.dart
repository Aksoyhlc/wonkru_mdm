import 'package:flutter/material.dart';

import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Motion/enter_animation.dart';

/// `BackdropFilter` is deliberately not used: it is expensive on CanvasKit and
/// blurs the text.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  static const double width = 420;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return EnterAnimation(
      offset: AppMotion.cardDistance,
      duration: AppMotion.slow,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s32,
          vertical: AppSpacing.s32,
        ),
        decoration: BoxDecoration(
          color: colors.workshop.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
