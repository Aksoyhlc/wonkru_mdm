import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../../Core/L10n/L.dart';
import '../../../../../Core/Theme/design.dart';
import '../../../../../Core/Utils/file_metadata.dart';
import '../../../Badge/status_badge.dart';
import '../../../Button/app_button.dart';
import '../../uploaded_file.dart';
import 'upload_box.dart';

class UploadedFilePanel extends StatelessWidget {
  const UploadedFilePanel({
    super.key,
    required this.file,
    required this.enabled,
    required this.onRemove,
    required this.onReplace,
  });

  final UploadedFile file;
  final bool enabled;
  final VoidCallback onRemove;
  final VoidCallback onReplace;

  bool get _isImage => file.contentType?.startsWith('image/') ?? false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: AppInsets.all12,
      decoration: uploadBoxDecoration(context, colors.success, false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (_isImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.r6),
                  child: Image.memory(
                    file.bytes,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _fileIcon(context, colors),
                  ),
                )
              else
                _fileIcon(context, colors),
              AppGap.h12,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.cellPrimary(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    AppGap.v4,
                    Row(
                      children: [
                        StatusBadge(
                          label: formatBytes(file.sizeBytes),
                          tone: UiAlertTone.success,
                        ),
                        if (file.contentType != null) ...[
                          AppGap.h6,
                          Flexible(
                            child: Text(
                              file.contentType!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.caption(context, size: 11),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppGap.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: L.common.remove,
                icon: LucideIcons.trash2,
                variant: AppButtonVariant.ghost,
                compact: true,
                onPressed: enabled ? onRemove : null,
              ),
              AppGap.h8,
              AppButton(
                label: L.common.replace,
                icon: LucideIcons.refreshCw,
                variant: AppButtonVariant.secondary,
                compact: true,
                onPressed: enabled ? onReplace : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fileIcon(BuildContext context, AppColors colors) => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: colors.muted,
      borderRadius: BorderRadius.circular(AppRadius.r6),
    ),
    child: Icon(LucideIcons.file, size: 22, color: colors.graphite),
  );
}
