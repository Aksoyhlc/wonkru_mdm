import 'package:flutter/widgets.dart';

import '../../../Core/Constants/Enums/table_enums.dart';
import 'Cells/cell_action.dart';
import 'Cells/cell_actions.dart';

class AppColumn<T> {
  const AppColumn({
    required this.title,
    required this.cell,
    this.width = 160,
    this.minWidth = 60,
    this.align = Alignment.centerLeft,
    this.sortKey,
    this.tooltip,
    this.visible = true,
    this.freeze = AppColumnFreeze.none,
    this.hideable = true,
    this.expand = false,
  });

  factory AppColumn.actions(
    List<CellAction> Function(T row) actions, {
    double width = 60,
  }) => AppColumn<T>(
    title: '',
    width: width,
    align: Alignment.center,
    freeze: AppColumnFreeze.end,
    hideable: false,
    cell: (row) => CellActions(actions: actions(row)),
  );

  final String title;
  final Widget Function(T row) cell;
  final double width;

  final double minWidth;

  final Alignment align;

  /// Server sort key; a column is sortable exactly when it has one.
  final String? sortKey;

  bool get sortable => sortKey != null;

  final String? tooltip;

  final bool visible;

  final AppColumnFreeze freeze;

  final bool hideable;

  final bool expand;

  AppColumn<T> copyWith({bool? visible}) => AppColumn<T>(
    title: title,
    cell: cell,
    width: width,
    minWidth: minWidth,
    align: align,
    sortKey: sortKey,
    tooltip: tooltip,
    visible: visible ?? this.visible,
    freeze: freeze,
    hideable: hideable,
    expand: expand,
  );
}
