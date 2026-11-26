import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class LauncherBackground {
  final String? type;

  final String? image;

  final String? color;

  LauncherBackground({this.type, this.image, this.color});

  factory LauncherBackground.fromJson(Map<String, dynamic> json) {
    return LauncherBackground(
      type: JsonParse.toStr(json['type']),
      image: JsonParse.toStr(json['image']),
      color: _color(json['color']),
    );
  }

  static String? _color(Object? raw) => raw is int ? raw.toString().padLeft(6, '0') : JsonParse.toStr(raw);

  Map<String, dynamic> toJson() => {'type': type, 'image': image, 'color': color};
}
