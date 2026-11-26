import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../config/storage_config.dart';
import 'storage_signature.dart';

/// Stores files on disk instead of in the database: Serverpod ships only the
/// database, S3, and GCS providers, and holding 100 MB APKs in Postgres `bytea`
/// bloats the database and slows reads and writes. Files live under
/// `storage/<storageId>/...`, where `storageId` is the directory name
/// (`private`, `public`).
///
/// Each file has a small `<file>.meta` JSON sidecar with its content type, HTTP
/// headers, and a sha256 computed while streaming the upload, so the checksum
/// does not require reading the file again. Upload and download links are signed
/// with [StorageSignature]; no extra database row is kept.
class LocalFileCloudStorage extends CloudStorage {
  LocalFileCloudStorage(
    super.storageId, {
    required this.publicBaseUrl,
    required this.signature,
    Directory? root,
  }) : _root = root ?? StorageConfig.root;

  final Uri publicBaseUrl;

  final StorageSignature signature;

  final Directory _root;

  /// Must match the path `server.dart` registers.
  static const uploadPath = '/storage/upload';

  static const downloadPath = '/storage/file';

  static const metadataSuffix = '.meta';

  /// Path traversal (`..`, `.`, empty segments) is rejected.
  File fileFor(String path) {
    final normalized = _normalize(path);
    return File('${_root.path}/$storageId/$normalized');
  }

  File _metadataFor(String path) =>
      File('${fileFor(path).path}$metadataSuffix');

  static String _normalize(String path) {
    final trimmed = path.startsWith('/') ? path.substring(1) : path;
    final segments = trimmed.split('/');
    if (segments.any((s) => s == '..' || s == '.' || s.isEmpty)) {
      throw CloudStorageException('Invalid storage path "$path".');
    }
    return segments.join('/');
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    StoreFileOptions options = const StoreFileOptions(),
  }) async {
    final file = fileFor(path);

    if (options.preventOverwrite && file.existsSync()) {
      throw CloudStorageFileAlreadyExistsException(
        storageId: storageId,
        path: path,
      );
    }

    final bytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );

    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    await writeMetadata(
      path: path,
      metadata: options.metadata,
      checksumSha256: sha256.convert(bytes).toString(),
      size: bytes.length,
    );
  }

  Future<void> writeMetadata({
    required String path,
    required FileMetadata metadata,
    required String checksumSha256,
    required int size,
  }) async {
    final file = _metadataFor(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(
      jsonEncode({
        'contentType': metadata.contentType,
        'cacheControl': metadata.cacheControl,
        'contentDisposition': metadata.contentDisposition,
        'contentEncoding': metadata.contentEncoding,
        'custom': metadata.custom,
        'sha256': checksumSha256,
        'size': size,
      }),
      flush: true,
    );
  }

  Future<Map<String, dynamic>> readMetadata(String path) async {
    final file = _metadataFor(path);
    if (!file.existsSync()) return const {};

    try {
      final decoded = jsonDecode(await file.readAsString());
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
    }
  }

  Future<String?> checksumOf(String path) async {
    final metadata = await readMetadata(path);
    final stored = metadata['sha256'];
    if (stored is String && stored.isNotEmpty) return stored;

    final file = fileFor(path);
    if (!file.existsSync()) return null;

    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  @override
  Future<ByteData> retrieveFile({
    required Session session,
    required String path,
  }) async {
    final file = fileFor(path);
    if (!file.existsSync()) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }

    return ByteData.sublistView(await file.readAsBytes());
  }

  @override
  Future<FileStat> statFile({
    required Session session,
    required String path,
  }) async {
    final file = fileFor(path);
    if (!file.existsSync()) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }

    final stat = await file.stat();
    final metadata = await readMetadata(path);

    return FileStat(
      size: stat.size,
      lastModified: stat.modified,
      contentType: metadata['contentType'] as String?,
      cacheControl: metadata['cacheControl'] as String?,
      contentDisposition: metadata['contentDisposition'] as String?,
      contentEncoding: metadata['contentEncoding'] as String?,
      custom: {
        for (final entry in (metadata['custom'] as Map? ?? const {}).entries)
          '${entry.key}': '${entry.value}',
      },
    );
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    final file = fileFor(path);
    if (file.existsSync()) await file.delete();

    final metadata = _metadataFor(path);
    if (metadata.existsSync()) await metadata.delete();
  }

  @override
  Future<Uri> publicDownloadUrl({
    required Session session,
    required String path,
  }) async {
    if (!fileFor(path).existsSync()) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }

    return _downloadUri(path);
  }

  @override
  Future<Uri> temporaryDownloadUrl({
    required Session session,
    required String path,
    TemporaryDownloadUrlOptions options = const TemporaryDownloadUrlOptions(),
  }) async {
    options.validate();

    if (!fileFor(path).existsSync()) {
      throw CloudStorageFileNotFoundException(
        storageId: storageId,
        path: path,
      );
    }

    final token = signature.signDownload(
      storageId: storageId,
      path: path,
      expiration: DateTime.now().toUtc().add(options.expirationDuration),
    );

    return _downloadUri(path, token: token);
  }

  @override
  Future<UploadDescription> createUploadDescription({
    required Session session,
    required String path,
    UploadOptions options = const UploadOptions(),
  }) async {
    options.validate();

    final token = signature.signUpload(
      storageId: storageId,
      path: path,
      maxSize: options.maxFileSize,
      contentLength: options.contentLength,
      preventOverwrite: options.preventOverwrite,
      expiration: DateTime.now().toUtc().add(options.expirationDuration),
    );

    // Only the content type travels outside the token; everything else the
    // upload route needs is in it.
    return BinaryUploadDescription(
      url: _uploadBaseUrl(
        session,
      ).replace(path: uploadPath, queryParameters: {'token': token}),
      method: 'POST',
      headers: {
        if (options.metadata.contentType != null)
          'Content-Type': options.metadata.contentType!,
      },
    );
  }

  /// Scheme and port come from configuration but the host is taken from the
  /// request's `Host` header, so an upload reaches an address the caller can
  /// actually use even when the configured host is not reachable from them.
  Uri _uploadBaseUrl(Session session) {
    final host = _requestHostName(session.request);
    return host == null ? publicBaseUrl : publicBaseUrl.replace(host: host);
  }

  static String? _requestHostName(Request? request) {
    if (request == null) return null;

    String? value;
    try {
      final values = request.headers['host'];
      value = values == null || values.isEmpty ? null : values.first.trim();
    } catch (_) {
      return null;
    }
    if (value == null || value.isEmpty) return null;

    // IPv6: `[::1]:8090` → `::1`
    if (value.startsWith('[')) {
      final end = value.indexOf(']');
      return end <= 1 ? null : value.substring(1, end);
    }

    return value.split(':').first;
  }

  @override
  Future<bool> verifyUpload({
    required Session session,
    required String path,
  }) async => fileFor(path).existsSync();

  Uri _downloadUri(String path, {String? token}) => publicBaseUrl.replace(
    path: '$downloadPath/$storageId/${_normalize(path)}',
    queryParameters: token == null ? null : {'token': token},
  );
}
