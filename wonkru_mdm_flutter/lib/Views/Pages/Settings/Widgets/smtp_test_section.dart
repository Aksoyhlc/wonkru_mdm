import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Errors/server_error_message.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/settings_controller.dart';
import '../../../../Logic/UI/input_controller.dart';
import '../../../Widgets/Alert/app_toast.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/named_dropdown.dart';
import '../../../Widgets/Switch/named_switch.dart';

/// The test runs against the unsaved form state, not the persisted settings.
class SmtpTestSection extends StatelessWidget {
  const SmtpTestSection({super.key, required this.controller});

  final SettingsController controller;

  static Map<SmtpEncryption, String> get _encryptionItems =>
      <SmtpEncryption, String>{
        SmtpEncryption.none: L.common.none,
        SmtpEncryption.tls: 'TLS',
        SmtpEncryption.ssl: 'SSL',
      };

  static Map<String, String> get _noticeMessages => <String, String>{
    'invalid_email': L.settings.noticeInvalidEmail,
    'missing_host': L.settings.noticeMissingHost,
    'mailer_not_smtp': L.settings.noticeNotSmtp,
    'sent': L.settings.noticeSent,
    'failed': L.settings.testMailFailed,
  };

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'SMTP',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          NamedSwitch(
            name: 'settings.smtpEnabled',
            title: L.settings.smtpEnabled,
            subtitle: L.settings.smtpEnabledSubtitle,
            dense: true,
          ),
          AppGap.v8,
          _grid([
            CustomTextField(
              name: 'settings.smtpHost',
              label: L.settings.smtpHost,
              dense: true,
            ),
            CustomTextField(
              name: 'settings.smtpPort',
              label: 'Port',
              keyboardType: TextInputType.number,
              dense: true,
            ),
            NamedDropdown<SmtpEncryption>(
              name: 'settings.smtpEncryption',
              label: L.settings.smtpEncryption,
              items: _encryptionItems,
              dense: true,
              fallback: SmtpEncryption.none,
            ),
            CustomTextField(
              name: 'settings.smtpUsername',
              label: L.settings.smtpUsername,
              dense: true,
            ),
            CustomTextField(
              name: 'settings.smtpPassword',
              label: L.settings.smtpPassword,
              obscureText: true,
              dense: true,
            ),
            CustomTextField(
              name: 'settings.smtpFromAddress',
              label: L.settings.smtpFromAddress,
              dense: true,
            ),
            CustomTextField(
              name: 'settings.smtpFromName',
              label: L.settings.smtpFromName,
              dense: true,
            ),
          ]),
          AppGap.v20,
          Divider(height: 1, thickness: 1, color: context.appColors.border),
          AppGap.v16,
          _testRow(context),
        ],
      ),
    );
  }

  Widget _testRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 560;
        final recipient = CustomTextField(
          name: 'settings.smtpTestRecipient',
          label: L.settings.smtpRecipient,
          hint: L.settings.smtpRecipientHint,
          dense: true,
        );
        final button = AppButton(
          label: L.settings.sendTestMail,
          icon: LucideIcons.send,
          compact: true,
          loading: controller.testing.value,
          onPressed: () => _sendTest(context),
        );

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              recipient,
              AppGap.v12,
              Align(alignment: Alignment.centerLeft, child: button),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: recipient),
            AppGap.h12,
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: button,
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendTest(BuildContext context) async {
    final recipient = InputController.to
        .getValue('settings.smtpTestRecipient')
        .trim();
    try {
      final notices = await controller.sendTestMail(
        recipient.isEmpty ? null : recipient,
      );
      if (notices.isEmpty) {
        AppToast.show(
          L.settings.testMailFailed,
          tone: UiAlertTone.warning,
        );
        return;
      }
      for (final notice in notices) {
        AppToast.show(_message(notice), tone: _tone(notice.severity));
      }
    } catch (e) {
      AppToast.show(
        L.settings.sendTestFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    }
  }

  String _message(SmtpTestNotice notice) {
    final label = _noticeMessages[notice.status] ?? notice.status;
    final detail = notice.detail;
    return detail == null || detail.isEmpty ? label : '$label: $detail';
  }

  UiAlertTone _tone(String severity) {
    return switch (severity) {
      'success' => UiAlertTone.success,
      'warning' => UiAlertTone.warning,
      'danger' => UiAlertTone.danger,
      _ => UiAlertTone.info,
    };
  }

  Widget _grid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 560
            ? 2
            : 1;
        const spacing = 16.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 16,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}
