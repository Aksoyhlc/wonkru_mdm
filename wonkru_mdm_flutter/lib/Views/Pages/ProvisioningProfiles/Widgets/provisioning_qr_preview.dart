import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Errors/server_error_message.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';

class ProvisioningQrPreview extends StatefulWidget {
  const ProvisioningQrPreview({super.key, required this.payload});

  final String? payload;

  @override
  State<ProvisioningQrPreview> createState() => _ProvisioningQrPreviewState();
}

class _ProvisioningQrPreviewState extends State<ProvisioningQrPreview> {
  bool _downloading = false;

  bool get _hasPayload => widget.payload != null;

  Future<void> _download() async {
    final payload = widget.payload;
    if (payload == null || _downloading) return;
    setState(() => _downloading = true);
    try {
      final bytes = await _renderPng(payload, 600);
      await FileSaver.instance.saveFile(
        name: 'provisioning-qr',
        bytes: bytes,
        fileExtension: 'png',
        mimeType: MimeType.png,
      );
      AppToast.show(
        L.provisioning.qrDownloaded,
        tone: UiAlertTone.success,
      );
    } catch (e) {
      AppToast.show(
        L.provisioning.qrDownloadFailed.trParams({
          'error': serverErrorMessage(e),
        }),
        tone: UiAlertTone.danger,
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _openFullscreen() {
    final payload = widget.payload;
    if (payload == null) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => _QrFullscreenDialog(payload: payload),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              L.provisioning.qrTitle,
              style: AppText.columnHeader(context),
            ),
            AppGap.h6,
            Text(
              L.provisioning.qrLive,
              style: AppText.caption(context, size: 11).copyWith(
                color: context.appColors.graphite.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        AppGap.v10,
        Container(
          padding: AppInsets.all16,
          decoration: context.appColors.outlined(
            fill: context.appColors.muted,
            radius: AppRadius.r10,
          ),
          child: _hasPayload ? _preview(context) : _placeholder(context),
        ),
      ],
    );
  }

  Widget _preview(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: AppInsets.all10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: QrImageView(
            data: widget.payload!,
            version: QrVersions.auto,
            size: 220,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
          ),
        ),
        AppGap.v14,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            AppButton(
              label: L.provisioning.fullscreen,
              compact: true,
              variant: AppButtonVariant.secondary,
              icon: LucideIcons.maximize,
              onPressed: _openFullscreen,
            ),
            AppButton(
              label: L.common.download,
              compact: true,
              icon: LucideIcons.download,
              loading: _downloading,
              onPressed: _download,
            ),
          ],
        ),
      ],
    );
  }

  Widget _placeholder(BuildContext context) {
    return SizedBox(
      height: 192,
      child: Center(
        child: Text(
          L.provisioning.qrPlaceholder,
          textAlign: TextAlign.center,
          style: AppText.bodyMuted(context),
        ),
      ),
    );
  }
}

class _QrFullscreenDialog extends StatelessWidget {
  const _QrFullscreenDialog({required this.payload});

  final String payload;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: AppInsets.all24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: AppInsets.all24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            child: QrImageView(
              data: payload,
              version: QrVersions.auto,
              size: 420,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            right: -12,
            top: -12,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 3,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(LucideIcons.x, size: 18, color: Colors.black87),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Uint8List> _renderPng(String data, double size) async {
  final painter = QrPainter(
    data: data,
    version: QrVersions.auto,
    gapless: false,
    eyeStyle: const QrEyeStyle(
      eyeShape: QrEyeShape.square,
      color: Colors.black,
    ),
    dataModuleStyle: const QrDataModuleStyle(
      dataModuleShape: QrDataModuleShape.square,
      color: Colors.black,
    ),
  );

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size, size),
    Paint()..color = Colors.white,
  );
  painter.paint(canvas, Size(size, size));

  final image = await recorder.endRecording().toImage(
    size.toInt(),
    size.toInt(),
  );
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  if (byteData == null) {
    throw StateError(L.provisioning.pngFailed);
  }
  return byteData.buffer.asUint8List();
}
