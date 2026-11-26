import 'package:flutter/material.dart';

import '../../../../Core/Theme/design.dart';

class CellPrimary extends StatelessWidget {
  const CellPrimary({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
  });

  final String title;
  final String? subtitle;

  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    final texts = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.trim().isEmpty ? '—' : title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.cellPrimary(context),
        ),
        if (hasSubtitle)
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.cellSecondary(context),
          ),
      ],
    );

    if (leading == null) return texts;
    return Row(
      children: [
        leading!,
        AppGap.h8,
        Expanded(child: texts),
      ],
    );
  }
}
