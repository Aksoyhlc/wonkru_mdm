import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Extensions/string.dart';

void main() {
  test('isNullOrEmpty handles null and empty', () {
    expect(((null) as String?).isNullOrEmpty, isTrue);
    expect(''.isNullOrEmpty, isTrue);
    expect('x'.isNullOrEmpty, isFalse);
  });

  test('toInt falls back to 0', () {
    expect('12'.toInt(), 12);
    expect('abc'.toInt(), 0);
  });

  test('fileExtension ignores query string', () {
    expect('a/b.apk?v=1'.fileExtension, 'apk');
  });
}
