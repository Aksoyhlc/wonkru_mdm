import 'dart:io';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

class _StaticAuthKeyProvider implements ClientAuthKeyProvider {
  _StaticAuthKeyProvider(this.headerValue);

  final String headerValue;

  @override
  Future<String?> get authHeaderValue async => headerValue;
}

/// Create a device notification and print its delivery records.
///
/// Usage: `dart run tool/create_device_notification.dart <deviceId> [title] [message]`
Future<void> main(List<String> args) async {
  final env = Platform.environment;
  final url = env['WONKRU_SERVER_URL'] ?? 'http://10.0.2.2:8090';
  final email = env['WONKRU_ADMIN_EMAIL'] ?? '';
  final password = env['WONKRU_ADMIN_PASSWORD'] ?? '';
  if (email.isEmpty || password.isEmpty) {
    throw StateError('WONKRU_ADMIN_EMAIL ve WONKRU_ADMIN_PASSWORD zorunlu.');
  }
  if (args.isEmpty) {
    throw ArgumentError('Kullanım: <deviceId> [title] [message]');
  }
  final deviceId = int.parse(args[0]);

  final client = Client(url);
  try {
    final auth = await client.adminAuth.login(email, password);
    client.authKeyProvider = _StaticAuthKeyProvider(
      wrapAsBearerAuthHeaderValue(auth.token),
    );
    final res = await client.adminDeviceNotification.create(
      AdminDeviceNotificationCreateRequest(
        title: args.length > 1 ? args[1] : 'E2E test bildirimi',
        message: args.length > 2 ? args[2] : 'Bildirim ack testi',
        type: 'normal',
        deviceIds: [deviceId],
      ),
    );
    stdout.writeln(
      'notification id=${res.notification.id} uuid=${res.notification.uuid} '
      'deliveries=${res.deliveries.length}',
    );
    stdout.writeln(res.toJson());
  } finally {
    client.close();
  }
}
