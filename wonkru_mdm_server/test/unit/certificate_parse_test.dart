import 'dart:convert';

import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/certificate_parse_service.dart';

import '../support/certificate_fixtures.dart';

void main() {
  const subject = 'CN=Wonkru Test Root CA, O=Wonkru, OU=MDM, C=TR';
  const serialNumber = '102030405';
  const fingerprint =
      'CB5A32AFEC40D93A3AB883416430BAB3E27701BD403A8A38AC9BDA12D210448F';

  final validFrom = DateTime.utc(2026, 9, 22, 19, 13, 11);
  final validUntil = DateTime.utc(2028, 9, 21, 19, 13, 11);

  final der = base64.decode(certificateFixtureDerBase64);
  final pkcs12Modern = base64.decode(certificateFixturePkcs12ModernBase64);
  final pkcs7 = base64.decode(certificateFixturePkcs7Base64);

  void expectFixtureCertificate(
    CertificateInfo info, {
    required String format,
    String certificateType = 'CA',
  }) {
    expect(info.issuer, subject);
    expect(info.subject, subject);
    expect(info.serialNumber, serialNumber);
    expect(info.fingerprintSha256, fingerprint);
    expect(info.validFrom, validFrom);
    expect(info.validUntil, validUntil);
    expect(info.format, format);
    expect(info.certificateType, certificateType);
    // The certificate is returned as PEM regardless of the input format.
    expect(info.certificatePem, isNotNull);
    expect(info.certificatePem!.trim(), certificateFixturePem.trim());
  }

  group('PEM', () {
    test('when a PEM body is given then it is read as PEM.', () {
      final info = CertificateParseService.parse(certificateFixturePem);

      expectFixtureCertificate(info, format: 'PEM');
    });

    test('when a base64 wrapped PEM body is given then it is still read as '
        'PEM.', () {
      final info = CertificateParseService.parse(
        base64.encode(utf8.encode(certificateFixturePem)),
      );

      expectFixtureCertificate(info, format: 'PEM');
    });

    test('when the body is not a certificate then it is rejected.', () {
      expect(
        () => CertificateParseService.parse('not a certificate'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('DER', () {
    test('when a base64 DER body is given then it is read as DER.', () {
      final info = CertificateParseService.parse(certificateFixtureDerBase64);

      expectFixtureCertificate(info, format: 'DER');
    });

    test('when a raw DER byte body is given then it is read as DER.', () {
      final info = CertificateParseService.parse(latin1.decode(der));

      expectFixtureCertificate(info, format: 'DER');
    });
  });

  group('PKCS#12', () {
    test('when a PBES2 store is opened with the right password then its '
        'certificate is read.', () {
      final info = CertificateParseService.parse(
        certificateFixturePkcs12ModernBase64,
        password: certificateFixturePassword,
      );

      expectFixtureCertificate(info, format: 'PKCS12');
    });

    test('when a PBES1 store is opened with the right password then its '
        'certificate is read.', () {
      final info = CertificateParseService.parse(
        certificateFixturePkcs12LegacyBase64,
        password: certificateFixturePassword,
      );

      expectFixtureCertificate(info, format: 'PKCS12');
    });

    test('when the password is wrong then a readable error is thrown.', () {
      expect(
        () => CertificateParseService.parse(
          certificateFixturePkcs12ModernBase64,
          password: 'wrong-password',
        ),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Incorrect PKCS12 password or corrupt file.',
          ),
        ),
      );
    });

    test('when a raw PBES2 store is opened then its certificate is read.', () {
      final info = CertificateParseService.parse(
        latin1.decode(pkcs12Modern),
        password: certificateFixturePassword,
      );

      expectFixtureCertificate(info, format: 'PKCS12');
    });
  });

  group('PKCS#7', () {
    test('when a DER bundle is given then it is read as PKCS7.', () {
      final info = CertificateParseService.parse(certificateFixturePkcs7Base64);

      expectFixtureCertificate(info, format: 'PKCS7');
    });

    test('when a raw DER bundle is given then it is read as PKCS7.', () {
      final info = CertificateParseService.parse(latin1.decode(pkcs7));

      expectFixtureCertificate(info, format: 'PKCS7');
    });

    test('when a PEM bundle is given then it is read as PKCS7.', () {
      final pem =
          '-----BEGIN PKCS7-----\n'
          '${base64.encode(pkcs7)}\n'
          '-----END PKCS7-----\n';

      final info = CertificateParseService.parse(pem);

      expectFixtureCertificate(info, format: 'PKCS7');
    });
  });
}
