import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show CertificateAction, RestrictionCatalog;

import '../config/storage_config.dart';
import '../generated/protocol.dart';
import '../util/json_utils.dart';
import 'policy_download_urls.dart';
import 'policy_payload_normalizer.dart';
import 'wlog_config_service.dart';

/// Builds the policy payload delivered to devices.
///
/// The payload stays a plain snake_case map on purpose: the Android agent parses
/// exactly that structure.
class PolicyPayloadService {
  const PolicyPayloadService._();

  static const _defaultFullSyncCron = '0 * * * *';
  static const _defaultMaxIntervalMinutes = 60;

  static Future<String> buildJson(Session session, Policy policy) async =>
      jsonEncode(await buildMap(session, policy));

  static Future<Map<String, dynamic>> buildMap(
    Session session,
    Policy policy, {
    Transaction? transaction,
  }) async {
    final policyId = policy.id!;

    return {
      'id': policyId,
      'name': policy.name,
      'slug': policy.slug,
      'description': policy.description,
      'version': policy.version,
      'is_active': policy.isActive,
      'default_policy': policy.defaultPolicy,
      'active_time_ranges': _decode(policy.activeTimeRanges),
      'battery_settings': _settings('battery_settings', policy.batterySettings),
      'storage_settings': _settings('storage_settings', policy.storageSettings),
      'audio_settings': _settings('audio_settings', policy.audioSettings),
      'display_settings': _settings('display_settings', policy.displaySettings),
      'security_settings': _settings(
        'security_settings',
        policy.securitySettings,
      ),
      'other_settings': _settings('other_settings', policy.otherSettings),
      'sync_settings': _syncSettings(policy),
      'restriction_settings': _restrictionSettings(policy),
      'launcher': await _launcher(session, policy.launcher),
      'applications': {
        'management_apps': await _applications(
          session,
          policyId,
          transaction: transaction,
        ),
      },
      'files': await _files(session, policyId, transaction: transaction),
      'certificates': await _certificates(
        session,
        policyId,
        transaction: transaction,
      ),
      'wlog_config': await WlogConfigService.build(
        session,
        transaction: transaction,
      ),
      'created_at': policy.createdAt?.toIso8601String(),
      'updated_at': policy.updatedAt?.toIso8601String(),
    };
  }

  static dynamic _settings(String column, String? raw) =>
      PolicyPayloadNormalizer.normalizeColumn(column, _decode(raw));

  /// The `launcher` column: normalised, then its background image is converted
  /// from a storage path to an absolute URL the device can download.
  ///
  /// The panel stores the uploaded image's path; the agent downloads only
  /// `http(s)` addresses. Absolute addresses (an external CDN) stay as-is. A
  /// path on the public disk yields a direct link, a private one the same 7-day
  /// signed link as certificates. Missing bytes make `image` null, so the device
  /// falls back to a colour background.
  static Future<dynamic> _launcher(Session session, String? raw) async {
    final launcher = _settings('launcher', raw);
    if (launcher is! Map<String, dynamic>) return launcher;

    // The agent reads a missing `mode` as true, so default it to false: a key
    // never touched in the panel must not force the device into kiosk mode.
    launcher.putIfAbsent('mode', () => false);

    final design = launcher['design'];
    if (design is! Map<String, dynamic>) return launcher;
    final background = design['background'];
    if (background is! Map<String, dynamic>) return launcher;

    final image = background['image'];
    if (image is String && image.trim().isNotEmpty) {
      background['image'] = await PolicyDownloadUrls.launcherImage(
        session,
        image.trim(),
      );
    }
    return launcher;
  }

  static Future<List<Map<String, dynamic>>> _applications(
    Session session,
    int policyId, {
    Transaction? transaction,
  }) async {
    final policyApplications = await PolicyApplication.db.find(
      session,
      where: (t) => t.policyId.equals(policyId),
      orderBy: (t) => t.sort,
      transaction: transaction,
    );

    final applications = <Application?>[];
    final versions = <ApplicationVersion?>[];

    for (final entry in policyApplications) {
      final applicationId = entry.applicationId;
      applications.add(
        await Application.db.findById(
          session,
          applicationId,
          transaction: transaction,
        ),
      );

      final targetVersionId = entry.targetVersionId;
      versions.add(
        targetVersionId != null
            ? await ApplicationVersion.db.findById(
                session,
                targetVersionId,
                transaction: transaction,
              )
            : await ApplicationVersion.db.findFirstRow(
                session,
                where: (t) =>
                    t.applicationId.equals(applicationId) &
                    t.isActive.equals(true),
                orderByList: (t) => [t.isDefault.desc(), t.versionCode.desc()],
                transaction: transaction,
              ),
      );
    }

    // Every version's download URL is resolved in one storage lookup.
    final urls = await PolicyDownloadUrls.forPaths(
      session,
      versions.whereType<ApplicationVersion>().map(
        (version) => version.filePath,
      ),
    );

    return [
      for (var i = 0; i < policyApplications.length; i++)
        _applicationEntry(
          policyApplications[i],
          applications[i],
          versions[i],
          urls,
        ),
    ];
  }

  static Map<String, dynamic> _applicationEntry(
    PolicyApplication entry,
    Application? application,
    ApplicationVersion? version,
    Map<String, String?> urls,
  ) {
    return {
      'sort': entry.sort,
      'action': entry.action.name,
      'show_launcher': entry.showLauncher,
      'custom_app_name': entry.customAppName,
      'run_on_boot': entry.runOnBoot,
      'update_policy': entry.updatePolicy?.name,
      'start_after_install': entry.startAfterInstall,
      'uninstall_block': entry.uninstallBlock,
      'application': application == null
          ? null
          : {
              'package_name': application.packageName,
              'app_name': application.appName,
              'icon_url': application.iconUrl,
              'is_system_app': application.isSystemApp,
            },
      'application_version': version == null
          ? null
          : {
              'version_code': version.versionCode,
              'checksum_sha256': version.checksumSha256,
              'download_url': urls[version.filePath],
            },
    };
  }

  static Future<List<Map<String, dynamic>>> _files(
    Session session,
    int policyId, {
    Transaction? transaction,
  }) async {
    final policyFiles = await PolicyFile.db.find(
      session,
      where: (t) => t.policyId.equals(policyId),
      transaction: transaction,
    );

    final files = <FileAsset?>[];
    for (final entry in policyFiles) {
      final fileId = entry.fileId;
      files.add(
        fileId == null
            ? null
            : await FileAsset.db.findById(
                session,
                fileId,
                transaction: transaction,
              ),
      );
    }

    final urls = await PolicyDownloadUrls.forFiles(
      session,
      files.whereType<FileAsset>(),
    );

    return [
      for (var i = 0; i < policyFiles.length; i++)
        _fileEntry(policyFiles[i], files[i], urls),
    ];
  }

  static Map<String, dynamic> _fileEntry(
    PolicyFile entry,
    FileAsset? file,
    Map<int, String?> urls,
  ) {
    final customName = file?.customName;
    return {
      'id': entry.id,
      'name': customName != null && customName.isNotEmpty
          ? customName
          : file?.name ?? entry.destinationPath,
      'policy_id': entry.policyId,
      'file_id': entry.fileId,
      'usage_type': entry.usageType.name,
      'destination_path': entry.destinationPath,
      'replace_if_exists': entry.replaceIfExists,
      'open_after_download': entry.openAfterDownload,
      'created_at': entry.createdAt?.toIso8601String(),
      'updated_at': entry.updatedAt?.toIso8601String(),
      'file': file == null
          ? null
          : {
              'id': file.id,
              'name': file.name,
              'custom_name': file.customName,
              'extension': file.fileExtension,
              'file_path': file.filePath,
              'public_url': urls[file.id],
              'mime_type': file.mimeType,
              'size_bytes': file.sizeBytes,
              'file_hash_sha256': file.fileHashSha256,
              'disk': file.disk?.name,
              'created_at': file.createdAt?.toIso8601String(),
              'updated_at': file.updatedAt?.toIso8601String(),
            },
    };
  }

  static Future<List<Map<String, dynamic>>> _certificates(
    Session session,
    int policyId, {
    Transaction? transaction,
  }) async {
    final policyCertificates = await PolicyCertificate.db.find(
      session,
      where: (t) => t.policyId.equals(policyId),
      transaction: transaction,
    );

    final certificates = <Certificate?>[];
    for (final entry in policyCertificates) {
      certificates.add(
        await Certificate.db.findById(
          session,
          entry.certificateId,
          transaction: transaction,
        ),
      );
    }

    // Certificates live on the private disk, so the device gets only a signed,
    // time-limited link. The password (needed to install the PKCS12) travels
    // only in this authenticated response and is never logged.
    final urls = <String, String?>{};
    for (final certificate in certificates.whereType<Certificate>()) {
      final path = certificate.filePath;
      if (path == null || path.isEmpty || urls.containsKey(path)) continue;
      urls[path] = await PolicyDownloadUrls.certificate(session, path);
    }

    final result = <Map<String, dynamic>>[];

    for (var i = 0; i < policyCertificates.length; i++) {
      final entry = policyCertificates[i];
      final certificate = certificates[i];
      if (certificate == null) {
        continue;
      }

      result.add({
        'id': certificate.id,
        'name': certificate.name,
        'certificate_type': certificate.certificateType.name,
        'file_hash': _certificateFileHash(certificate),
        'download_url': urls[certificate.filePath],
        'action': (entry.action ?? CertificateAction.install).name,
        'password': certificate.password,
      });
    }

    return result;
  }

  static String? _certificateFileHash(Certificate certificate) {
    final stored = certificate.fileHash;
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    final filePath = certificate.filePath;
    if (filePath == null || filePath.isEmpty) {
      return null;
    }

    final file = StorageConfig.privateFile(filePath);
    if (!file.existsSync()) {
      return null;
    }

    return sha256.convert(file.readAsBytesSync()).toString();
  }

  static Map<String, dynamic>? _syncSettings(Policy policy) {
    final raw = policy.syncSettings;
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final decoded = decodeJsonMap(raw);

    return {
      'full_sync_cron': decoded['full_sync_cron'] ?? _defaultFullSyncCron,
      'max_interval_minutes':
          decoded['max_interval_minutes'] ?? _defaultMaxIntervalMinutes,
    };
  }

  static Map<String, dynamic> _restrictionSettings(Policy policy) {
    final decoded = decodeJsonMap(policy.restrictionSettings);

    return {
      'restrictions': [
        for (final item in asList(decoded['restrictions']))
          if (item is Map) _restrictionEntry(item),
      ],
    };
  }

  /// Resolves one stored entry against the catalog; an unknown key yields null
  /// fields.
  ///
  /// `value` is tri-state: `0` allow, `1` restrict, `2` default (don't touch).
  /// The payload carries no label; the panel resolves it from the translation
  /// layer (`policies.restriction.<key>`).
  static Map<String, dynamic> _restrictionEntry(Map<dynamic, dynamic> item) {
    final restriction =
        RestrictionCatalog.byKey[item['restriction']?.toString()];

    return {
      'name': restriction?.name,
      'key': restriction?.key,
      'api_level': restriction?.apiLevel,
      'value': PolicyPayloadNormalizer.restrictionValue(item['value']),
    };
  }

  /// Empty or broken JSON becomes null so one broken column does not drop the
  /// whole payload.
  static dynamic _decode(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }
}
