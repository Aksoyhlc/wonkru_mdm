import 'package:serverpod/serverpod.dart';

import '../config/storage_config.dart';
import '../generated/protocol.dart';
import 'policy_version_service.dart';

/// A file change invalidates every policy that ships it; deleting a file row
/// also removes the bytes it points at.
class FileAssetService {
  const FileAssetService._();

  static const fallbackStorageId = StorageConfig.privateDisk;

  static String storageIdFor(StorageDisk? disk) =>
      disk?.name ?? fallbackStorageId;

  static Future<void> bumpAffectedPolicies(
    Session session,
    int fileId, {
    Transaction? transaction,
  }) async {
    await PolicyVersionService.bumpForFile(
      session,
      fileId,
      transaction: transaction,
    );
  }

  static Future<void> onDeleting(
    Session session,
    FileAsset file, {
    Transaction? transaction,
  }) async {
    await deleteFromStorage(session, file);

    final fileId = file.id;
    if (fileId != null) {
      await bumpAffectedPolicies(session, fileId, transaction: transaction);
    }
  }

  static Future<void> onForceDeleted(Session session, FileAsset file) =>
      deleteFromStorage(session, file);

  /// An empty path, a missing object or a storage failure never propagates: a
  /// failed cleanup must not block the delete itself.
  static Future<void> deleteFromStorage(Session session, FileAsset file) async {
    final path = file.filePath;
    if (path.isEmpty) {
      return;
    }

    final disk = file.disk;
    final storageId = storageIdFor(disk);

    try {
      final exists = await session.storage.fileExists(
        storageId: storageId,
        path: path,
      );

      if (!exists) {
        session.log(
          'File to delete not found in storage',
          level: LogLevel.debug,
          metadata: {'fileId': file.id, 'path': path, 'storageId': storageId},
        );
        return;
      }

      await session.storage.deleteFile(storageId: storageId, path: path);
      session.log(
        'File deleted from storage',
        level: LogLevel.debug,
        metadata: {'fileId': file.id, 'path': path, 'storageId': storageId},
      );
    } catch (exception, stackTrace) {
      session.log(
        'Error while deleting file from storage',
        level: LogLevel.error,
        exception: exception,
        stackTrace: stackTrace,
        metadata: {'fileId': file.id, 'path': path, 'storageId': storageId},
      );
    }
  }
}
