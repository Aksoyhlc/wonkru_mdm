import 'package:test/test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:wonkru_mdm_server/src/util/server_time.dart';

void main() {
  tzdata.initializeTimeZones();

  final istanbul = tz.getLocation('Europe/Istanbul');
  final newYork = tz.getLocation('America/New_York');

  group('ServerTime.format', () {
    test('writes the UTC wall clock when no zone is given', () {
      expect(
        ServerTime.format(DateTime.utc(2026, 9, 25, 19, 40), null),
        '25.09.2026 19:40',
      );
    });

    test('writes the zone wall clock when a zone is given', () {
      expect(
        ServerTime.format(DateTime.utc(2026, 9, 25, 19, 40), istanbul),
        '25.09.2026 22:40',
      );
    });

    test('seconds format is requested', () {
      expect(
        ServerTime.format(
          DateTime.utc(2026, 9, 25, 19, 40, 7),
          istanbul,
          withSeconds: true,
        ),
        '25.09.2026 22:40:07',
      );
    });

    test('the conversion can change the day', () {
      expect(
        ServerTime.format(DateTime.utc(2026, 9, 25, 22, 30), istanbul),
        '26.09.2026 01:30',
      );
    });

    test('daylight saving depends on the zone', () {
      // January: EST (UTC-5), July: EDT (UTC-4).
      expect(
        ServerTime.format(DateTime.utc(2026, 1, 15, 12), newYork),
        '15.01.2026 07:00',
      );
      expect(
        ServerTime.format(DateTime.utc(2026, 7, 15, 12), newYork),
        '15.07.2026 08:00',
      );
    });

    test('an instant given as local time is still treated as UTC and converted', () {
      // Storage keeps UTC; a value that is not `DateTime.utc` is still an
      // instant.
      final local = DateTime.utc(2026, 9, 25, 19, 40).toLocal();
      expect(ServerTime.format(local, istanbul), '25.09.2026 22:40');
    });
  });
}
