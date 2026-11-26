import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Data/Repositories/upload_repository.dart';

class FileUploadController extends GetxController {
  /// With a known size the limit is checked on the server before transfer.
  Future<AdminUploadDescription> describe(
    String purpose,
    String fileName,
    int sizeBytes, {
    String? disk,
  }) => UploadRepository.getUploadDescription(
    purpose,
    fileName,
    sizeBytes,
    disk: disk,
  );

  Future<bool> verify(String storageId, String path) =>
      UploadRepository.verifyUpload(storageId, path);

  Future<String?> checksum(String storageId, String path) =>
      UploadRepository.fileChecksum(storageId, path);
}
