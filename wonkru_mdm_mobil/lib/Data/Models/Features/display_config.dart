import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Constants/Enums/screen_orientation.dart';
import 'package:wonkrumdm/Core/Extensions/enum.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

const _tag = 'DisplayConfig';

class DisplayConfig {
  final String? lockScreenMessage;

  final OnOff? screenCapturePolicy;

  final int? screenTimeoutMs;

  final bool? screenTimeoutConfigRestriction;

  final int? brightnessLevel;

  final int? minBrightness;

  final int? maxBrightness;

  final OnOff? autoBrightnessPolicy;

  final bool? brightnessConfigRestriction;

  final RotationPolicy? rotationPolicy;

  final ScreenOrientation? lockedOrientation;

  DisplayConfig({
    this.lockScreenMessage,
    this.screenCapturePolicy,
    this.screenTimeoutMs,
    this.screenTimeoutConfigRestriction,
    this.brightnessLevel,
    this.minBrightness,
    this.maxBrightness,
    this.autoBrightnessPolicy,
    this.brightnessConfigRestriction,
    this.rotationPolicy,
    this.lockedOrientation,
  });

  static int? _brightnessFromJson(dynamic value) {
    final n = JsonParse.toInt(value);
    if (n == null) return null;
    if (n > 100) return (n * 100 / 255).round().clamp(0, 100);
    return n.clamp(0, 100);
  }

  /// `min_brightness > max_brightness` is an unapplicable range: both are
  /// ignored (no bound applied) and a warning is logged, while the other display
  /// settings still apply.
  ///
  /// `screen_timeout_config_restriction` / `brightness_config_restriction` are
  /// tri-state: `true` locks, `false` releases, absent/`2` leaves untouched.
  factory DisplayConfig.fromJson(Map<String, dynamic> json) {
    var minBrightness = _brightnessFromJson(json['min_brightness']);
    var maxBrightness = _brightnessFromJson(json['max_brightness']);
    if (minBrightness != null && maxBrightness != null && minBrightness > maxBrightness) {
      WLog.w(
        _tag,
        'min_brightness ($minBrightness) > max_brightness ($maxBrightness); brightness range ignored',
      );
      minBrightness = null;
      maxBrightness = null;
    }

    return DisplayConfig(
      lockScreenMessage: JsonParse.toStr(json['lock_screen_message']),
      screenCapturePolicy: JsonParse.toOnOffOrDef(json['screen_capture_policy']),
      screenTimeoutMs: JsonParse.toInt(json['screen_timeout_ms']),
      screenTimeoutConfigRestriction: JsonParse.toTriStateBool(json['screen_timeout_config_restriction']),
      brightnessLevel: _brightnessFromJson(json['brightness_level']),
      minBrightness: minBrightness,
      maxBrightness: maxBrightness,
      autoBrightnessPolicy: JsonParse.toOnOffOrDef(json['auto_brightness_policy']),
      brightnessConfigRestriction: JsonParse.toTriStateBool(json['brightness_config_restriction']),
      rotationPolicy: RotationPolicy.values.fromIntOrDefault(
        JsonParse.toInt(json['rotation_policy']),
        RotationPolicy.systemDefault,
      ),
      lockedOrientation: ScreenOrientation.values.fromIntOrDefault(
        JsonParse.toInt(json['locked_orientation']),
        ScreenOrientation.auto,
      ),
    );
  }
}
