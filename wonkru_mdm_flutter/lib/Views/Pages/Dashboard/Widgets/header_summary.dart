import 'package:flutter/material.dart';

import '../../../../Core/Theme/design.dart';

/// Label + value summary drawn at the same height as a dropdown so header rows
/// across cards align.
class HeaderSummary extends StatelessWidget {
  const HeaderSummary({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.s8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppText.caption(context, size: 12)),
            AppGap.h6,
            Text(value, style: AppText.cellPrimary(context)),
          ],
        ),
      ),
    );
  }
}
