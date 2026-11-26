import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/service/enrollment_key_service.dart';

void main() {
  group('Given EnrollmentKeyService.generate', () {
    test('produces WNKR-XXXX-XXXX-XXXX in the Crockford alphabet', () {
      final key = EnrollmentKeyService.generate();

      expect(
        RegExp(r'^WNKR(-[0-9A-HJKMNP-TV-Z]{4}){3}$').hasMatch(key),
        isTrue,
        reason: 'unexpected key: $key',
      );
    });

    test('does not repeat', () {
      final keys = <String>{
        for (var i = 0; i < 50; i++) EnrollmentKeyService.generate(),
      };

      expect(keys.length, 50);
    });
  });

  group('Given EnrollmentKeyService.normalize', () {
    test('keeps a canonical key unchanged', () {
      expect(
        EnrollmentKeyService.normalize('WNKR-1A2B-3C4D-5E6F'),
        'WNKR-1A2B-3C4D-5E6F',
      );
    });

    test('accepts lowercase, spaces and missing separators', () {
      expect(
        EnrollmentKeyService.normalize('wnkr1a2b3c4d5e6f'),
        'WNKR-1A2B-3C4D-5E6F',
      );
      expect(
        EnrollmentKeyService.normalize('  wNkR 1a2b-3c4d 5e6f '),
        'WNKR-1A2B-3C4D-5E6F',
      );
    });

    test('maps ambiguous Crockford letters to digits', () {
      expect(
        EnrollmentKeyService.normalize('WNKR-IOOO-1A2B-3C4D'),
        'WNKR-1000-1A2B-3C4D',
      );
      expect(
        EnrollmentKeyService.normalize('wnkrl111-1a2b-3c4d'),
        'WNKR-1111-1A2B-3C4D',
      );
    });

    test('rejects wrong length, empty and out-of-alphabet input', () {
      expect(EnrollmentKeyService.normalize('WNKR-1A2B-3C4D'), isNull);
      expect(EnrollmentKeyService.normalize('WNKR-1A2B-3C4D-5E6F-7G8H'), isNull);
      expect(EnrollmentKeyService.normalize('WNKR-1A2B-3C4D-5E6U'), isNull);
      expect(EnrollmentKeyService.normalize(''), isNull);
      expect(EnrollmentKeyService.normalize(null), isNull);
    });
  });
}
