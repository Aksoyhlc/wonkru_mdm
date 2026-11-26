import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

/// "Label → value" row for detail cards. The value is plain text ([value]) or a
/// widget such as a badge/meter ([child]); `—` when absent. On narrow screens
/// the label moves above the value so long values are not clipped.
class DetailField extends StatelessWidget {
  const DetailField({
    super.key,
    required this.label,
    this.value,
    this.child,
    this.mono = false,
    this.labelWidth = 150,
    this.divider = true,
  });

  final String label;
  final String? value;

  final Widget? child;

  final bool mono;

  final double labelWidth;

  final bool divider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = (value == null || value!.trim().isEmpty) ? '—' : value!;

    final valueWidget =
        child ??
        SelectableText(
          text,
          // Without `minLines` the field reserves two rows and single-line
          // values leave a gap.
          minLines: 1,
          maxLines: 2,
          style: mono
              ? AppText.mono(colors.carbon, size: 12.5)
              : AppText.body(context),
        );
    final labelWidget = Text(label, style: AppText.fieldLabel(context));

    return Container(
      padding: AppInsets.v6,
      decoration: divider ? colors.hairlineBottom() : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth - labelWidth - 12 < 160;
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget,
                AppGap.v2,
                valueWidget,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: labelWidth, child: labelWidget),
              AppGap.h12,
              Expanded(child: valueWidget),
            ],
          );
        },
      ),
    );
  }
}
