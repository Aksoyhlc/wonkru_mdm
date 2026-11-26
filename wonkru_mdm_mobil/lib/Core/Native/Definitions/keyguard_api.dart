import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/keyguard_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/KeyguardApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.keyguard'),
  ),
)

class KeyguardFeatures {
  bool? disableSecureCamera;

  bool? disableUnredactedNotifications;

  bool? disableFingerprint;

  bool? disableFace;

  bool? disableIris;

  bool? disableBiometrics;

  bool? disableTrustAgents;

  bool? disableAll;
}

@HostApi()
abstract class KeyguardAPI {
  @async
  Map<String, Object?> setKeyguardDisabledFeatures(KeyguardFeatures features);

  @async
  Map<String, Object?> getKeyguardDisabledFeatures();

  @async
  int getMaximumTimeToLock();

  @async
  bool isDeviceOwner();

  @async
  bool isKeyguardLocked();

  @async
  bool isKeyguardSecure();
}