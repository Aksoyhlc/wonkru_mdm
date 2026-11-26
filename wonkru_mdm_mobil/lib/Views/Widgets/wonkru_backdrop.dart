import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_colors.dart';

class WonkruBackdrop extends StatelessWidget {
  const WonkruBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.05),
          radius: 1.15,
          colors: [WonkruColors.surface, WonkruColors.bg],
        ),
      ),
      child: CustomPaint(painter: _WonkruBackdropPainter()),
    );
  }
}

class _WonkruBackdropPainter extends CustomPainter {
  const _WonkruBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final w = size.width;
    final h = size.height;

    final upperCurve = Path()
      ..moveTo(0, h * 0.33)
      ..cubicTo(w * 0.34, h * 0.35, w * 0.76, h * 0.27, w, h * 0.13);
    final upperFill = Path.from(upperCurve)
      ..lineTo(w, 0)
      ..lineTo(0, 0)
      ..close();

    final lowerCurve = Path()
      ..moveTo(w * 0.09, h)
      ..cubicTo(w * 0.29, h * 0.78, w * 0.67, h * 0.61, w, h * 0.56);
    final lowerFill = Path.from(lowerCurve)
      ..lineTo(w, h)
      ..close();

    canvas.drawPath(
      upperFill,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0.58, -0.46),
          radius: 0.64,
          colors: [Color(0xFF2B3038), Color(0x00151A24)],
        ).createShader(bounds),
    );
    canvas.drawPath(
      lowerFill,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0.27, 0.25),
          radius: 0.60,
          colors: [Color(0xFF30343B), Color(0x00151A24)],
        ).createShader(bounds),
    );

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          WonkruColors.accent.withValues(alpha: 0.42),
          Colors.transparent,
        ],
        stops: const [0.14, 0.64, 1],
      ).createShader(bounds);
    canvas.drawPath(upperCurve, edgePaint);
    canvas.drawPath(lowerCurve, edgePaint);
  }

  @override
  bool shouldRepaint(_WonkruBackdropPainter oldDelegate) => false;
}
