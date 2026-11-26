import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'trend_geometry.dart';

class TrendPainter extends CustomPainter {
  TrendPainter({
    required this.progress,
    required this.geometry,
    required this.values,
    required this.secondary,
    required this.ticks,
    required this.tickLabels,
    required this.xLabels,
    required this.hoverIndex,
    required this.line,
    required this.secondaryLine,
    required this.grid,
    required this.surface,
    required this.axisStyle,
  });

  final TrendGeometry geometry;
  final double progress;
  final List<int> values;
  final List<int>? secondary;
  final int ticks;
  final List<String> tickLabels;
  final List<String> xLabels;
  final int? hoverIndex;
  final Color line;
  final Color secondaryLine;
  final Color grid;
  final Color surface;
  final TextStyle axisStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = geometry.plot;
    _paintGrid(canvas, plot);
    _paintXLabels(canvas, plot);

    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(
        plot.left,
        plot.top,
        plot.left + plot.width * progress,
        plot.bottom,
      ),
    );
    _paintSeries(canvas, plot, values, line, fill: true);
    if (secondary != null) {
      _paintSeries(canvas, plot, secondary!, secondaryLine, dashed: true);
    }

    canvas.restore();

    final index = hoverIndex;
    if (index != null) {
      final x = geometry.xAt(index);
      canvas.drawLine(
        Offset(x, plot.top),
        Offset(x, plot.bottom),
        Paint()
          ..color = line.withValues(alpha: 0.35)
          ..strokeWidth = 1,
      );
      _paintDot(canvas, Offset(x, geometry.yAt(values[index])), line);
      if (secondary != null) {
        _paintDot(
          canvas,
          Offset(x, geometry.yAt(secondary![index])),
          secondaryLine,
        );
      }
    }
  }

  void _paintGrid(Canvas canvas, Rect plot) {
    final gridPaint = Paint()
      ..color = grid.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;

    for (var i = 0; i <= ticks; i++) {
      final y = plot.bottom - plot.height * i / ticks;
      if (i == 0) {
        canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), axisPaint);
      } else {
        _dashedLine(
          canvas,
          Offset(plot.left, y),
          Offset(plot.right, y),
          gridPaint,
        );
      }

      final label = _text(tickLabels[i]);
      label.paint(
        canvas,
        Offset(plot.left - label.width - 8, y - label.height / 2),
      );
    }
  }

  void _paintXLabels(Canvas canvas, Rect plot) {
    if (xLabels.isEmpty) return;

    final widest = xLabels.map((l) => _text(l).width).fold(0.0, math.max);
    final slots = math.max(1, (plot.width / (widest + 18)).floor());
    final every = math.max(1, (xLabels.length / slots).ceil());

    double? lastRight;
    for (var i = 0; i < xLabels.length; i++) {
      final isLast = i == xLabels.length - 1;
      if (i % every != 0 && !isLast) continue;

      final label = _text(xLabels[i]);
      final left = (geometry.xAt(i) - label.width / 2)
          .clamp(
            2.0,
            math.max(2.0, geometry.size.width - label.width),
          )
          .toDouble();
      if (lastRight != null && left < lastRight + 8) continue;

      label.paint(canvas, Offset(left, plot.bottom + 7));
      lastRight = left + label.width;

      canvas.drawLine(
        Offset(geometry.xAt(i), plot.bottom),
        Offset(geometry.xAt(i), plot.bottom + 3),
        Paint()
          ..color = grid
          ..strokeWidth = 1,
      );
    }
  }

  void _paintSeries(
    Canvas canvas,
    Rect plot,
    List<int> series,
    Color color, {
    bool fill = false,
    bool dashed = false,
  }) {
    final points = [
      for (var i = 0; i < series.length; i++)
        Offset(geometry.xAt(i), geometry.yAt(series[i])),
    ];

    if (points.length == 1) {
      _paintDot(canvas, points.first, color);
      return;
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    if (fill) {
      final areaPath = Path.from(linePath)
        ..lineTo(points.last.dx, plot.bottom)
        ..lineTo(points.first.dx, plot.bottom)
        ..close();
      canvas.drawPath(
        areaPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.28),
              color.withValues(alpha: 0.02),
            ],
          ).createShader(plot),
      );
    }

    final stroke = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    if (!dashed) {
      canvas.drawPath(linePath, stroke);
      return;
    }
    for (final metric in linePath.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), stroke);
        distance += 9;
      }
    }
  }

  void _paintDot(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 5, Paint()..color = surface);
    canvas.drawCircle(center, 3.5, Paint()..color = color);
  }

  void _dashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    var x = from.dx;
    while (x < to.dx) {
      canvas.drawLine(
        Offset(x, from.dy),
        Offset(math.min(x + 3, to.dx), from.dy),
        paint,
      );
      x += 7;
    }
  }

  TextPainter _text(String value) => TextPainter(
    text: TextSpan(text: value, style: axisStyle),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();

  @override
  bool shouldRepaint(covariant TrendPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.values != values ||
      oldDelegate.secondary != secondary ||
      oldDelegate.hoverIndex != hoverIndex ||
      oldDelegate.geometry.size != geometry.size ||
      oldDelegate.line != line;
}
