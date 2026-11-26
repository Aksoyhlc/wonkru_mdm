import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../Core/Theme/design.dart';

class PulseDot extends StatelessWidget {
  const PulseDot({super.key, required this.color, this.size = AppSpacing.s8});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    final dot = DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (!AppMotion.reduced(context))
              Positioned.fill(
                child: dot
                    .animate(onPlay: (controller) => controller.repeat())
                    .fade(
                      begin: 0.35,
                      end: 0,
                      duration: AppMotion.pulse,
                      curve: AppMotion.enter,
                    )
                    .scaleXY(
                      begin: 1,
                      end: 2.5,
                      duration: AppMotion.pulse,
                      curve: AppMotion.enter,
                    ),
              ),
            Positioned.fill(child: dot),
          ],
        ),
      ),
    );
  }
}
