import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/certificate_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/CertificateApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.certificate'),
  ),
)
class NativeCertificateInfo {
  String? alias;

  String? subject;

  String? issuer;

  int? validFrom;

  int? validTo;

  bool? isCa;
}

@HostApi()
abstract class CertificateAPI {
  @async
  Map<String, Object?> installCaCertificate(Uint8List certData);

  @async
  Map<String, Object?> getInstalledCaCertificates();

  @async
  Map<String, Object?> installUserKeyPair(Uint8List p12Data, String password, String alias, bool isWifi);

  @async
  Map<String, Object?> removeKeyPair(String alias);
}