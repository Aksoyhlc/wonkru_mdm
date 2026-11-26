import 'package:wonkru_mdm_client/wonkru_mdm_client.dart'
    show FileOperationType;
import 'package:wonkrumdm/Data/Models/Features/file_config.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class FilePolicy {
  final int id;

  final String name;

  final bool enabled;

  final int policyId;

  final int fileId;

  final FileOperationType usageType;

  final String destinationPath;

  final bool replaceIfExists;

  final bool openAfterDownload;

  final FileConfig? file;

  FilePolicy({
    required this.id,
    this.name = '',
    this.enabled = true,
    required this.policyId,
    required this.fileId,
    required this.usageType,
    required this.destinationPath,
    this.replaceIfExists = true,
    this.openAfterDownload = false,
    this.file,
  });

  factory FilePolicy.fromJson(Map<String, dynamic> json) {
    return FilePolicy(
      id: JsonParse.toInt(json['id']) ?? 0,
      name: JsonParse.toStr(json['name']) ?? JsonParse.toStr(JsonParse.toMap(json['file'])?['name']) ?? 'Unnamed Policy',
      enabled: JsonParse.toBool(json['enabled']) ?? true,
      policyId: JsonParse.toInt(json['policy_id']) ?? 0,
      fileId: JsonParse.toInt(json['file_id']) ?? 0,
      usageType: FileOperationType.values.firstWhere(
        (e) => e.name == (JsonParse.toStr(json['usage_type']) ?? 'download'),
        orElse: () => FileOperationType.download,
      ),
      destinationPath: JsonParse.toStr(json['destination_path']) ?? '',
      replaceIfExists: JsonParse.toBool(json['replace_if_exists']) ?? true,
      openAfterDownload: JsonParse.toBool(json['open_after_download']) ?? false,
      file: JsonParse.nested(json['file'], FileConfig.fromJson, field: 'file'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'enabled': enabled,
    'policy_id': policyId,
    'file_id': fileId,
    'usage_type': usageType.name,
    'destination_path': destinationPath,
    'replace_if_exists': replaceIfExists,
    'open_after_download': openAfterDownload,
    'file': file?.toJson(),
  };

  String get sourceUrl {
    final url = file?.publicUrl ?? file?.filePath ?? '';
    return url;
  }

  String? get hash => file?.fileHashSha256;

  @override
  String toString() {
    return 'FilePolicy(id: $id, name: $name, type: ${usageType.name}, path: $destinationPath, file: ${file?.fullName})';
  }
}
