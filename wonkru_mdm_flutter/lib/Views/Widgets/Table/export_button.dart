import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/L10n/L.dart';
import '../Action/run_action.dart';
import '../Button/app_button.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({
    super.key,
    required this.fileName,
    required this.onExport,
    this.label,
    this.variant = AppButtonVariant.secondary,
  });

  final String fileName;
  final Future<ByteData> Function() onExport;
  final String? label;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label ?? L.common.export,
      compact: true,
      variant: variant,
      icon: LucideIcons.download,
      onAsync: () => runAction(
        () async {
          final data = await onExport();
          await FileSaver.instance.saveFile(
            name: fileName,
            bytes: data.buffer.asUint8List(
              data.offsetInBytes,
              data.lengthInBytes,
            ),
            fileExtension: 'csv',
            mimeType: MimeType.csv,
          );
        },
        success: L.common.csvDownloaded,
        failure: L.common.exportFailed,
      ),
    );
  }
}
