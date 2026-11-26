import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/base_api.dart';

const _tag = 'FileApi';

class FileApi extends BaseApi {
  static final FileApi _instance = FileApi._internal();
  factory FileApi() => _instance;
  FileApi._internal();

  Future<(bool, String)> downloadFile(
    String url,
    String destPath, {
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      WLog.d(_tag, 'Downloading file -> $url');

      final destDir = Directory(destPath).parent;
      if (!await destDir.exists()) {
        await destDir.create(recursive: true);
        WLog.d(_tag, 'Target directory created -> ${destDir.path}');
      }

      final dio = await createSecureDio();

      await dio.download(
        url,
        destPath,
        options: Options(
          receiveTimeout: const Duration(minutes: 10),
        ),
        onReceiveProgress: (received, total) {
          onProgress?.call(received, total);

          if (total != -1 && onProgress == null) {
            final progress = (received / total * 100).toStringAsFixed(0);
            if (int.tryParse(progress) != null && int.parse(progress) % 10 == 0) {
              WLog.v(_tag, 'Download -> $progress%');
            }
          }
        },
      );

      final file = File(destPath);
      if (!await file.exists()) {
        WLog.w(_tag, 'File not found after download -> $destPath');
        return (false, 'Could not create file');
      }

      final size = await file.length();
      WLog.i(_tag, 'Download complete -> ${(size / 1024 / 1024).toStringAsFixed(2)} MB');

      return (true, destPath);
    } on DioException catch (e, s) {
      final (_, msg) = normalizeDioError(e, s);
      WLog.e(_tag, 'Download error (Dio): $msg', error: e, stackTrace: s);
      return (false, msg);
    } catch (e, s) {
      WLog.e(_tag, 'Unexpected download error', error: e, stackTrace: s);
      return (false, 'Unexpected error during download');
    }
  }

  Future<(bool, String)> uploadFile(
    String filePath,
    String uploadUrl, {
    String fieldName = 'file',
    Map<String, String>? extraFields,
    String? fileHash,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        WLog.w(_tag, 'File to upload not found -> $filePath');
        return (false, 'File not found');
      }

      final fileSize = await file.length();
      final fileName = filePath.split('/').last;
      WLog.d(_tag, 'Uploading file -> $fileName (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)');

      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath, filename: fileName),
        if (fileHash != null) 'hash': fileHash,
        ...?extraFields,
      });

      final dio = await createSecureDio();

      final response = await dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          sendTimeout: const Duration(minutes: 10),
          receiveTimeout: const Duration(minutes: 5),
        ),
        onSendProgress: (sent, total) {
          onProgress?.call(sent, total);

          if (total != -1 && onProgress == null) {
            final progress = (sent / total * 100).toStringAsFixed(0);
            if (int.tryParse(progress) != null && int.parse(progress) % 10 == 0) {
              WLog.v(_tag, 'Upload -> $progress%');
            }
          }
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        WLog.i(_tag, 'Upload complete');

        final responseData = response.data;
        if (responseData is Map && responseData.containsKey('message')) {
          return (true, responseData['message'].toString());
        }
        if (responseData is Map && responseData.containsKey('id')) {
          return (true, "Uploaded: ${responseData['id']}");
        }

        return (true, "File uploaded successfully");
      } else {
        WLog.w(_tag, 'Upload failed: HTTP ${response.statusCode}');
        return (false, 'Upload failed (HTTP ${response.statusCode})');
      }
    } on DioException catch (e, s) {
      final (_, msg) = normalizeDioError(e, s);
      WLog.e(_tag, 'Upload error (Dio): $msg', error: e, stackTrace: s);
      return (false, msg);
    } catch (e, s) {
      WLog.e(_tag, 'Unexpected upload error', error: e, stackTrace: s);
      return (false, 'Unexpected error during upload');
    }
  }
}