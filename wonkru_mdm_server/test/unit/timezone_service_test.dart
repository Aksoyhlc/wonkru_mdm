import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/timezone_service.dart';

void main() {
  TimezoneService.ensureInitialized();

  group('TimezoneService.resolve', () {
    test('empty and missing values return null', () {
      expect(TimezoneService.resolve(null), isNull);
      expect(TimezoneService.resolve(''), isNull);
      expect(TimezoneService.resolve('   '), isNull);
    });

    test('a valid IANA name returns a Location', () {
      final location = TimezoneService.resolve('Europe/Istanbul');

      expect(location, isNotNull);
      expect(location!.name, 'Europe/Istanbul');
    });

    test('an unknown name returns null', () {
      expect(TimezoneService.resolve('Mars/Olympus'), isNull);
    });
  });

  group('TimezoneService.validate', () {
    test('an empty value is accepted', () {
      expect(() => TimezoneService.validate(null), returnsNormally);
      expect(() => TimezoneService.validate(''), returnsNormally);
    });

    test('a valid zone is accepted', () {
      expect(
        () => TimezoneService.validate('America/New_York'),
        returnsNormally,
      );
    });

    test('an unknown zone is rejected with the field name', () {
      expect(
        () => TimezoneService.validate('Mars/Olympus'),
        throwsA(
          isA<AdminSettingsException>().having(
            (e) => e.field,
            'field',
            'panelTimezone',
          ),
        ),
      );
    });
  });
}
