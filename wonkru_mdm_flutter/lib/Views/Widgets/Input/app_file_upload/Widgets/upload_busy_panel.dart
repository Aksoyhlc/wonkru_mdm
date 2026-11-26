import 'package:flutter/material.dart';

import '../../../../../Core/L10n/L.dart';
import '../../../../../Core/Theme/design.dart';
import 'upload_box.dart';

class UploadBusyPanel extends StatelessWidget {
  const UploadBusyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s24,
      ),
      decoration: uploadBoxDecoration(context, context.appColors.border, false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          AppGap.h10,
          Text(L.common.loading, style: AppText.body(context)),
        ],
      ),
    );
  }
}
