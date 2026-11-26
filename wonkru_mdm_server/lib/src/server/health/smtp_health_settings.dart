/// Only the SMTP fields, so the indicator can be fed easily from tests.
class SmtpHealthSettings {
  const SmtpHealthSettings({
    required this.enabled,
    required this.host,
    required this.port,
    required this.fromAddress,
  });

  final bool enabled;

  final String host;

  final int port;

  final String fromAddress;
}
