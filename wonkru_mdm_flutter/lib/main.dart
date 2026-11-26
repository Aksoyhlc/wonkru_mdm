import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'Core/Init/dependency_injection.dart';
import 'Data/Client/serverpod_client.dart';
import 'Logic/Controllers/auth_controller.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Time zone data: times are shown converted to the selected region.
  tzdata.initializeTimeZones();
  usePathUrlStrategy();
  await initializeServerpodClient();
  await DependencyInjection.initCore();
  // Re-read session state on 401/403: when the 2FA window expires, admin
  // endpoints return 403 and the panel must return to the code step.
  onUnauthorized = () => Get.find<AuthController>().init();
  // Started in the background; the router shows the loader until it settles.
  unawaited(Get.find<AuthController>().init());
  runApp(const WonkruApp());
}
