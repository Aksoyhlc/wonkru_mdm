import 'package:flutter_test/flutter_test.dart';
import '../../tool/send_device_command.dart';

void main() {
  const env = {
    'WONKRU_ADMIN_EMAIL': 'admin@example.com',
    'WONKRU_ADMIN_PASSWORD': 'secret',
  };

  test('parses valid arguments and environment', () {
    final c = parseSendCommandConfig(['42', 'send_notification'], env);
    expect(c.deviceId, 42);
    expect(c.action, 'send_notification');
    expect(c.paramsJson, isNull);
    expect(c.serverUrl.toString(), 'http://10.0.2.2:8090');
    expect(c.email, 'admin@example.com');
  });

  test('takes the paramsJson argument', () {
    final c = parseSendCommandConfig(
      ['7', 'launch_app', '{"package":"com.android.settings"}'],
      env,
    );
    expect(c.paramsJson, '{"package":"com.android.settings"}');
  });

  test('uses WONKRU_SERVER_URL when provided', () {
    final c = parseSendCommandConfig(['1', 'device_data'], {
      ...env,
      'WONKRU_SERVER_URL': 'http://10.0.2.2:8090',
    });
    expect(c.serverUrl.toString(), 'http://10.0.2.2:8090');
  });

  test('throws StateError when credentials are missing', () {
    expect(
      () => parseSendCommandConfig(['1', 'device_data'], {}),
      throwsA(isA<StateError>()),
    );
  });

  test('an invalid deviceId / empty action is rejected', () {
    expect(
      () => parseSendCommandConfig(['0', 'device_data'], env),
      throwsA(isA<ArgumentError>()),
    );
    expect(
      () => parseSendCommandConfig(['1', ''], env),
      throwsA(isA<ArgumentError>()),
    );
  });
}
