import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Network/dio_factory.dart';

const _tag = 'FileCache';

class FileCache {
  static FileCache? _instance;

  static FileCache get instance => _instance ??= FileCache._();

  FileCache._();

  Directory? _cacheDir;

  Duration cacheDuration = const Duration(hours: 24);

  Future<Directory> get cacheDirectory async {
    if (_cacheDir != null) return _cacheDir!;

    final tempDir = await getTemporaryDirectory();
    _cacheDir = Directory('${tempDir.path}/file_cache');

    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }

    return _cacheDir!;
  }

  String _generateFileName(String url) {
    final bytes = utf8.encode(url);
    final digest = sha256.convert(bytes);

    final uri = Uri.parse(url);
    final path = uri.path;
    String extension = '';

    if (path.contains('.')) {
      extension = path.substring(path.lastIndexOf('.'));
      if (![
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'pdf',
        'txt',
        'json',
      ].contains(extension.toLowerCase().replaceAll('.', ''))) {
        extension = '';
      }
    }

    return '${digest.toString()}$extension';
  }

  Future<bool> _isCacheValid(File file) async {
    if (!await file.exists()) return false;

    final stat = await file.stat();
    final now = DateTime.now();
    final fileAge = now.difference(stat.modified);

    return fileAge <= cacheDuration;
  }

  Future<String?> downloadAndCache(
    String url, {
    Duration? customCacheDuration,
  }) async {
    try {
      final cacheDir = await cacheDirectory;
      final fileName = _generateFileName(url);
      final file = File('${cacheDir.path}/$fileName');

      if (await _isCacheValid(file)) {
        WLog.v(_tag, 'Cache hit for $url');
        return file.path;
      }

      WLog.d(_tag, 'Downloading $url');

      final dio = DioFactory.create();
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (_) => true,
        ),
      );

      if (response.statusCode == 200) {
        final bytes = response.data;
        if (bytes == null) {
          WLog.w(_tag, 'Download failed for $url (empty body)');
          return null;
        }
        await file.writeAsBytes(bytes);
        WLog.d(_tag, 'Downloaded and cached $url -> ${file.path}');
        return file.path;
      } else {
        WLog.w(_tag, 'Download failed for $url (${response.statusCode})');
        return null;
      }
    } catch (e, st) {
      WLog.e(_tag, 'Error downloading $url', error: e, stackTrace: st);
      return null;
    }
  }

  Future<bool> clearCache(String url) async {
    try {
      final cacheDir = await cacheDirectory;
      final fileName = _generateFileName(url);
      final file = File('${cacheDir.path}/$fileName');

      if (await file.exists()) {
        await file.delete();
        WLog.d(_tag, 'Cleared cache for $url');
        return true;
      }

      return false;
    } catch (e, st) {
      WLog.e(_tag, 'Error clearing cache for $url', error: e, stackTrace: st);
      return false;
    }
  }

  Future<bool> clearAllCache() async {
    try {
      final cacheDir = await cacheDirectory;

      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        _cacheDir = null;
        WLog.i(_tag, 'Cleared all cache');
        return true;
      }

      return false;
    } catch (e, st) {
      WLog.e(_tag, 'Error clearing all cache', error: e, stackTrace: st);
      return false;
    }
  }

  Future<int> cleanExpiredCache() async {
    try {
      final cacheDir = await cacheDirectory;
      int deletedCount = 0;

      if (await cacheDir.exists()) {
        final files = cacheDir
            .listSync()
            .where((entity) => entity is File)
            .cast<File>();

        for (final file in files) {
          if (!await _isCacheValid(file)) {
            await file.delete();
            deletedCount++;
          }
        }
      }

      WLog.d(_tag, 'Cleaned $deletedCount expired files');
      return deletedCount;
    } catch (e, st) {
      WLog.e(_tag, 'Error cleaning expired cache', error: e, stackTrace: st);
      return 0;
    }
  }

  Future<int> getCacheSize() async {
    try {
      final cacheDir = await cacheDirectory;
      int totalSize = 0;

      if (await cacheDir.exists()) {
        final files = cacheDir
            .listSync(recursive: true)
            .where((entity) => entity is File)
            .cast<File>();

        for (final file in files) {
          final stat = await file.stat();
          totalSize += stat.size;
        }
      }

      return totalSize;
    } catch (e, st) {
      WLog.e(_tag, 'Error calculating cache size', error: e, stackTrace: st);
      return 0;
    }
  }

  Future<String?> getCachedPath(String url) async {
    try {
      final cacheDir = await cacheDirectory;
      final fileName = _generateFileName(url);
      final file = File('${cacheDir.path}/$fileName');

      if (await _isCacheValid(file)) {
        return file.path;
      }

      return null;
    } catch (e, st) {
      WLog.e(
        _tag,
        'Error checking cached path for $url',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<Uint8List?> getCachedBytes(String url) async {
    try {
      final path = await getCachedPath(url);
      if (path != null) {
        final file = File(path);
        return await file.readAsBytes();
      }
      return null;
    } catch (e, st) {
      WLog.e(
        _tag,
        'Error reading cached bytes for $url',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}