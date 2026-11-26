import 'package:flutter/widgets.dart';

import 'app_colors.dart';
import 'app_radius.dart';

extension AppDecorationsX on AppColors {
  BoxDecoration outlined({Color? fill, double radius = AppRadius.r8}) =>
      BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border),
      );

  BoxDecoration hairlineBottom({Color? fill}) => BoxDecoration(
    color: fill,
    border: Border(bottom: BorderSide(color: border)),
  );
}
