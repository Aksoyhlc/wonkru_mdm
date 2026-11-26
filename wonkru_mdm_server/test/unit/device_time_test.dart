import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/util/device_time.dart';

void main() {
  group('parseDeviceTimestamp', () {
    test('UTC text with a Z suffix is parsed as-is', () {
      expect(
        parseDeviceTimestamp('2026-09-24T11:05:00.000Z'),
        DateTime.utc(2026, 9, 24, 11, 5),
      );
    });

    test('an explicit offset is converted to UTC', () {
      expect(
        parseDeviceTimestamp('2026-09-24T14:05:00+03:00'),
        DateTime.utc(2026, 9, 24, 11, 5),
      );
      expect(
        parseDeviceTimestamp('2026-09-24T14:05:00+0300'),
        DateTime.utc(2026, 9, 24, 11, 5),
      );
    });

    test('a legacy local time without offset is considered unreliable (null)', () {
      expect(parseDeviceTimestamp('2026-09-24T14:05:00.000'), isNull);
    });

    test('a date-only, empty, or corrupt text returns null', () {
      expect(parseDeviceTimestamp('2026-09-24'), isNull);
      expect(parseDeviceTimestamp(''), isNull);
      expect(parseDeviceTimestamp(null), isNull);
      expect(parseDeviceTimestamp('yesterday Z'), isNull);
    });
  });
}
