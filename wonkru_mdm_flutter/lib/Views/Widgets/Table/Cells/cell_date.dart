import 'package:flutter/material.dart';

import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/Theme/design.dart';

class CellDate extends StatelessWidget {
  const CellDate(
    this.value, {
    super.key,
    this.relative = true,
    this.withTime = true,
  });

  final DateTime? value;
  final bool relative;
  final bool withTime;

  @override
  Widget build(BuildContext context) {
    final date = value;
    if (date == null) {
      return Text('—', style: AppText.cellPrimary(context));
    }

    final absolute = withTime ? date.formatDateTime() : date.formatDate();
    if (!relative) {
      return Text(
        absolute,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppText.cellPrimary(context),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date.relativeTr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.cellPrimary(context),
        ),
        Text(
          absolute,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.cellSecondary(context),
        ),
      ],
    );
  }
}
