import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/Core/Native/Generated/password_policy_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wonkrumdm/api/PasswordPolicyApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.wonkrumdm.api.password'),
  ),
)
class NativePasswordConfig {
  int? complexityLevel;

  int? quality;

  int? minLength;

  int? minUpperCase;
  int? minLowerCase;
  int? minLetters;
  int? minNumeric;
  int? minSymbols;
  int? minNonLetter;

  int? historyLength;
  int? expirationTimeoutMs;

  int? maxFailedAttempts;
}

@HostApi()
abstract class PasswordPolicyAPI {
  @async
  Map<String, Object?> setPasswordPolicy(NativePasswordConfig config);

  @async
  Map<String, Object?> clearPasswordPolicy();

  @async
  Map<String, Object?> getPasswordPolicy();

  @async
  Map<String, Object?> isActivePasswordSufficient();

  @async
  Map<String, Object?> lockNow();

  void openSetPasswordScreen();
}

@FlutterApi()
abstract class PasswordEventsFlutterApi {
  void onFailedAttempt(int currentFailedAttempts, int? maxFailedAttempts);
}