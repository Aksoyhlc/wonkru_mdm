library;

class BrightnessUtils {
  static const int rawMin = 0;
  static const int rawMax = 255;

  /// Android's `screen_brightness` is already a linear 0-255 index; no gamma is applied.
  static int percentToRaw(int percent) =>
      (percent.clamp(0, 100) * rawMax / 100).round().clamp(rawMin, rawMax);

  static int rawToPercent(int raw) =>
      (raw.clamp(rawMin, rawMax) * 100 / rawMax).round().clamp(0, 100);
}
