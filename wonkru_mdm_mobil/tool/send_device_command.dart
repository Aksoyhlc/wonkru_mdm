import 'dart:io';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

class SendCommandConfig {
  const SendCommandConfig({
    required this.serverUrl,
    required this.email,
    required this.password,
    required this.deviceId,
    required this.action,
    required this.paramsJson,
  });

  final Uri serverUrl;
  final String email;
  final String password;
  final int deviceId;
  final String action;
  final String? paramsJson;
}

/// Parse `<deviceId> <action> [paramsJson]` and environment credentials.
/// Throws [StateError] for missing credentials and [ArgumentError] for invalid arguments.
SendCommandConfig parseSendCommandConfig(
  List<String> args,
  Map<String, String> env,
) {
  if (args.length < 2) {
    throw ArgumentError('Kullanım: <deviceId> <action> [paramsJson]');
  }
  final deviceId = int.tryParse(args[0]);
  if (deviceId == null || deviceId <= 0) {
    throw ArgumentError('deviceId pozitif tam sayı olmalı: "${args[0]}"');
  }
  final action = args[1].trim();
  if (action.isEmpty) {
    throw ArgumentError('action boş olamaz.');
  }
  final email = env['WONKRU_ADMIN_EMAIL']?.trim() ?? '';
  final password = env['WONKRU_ADMIN_PASSWORD'] ?? '';
  if (email.isEmpty || password.isEmpty) {
    throw StateError(
      'WONKRU_ADMIN_EMAIL ve WONKRU_ADMIN_PASSWORD ortam değişkenleri zorunlu.',
    );
  }
  return SendCommandConfig(
    serverUrl: Uri.parse(env['WONKRU_SERVER_URL'] ?? 'http://10.0.2.2:8090'),
    email: email,
    password: password,
    deviceId: deviceId,
    action: action,
    paramsJson: args.length > 2 ? args[2] : null,
  );
}

/// Token refresh is unnecessary for this short-lived command.
class _StaticAuthKeyProvider implements ClientAuthKeyProvider {
  _StaticAuthKeyProvider(this.headerValue);

  final String headerValue;

  @override
  Future<String?> get authHeaderValue async => headerValue;
}

/// Queue a device command and print the queue status.
Future<void> main(List<String> args) async {
  final config = parseSendCommandConfig(args, Platform.environment);
  final client = Client(config.serverUrl.toString());
  try {
    final auth = await client.adminAuth.login(config.email, config.password);
    client.authKeyProvider = _StaticAuthKeyProvider(
      wrapAsBearerAuthHeaderValue(auth.token),
    );
    final status = await client.adminDevice.sendCommand(
      [config.deviceId],
      config.action,
      config.paramsJson,
    );
    stdout.writeln('bulkId=${status.bulkId} toplam=${status.total}');
  } finally {
    client.close();
  }
}
