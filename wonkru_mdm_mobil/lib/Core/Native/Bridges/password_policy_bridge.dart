import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/password_policy_api.g.dart';

class PasswordPolicyBridge extends BaseBridge {
  static final PasswordPolicyBridge _instance = PasswordPolicyBridge._internal();

  factory PasswordPolicyBridge() => _instance;

  PasswordPolicyBridge._internal();

  final _api = PasswordPolicyAPI();

  @override
  String get bridgeName => "PasswordPolicyBridge";

  Future<bool> setPasswordPolicy(NativePasswordConfig config) async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setPasswordPolicy(config),
      logMessage: "$bridgeName: Password policy set",
    );
    return success;
  }

  Future<bool> clearPasswordPolicy() async {
    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.clearPasswordPolicy(),
      logMessage: "$bridgeName: Password policies cleared",
    );
    return success;
  }

  Future<NativePasswordConfig?> getPasswordPolicy() async {
    final (success, data) = await mdmResultSafeCall<Object>(
      () async => await _api.getPasswordPolicy(),
      defaultValue: null,
    );

    if (success && data != null) {
      final map = data as Map<Object?, Object?>;
      return NativePasswordConfig(
        complexityLevel: map['complexityLevel'] as int?,
        quality: map['quality'] as int?,
        minLength: map['minLength'] as int?,
        minUpperCase: map['minUpperCase'] as int?,
        minLowerCase: map['minLowerCase'] as int?,
        minLetters: map['minLetters'] as int?,
        minNumeric: map['minNumeric'] as int?,
        minSymbols: map['minSymbols'] as int?,
        minNonLetter: map['minNonLetter'] as int?,
        historyLength: map['historyLength'] as int?,
        expirationTimeoutMs: map['expirationTimeoutMs'] as int?,
        maxFailedAttempts: map['maxFailedAttempts'] as int?,
      );
    }
    return null;
  }

  Future<bool> isActivePasswordSufficient() async {
    final (success, data) = await mdmResultSafeCall<bool>(
      () async => await _api.isActivePasswordSufficient(),
      defaultValue: false,
    );

    return success && (data ?? false);
  }

  Future<void> openSetPasswordScreen() async {
    await safeCall<void>(() async => await _api.openSetPasswordScreen(), defaultValue: null);
  }
}
