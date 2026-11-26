import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';
import '../Motion/enter_animation.dart';
import 'section_card.dart';

/// Lays [MetricTile]s in a titled card as equal-width, divider-separated cells.
///
/// When the width runs out ([minTileWidth] per tile) the strip splits into rows
/// with the same column count, the last row padded so columns stay aligned.
class MetricGroupCard extends StatelessWidget {
  const MetricGroupCard({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
    this.motionStartIndex,
    this.minTileWidth = 160,
  });

  final String title;

  final int? motionStartIndex;
  final List<Widget> children;
  final Widget? trailing;
  final double minTileWidth;

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: context.appColors.border);

    return SectionCard(
      title: title,
      trailing: trailing,
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = math.max(
            1,
            math.min(
              children.length,
              (constraints.maxWidth / minTileWidth).floor(),
            ),
          );
          final rows = (children.length / columns).ceil();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var row = 0; row < rows; row++)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var column = 0; column < columns; column++)
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                              left: column == 0 ? BorderSide.none : border,
                              top: row == 0 ? BorderSide.none : border,
                            ),
                          ),
                          child: row * columns + column < children.length
                              ? (motionStartIndex == null
                                    ? children[row * columns + column]
                                    : EnterAnimation(
                                        index:
                                            motionStartIndex! +
                                            row * columns +
                                            column,
                                        child: children[row * columns + column],
                                      ))
                              : const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
