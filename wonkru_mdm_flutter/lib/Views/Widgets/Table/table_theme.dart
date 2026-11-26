import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../Core/Theme/design.dart';

class AppTableTheme {
  const AppTableTheme._();

  static SfDataGridThemeData of(BuildContext context) {
    final colors = context.appColors;
    return SfDataGridThemeData(
      headerColor: colors.surfaceSubtle,
      headerHoverColor: colors.hover,
      gridLineColor: colors.border,
      gridLineStrokeWidth: 1,
      rowHoverColor: colors.hover,
      selectionColor: colors.selected,
      sortIconColor: colors.loomBlue,
      currentCellStyle: DataGridCurrentCellStyle(
        borderColor: Colors.transparent,
        borderWidth: 0,
      ),
      frozenPaneLineColor: colors.border,
      frozenPaneLineWidth: 1,
      frozenPaneElevation: 0,
      columnResizeIndicatorColor: colors.loomBlue,
      columnResizeIndicatorStrokeWidth: 2,
    );
  }
}
