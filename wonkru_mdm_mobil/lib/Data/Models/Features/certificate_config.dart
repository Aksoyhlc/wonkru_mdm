import 'certificate_policy.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class CertificateSettings {
  final List<CertificatePolicy> policies;

  CertificateSettings({required this.policies});

  bool get isEmpty => policies.isEmpty;
  bool get isNotEmpty => policies.isNotEmpty;
  int get length => policies.length;

  factory CertificateSettings.fromJson(dynamic json) {
    if (json is! List) return CertificateSettings(policies: []);
    return CertificateSettings(
      policies: JsonParse.listOf(json, CertificatePolicy.fromJson, field: 'certificates'),
    );
  }
}