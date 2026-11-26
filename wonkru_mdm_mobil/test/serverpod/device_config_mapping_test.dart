import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Data/Models/Features/config.dart';

void main() {
  test('policy JSON unfolds into top-level fields', () {
    final policy = jsonEncode({
      'id': 7,
      'name': 'Default',
      'version': 3,
      'is_active': true,
      'sync_settings': {'full_sync_cron': '0 * * * *', 'max_interval_minutes': 30},
    });
    final map = jsonDecode(policy) as Map<String, dynamic>;
    final config = DeviceConfig.fromJson(map);
    expect(config.id, 7);
    expect(config.version, 3);
    expect(config.syncSettings?.maxIntervalMinutes, 30);
  });
}
