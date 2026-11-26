import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/settings_controller.dart';
import '../../../Logic/UI/input_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/EmptyState/error_panel.dart';
import '../../Widgets/Loading/app_loader.dart';
import 'Widgets/enrollment_key_section.dart';
import 'Widgets/settings_sections.dart';
import 'Widgets/smtp_test_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsController _controller = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    unawaited(_controller.load());
  }

  @override
  void dispose() {
    InputController.to.removeDataControllers(SettingsController.inputKeys);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.loading.value && _controller.state.value == null) {
        return const Center(child: AppLoader(size: 26));
      }

      if (_controller.state.value == null) {
        return ErrorPanel(
          message: _controller.error.value ?? L.settings.loadFailed,
          onRetry: _controller.load,
        );
      }

      return Column(
        children: [
          _toolbar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: AppInsets.all20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_controller.optionsError.value != null) ...[
                    _warningBanner(context, _controller.optionsError.value!),
                    AppGap.v16,
                  ],
                  SettingsSections(controller: _controller),
                  AppGap.v16,
                  SmtpTestSection(controller: _controller),
                  AppGap.v16,
                  EnrollmentKeySection(controller: _controller),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _toolbar(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s10,
      ),
      decoration: colors.hairlineBottom(fill: colors.workshop),
      child: Row(
        children: [
          Text(
            L.settings.title,
            style: AppText.pageTitle(context),
          ),
          const Spacer(),
          AppButton(
            label: L.common.save,
            icon: LucideIcons.save,
            compact: true,
            loading: _controller.saving.value,
            onPressed: _save,
          ),
        ],
      ),
    );
  }

  Widget _warningBanner(BuildContext context, String message) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: Border.all(color: colors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.triangleAlert, size: 16, color: colors.warning),
          AppGap.h10,
          Expanded(
            child: Text(
              L.settings.optionsLoadFailed.trParams({'message': message}),
              style: AppText.body(context),
            ),
          ),
          AppGap.h12,
          AppButton(
            label: L.settings.retry,
            compact: true,
            variant: AppButtonVariant.secondary,
            onPressed: _controller.load,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!InputController.to.validateAll()) {
      AppToast.show(L.settings.checkFields, tone: UiAlertTone.warning);
      return;
    }

    try {
      await _controller.save();
      if (!mounted) return;
      AppToast.show(L.settings.saved, tone: UiAlertTone.success);
    } on AdminSettingsException catch (e) {
      AppToast.show(e.message, tone: UiAlertTone.danger);
    } catch (e) {
      AppToast.show(
        L.common.saveFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    }
  }
}
