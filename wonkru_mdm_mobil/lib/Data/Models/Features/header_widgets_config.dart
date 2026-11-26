import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class HeaderWidgetsConfig {
  final bool left;
  final bool center;
  final bool right;

  HeaderWidgetsConfig({this.left = true, this.center = true, this.right = true});

  factory HeaderWidgetsConfig.fromJson(Map<String, dynamic> json) {
    return HeaderWidgetsConfig(
      left: JsonParse.toBool(json['left']) ?? true,
      center: JsonParse.toBool(json['center']) ?? true,
      right: JsonParse.toBool(json['right']) ?? true,
    );
  }

  Map<String, dynamic> toJson() => {'left': left, 'center': center, 'right': right};

  bool get isEmpty => !left && !center && !right;
}
