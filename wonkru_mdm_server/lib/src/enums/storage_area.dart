import '../config/storage_config.dart';

/// Folders uploaded files land in.
///
/// The upload path is produced in one place, so whichever endpoint writes (the
/// panel's signed upload, an endpoint's own `storeFile`, the device agent) the
/// same file type lands in the same folder. The path is relative to the disk;
/// on disk it is `storage/<disk>/<directory>/<file>`.
enum StorageArea {
  /// Application packages (APK); the device downloads them directly.
  applications('applications', StorageConfig.publicDisk),

  /// Certificates installed on devices (may carry a PKCS12 key). Private disk:
  /// the device downloads via the signed, time-limited link in the policy.
  certificates('certificates', StorageConfig.privateDisk),

  /// Kiosk/launcher background images; the device downloads them directly.
  launcherBackgrounds('launcher-backgrounds', StorageConfig.publicDisk),

  /// Files uploaded by device agents (screenshots, logs…). Private disk: the
  /// panel opens them via a signed, time-limited link.
  deviceUploads('device-uploads', StorageConfig.privateDisk),

  /// Free files uploaded from the panel. The disk is selectable per row:
  /// `private` to keep confidential, `public` for files the device fetches.
  files('files', StorageConfig.privateDisk, diskSelectable: true);

  const StorageArea(
    this.directory,
    this.defaultDisk, {
    this.diskSelectable = false,
  });

  final String directory;

  final String defaultDisk;

  final bool diskSelectable;

  String pathFor(String fileName) => '$directory/$fileName';

  bool owns(String path) => path.startsWith('$directory/');

  String diskFor(String? disk) {
    if (!diskSelectable || disk == null || disk.isEmpty) {
      return defaultDisk;
    }
    return StorageConfig.requireDisk(disk);
  }

  /// True for areas that are not disk-selectable and default to `private`; the
  /// public download route does not serve these folders.
  bool get privateOnly =>
      !diskSelectable && defaultDisk == StorageConfig.privateDisk;

  static StorageArea? forPath(String path) {
    for (final area in values) {
      if (area.owns(path)) return area;
    }
    return null;
  }
}
