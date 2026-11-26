import 'package:serverpod/serverpod.dart';

import '../config/storage_config.dart';

/// Public disk files get a direct URL; private disk files are only reachable
/// through a signed, time-limited URL.
class StorageUrlService {
  const StorageUrlService._();

  static const panelLinkLifetime = Duration(minutes: 10);

  /// Long enough that a device can fetch the policy and still download it
  /// after being offline for a while.
  static const deviceLinkLifetime = Duration(days: 7);

  /// Returns `null` when the file is missing, so payloads can still be built
  /// for rows whose bytes were never uploaded.
  static Future<String?> publicUrl(Session session, String path) async {
    if (path.isEmpty) {
      return null;
    }

    final urls = await session.storage.publicDownloadUrls(
      storageId: StorageConfig.publicDisk,
      paths: [path],
    );

    return urls.first?.toString();
  }

  /// Returns `null` when the file is missing or the storage cannot sign.
  static Future<String?> signedUrl(
    Session session,
    String path, {
    required Duration lifetime,
    String? downloadFileName,
  }) async {
    if (path.isEmpty) {
      return null;
    }
    try {
      final uri = await session.storage.temporaryDownloadUrl(
        storageId: StorageConfig.privateDisk,
        path: path,
        options: TemporaryDownloadUrlOptions(
          expirationDuration: lifetime,
          downloadFileName: downloadFileName,
        ),
      );
      return uri.toString();
    } on CloudStorageException {
      return null;
    }
  }
}
