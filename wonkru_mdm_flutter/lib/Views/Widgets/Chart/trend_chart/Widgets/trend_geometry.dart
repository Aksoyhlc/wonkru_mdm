import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Shared by the painter and hover tracking so both agree on positions.
class TrendGeometry {
  TrendGeometry({
    required this.size,
    required this.leftInset,
    required this.count,
    required this.max,
  });

  final Size size;
  final double leftInset;
  final int count;
  final int max;

  static const topInset = 8.0;
  static const bottomInset = 24.0;
  static const rightInset = 6.0;

  Rect get plot => Rect.fromLTRB(
    leftInset,
    topInset,
    math.max(leftInset + 1, size.width - rightInset),
    math.max(topInset + 1, size.height - bottomInset),
  );

  double get stepX => count <= 1 ? 0 : plot.width / (count - 1);

  double xAt(int index) =>
      count <= 1 ? plot.center.dx : plot.left + index * stepX;

  double yAt(int value) =>
      plot.bottom - (max == 0 ? 0 : value / max) * plot.height;

  int? indexAt(double dx) {
    if (count == 0) return null;
    if (count == 1) return 0;
    return ((dx - plot.left) / stepX).round().clamp(0, count - 1);
  }
}
