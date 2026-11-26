import 'managed_app.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class AppConfig {
  final List<ManagedApp>? managedApps;

  AppConfig({this.managedApps});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    // A single corrupt entry is skipped; the rest of the list is applied.
    final apps = json['management_apps'] != null
        ? JsonParse.listOf(json['management_apps'], ManagedApp.fromJson, field: 'management_apps')
        : null;
    return AppConfig(managedApps: apps);
  }
}