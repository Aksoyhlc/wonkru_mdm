import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/display_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/DisplayApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.display'),
  ),
)
class NativeSettingsEvent {
  String? type;

  int? value;
}

@HostApi()
abstract class DisplayAPI {
  @async
  Map<String, Object?> lockNow();

  @async
  Map<String, Object?> setLockScreenMessage(String? message);

  @async
  Map<String, Object?> setScreenCaptureDisabled(bool disabled);

  @async
  void startSettingsListener();

  @async
  void stopSettingsListener();

  @async
  bool hasWriteSettingsPermission();

  @async
  void requestWriteSettingsPermission();

  @async
  Map<String, Object?> getDisplayInfo();
}

@FlutterApi()
abstract class DisplayEventAPI {
  void onSettingsChanged(NativeSettingsEvent event);

  void onScreenOn();

  void onScreenOff();

  void onKeyguardUnlocked();

  void onUserUnlocked();
}