import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/launcher_mode_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/LauncherModeApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.launcher_mode'),
  ),
)
@HostApi()
abstract class LauncherModeApi {
  @async
  Map<String, Object?> addHomeIntentHandler(String packageName);

  @async
  Map<String, Object?> clearHomeIntentHandler(String packageName);
}
