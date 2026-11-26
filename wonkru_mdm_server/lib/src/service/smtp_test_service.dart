import '../config/mail_config.dart';
import '../generated/protocol.dart';
import 'smtp_mail_service.dart';

/// Sends the settings page's SMTP test mail and reports each outcome.
class SmtpTestService {
  const SmtpTestService._();

  static const defaultRecipient = 'example@gmail.com';

  static Future<List<SmtpTestNotice>> send(
    SettingsFormState state,
    String? recipient,
  ) async {
    final notices = <SmtpTestNotice>[];
    final to = _normalizeRecipient(recipient);

    if (!_isEmail(to)) {
      return [SmtpTestNotice(status: 'invalid_email', severity: 'danger')];
    }

    if (state.smtpEnabled && state.smtpHost.trim().isEmpty) {
      return [SmtpTestNotice(status: 'missing_host', severity: 'danger')];
    }

    if (!state.smtpEnabled && MailConfig.defaultMailer != 'smtp') {
      notices.add(
        SmtpTestNotice(
          status: 'mailer_not_smtp',
          severity: 'warning',
          detail: MailConfig.defaultMailer,
        ),
      );
    }

    final now = DateTime.now().toUtc();
    final subject = 'SMTP test - ${state.panelBrandName} - $now';
    final body = 'This is a test mail from ${state.panelBrandName}.\n\n$now\n';

    try {
      await SmtpMailService.send(state, to: to, subject: subject, body: body);
      notices.add(
        SmtpTestNotice(status: 'sent', severity: 'success', detail: to),
      );
    } catch (error) {
      notices.add(
        SmtpTestNotice(
          status: 'failed',
          severity: 'danger',
          detail: '$error',
        ),
      );
    }

    return notices;
  }

  static String _normalizeRecipient(String? recipient) {
    final trimmed = (recipient ?? '').trim();

    return trimmed.isNotEmpty ? trimmed : defaultRecipient;
  }

  static bool _isEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s.]+\.[^@\s]+$').hasMatch(value);
  }
}
