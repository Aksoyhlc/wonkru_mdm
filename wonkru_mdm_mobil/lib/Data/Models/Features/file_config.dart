import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class FileConfig {
  final int id;

  final String name;

  final String extension;

  final String filePath;

  final String? publicUrl;

  final String mimeType;

  final int sizeBytes;

  final String? fileHashSha256;

  FileConfig({
    required this.id,
    required this.name,
    required this.extension,
    required this.filePath,
    this.publicUrl,
    required this.mimeType,
    required this.sizeBytes,
    this.fileHashSha256,
  });

  factory FileConfig.fromJson(Map<String, dynamic> json) {
    return FileConfig(
      id: JsonParse.toInt(json['id']) ?? 0,
      name: JsonParse.toStr(json['name']) ?? '',
      extension: JsonParse.toStr(json['extension']) ?? '',
      filePath: JsonParse.toStr(json['file_path']) ?? '',
      publicUrl: JsonParse.toStr(json['public_url']),
      mimeType: JsonParse.toStr(json['mime_type']) ?? 'application/octet-stream',
      sizeBytes: JsonParse.toInt(json['size_bytes']) ?? 0,
      fileHashSha256: JsonParse.toStr(json['file_hash_sha256']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'extension': extension,
    'file_path': filePath,
    'public_url': publicUrl,
    'mime_type': mimeType,
    'size_bytes': sizeBytes,
    'file_hash_sha256': fileHashSha256,
  };

  String get fullName => '$name.$extension';
}
