import 'package:serverpod/serverpod.dart';

import '../config/storage_config.dart';
import '../enums/storage_area.dart';
import '../generated/protocol.dart';
import 'file_asset_service.dart';
import 'storage_url_service.dart';

/// Resolves the download links embedded in a policy payload.
///
/// A URL is built from the storage path, not from a stored absolute address, so
/// moving the server does not break existing policies; a stored `public_url` is
/// only the fallback for external addresses. A public path yields a direct
/// link, a private one a signed, time-limited link.
class PolicyDownloadUrls {
  const PolicyDownloadUrls._();

  /// Whether [value] is already an absolute `http(s)` address.
  static bool isAbsoluteUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.hasAuthority &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  /// The launcher background image: an absolute address is kept, a storage path
  /// becomes a direct (public) or signed (private) link.
  static Future<String?> launcherImage(Session session, String value) {
    if (isAbsoluteUrl(value)) return Future.value(value);
    final area = StorageArea.forPath(value);
    final disk = area?.defaultDisk ?? StorageConfig.publicDisk;
    if (disk == StorageConfig.privateDisk) {
      return StorageUrlService.signedUrl(
        session,
        value,
        lifetime: StorageUrlService.deviceLinkLifetime,
      );
    }
    return StorageUrlService.publicUrl(session, value);
  }

  /// Signed link for a certificate on the private disk, or null.
  static Future<String?> certificate(Session session, String path) =>
      StorageUrlService.signedUrl(
        session,
        path,
        lifetime: StorageUrlService.deviceLinkLifetime,
      );

  /// Resolves download URLs for [files], keyed by file id.
  ///
  /// If a path cannot be resolved (no bytes or an empty path) the stored
  /// `public_url` is the fallback; if neither exists the result is null and the
  /// payload is still built. Each file resolves per its own disk.
  static Future<Map<int, String?>> forFiles(
    Session session,
    Iterable<FileAsset> files,
  ) async {
    final urls = <int, String?>{};
    final pending = <int, FileAsset>{};
    final stored = <int, String>{};

    for (final file in files) {
      final id = file.id;
      if (id == null) {
        continue;
      }

      final existing = file.publicUrl;
      if (existing != null && existing.isNotEmpty) {
        stored[id] = existing;
      }
      if (file.filePath.isEmpty) {
        urls[id] = stored[id];
      } else {
        pending[id] = file;
      }
    }

    final publicFiles = <int, FileAsset>{};
    for (final entry in pending.entries) {
      if (FileAssetService.storageIdFor(entry.value.disk) ==
          StorageConfig.publicDisk) {
        publicFiles[entry.key] = entry.value;
      }
    }

    if (publicFiles.isNotEmpty) {
      final resolved = await forPaths(
        session,
        publicFiles.values.map((file) => file.filePath),
      );
      for (final entry in publicFiles.entries) {
        urls[entry.key] = resolved[entry.value.filePath] ?? stored[entry.key];
      }
    }

    for (final entry in pending.entries) {
      if (publicFiles.containsKey(entry.key)) {
        continue;
      }
      urls[entry.key] =
          await _privateSigned(session, entry.value.filePath) ??
          stored[entry.key];
    }

    return urls;
  }

  /// Signed download link for [path] on the private disk; null if the bytes are
  /// absent.
  ///
  /// The one-week lifetime is deliberate: a device may receive the policy and
  /// download the file only after being offline for a while.
  static Future<String?> _privateSigned(Session session, String path) async {
    try {
      final uri = await session.storage.temporaryDownloadUrl(
        storageId: StorageConfig.privateDisk,
        path: path,
        options: const TemporaryDownloadUrlOptions(
          expirationDuration: Duration(days: 7),
        ),
      );
      return uri.toString();
    } on CloudStorageException {
      return null;
    }
  }

  /// Public download links for [paths], keyed by path.
  static Future<Map<String, String?>> forPaths(
    Session session,
    Iterable<String?> paths,
  ) async {
    final wanted = <String>{
      for (final path in paths)
        if (path != null && path.isNotEmpty) path,
    };

    if (wanted.isEmpty) {
      return const {};
    }

    final ordered = wanted.toList();
    final resolved = await session.storage.publicDownloadUrls(
      storageId: StorageConfig.publicDisk,
      paths: ordered,
    );

    return {
      for (var i = 0; i < ordered.length; i++)
        ordered[i]: resolved[i]?.toString(),
    };
  }
}
