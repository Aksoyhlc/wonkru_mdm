import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/util/apk_package.dart';

import '../support/apk_fixtures.dart';

void main() {
  group('Given apkPackageName', () {
    test('when the manifest is UTF-8 then the package name is read.', () {
      expect(
        apkPackageName(minimalApk(packageName: 'com.x.y', utf8: true)),
        'com.x.y',
      );
    });

    test('when the manifest is UTF-16 then the package name is read.', () {
      expect(
        apkPackageName(minimalApk(packageName: 'com.x.y', utf8: false)),
        'com.x.y',
      );
    });

    test('when the manifest has no package then null is returned.', () {
      expect(apkPackageName(minimalApk(packageName: null)), isNull);
    });

    test('when the archive has no manifest then null is returned.', () {
      expect(apkPackageName(apkWithoutManifest()), isNull);
    });

    test('when the bytes are not a ZIP then null is returned.', () {
      expect(
        apkPackageName(Uint8List.fromList(List.generate(64, (i) => i))),
        isNull,
      );
    });

    test('when the bytes are empty then null is returned.', () {
      expect(apkPackageName(Uint8List(0)), isNull);
    });
  });
}
