import '../enums/storage_area.dart';
import '../enums/upload_limit.dart';

/// One upload kind's storage area, size limit and file-type rules.
///
/// The server derives the storage path from [area], so the client can never
/// choose where a file lands.
class UploadPurpose {
  const UploadPurpose({
    required this.area,
    required this.limit,
    required this.defaultExtension,
    this.allowedExtensions,
    this.contentType,
  });

  final StorageArea area;

  /// The cap is read from Settings at runtime.
  final UploadLimit limit;

  final String defaultExtension;

  final Set<String>? allowedExtensions;

  final String? contentType;
}
