import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Utils/device_path.dart';

void main() {
  test('absolute Android paths are accepted', () {
    expect(isAbsoluteDevicePath('/storage/emulated/0/Download/a.pdf'), isTrue);
    expect(isAbsoluteDevicePath('/data/local/tmp/x'), isTrue);
  });

  test('leading/trailing whitespace is trimmed', () {
    expect(isAbsoluteDevicePath('  /sdcard/a.txt  '), isTrue);
  });

  test('relative names and empty values are rejected', () {
    expect(isAbsoluteDevicePath('2wed'), isFalse);
    expect(isAbsoluteDevicePath('bvc'), isFalse);
    expect(isAbsoluteDevicePath('Download/a.pdf'), isFalse);
    expect(isAbsoluteDevicePath(''), isFalse);
    expect(isAbsoluteDevicePath('   '), isFalse);
  });
}
