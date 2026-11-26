import 'package:serverpod/serverpod.dart';

import '../enums/storage_area.dart';
import '../generated/protocol.dart';
import 'setting_service.dart';
import 'storage_url_service.dart';

class MdmAgentService {
  const MdmAgentService._();

  static const packageSetting = 'mdm_apk_package_name';
  static const defaultPackage = 'com.wonkrumdm';

  static Future<String> packageName(
    Session session, {
    Transaction? transaction,
  }) async {
    final saved = await SettingService.raw(
      session,
      packageSetting,
      transaction: transaction,
    );
    return saved == null || saved.isEmpty ? defaultPackage : saved;
  }

  static Future<Application?> findApplication(
    Session session,
    String package, {
    Transaction? transaction,
  }) => Application.db.findFirstRow(
    session,
    where: (t) => t.packageName.equals(package) & t.deletedAt.equals(null),
    transaction: transaction,
  );

  static Future<({String package, String url, String? checksum})?> download(
    Session session,
  ) async {
    final package = await packageName(session);
    final application = await findApplication(session, package);
    if (application == null) return null;

    final versions = await ApplicationVersion.db.find(
      session,
      where: (t) =>
          t.applicationId.equals(application.id!) &
          t.isActive.equals(true) &
          t.filePath.notEquals(null),
      orderByList: (t) => [t.isDefault.desc(), t.versionCode.desc()],
    );
    for (final version in versions) {
      final path = version.filePath!;
      if (!StorageArea.applications.owns(path)) continue;

      final url = await StorageUrlService.publicUrl(session, path);
      if (url == null) continue;
      return (package: package, url: url, checksum: version.checksumSha256);
    }
    return null;
  }
}
