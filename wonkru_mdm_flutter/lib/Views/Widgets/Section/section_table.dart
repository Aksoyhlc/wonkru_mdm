import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';
import '../Layout/min_width_scroll.dart';
import 'section_column.dart';

class SectionTable<T> extends StatelessWidget {
  const SectionTable({
    super.key,
    required this.minWidth,
    required this.columns,
    required this.rows,
    this.actionsWidth = 0,
    this.actions,
  });

  final double minWidth;
  final List<SectionColumn<T>> columns;
  final List<T> rows;
  final double actionsWidth;
  final List<Widget> Function(T row, int index)? actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final headerStyle = AppText.columnHeader(context).copyWith(fontSize: 11.5);

    return MinWidthScroll(
      minWidth: minWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: Row(
              children: [
                for (final column in columns)
                  Expanded(
                    flex: column.flex,
                    child: Text(column.title, style: headerStyle),
                  ),
                if (actions != null) SizedBox(width: actionsWidth),
              ],
            ),
          ),
          Container(height: 1, color: colors.border),
          for (var i = 0; i < rows.length; i++)
            Container(
              padding: AppInsets.v6,
              decoration: colors.hairlineBottom(),
              child: Row(
                children: [
                  for (final column in columns)
                    Expanded(
                      flex: column.flex,
                      child: column.cell(context, rows[i]),
                    ),
                  if (actions != null)
                    SizedBox(
                      width: actionsWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: AppSpacing.s6,
                        children: actions!(rows[i], i),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
