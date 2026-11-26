import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';

import '../config/mail_config.dart';
import '../generated/protocol.dart';

class SmtpMailService {
  const SmtpMailService._();

  static Future<void> send(
    SettingsFormState state, {
    required String to,
    required String subject,
    required String body,
  }) async {
    final encryption = state.smtpEncryption;

    final server = SmtpServer(
      state.smtpHost.trim(),
      port: state.smtpPort,
      username: state.smtpUsername.isEmpty ? null : state.smtpUsername,
      password: state.smtpPassword.isEmpty ? null : state.smtpPassword,
      ssl: encryption == SmtpEncryption.ssl,
      allowInsecure: encryption == SmtpEncryption.none,
    );

    final fromAddress = state.smtpFromAddress.isEmpty
        ? MailConfig.fromAddress
        : state.smtpFromAddress;
    final fromName = state.smtpFromName.isEmpty
        ? MailConfig.fromName
        : state.smtpFromName;

    final message = mailer.Message()
      ..from = mailer.Address(fromAddress, fromName)
      ..recipients.add(to)
      ..subject = subject
      ..text = body;

    await mailer.send(message, server);
  }
}
