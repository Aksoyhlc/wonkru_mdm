import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class ApplicationVersion {
  final int? versionCode;
  final String? checksumSha256;

  final String? downloadUrl;

  ApplicationVersion({
    this.versionCode,
    this.checksumSha256,
    this.downloadUrl,
  });

  factory ApplicationVersion.fromJson(Map<String, dynamic> json) {
    return ApplicationVersion(
      versionCode: JsonParse.toInt(json['version_code']),
      checksumSha256: JsonParse.toStr(json['checksum_sha256']),
      downloadUrl: JsonParse.toStr(json['download_url']),
    );
  }
}
