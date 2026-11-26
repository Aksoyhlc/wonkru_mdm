class SystemSettingsKey {
  final String value;
  
  const SystemSettingsKey(this.value);

  static const screenBrightness = SystemSettingsKey('screen_brightness');

  static const screenBrightnessMode = SystemSettingsKey('screen_brightness_mode');

  static const screenOffTimeout = SystemSettingsKey('screen_off_timeout');

  static const accelerometerRotation = SystemSettingsKey('accelerometer_rotation');

  static const userRotation = SystemSettingsKey('user_rotation');

  static const fontScale = SystemSettingsKey('font_scale');

  static const time1224 = SystemSettingsKey('time_12_24');

  static const autoTime = SystemSettingsKey('auto_time');

  static const autoTimeZone = SystemSettingsKey('auto_time_zone');

  static const lowPowerMode = SystemSettingsKey('low_power_mode');

  static const values = [
    screenBrightness,
    screenBrightnessMode,
    screenOffTimeout,
    accelerometerRotation,
    userRotation,
    fontScale,
    time1224,
    autoTime,
    autoTimeZone,
    lowPowerMode,
  ];

  static SystemSettingsKey? fromString(String value, {bool createIfMissing = false}) {
    for (final key in values) {
      if (key.value == value) return key;
    }
    
    if (createIfMissing) {
      return SystemSettingsKey(value);
    }
    
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemSettingsKey &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'SystemSettingsKey($value)';
}