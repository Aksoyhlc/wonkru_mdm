import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Data/Models/Features/application_version.dart';

void main() {
  test('download_url is parsed', () {
    final version = ApplicationVersion.fromJson({
      'version_code': 12,
      'checksum_sha256': 'abc',
      'download_url': 'http://host:8082/storage/file/public/applications/a.apk',
    });
    expect(version.versionCode, 12);
    expect(version.downloadUrl, 'http://host:8082/storage/file/public/applications/a.apk');
  });
}
