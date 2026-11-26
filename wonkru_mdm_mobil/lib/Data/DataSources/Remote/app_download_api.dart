import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/base_api.dart';
import 'package:wonkrumdm/Data/Models/Features/application_version.dart';

const _tag = 'AppDownloadApi';

class AppDownloadApi extends BaseApi {
  Future<String> _calculateFileHash(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<(bool, String?)> downloadApp({required String packageName, required ApplicationVersion appVersion}) async {
    try {
      final versionCode = appVersion.versionCode;
      WLog.i(_tag, "APK download starting -> $packageName (v$versionCode)");

      final downloadUrl = appVersion.downloadUrl;
      if (downloadUrl == null || downloadUrl.isEmpty) {
        WLog.w(_tag, "No APK download URL -> $packageName (v$versionCode)");
        lastMessage = 'APK download URL not found';
        return (false, null);
      }

      final expectedHash = appVersion.checksumSha256;

      final tempDir = await getTemporaryDirectory();
      final fileName = "$packageName-${versionCode ?? 'latest'}.apk";
      final savePath = "${tempDir.path}/$fileName";

      final dio = await createSecureDio();

      WLog.d(_tag, "Downloading file -> $downloadUrl");

      String lastProgressMessage = '';

      await dio.download(
        downloadUrl,
        savePath,
        options: Options(
          headers: {'Accept': 'application/vnd.android.package-archive'},
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 5), // Timeout for large files
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            if (progress != lastProgressMessage) {
              lastProgressMessage = progress;
              WLog.v(_tag, "Download progress -> $lastProgressMessage%");
            }
          }
        },
      );

      final file = File(savePath);
      if (!await file.exists()) {
        WLog.w(_tag, "Download failed - File not found");
        lastMessage = 'Downloaded file not found';
        return (false, null);
      }

      final fileSize = await file.length();
      WLog.i(_tag, "Download complete. File size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB");

      if (expectedHash != null && expectedHash.isNotEmpty) {
        WLog.d(_tag, "Checking hash");
        final actualHash = await _calculateFileHash(savePath);

        if (actualHash.toLowerCase() != expectedHash.toLowerCase()) {
          WLog.w(_tag, "Hash mismatch. Expected: $expectedHash, Got: $actualHash");

          try {
            await file.delete();
            WLog.d(_tag, "Corrupted file deleted");
          } catch (e, st) {
            WLog.e(_tag, "Error deleting file", error: e, stackTrace: st);
          }

          lastMessage = 'File integrity check failed! The downloaded file may be corrupted.';
          return (false, null);
        }
        WLog.d(_tag, "Hash check passed ✓");
      } else {
        WLog.d(_tag, "No hash info, check skipped");
      }

      return (true, savePath);
    } on DioException catch (e, s) {
      final (_, msg) = normalizeDioError(e, s);
      WLog.e(_tag, 'Download error (Dio): $msg', error: e, stackTrace: s);
      lastMessage = msg;
      return (false, null);
    } catch (e, s) {
      WLog.e(_tag, 'Download error', error: e, stackTrace: s);
      lastMessage = 'Unexpected error during download';
      return (false, null);
    }
  }
}