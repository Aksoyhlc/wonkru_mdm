import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Utils/setup_payload.dart';

void main() {
  group('Given SetupPayload.parse', () {
    test('reads the extras bundle of a provisioning QR', () {
      const raw = '''
      {
        "android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE": {
          "server_url": "https://api.example.com",
          "device_code": "ABC123",
          "enrollment_key": "WNKR-1A2B-3C4D-5E6F"
        }
      }''';

      final payload = SetupPayload.parse(raw)!;

      expect(payload.serverUrl, 'https://api.example.com');
      expect(payload.deviceCode, 'ABC123');
      expect(payload.enrollmentKey, 'WNKR-1A2B-3C4D-5E6F');
    });

    test('reads a flat setup JSON', () {
      final payload = SetupPayload.parse(
        '{"server_url":"http://10.0.2.2:8090",'
        '"enrollment_key":"WNKR-1A2B-3C4D-5E6F"}',
      )!;

      expect(payload.serverUrl, 'http://10.0.2.2:8090');
      expect(payload.enrollmentKey, 'WNKR-1A2B-3C4D-5E6F');
      expect(payload.deviceCode, isNull);
    });

    test('treats a plain key as the enrollment key', () {
      final payload = SetupPayload.parse('  WNKR-1A2B-3C4D-5E6F  ')!;

      expect(payload.enrollmentKey, 'WNKR-1A2B-3C4D-5E6F');
      expect(payload.serverUrl, isNull);
    });

    test('rejects empty, irrelevant JSON and JSON arrays', () {
      expect(SetupPayload.parse('   '), isNull);
      expect(SetupPayload.parse('{}'), isNull);
      expect(SetupPayload.parse('{"foo":"bar"}'), isNull);
      expect(SetupPayload.parse('[1,2,3]'), isNull);
      expect(SetupPayload.parse('{not json}'), isNull);
    });
  });
}
