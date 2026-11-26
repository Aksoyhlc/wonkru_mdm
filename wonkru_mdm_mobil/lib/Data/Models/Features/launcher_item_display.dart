import 'package:wonkrumdm/Core/Constants/Enums/launcher_mode_enums.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class LauncherItemDisplay {
  final IconSize? iconSize;

  final bool showLabel;

  final String? labelColor;

  final String? backgroundColor;

  final int? borderRadius;

  final bool longPressSettingsOpen;

  final double? labelFontSize;

  LauncherItemDisplay({
    this.iconSize,
    this.showLabel = true,
    this.labelColor,
    this.backgroundColor,
    this.borderRadius,
    this.longPressSettingsOpen = false,
    this.labelFontSize,
  });

  factory LauncherItemDisplay.fromJson(Map<String, dynamic> json) {
    return LauncherItemDisplay(
      iconSize: IconSize.values.tryFromValue(json['icon_size']),
      showLabel: JsonParse.toBool(json['show_label']) ?? true,
      labelColor: _color(json['label_color']),
      backgroundColor: _color(json['background_color']),
      borderRadius: JsonParse.toInt(json['border_radius']),
      longPressSettingsOpen: JsonParse.toBool(json['long_press_settings_open']) ?? false,
      labelFontSize: JsonParse.toDouble(json['label_font_size']),
    );
  }

  static String? _color(Object? raw) => raw is int ? raw.toString().padLeft(6, '0') : JsonParse.toStr(raw);

  Map<String, dynamic> toJson() => {
    'icon_size': iconSize?.value,
    'show_label': showLabel,
    'label_color': labelColor,
    'background_color': backgroundColor,
    'border_radius': borderRadius,
    'long_press_settings_open': longPressSettingsOpen,
    'label_font_size': labelFontSize,
  };
}
