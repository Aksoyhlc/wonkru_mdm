import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Utils/copy_text.dart'
    if (dart.library.js_interop) '../../../../Core/Utils/copy_text_web.dart';
import '../../../../Logic/Controllers/settings_controller.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Card/section_card.dart';
import 'enrollment_key_qr_dialog.dart';
import 'enrollment_key_rotate_dialog.dart';

/// The key is not part of the settings form: Save does not persist it, only
/// Rotate changes it.
class EnrollmentKeySection extends StatefulWidget {
  const EnrollmentKeySection({super.key, required this.controller});

  final SettingsController controller;

  @override
  State<EnrollmentKeySection> createState() => _EnrollmentKeySectionState();
}

class _EnrollmentKeySectionState extends State<EnrollmentKeySection> {
  /// Fixed dot count so the key's real length is not leaked.
  static const _maskLength = 24;

  bool _revealed = false;

  SettingsController get _controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SectionCard(
      title: L.settings.sectionEnrollment,
      child: Obx(() {
        final key = _controller.enrollmentKey.value;
        final error = _controller.enrollmentKeyError.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              L.settings.enrollmentKeyHint,
              style: AppText.bodyMuted(context),
            ),
            AppGap.v16,
            if (key == null)
              Text(
                error == null ? '…' : L.settings.enrollmentKeyLoadFailed,
                style: AppText.body(
                  context,
                ).copyWith(color: error == null ? null : colors.madder),
              )
            else
              Wrap(
                spacing: AppSpacing.s8,
                runSpacing: AppSpacing.s8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SelectableText(
                    _revealed ? key : '•' * _maskLength,
                    style: AppText.mono(colors.carbon, size: 13),
                  ),
                  AppButton(
                    label: _revealed
                        ? L.settings.enrollmentKeyHide
                        : L.settings.enrollmentKeyShow,
                    icon: _revealed ? LucideIcons.eyeOff : LucideIcons.eye,
                    variant: AppButtonVariant.ghost,
                    compact: true,
                    onPressed: () => setState(() => _revealed = !_revealed),
                  ),
                  AppButton(
                    label: L.common.copy,
                    icon: LucideIcons.copy,
                    variant: AppButtonVariant.secondary,
                    compact: true,
                    onPressed: () => _copy(key),
                  ),
                  AppButton(
                    label: L.settings.enrollmentKeyQr,
                    icon: LucideIcons.qrCode,
                    variant: AppButtonVariant.secondary,
                    compact: true,
                    onPressed: _showQr,
                  ),
                  AppButton(
                    label: L.settings.enrollmentKeyRotate,
                    icon: LucideIcons.refreshCw,
                    variant: AppButtonVariant.danger,
                    compact: true,
                    loading: _controller.rotatingEnrollmentKey.value,
                    onPressed: _rotate,
                  ),
                ],
              ),
          ],
        );
      }),
    );
  }

  Future<void> _copy(String key) async {
    final copied = await tryCopyText(key);
    if (!mounted) return;
    AppToast.show(
      copied
          ? L.settings.enrollmentKeyCopied
          : L.settings.enrollmentKeyCopyFailed,
      tone: copied ? UiAlertTone.info : UiAlertTone.warning,
    );
  }

  Future<void> _showQr() async {
    try {
      final payload = await _controller.enrollmentQrPayload();
      if (!mounted) return;
      await EnrollmentKeyQrDialog.show(context, payload);
    } catch (_) {
      AppToast.show(
        L.settings.enrollmentKeyLoadFailed,
        tone: UiAlertTone.danger,
      );
    }
  }

  Future<void> _rotate() async {
    final confirmed = await EnrollmentKeyRotateDialog.show(context);
    if (!confirmed) return;

    try {
      await _controller.rotateEnrollmentKey();
      AppToast.show(L.settings.enrollmentKeyRotated, tone: UiAlertTone.success);
    } catch (_) {
      AppToast.show(
        L.settings.enrollmentKeyRotateFailed,
        tone: UiAlertTone.danger,
      );
    }
  }
}
