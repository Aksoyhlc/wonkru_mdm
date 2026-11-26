import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

class ApplicationFormResult {
  const ApplicationFormResult({
    required this.application,
    this.apkPath,
    this.apkSizeBytes,
    this.apkChecksumSha256,
    this.versionName,
    this.versionCode,
    this.minSdkVersion,
    this.targetSdkVersion,
    this.permissions,
  });

  final Application application;

  final String? apkPath;
  final int? apkSizeBytes;
  final String? apkChecksumSha256;

  final String? versionName;
  final int? versionCode;
  final int? minSdkVersion;
  final int? targetSdkVersion;

  final String? permissions;

  bool get hasApk =>
      apkPath != null && versionName != null && versionCode != null;

  ApplicationVersion toVersion(int applicationId) => ApplicationVersion(
    applicationId: applicationId,
    versionName: versionName!,
    versionCode: versionCode!,
    filePath: apkPath,
    fileSizeBytes: apkSizeBytes,
    checksumSha256: apkChecksumSha256,
    minSdkVersion: minSdkVersion,
    targetSdkVersion: targetSdkVersion,
    permissions: permissions,
  );
}
