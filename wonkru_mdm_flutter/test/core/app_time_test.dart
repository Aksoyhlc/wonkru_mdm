import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:wonkru_mdm_flutter/Core/Time/app_time.dart';

void main() {
  tzdata.initializeTimeZones();
  final appTime = AppTime.instance;

  setUp(() => appTime.set(null));

  group('AppTime', () {
    test('not configured initially', () {
      expect(appTime.isConfigured, isFalse);
      expect(appTime.zoneName.value, isNull);
    });

    test('a valid zone is configured', () {
      appTime.set('Europe/Istanbul');

      expect(appTime.isConfigured, isTrue);
      expect(appTime.zoneName.value, 'Europe/Istanbul');
    });

    test('an unknown zone counts as not configured', () {
      appTime.set('Mars/Olympus');

      expect(appTime.isConfigured, isFalse);
      expect(appTime.zoneName.value, isNull);
    });

    test('an empty value clears the zone', () {
      appTime.set('Europe/Istanbul');
      appTime.set('  ');

      expect(appTime.isConfigured, isFalse);
      expect(appTime.zoneName.value, isNull);
    });

    test('formats the UTC wall clock when no zone is set', () {
      expect(
        appTime.format(DateTime.utc(2026, 9, 25, 19, 40), 'dd.MM.yyyy HH:mm'),
        '25.09.2026 19:40',
      );
    });

    test('formats the zone wall clock when a zone is set', () {
      appTime.set('Europe/Istanbul');

      expect(
        appTime.format(DateTime.utc(2026, 9, 25, 19, 40), 'dd.MM.yyyy HH:mm'),
        '25.09.2026 22:40',
      );
    });

    test('the day changes on a conversion past midnight', () {
      appTime.set('Europe/Istanbul');

      expect(
        appTime.format(DateTime.utc(2026, 9, 25, 22, 30), 'dd.MM.yyyy HH:mm'),
        '26.09.2026 01:30',
      );
    });

    test('daylight saving varies by zone', () {
      appTime.set('America/New_York');

      expect(appTime.format(DateTime.utc(2026, 1, 15, 12), 'HH:mm'), '07:00');
      expect(appTime.format(DateTime.utc(2026, 7, 15, 12), 'HH:mm'), '08:00');
    });

    test('produces day/month names for the active locale', () {
      appTime.set('Europe/Istanbul');

      expect(
        appTime.format(
          DateTime.utc(2026, 9, 25, 19, 40),
          'EEE, d MMM y',
          locale: 'en_US',
        ),
        'Fri, 25 Sep 2026',
      );
    });

    test('the zone label shows the offset', () {
      appTime.set('Europe/Istanbul');
      expect(appTime.label, 'UTC+03');

      appTime.set('Asia/Kolkata');
      expect(appTime.label, 'UTC+05:30');

      appTime.set(null);
      expect(appTime.label, 'UTC');
    });
  });
}
