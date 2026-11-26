import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import 'admin_settings_service.dart';
import 'smtp_mail_service.dart';

/// Same signature as `SmtpMailService.send`; a separate typedef so tests can
/// exercise transport selection without a real SMTP server.
typedef SmtpVerificationCodeSender =
    Future<void> Function(
      SettingsFormState state, {
      required String to,
      required String subject,
      required String body,
    });

/// Same signature as `AdminSettingsService.read`; separate so tests can stub
/// settings.
typedef SmtpSettingsReader =
    Future<SettingsFormState> Function(
      Session session, {
      Transaction? transaction,
    });

/// Chooses how the email IDP delivers verification codes.
///
/// If SMTP is enabled in the `settings` table (`smtp_enabled` set and
/// `smtp_host` non-empty) the code goes out through [SmtpMailService]. Otherwise
/// [ServerpodCloudEmailIdpConfig] behaviour is kept: the code is logged in
/// development and sent by Serverpod Cloud in staging/production.
///
/// Delivery is best-effort, like the Serverpod Cloud path: an SMTP failure never
/// breaks registration or password reset and only reaches the server logs.
/// Raising it would leak account existence on password reset, where mail is only
/// sent to known addresses.
class EmailIdpSender {
  const EmailIdpSender._();

  static const appDisplayName = 'wonkru_mdm';

  /// Upper bound on SMTP sending. Registration is public, so this keeps an
  /// unresponsive server from holding the request handler open.
  static const sendTimeout = Duration(seconds: 30);

  static const verificationCodeLifetime = Duration(minutes: 15);

  static EmailIdpConfigFromPasswords config({
    EmailIdpConfig? cloudFallback,
    SmtpVerificationCodeSender sendOverSmtp = SmtpMailService.send,
    SmtpSettingsReader readSettings = AdminSettingsService.read,
    Duration? timeout = sendTimeout,
  }) {
    final cloud =
        cloudFallback ??
        ServerpodCloudEmailIdpConfig(appDisplayName: appDisplayName);

    return EmailIdpConfigFromPasswords(
      // Pinned rather than trusting the library default: a future dependency
      // update must not silently weaken login protection.
      failedLoginRateLimit: const RateLimit(
        maxAttempts: 5,
        timeframe: Duration(minutes: 5),
      ),
      maxPasswordResetAttempts: const RateLimit(
        maxAttempts: 3,
        timeframe: Duration(hours: 1),
      ),
      sendRegistrationVerificationCode:
          (
            final Session session, {
            required final String email,
            required final UuidValue accountRequestId,
            required final String verificationCode,
            required final Transaction? transaction,
          }) => _send(
            session,
            email: email,
            verificationCode: verificationCode,
            isPasswordReset: false,
            transaction: transaction,
            cloudFallback: cloud.sendRegistrationVerificationCode == null
                ? null
                : () async {
                    await cloud.sendRegistrationVerificationCode!(
                      session,
                      email: email,
                      accountRequestId: accountRequestId,
                      verificationCode: verificationCode,
                      transaction: transaction,
                    );
                  },
            sendOverSmtp: sendOverSmtp,
            readSettings: readSettings,
            timeout: timeout,
          ),
      sendPasswordResetVerificationCode:
          (
            final Session session, {
            required final String email,
            required final UuidValue passwordResetRequestId,
            required final String verificationCode,
            required final Transaction? transaction,
          }) => _send(
            session,
            email: email,
            verificationCode: verificationCode,
            isPasswordReset: true,
            transaction: transaction,
            cloudFallback: cloud.sendPasswordResetVerificationCode == null
                ? null
                : () async {
                    await cloud.sendPasswordResetVerificationCode!(
                      session,
                      email: email,
                      passwordResetRequestId: passwordResetRequestId,
                      verificationCode: verificationCode,
                      transaction: transaction,
                    );
                  },
            sendOverSmtp: sendOverSmtp,
            readSettings: readSettings,
            timeout: timeout,
          ),
    );
  }

  static Future<void> _send(
    Session session, {
    required String email,
    required String verificationCode,
    required bool isPasswordReset,
    required Transaction? transaction,
    required Future<void> Function()? cloudFallback,
    required SmtpVerificationCodeSender sendOverSmtp,
    required SmtpSettingsReader readSettings,
    required Duration? timeout,
  }) async {
    final label = isPasswordReset ? 'password reset' : 'registration';

    SettingsFormState state;
    try {
      state = await readSettings(session, transaction: transaction);
    } catch (error, stackTrace) {
      session.log(
        'SMTP settings could not be read; the $label verification code is '
        'being sent over Serverpod Cloud.',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
      await cloudFallback?.call();
      return;
    }

    if (!state.smtpEnabled || state.smtpHost.trim().isEmpty) {
      await cloudFallback?.call();
      return;
    }

    try {
      final sending = sendOverSmtp(
        state,
        to: email,
        subject: _subject(state, isPasswordReset: isPasswordReset),
        body: _body(
          state,
          verificationCode: verificationCode,
          isPasswordReset: isPasswordReset,
        ),
      );
      await (timeout == null ? sending : sending.timeout(timeout));
    } catch (error, stackTrace) {
      session.log(
        'Could not send the $label verification code over SMTP ($email).',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  static String _subject(
    SettingsFormState state, {
    required bool isPasswordReset,
  }) {
    final brand = _brand(state);
    return isPasswordReset
        ? '$brand password reset code'
        : '$brand registration verification code';
  }

  static String _body(
    SettingsFormState state, {
    required String verificationCode,
    required bool isPasswordReset,
  }) {
    final brand = _brand(state);
    final action = isPasswordReset
        ? 'reset your password'
        : 'verify your registration';
    final minutes = verificationCodeLifetime.inMinutes;

    return 'Hello,\n\n'
        'Your verification code to $action for your $brand account:\n\n'
        '  $verificationCode\n\n'
        'The code is valid for $minutes minutes. If you did not make this '
        'request, you can ignore this email.\n';
  }

  static String _brand(SettingsFormState state) {
    final name = state.panelBrandName.trim();
    return name.isEmpty ? appDisplayName : name;
  }
}
