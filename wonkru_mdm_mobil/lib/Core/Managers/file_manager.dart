import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart'
    show FileOperationType;
import 'package:wonkrumdm/Core/Init/app_bootstrap.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Utils/device_path.dart';
import 'package:wonkrumdm/Core/Utils/hash_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/file_api.dart';
import 'package:wonkrumdm/Data/Models/Features/file_policy.dart';
import 'package:wonkrumdm/Data/Models/Features/file_policy_config.dart';

const _tag = 'FileManager';

class FileManager extends BaseManager<FilePolicyConfig> {
  static final FileManager _instance = FileManager._internal();

  factory FileManager() => _instance;

  FileManager._internal();

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final appDir = await getApplicationDocumentsDirectory();
      final tempDir = await getTemporaryDirectory();

      return {'appDocumentsPath': appDir.path, 'tempPath': tempDir.path};
    }, defaultValue: {});
  }

  final _fileApi = FileApi();

  @override
  Future<void> applyConfiguration(FilePolicyConfig config) async {
    await safeExecute(() async {
      if (config.isEmpty) {
        WLog.d(_tag, 'File list empty');
        return;
      }

      WLog.d(_tag, '${config.length} file operations pending...');

      if (config.filesToDelete.isNotEmpty) {
        WLog.d(_tag, '${config.filesToDelete.length} files to delete...');
        for (final path in config.filesToDelete) {
          await deleteFile(path);
        }
      }

      await applyPolicies(config.policies);
    }, logMessage: 'FileManager: File configuration completed');
  }

  Future<(bool, String)> downloadFile(
    String url,
    String destPath, {
    String? hash,
    bool openAfterDownload = false,
  }) async {
    final (success, result) = await _fileApi.downloadFile(url, destPath);

    if (!success) return (false, result);

    if (hash != null && hash.isNotEmpty) {
      final actualHash = await HashHelper.calculateFileHash(destPath);
      if (actualHash.toLowerCase() != hash.toLowerCase()) {
        await File(destPath).delete();
        return (false, "Hash verification failed: File may be corrupt");
      }
      WLog.d(_tag, "Hash verification passed");
    }

    if (openAfterDownload) {
      await openFile(destPath);
    }

    return (true, destPath);
  }

  Future<(bool, String)> deleteFile(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        WLog.d(_tag, "File already does not exist -> $path");
        return (true, "File already does not exist");
      }

      await file.delete();
      WLog.d(_tag, "File deleted -> $path");
      return (true, "File deleted successfully");
    } catch (e) {
      final msg = "File deletion error (path=$path): $e";
      WLog.d(_tag, "$msg");
      return (false, msg);
    }
  }

  Future<(bool, String)> deleteFolder(String path) async {
    try {
      final dir = Directory(path);

      if (!await dir.exists()) {
        WLog.d(_tag, "Folder already does not exist -> $path");
        return (true, "Folder already does not exist");
      }

      await dir.delete(recursive: true);
      WLog.d(_tag, "Folder deleted -> $path");
      return (true, "Folder deleted successfully");
    } catch (e) {
      final msg = "Folder deletion error (path=$path): $e";
      WLog.d(_tag, "$msg");
      return (false, msg);
    }
  }

  Future<(bool, String)> openFile(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        return (false, "File not found: $path");
      }

      WLog.d(_tag, "Opening file -> $path");
      final result = await OpenFile.open(path);

      if (result.type == ResultType.done) {
        WLog.d(_tag, "File opened successfully");
        return (true, "File opened successfully");
      } else {
        final msg = "Failed to open file: ${result.message}";
        WLog.d(_tag, "$msg");
        return (false, msg);
      }
    } catch (e) {
      final msg = "File open error (path=$path): $e";
      WLog.d(_tag, "$msg");
      return (false, msg);
    }
  }

  Future<void> applyPolicies(List<FilePolicy> policies) async {
    WLog.d(_tag, "Applying ${policies.length} policies...");

    final activePolicies = policies.where((p) {
      if (!p.enabled) {
        WLog.d(_tag, "Policy disabled, skipping -> ${p.name}");
        return false;
      }
      return true;
    }).toList();

    const int batchSize = 3;
    for (var i = 0; i < activePolicies.length; i += batchSize) {
      final end = (i + batchSize < activePolicies.length)
          ? i + batchSize
          : activePolicies.length;
      final batch = activePolicies.sublist(i, end);

      WLog.d(_tag, "Batch starting ($i - $end)");

      await Future.wait(batch.map((policy) => enforcePolicy(policy)));
    }

    WLog.d(_tag, "All policies applied.");
  }

  Future<void> enforcePolicy(FilePolicy policy) async {
    try {
      WLog.d(
        _tag,
        "Processing policy -> ${policy.usageType.name} (ID: ${policy.id})",
      );

      final targetPath = await _resolveDestinationPath(policy);
      WLog.d(_tag, "Resolved target path -> $targetPath");

      switch (policy.usageType) {
        case FileOperationType.download:
          await _handleDownloadPolicy(policy, targetPath);
          break;
        case FileOperationType.delete:
          await _handleDeletePolicy(policy, targetPath);
          break;
        case FileOperationType.open:
          await _handleOpenPolicy(policy, targetPath);
          break;
      }
    } catch (e) {
      WLog.d(_tag, "Policy error -> ${policy.id}: $e");
    }
  }

  Future<void> _handleDownloadPolicy(
    FilePolicy policy,
    String targetPath,
  ) async {
    if (targetPath.isEmpty) {
      WLog.d(_tag, "Target path not specified, skipping");
      return;
    }

    if (!isAbsoluteDevicePath(targetPath)) {
      WLog.w(
        _tag,
        "Relative target path rejected (absolute path required) -> '$targetPath'",
      );
      return;
    }

    final destFile = File(targetPath);
    bool needDownload = false;

    if (!await destFile.exists()) {
      needDownload = true;
      WLog.d(_tag, "File does not exist, will download");
    } else if (policy.hash != null && policy.hash!.isNotEmpty) {
      final actualHash = await HashHelper.calculateFileHash(targetPath);
      if (actualHash.toLowerCase() != policy.hash!.toLowerCase()) {
        needDownload = true;
        WLog.d(_tag, "Hash mismatch, file will be updated");
      } else {
        WLog.d(_tag, "File is up to date");
      }
    } else if (!policy.replaceIfExists) {
      WLog.d(_tag, "File exists and replaceIfExists=false, skipping");
      return;
    } else {
      needDownload = true;
    }

    if (needDownload) {
      final fullUrl = _resolveUrl(policy.sourceUrl);

      final (success, msg) = await downloadFile(
        fullUrl,
        targetPath,
        hash: policy.hash,
        openAfterDownload: policy.openAfterDownload,
      );

      if (success) {
        WLog.d(_tag, "Download completed -> $targetPath");
      } else {
        WLog.d(_tag, "Download failed -> $msg");
      }
    }
  }

  Future<void> _handleDeletePolicy(FilePolicy policy, String targetPath) async {
    if (targetPath.isEmpty) {
      WLog.d(_tag, "Delete path not specified, skipping");
      return;
    }

    if (!isAbsoluteDevicePath(targetPath)) {
      WLog.w(
        _tag,
        "Relative delete path rejected (absolute path required) -> '$targetPath'",
      );
      return;
    }

    final path = targetPath;

    if (await Directory(path).exists()) {
      final (success, msg) = await deleteFolder(path);
      WLog.d(_tag, "Folder deletion -> $msg");
    } else if (await File(path).exists()) {
      final (success, msg) = await deleteFile(path);
      WLog.d(_tag, "File deletion -> $msg");
    } else {
      WLog.d(_tag, "File/folder not found for deletion -> $path");
    }
  }

  Future<void> _handleOpenPolicy(FilePolicy policy, String targetPath) async {
    if (targetPath.isEmpty) {
      targetPath = await _getDefaultDownloadPath(policy.sourceUrl);
    }

    if (!isAbsoluteDevicePath(targetPath)) {
      WLog.w(
        _tag,
        "Relative open path rejected (absolute path required) -> '$targetPath'",
      );
      return;
    }

    if (!await File(targetPath).exists()) {
      WLog.d(_tag, "File not found, downloading first");
      final fullUrl = _resolveUrl(policy.sourceUrl);
      final (success, msg) = await downloadFile(
        fullUrl,
        targetPath,
        hash: policy.hash,
      );

      if (!success) {
        WLog.d(_tag, "Download failed, cannot open -> $msg");
        return;
      }
    }

    if (AppBootstrap.isHeadless) {
      WLog.d(_tag, "Headless mode, skipping file open");
      return;
    }

    final (success, msg) = await openFile(targetPath);
    WLog.d(_tag, "File open -> $msg");
  }

  Future<String> _getDefaultDownloadPath(String url) async {
    final uri = Uri.parse(url);
    final fileName = uri.pathSegments.isNotEmpty
        ? uri.pathSegments.last
        : 'downloaded_file';
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/Downloads/$fileName';
  }

  Future<String> _resolveDestinationPath(FilePolicy policy) async {
    final path = policy.destinationPath;
    if (path.isEmpty) return '';

    final file = policy.file;

    // File-less rows (delete) use the destination path as the on-device path directly.
    if (file == null) return path;

    Directory dic = await getApplicationDocumentsDirectory();
    String fileName = file.fullName;

    if (path.startsWith('custom')) {
      Uri? uri = Uri.tryParse(path);

      if (uri == null) {
        WLog.d(_tag, " custom path parsing failed, invalid URI -> $path");
        return '';
      }

      String? file_name = uri.queryParameters['file_name'];
      String? directory = uri.queryParameters['directory'];

      if (file_name != null && file_name.isNotEmpty) {
        fileName = file_name;
      }

      if (directory != null && directory.isNotEmpty) {
        if (directory == '_DOCUMENT_') {
          dic = await getApplicationDocumentsDirectory();
        } else if (directory == '_TEMP_') {
          dic = await getTemporaryDirectory();
        } else if (directory == '_DOWNLOAD_') {
          dic =
              (await getDownloadsDirectory()) ??
              Directory('/storage/emulated/0/Download');
        } else {
          dic = Directory(directory);
        }

        if (!await dic.exists()) {
          await dic.create(recursive: true);
        }
      }

      return '${dic.path}${Platform.pathSeparator}${fileName}';
    }

    if (path.endsWith(Platform.pathSeparator)) {
      return '$path$fileName';
    }

    if (await Directory(path).exists()) {
      return '$path${Platform.pathSeparator}${fileName}';
    }

    final lastSegment = path.split(Platform.pathSeparator).last;
    if (lastSegment.contains('.')) {
      return path;
    }

    return '$path${Platform.pathSeparator}${fileName}';
  }

  String _resolveUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http')) return url;
    // The server produces an absolute public_url for policy files; a relative path cannot be downloaded, so warn.
    WLog.w(_tag, "Relative file URL not supported -> $url");
    return url;
  }
}
