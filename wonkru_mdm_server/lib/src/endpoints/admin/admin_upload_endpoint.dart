import 'package:serverpod/serverpod.dart';

import '../../config/storage_config.dart';
import '../../config/upload_purpose.dart';
import '../../enums/storage_area.dart';
import '../../enums/upload_limit.dart';
import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/storage_url_service.dart';
import '../../storage/local_file_cloud_storage.dart';
import 'admin_certificate_endpoint.dart';

/// The storage path is always derived server-side from the purpose; the client
/// cannot choose where a file lands.
class AdminUploadEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const publicStorageId = StorageConfig.publicDisk;
  static const privateStorageId = StorageConfig.privateDisk;

  static const _apk = 'apk';
  static const _certificate = 'certificate';
  static const _file = 'file';
  static const _launcherBackground = 'launcherBackground';

  /// [disk] (`private` or `public`, default `private`) overrides storage for the
  /// `file` purpose only.
  Future<AdminUploadDescription> getUploadDescription(
    Session session,
    String purpose,
    String fileName,
    int? sizeBytes, {
    String? disk,
  }) async {
    await AdminAuthService.requireAdmin(session);

    final spec = _purpose(purpose);
    final storageId = spec.area.diskFor(disk);

    // Clamp the configured limit to the server's maxRequestSize ceiling.
    final configured = await spec.limit.maxBytes(session);
    final ceiling = UploadLimit.ceilingBytes(session);
    final maxFileSize = configured < ceiling ? configured : ceiling;

    final contentLength = sizeBytes != null && sizeBytes >= 0
        ? sizeBytes
        : null;
    if (contentLength != null && contentLength > maxFileSize) {
      throw AdminUploadException(
        message:
            'File is too large for this upload: '
            '${_megabytes(contentLength)} MB. '
            'The upper limit is ${_megabytes(maxFileSize)} MB. '
            'The limit can be changed under Settings > Upload Limits.',
        purpose: purpose,
        maxSizeBytes: maxFileSize,
        sizeBytes: contentLength,
      );
    }

    final extension = _extension(fileName, spec);
    final path = spec.area.pathFor('${const Uuid().v7()}.$extension');

    final description = await session.storage.createUploadDescription(
      storageId: storageId,
      path: path,
      options: UploadOptions(
        maxFileSize: maxFileSize,
        contentLength: contentLength,
        metadata: FileMetadata(contentType: _contentType(spec, extension)),
      ),
    );

    return AdminUploadDescription(
      storageId: storageId,
      path: path,
      description: description,
    );
  }

  /// Only panel-managed folders are accepted, so a forged path cannot be probed.
  Future<bool> verifyUpload(
    Session session,
    String storageId,
    String path,
  ) async {
    await AdminAuthService.requireAdmin(session);

    _requireStorage(storageId);
    _requireManagedPath(path);

    return session.storage.verifyUpload(storageId: storageId, path: path);
  }

  /// SHA-256 of a stored upload, or null when the storage keeps none.
  Future<String?> fileChecksum(
    Session session,
    String storageId,
    String path,
  ) async {
    await AdminAuthService.requireAdmin(session);

    _requireStorage(storageId);
    _requireManagedPath(path);

    final storage = session.serverpod.storage[storageId];
    if (storage is! LocalFileCloudStorage) return null;

    return storage.checksumOf(path);
  }

  /// Private-only areas get a short-lived signed URL; null for unmanaged paths or
  /// missing files.
  Future<String?> publicDownloadUrl(Session session, String path) async {
    await AdminAuthService.requireAdmin(session);

    final area = _areaOf(path);
    if (area == null) {
      return null;
    }
    if (area.privateOnly) {
      return StorageUrlService.signedUrl(
        session,
        path,
        lifetime: StorageUrlService.panelLinkLifetime,
      );
    }

    final url = await session.storage.publicDownloadUrl(
      storageId: publicStorageId,
      path: path,
    );
    return url.toString();
  }

  static UploadPurpose _purpose(String purpose) => switch (purpose) {
    _apk => const UploadPurpose(
      area: StorageArea.applications,
      limit: UploadLimit.apk,
      allowedExtensions: {'apk'},
      contentType: 'application/vnd.android.package-archive',
      defaultExtension: 'apk',
    ),
    _certificate => const UploadPurpose(
      area: StorageArea.certificates,
      limit: UploadLimit.certificate,
      // Shared with the certificate endpoint so p7b/p7c are not rejected here.
      allowedExtensions: AdminCertificateEndpoint.allowedExtensions,
      contentType: 'application/x-pem-file',
      defaultExtension: 'pem',
    ),
    _file => const UploadPurpose(
      area: StorageArea.files,
      limit: UploadLimit.file,
      contentType: 'application/octet-stream',
      defaultExtension: 'bin',
    ),
    _launcherBackground => const UploadPurpose(
      area: StorageArea.launcherBackgrounds,
      limit: UploadLimit.launcherBackground,
      allowedExtensions: {'png', 'jpg', 'jpeg', 'webp'},
      defaultExtension: 'png',
    ),
    _ => throw Exception('Unknown upload purpose "$purpose".'),
  };

  static void _requireStorage(String storageId) =>
      StorageConfig.requireDisk(storageId);

  /// The folder the device writes to is deliberately excluded.
  static const _managedAreas = <StorageArea>{
    StorageArea.applications,
    StorageArea.certificates,
    StorageArea.launcherBackgrounds,
    StorageArea.files,
  };

  static StorageArea? _areaOf(String path) {
    final area = StorageArea.forPath(path);
    return area != null && _managedAreas.contains(area) ? area : null;
  }

  static void _requireManagedPath(String path) {
    if (_areaOf(path) == null) {
      throw Exception('Upload path is not a managed upload folder.');
    }
  }

  /// Non-alphanumerics are dropped so a crafted name cannot inject a path
  /// separator or a second extension.
  static String _extension(String fileName, UploadPurpose purpose) {
    final dot = fileName.lastIndexOf('.');
    final raw = dot < 0 || dot == fileName.length - 1
        ? ''
        : fileName.substring(dot + 1).toLowerCase();
    final sanitized = raw.replaceAll(RegExp('[^a-z0-9]'), '');

    if (sanitized.isEmpty) {
      return purpose.defaultExtension;
    }

    final allowed = purpose.allowedExtensions;
    if (allowed != null && !allowed.contains(sanitized)) {
      throw Exception('Unsupported file type for this upload purpose.');
    }

    return sanitized;
  }

  static String _megabytes(int bytes) =>
      (bytes / UploadLimit.mebibyte).toStringAsFixed(1);

  static String _contentType(UploadPurpose purpose, String extension) {
    final contentType = purpose.contentType;
    if (contentType != null) {
      return contentType;
    }

    return switch (extension) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      _ => 'application/octet-stream',
    };
  }
}
