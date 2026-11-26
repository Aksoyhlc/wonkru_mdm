import 'dart:io';

class MailConfig {
  const MailConfig._();

  static String get defaultMailer =>
      Platform.environment['MAIL_MAILER'] ?? 'log';

  static String get host => Platform.environment['MAIL_HOST'] ?? '127.0.0.1';

  static int get port =>
      int.tryParse(Platform.environment['MAIL_PORT'] ?? '') ?? 587;

  static String get username => Platform.environment['MAIL_USERNAME'] ?? '';

  static String get password => Platform.environment['MAIL_PASSWORD'] ?? '';

  static String get scheme => Platform.environment['MAIL_SCHEME'] ?? '';

  static String get fromAddress =>
      Platform.environment['MAIL_FROM_ADDRESS'] ?? 'hello@example.com';

  static String get fromName =>
      Platform.environment['MAIL_FROM_NAME'] ?? 'Example';
}
