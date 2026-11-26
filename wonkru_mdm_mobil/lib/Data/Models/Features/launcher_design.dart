import 'package:wonkrumdm/Core/Constants/Enums/launcher_mode_enums.dart';

import 'launcher_item_display.dart';
import 'launcher_background.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class LauncherDesign {
  final LayoutType? layoutType;

  final int? columns;

  final int? rows;

  final LauncherBackground? background;

  final LauncherItemDisplay? itemDisplay;

  LauncherDesign({this.layoutType, this.columns, this.rows, this.background, this.itemDisplay});

  factory LauncherDesign.fromJson(Map<String, dynamic> json) {
    return LauncherDesign(
      layoutType: LayoutType.values.tryFromValue(json['layout_type']),
      columns: JsonParse.toInt(json['columns']),
      rows: JsonParse.toInt(json['rows']),
      background: JsonParse.nested(json['background'], LauncherBackground.fromJson, field: 'launcher.background'),
      itemDisplay: JsonParse.nested(json['item_display'], LauncherItemDisplay.fromJson, field: 'launcher.item_display'),
    );
  }

  Map<String, dynamic> toJson() => {
    'layout_type': layoutType?.value,
    'columns': columns,
    'rows': rows,
    'background': background?.toJson(),
    'item_display': itemDisplay?.toJson(),
  };
}
