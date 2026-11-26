import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../Core/Theme/design.dart';

class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    required this.height,
    this.radius = AppRadius.r8,
  });
  final double? width;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.border,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    if (AppMotion.reduced(context)) return box;
    return RepaintBoundary(
      child: box
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: AppMotion.shimmer,
            color: colors.hover,
            curve: AppMotion.enter,
          ),
    );
  }
}
