import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

/// Spreads equal-width boxes across the available space.
///
/// `Wrap` with fixed-width boxes either overflowed on narrow screens or left a
/// gap at the end of each row on wide ones. Here the column count is derived
/// from [minTileWidth] and the boxes share the remaining width equally, down to
/// a single column on narrow screens.
class AppTileGrid extends StatelessWidget {
  const AppTileGrid({
    super.key,
    required this.children,
    required this.minTileWidth,
    this.spacing = AppSpacing.s16,
    this.runSpacing = AppSpacing.s16,
  });

  final List<Widget> children;

  final double minTileWidth;

  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        final columns = math.max(
          1,
          math.min(
            children.length,
            ((available + spacing) / (minTileWidth + spacing)).floor(),
          ),
        );
        final tileWidth = (available - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final child in children)
              SizedBox(width: tileWidth, child: child),
          ],
        );
      },
    );
  }
}
