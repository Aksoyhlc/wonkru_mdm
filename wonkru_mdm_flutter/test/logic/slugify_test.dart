import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Utils/slugify.dart';

/// The client `slugify` must match the server's `PolicySlugService.slugify`;
/// both sides apply the same rules.
void main() {
  group('slugify', () {
    test('lowercases and turns spaces into hyphens.', () {
      expect(slugify('Fresh Policy'), 'fresh-policy');
      expect(slugify('  A   B  '), 'a-b');
    });

    test('converts Turkish characters to their ASCII equivalents.', () {
      expect(slugify('Şirket Politikası'), 'sirket-politikasi');
      expect(slugify('ÖĞÜN çalışma'), 'ogun-calisma');
    });

    test('collapses non-alphanumerics into single hyphens and trims the ends.', () {
      expect(slugify('a---b'), 'a-b');
      expect(slugify('###'), isEmpty);
      expect(slugify('--X--'), 'x');
    });
  });
}
