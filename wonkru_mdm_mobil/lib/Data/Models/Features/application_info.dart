import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class ApplicationInfo {
  final String? packageName;
  final String? appName;
  final String? iconUrl;
  final bool isSystemApp;

  ApplicationInfo({this.packageName, this.appName, this.iconUrl, this.isSystemApp = false});

  factory ApplicationInfo.fromJson(Map<String, dynamic> json) {
    return ApplicationInfo(
      packageName: JsonParse.toStr(json['package_name']),
      appName: JsonParse.toStr(json['app_name']),
      iconUrl: JsonParse.toStr(json['icon_url']),
      isSystemApp: JsonParse.toBool(json['is_system_app']) ?? false,
    );
  }
}
