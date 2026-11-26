import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

class CheckboxRow extends StatelessWidget {
  const CheckboxRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onChanged,
    this.trailing,
    this.singleLine = true,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final Widget? trailing;

  final bool singleLine;

  @override
  Widget build(BuildContext context) {
    final maxLines = singleLine ? 1 : null;
    final overflow = singleLine ? TextOverflow.ellipsis : null;

    return InkWell(
      onTap: () => onChanged(!selected),
      child: Padding(
        padding: AppInsets.v2,
        child: Row(
          children: [
            Checkbox(
              value: selected,
              visualDensity: VisualDensity.compact,
              onChanged: (value) => onChanged(value ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: maxLines,
                    overflow: overflow,
                    style: AppText.body(context),
                  ),
                  Text(
                    subtitle,
                    maxLines: maxLines,
                    overflow: overflow,
                    style: AppText.caption(context, size: 11),
                  ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
