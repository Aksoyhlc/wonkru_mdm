import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Services/sync_storage_filter.dart';

void main() {
  test('secure storage carries only allowlisted Sk keys', () {
    final filtered = SyncStorageFilter.secureStorage({
      Sk.deviceToken.name: 'secret-token',
      Sk.enrollmentKey.name: 'secret-key',
      Sk.enrollmentKeyRejected.name: 'old',
      Sk.commandJournal.name: '[]',
      Sk.bt_management_admin_password.name: 'password',
      'device_config': '{}',
      'unknown_key': 'x',
      Sk.lastSync.name: 1,
      Sk.deviceUuid.name: 'uuid',
    });

    expect(filtered, {Sk.lastSync.name: 1, Sk.deviceUuid.name: 'uuid'});
  });

  test('secrets and app events are stripped from plain storage', () {
    final filtered = SyncStorageFilter.basicStorage({
      'enrollment_key': 'qr-key',
      Sk.deviceToken.name: 'secret',
      Sk.app_events.name: '[]',
      'launcher_mode_enabled': true,
      'server_url': 'http://x',
    });

    expect(filtered, {'launcher_mode_enabled': true, 'server_url': 'http://x'});
  });

  test('the allowlist contains no secret key', () {
    for (final secret in SyncStorageFilter.secretKeys) {
      expect(SyncStorageFilter.secureAllowlist, isNot(contains(secret)));
    }
  });
}
