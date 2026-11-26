/// Wire values match the server (`CA|CLIENT|SERVER|USER|PKCS12`); types other
/// than `ca` install as a key pair and never take the CA install path.
enum CertificateType {
  ca('CA'),

  client('CLIENT'),

  server('SERVER'),

  user('USER'),

  pkcs12('PKCS12');

  final String value;
  const CertificateType(this.value);

  static CertificateType fromString(String? value) {
    return CertificateType.values.firstWhere(
      (e) => e.value.toUpperCase() == value?.toUpperCase(),
      orElse: () => CertificateType.ca,
    );
  }
}
