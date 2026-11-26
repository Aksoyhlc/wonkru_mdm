import 'package:wonkrumdm/Data/Models/Features/header_widgets_config.dart';
import 'package:wonkrumdm/Data/Models/Features/launcher_design.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class LauncherConfig {
  final bool isActive;

  final LauncherDesign? design;

  final HeaderWidgetsConfig? headerWidgets;

  LauncherConfig({this.isActive = true, this.design, this.headerWidgets});

  factory LauncherConfig.fromPolicyPayload(Map<String, dynamic> policy) {
    final launcher = JsonParse.toMap(policy['launcher']);
    if (launcher == null) return LauncherConfig();

    final isActive = JsonParse.toBool(launcher['mode']) ?? true;
    final design = JsonParse.nested(launcher['design'], LauncherDesign.fromJson, field: 'launcher.design');
    final headerWidgets = JsonParse.nested(
      launcher['header_widgets'],
      HeaderWidgetsConfig.fromJson,
      field: 'launcher.header_widgets',
    );
    return LauncherConfig(isActive: isActive, design: design, headerWidgets: headerWidgets);
  }

  Map<String, dynamic> toJson() {
    if (design == null && headerWidgets == null) return {};
    return {
      'launcher': {
        if (design != null) 'design': design!.toJson(),
        if (headerWidgets != null) 'header_widgets': headerWidgets!.toJson(),
      },
    };
  }
}
