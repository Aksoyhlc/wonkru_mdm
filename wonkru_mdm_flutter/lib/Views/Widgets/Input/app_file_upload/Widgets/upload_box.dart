import 'package:flutter/material.dart';

import '../../../../../Core/Theme/design.dart';

/// Shared upload-area decoration; [highlighted] is used while a drag hovers.
BoxDecoration uploadBoxDecoration(
  BuildContext context,
  Color border,
  bool highlighted,
) => BoxDecoration(
  color: highlighted ? context.appColors.muted : context.appColors.workshop,
  borderRadius: BorderRadius.circular(AppRadius.r8),
  border: Border.all(color: border, width: highlighted ? 1.5 : 1),
);
