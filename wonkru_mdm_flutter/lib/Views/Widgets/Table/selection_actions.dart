import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Theme/design.dart';

class SelectionActions extends StatelessWidget {
  const SelectionActions({
    super.key,
    required this.selected,
    required this.countLabel,
    required this.actions,
    this.countStyle,
  });

  final RxSet<int> selected;
  final String Function(int count) countLabel;

  final List<Widget> Function(int count) actions;

  final TextStyle? countStyle;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = selected.length;
      if (count == 0) return const SizedBox.shrink();
      final buttons = actions(count);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            countLabel(count),
            style: countStyle ?? AppText.caption(context, size: 12),
          ),
          AppGap.h10,
          for (var i = 0; i < buttons.length; i++) ...[
            if (i > 0) AppGap.h8,
            buttons[i],
          ],
        ],
      );
    });
  }
}
