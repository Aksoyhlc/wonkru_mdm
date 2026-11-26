import 'package:wonkrumdm/Core/Constants/Enums/app_enums.dart';
import 'package:wonkrumdm/Core/Constants/Enums/auto_update_policy.dart';
import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Extensions/enum.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';

import 'application_info.dart';
import 'application_version.dart';

class ManagedApp {
  final String? customAppName;

  final int? sort;

  final AppAction? action;

  final bool? launchAfterInstall;

  final OnOff? runOnBoot;

  final bool showLauncher;

  final AutoUpdatePolicy? updatePolicy;

  final bool uninstallBlock;

  final ApplicationInfo? application;

  final ApplicationVersion? applicationVersion;

  ManagedApp({
    this.customAppName,
    this.sort,
    this.action,
    this.launchAfterInstall = false,
    this.runOnBoot,
    this.showLauncher = true,
    this.updatePolicy,
    this.uninstallBlock = false,
    this.application,
    this.applicationVersion,
  });

  String? get packageName => application?.packageName;

  String? get appName => application?.appName;

  factory ManagedApp.fromJson(Map<String, dynamic> json) {
    return ManagedApp(
      customAppName: JsonParse.toStr(json['custom_app_name']),
      sort: JsonParse.toInt(json['sort']),
      action: AppAction.values.tryFromValue(json['action']),
      launchAfterInstall:
          JsonParse.toBool(json['start_after_install']) ?? false,
      runOnBoot: JsonParse.toOnOff(json['run_on_boot']),
      showLauncher: JsonParse.toBool(json['show_launcher']) ?? true,
      updatePolicy: AutoUpdatePolicy.values.tryFromValue(json['update_policy']),
      uninstallBlock: JsonParse.toBool(json['uninstall_block']) ?? false,
      application: JsonParse.nested(
        json['application'],
        ApplicationInfo.fromJson,
        field: 'application',
      ),
      applicationVersion: JsonParse.nested(
        json['application_version'],
        ApplicationVersion.fromJson,
        field: 'application_version',
      ),
    );
  }
}
