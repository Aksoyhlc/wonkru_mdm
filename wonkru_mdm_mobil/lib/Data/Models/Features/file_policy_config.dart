import 'file_policy.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class FilePolicyConfig {
  final List<FilePolicy> policies;
  final List<String> filesToDelete;

  FilePolicyConfig({required this.policies, this.filesToDelete = const []});

  bool get isEmpty => policies.isEmpty && filesToDelete.isEmpty;

  bool get isNotEmpty => policies.isNotEmpty || filesToDelete.isNotEmpty;

  int get length => policies.length + filesToDelete.length;

  factory FilePolicyConfig.fromJson(Map<String, dynamic> json) {
    final files = JsonParse.listOf(json['files'], FilePolicy.fromJson, field: 'files');

    final filesToDelete = JsonParse.toStringList(json['files_to_delete']) ?? [];

    return FilePolicyConfig(policies: files, filesToDelete: filesToDelete);
  }
}
