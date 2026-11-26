import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../Alert/app_toast.dart';

class CellCopy extends StatelessWidget {
  const CellCopy(
    this.value, {
    super.key,
    this.maxChars = 24,
    this.copiedMessage,
    this.onOpen,
  });

  final String? value;

  final int maxChars;

  final String? copiedMessage;

  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = value;
    if (text == null || text.trim().isEmpty) {
      return Text('—', style: AppText.cellSecondary(context));
    }

    final short = text.length <= maxChars
        ? text
        : '${text.substring(0, maxChars)}…';

    return Row(
      children: [
        Expanded(
          child: Tooltip(
            message: text,
            child: Text(
              short,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.mono(colors.carbon),
            ),
          ),
        ),
        _iconButton(
          context,
          icon: LucideIcons.copy,
          tooltip: L.common.copy,
          onTap: () => _copy(text),
        ),
        if (onOpen != null)
          _iconButton(
            context,
            icon: LucideIcons.externalLink,
            tooltip: L.common.openLink,
            onTap: onOpen!,
          ),
      ],
    );
  }

  Widget _iconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r4),
        child: Padding(
          padding: AppInsets.all4,
          child: Icon(icon, size: 13, color: context.appColors.graphite),
        ),
      ),
    );
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    AppToast.show(copiedMessage ?? L.common.copied, tone: UiAlertTone.info);
  }
}
