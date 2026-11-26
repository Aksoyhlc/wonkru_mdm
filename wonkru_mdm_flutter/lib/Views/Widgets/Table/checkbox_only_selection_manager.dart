import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// A selection manager that only selects rows from the checkbox column.
///
/// `SfDataGrid` also selects a row when any of its cells is tapped. Tapping a
/// row opens the record (`onRowTap`), so the selection would otherwise linger
/// when the user returns. Taps outside the checkbox column (visible column
/// index 0) are ignored here; cell taps still flow through `onCellTap`.
class CheckboxOnlySelectionManager extends RowSelectionManager {
  static const _checkboxColumnIndex = 0;

  @override
  void handleTap(RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.columnIndex != _checkboxColumnIndex) return;
    super.handleTap(rowColumnIndex);
  }
}
