import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Utils/brightness_utils.dart';

void main() {
  test('percentage maps linearly to the 0-255 range', () {
    expect(BrightnessUtils.percentToRaw(0), 0);
    expect(BrightnessUtils.percentToRaw(50), 128);
    expect(BrightnessUtils.percentToRaw(100), 255);
  });

  test('raw↔percent round trip', () {
    expect(BrightnessUtils.rawToPercent(BrightnessUtils.percentToRaw(30)), 30);
    expect(BrightnessUtils.rawToPercent(BrightnessUtils.percentToRaw(75)), 75);
  });
}
