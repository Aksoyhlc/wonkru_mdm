import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Logging/wlog.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';

/// Repeats `ExportButton`'s pattern because that widget is CSV-specific.
class DevicePdfReportButton extends StatelessWidget {
  const DevicePdfReportButton({
    super.key,
    required this.onExport,
    required this.fileName,
  });

  final Future<ByteData> Function() onExport;

  /// File name without extension; `.pdf` is appended by [FileSaver].
  final String fileName;

  Future<void> _export() async {
    try {
      final data = await onExport();
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );
      AppToast.show(L.devices.pdfDownloaded, tone: UiAlertTone.success);
    } catch (e) {
      WLog.e('DevicePdfReport', 'PDF export failed', error: e);
      AppToast.show(L.devices.pdfDownloadFailed, tone: UiAlertTone.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: L.devices.downloadPdf,
      compact: true,
      variant: AppButtonVariant.secondary,
      icon: LucideIcons.fileText,
      onAsync: _export,
    );
  }
}
