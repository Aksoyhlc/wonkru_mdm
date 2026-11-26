import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';
import '../Motion/app_skeleton.dart';

class TableSkeleton extends StatelessWidget {
  const TableSkeleton({
    super.key,
    required this.widths,
    required this.rowHeight,
    required this.checkboxWidth,
  });

  final List<double> widths;
  final double rowHeight;
  final double checkboxWidth;

  static const _rows = 8;
  static const _barHeight = 12.0;

  @override
  Widget build(BuildContext context) => ClipRect(
    child: SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.headerHeight),
            for (var row = 0; row < _rows; row++)
              SizedBox(
                height: rowHeight,
                child: Row(
                  children: [
                    if (checkboxWidth > 0) SizedBox(width: checkboxWidth),
                    for (final width in widths)
                      SizedBox(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.cellPaddingH,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppSkeleton(
                              width: width * 0.6,
                              height: _barHeight,
                              radius: AppSpacing.s4,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
