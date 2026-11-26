// A custom field (`_items`) can't be written as a named initializing formal, so
// `prefer_initializing_formals` raises a false positive here.
// ignore_for_file: prefer_initializing_formals

import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Core/Theme/design.dart';
import 'table_column.dart';

class TableDataSource<T> extends DataGridSource {
  TableDataSource({
    required List<T> items,
    required this.columns,
    this.onPageChange,
  }) : _items = items;

  List<T> _items;
  List<AppColumn<T>> columns;
  final Future<void> Function(int pageIndex)? onPageChange;

  void update(List<T> next) {
    _items = next;
    notifyListeners();
  }

  void updateColumns(List<AppColumn<T>> next) {
    columns = next;
    notifyListeners();
  }

  /// Column names are bound to a fixed index, not the header text, so two
  /// columns with the same title don't collide. Each row has one cell per
  /// column; the first cell carries the row index, which [buildRow] reads.
  @override
  List<DataGridRow> get rows => [
    for (var i = 0; i < _items.length; i++)
      DataGridRow(
        cells: [
          for (var c = 0; c < columns.length; c++)
            DataGridCell<String>(
              columnName: 'col_$c',
              value: c == 0 ? '$i' : '',
            ),
        ],
      ),
  ];

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final index = int.parse(row.getCells().first.value as String);
    final item = _items[index];
    return DataGridRowAdapter(
      cells: [
        for (final column in columns)
          Container(
            alignment: column.align,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cellPaddingH,
            ),
            child: column.cell(item),
          ),
      ],
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    await onPageChange?.call(newPageIndex);
    return true;
  }
}
