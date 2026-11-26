import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device_register.dart';
import 'package:wonkrumdm/Views/Widgets/bootstrap_ca_installer_sheet.dart';

void main() {
  group('resolveBootstrapCaUri', () {
    test('uses the server address port for the CA route', () {
      final uri = resolveBootstrapCaUri(base: 'http://10.0.2.2:8088');

      expect(uri.toString(), 'http://10.0.2.2:8088/downloads/local-ca');
    });

    test('keeps the scheme default port when the base has no port', () {
      final uri = resolveBootstrapCaUri(base: 'https://mdm.wonkru.com');

      expect(uri.toString(), 'https://mdm.wonkru.com/downloads/local-ca');
    });

    test('CA route is appended when only a host is given', () {
      final uri = resolveBootstrapCaUri(
        base: 'http://10.0.2.2:8088',
        userValue: 'http://10.0.2.2',
      );

      expect(uri.toString(), 'http://10.0.2.2/downloads/local-ca');
    });

    test('a pathless address with the https scheme is also accepted', () {
      final uri = resolveBootstrapCaUri(
        base: 'https://mdm.wonkru.com',
        userValue: 'https://mdm.wonkru.com',
      );

      expect(uri.toString(), 'https://mdm.wonkru.com/downloads/local-ca');
    });

    test('a full path is used as-is', () {
      final uri = resolveBootstrapCaUri(
        base: 'http://10.0.2.2:8088',
        userValue: 'https://ca.example:9443/custom/ca.pem',
      );

      expect(uri.toString(), 'https://ca.example:9443/custom/ca.pem');
    });

    test('returns null for invalid addresses', () {
      expect(resolveBootstrapCaUri(base: ''), isNull);
      expect(
        resolveBootstrapCaUri(base: 'http://host', userValue: 'invalid'),
        isNull,
      );
    });
  });

  group('isValidBootstrapCaUrl', () {
    test('http and https accepted, others rejected', () {
      expect(
        isValidBootstrapCaUrl('http://10.0.2.2:8082/downloads/local-ca'),
        isTrue,
      );
      expect(
        isValidBootstrapCaUrl('https://mdm.wonkru.com/downloads/local-ca'),
        isTrue,
      );
      expect(isValidBootstrapCaUrl('ftp://host/ca'), isFalse);
      expect(isValidBootstrapCaUrl('10.0.2.2'), isFalse);
      expect(isValidBootstrapCaUrl(''), isFalse);
    });
  });
}
