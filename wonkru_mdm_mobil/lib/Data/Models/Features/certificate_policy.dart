import 'package:wonkrumdm/Core/Constants/Enums/certificate_action.dart';
import 'package:wonkrumdm/Core/Constants/Enums/certificate_type.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class CertificatePolicy {
  final int? id;
  final String? name;
  final CertificateType certificateType;
  final String? downloadUrl;
  final CertificateAction action;
  final String? password;
  final String? fileHash;

  CertificatePolicy({
    this.id,
    this.name,
    this.certificateType = CertificateType.ca,
    this.downloadUrl,
    this.action = CertificateAction.install,
    this.password,
    this.fileHash,
  });

  factory CertificatePolicy.fromJson(Map<String, dynamic> json) {
    return CertificatePolicy(
      id: JsonParse.toInt(json['id']),
      name: JsonParse.toStr(json['name']),
      certificateType: CertificateType.fromString(JsonParse.toStr(json['certificate_type'])),
      downloadUrl: JsonParse.toStr(json['download_url']),
      action: CertificateAction.fromString(JsonParse.toStr(json['action'])),
      password: JsonParse.toStr(json['password']),
      fileHash: JsonParse.toStr(json['file_hash']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'certificate_type': certificateType.value,
        'download_url': downloadUrl,
        'action': action.name,
        'password': password,
        'file_hash': fileHash,
      };
}
