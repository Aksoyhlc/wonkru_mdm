import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

/// The panel does not send files over RPC: it asks the server for an upload
/// description, hands it to `FileUploader`, then verifies the result.
class UploadRepository {
  const UploadRepository._();

  /// When `sizeBytes` is known the size limit is checked up front on the
  /// server. `disk` selects the store only for the `file` purpose
  /// (`private`/`public`); other purposes use a fixed store.
  static Future<AdminUploadDescription> getUploadDescription(
    String purpose,
    String fileName,
    int? sizeBytes, {
    String? disk,
  }) => serverpodClient.adminUpload.getUploadDescription(
    purpose,
    fileName,
    sizeBytes,
    disk: disk,
  );

  static Future<bool> verifyUpload(String storageId, String path) =>
      serverpodClient.adminUpload.verifyUpload(storageId, path);

  static Future<String?> fileChecksum(String storageId, String path) =>
      serverpodClient.adminUpload.fileChecksum(storageId, path);

  static Future<String?> publicDownloadUrl(String path) =>
      serverpodClient.adminUpload.publicDownloadUrl(path);
}
