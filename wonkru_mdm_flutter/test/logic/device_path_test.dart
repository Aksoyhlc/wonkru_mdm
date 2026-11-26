import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Utils/device_path.dart';

void main() {
  test('an absolute path is valid', () {
    expect(isAbsoluteDevicePath('/sdcard/Download/a.pdf'), isTrue);
    expect(isAbsoluteDevicePath('/storage/emulated/0/x'), isTrue);
  });

  test('whitespace is trimmed', () {
    expect(isAbsoluteDevicePath('  /sdcard/a.txt  '), isTrue);
  });

  test('a relative path is invalid', () {
    expect(isAbsoluteDevicePath('2wed'), isFalse);
    expect(isAbsoluteDevicePath('Download/a.pdf'), isFalse);
    expect(isAbsoluteDevicePath(''), isFalse);
    expect(isAbsoluteDevicePath('   '), isFalse);
  });
}
