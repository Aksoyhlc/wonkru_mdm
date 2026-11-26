import 'package:flutter/material.dart';

import '../Theme/design.dart';

extension ContextExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  TextTheme get textStyles => Theme.of(this).textTheme;
  Color get errorColor => Theme.of(this).colorScheme.error;

  void back() => Navigator.pop(this);
}
