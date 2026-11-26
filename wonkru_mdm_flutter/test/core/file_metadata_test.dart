import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Utils/file_metadata.dart';

void main() {
  group('fileExtensionOf', () {
    test('lowercases the extension without the dot', () {
      expect(fileExtensionOf('Report.PDF'), 'pdf');
      expect(fileExtensionOf('archive.tar.gz'), 'gz');
    });

    test('returns empty when there is no extension', () {
      expect(fileExtensionOf('Makefile'), '');
      expect(fileExtensionOf('trailing.'), '');
      expect(fileExtensionOf(''), '');
    });
  });

  group('mimeTypeForFileName', () {
    test('maps known extensions', () {
      expect(
        mimeTypeForFileName('app.apk'),
        'application/vnd.android.package-archive',
      );
      expect(mimeTypeForFileName('logo.PNG'), 'image/png');
      expect(mimeTypeForFileName('photo.jpeg'), 'image/jpeg');
      expect(mimeTypeForFileName('cert.pem'), 'application/x-pem-file');
    });

    test('returns null for an unknown extension', () {
      expect(mimeTypeForFileName('data.xyz'), isNull);
      expect(mimeTypeForFileName('noextension'), isNull);
    });
  });

  group('formatBytes', () {
    test('byte, KB and MB formats', () {
      expect(formatBytes(512), '512 B');
      expect(formatBytes(2048), '2.0 KB');
      expect(formatBytes(5 * 1024 * 1024), '5.0 MB');
    });
  });
}
