import 'dart:io';

/// The server's on-disk file layout.
///
/// Root `storage/` holds two access areas:
///
/// ```
/// storage/
///   private/   unreadable without a signed link
///   public/    directly downloadable
/// ```
///
/// [StorageArea] decides the folders under each area. The disk id
/// (`private` / `public`) is the directory name; there is no separate mapping.
class StorageConfig {
  const StorageConfig._();

  static const privateDisk = 'private';

  static const publicDisk = 'public';

  static const disks = <String>{privateDisk, publicDisk};

  /// Storage root; override with `STORAGE_PATH`.
  static Directory get root =>
      Directory(Platform.environment['STORAGE_PATH'] ?? 'storage');

  static Directory get privateRoot => diskRoot(privateDisk);

  static Directory get publicRoot => diskRoot(publicDisk);

  static Directory diskRoot(String storageId) =>
      Directory('${root.path}/$storageId');

  static File privateFile(String path) => File('${privateRoot.path}/$path');

  static File publicFile(String path) => File('${publicRoot.path}/$path');

  /// Throws if [storageId] is not a known disk.
  static String requireDisk(String storageId) {
    if (!disks.contains(storageId)) {
      throw Exception('Unknown storage "$storageId".');
    }
    return storageId;
  }
}
