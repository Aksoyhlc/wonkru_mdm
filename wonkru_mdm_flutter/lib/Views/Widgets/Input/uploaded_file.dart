import 'dart:typed_data';

class UploadedFile {
  const UploadedFile({
    required this.storageId,
    required this.path,
    required this.fileName,
    required this.sizeBytes,
    required this.bytes,
    this.contentType,
    this.checksumSha256,
  });

  /// The disk the file was written to (`public` or `private`).
  final String storageId;

  /// Server-generated path within the disk.
  final String path;

  final String fileName;
  final int sizeBytes;
  final Uint8List bytes;
  final String? contentType;

  /// SHA-256 computed by the server during upload; null if it could not be
  /// computed. The panel never computes it: hashing a 100 MB file in the
  /// browser would freeze the UI for seconds.
  final String? checksumSha256;
}
