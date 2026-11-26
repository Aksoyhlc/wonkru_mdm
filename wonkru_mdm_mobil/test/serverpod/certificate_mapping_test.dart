import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Constants/Enums/certificate_action.dart';
import 'package:wonkrumdm/Core/Constants/Enums/certificate_type.dart';
import 'package:wonkrumdm/Data/Models/Features/certificate_policy.dart';

void main() {
  test('the uninstall wire value resolves to uninstall', () {
    final policy = CertificatePolicy.fromJson({
      'id': 1,
      'name': 'CA',
      'certificate_type': 'ca',
      'action': 'uninstall',
    });
    expect(policy.action, CertificateAction.uninstall);
  });

  test('the legacy remove value also counts as uninstall', () {
    expect(CertificateAction.fromString('remove'), CertificateAction.uninstall);
  });

  test('the safe default install is kept for an unknown value', () {
    expect(CertificateAction.fromString('unknown'), CertificateAction.install);
    expect(CertificateAction.fromString(null), CertificateAction.install);
  });

  test('CLIENT/SERVER types are not interpreted as CA', () {
    expect(CertificateType.fromString('CLIENT'), CertificateType.client);
    expect(CertificateType.fromString('SERVER'), CertificateType.server);
  });

  test('certificate types match case-insensitively', () {
    expect(CertificateType.fromString('client'), CertificateType.client);
    expect(CertificateType.fromString('server'), CertificateType.server);
    expect(CertificateType.fromString('Ca'), CertificateType.ca);
    expect(CertificateType.fromString('USER'), CertificateType.user);
    expect(CertificateType.fromString('pkcs12'), CertificateType.pkcs12);
  });

  test('the safe default ca is kept for an unknown certificate type', () {
    expect(CertificateType.fromString('unknown'), CertificateType.ca);
    expect(CertificateType.fromString(null), CertificateType.ca);
  });

  test('a CLIENT policy is resolved from JSON as the client type', () {
    final policy = CertificatePolicy.fromJson({
      'id': 2,
      'name': 'Wifi Client',
      'certificate_type': 'CLIENT',
      'action': 'install',
    });
    expect(policy.certificateType, CertificateType.client);
    expect(policy.certificateType, isNot(CertificateType.ca));
  });
}
