import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Managers/keyguard_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/password_policy_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/password_policy_api.g.dart';
import 'package:wonkrumdm/Data/Models/Features/security_config.dart';

const _tag = 'SecurityManager';

class SecurityManager extends BaseManager<SecurityConfig> {
  static final SecurityManager _instance = SecurityManager._internal();

  factory SecurityManager() => _instance;

  SecurityManager._internal();

  final _passwordBridge = PasswordPolicyBridge();
  final _keyguardManager = KeyguardManager();

  @override
  Future<void> applyConfiguration(SecurityConfig config) async {
    await safeExecute(() async {
      if (config.passwordPolicy != null) {
        await _passwordBridge.setPasswordPolicy(config.passwordPolicy!);
        WLog.i(_tag, 'Password policy applied');
      } else {
        await _passwordBridge.clearPasswordPolicy();
      }

      if (config.keyguardConfig != null) {
        await _keyguardManager.applyConfiguration(config.keyguardConfig!);
      }
    }, logMessage: "SecurityManager: Security policies applied");
  }

  Future<NativePasswordConfig?> getCurrentPasswordPolicy() async {
    return await _passwordBridge.getPasswordPolicy();
  }

  Future<bool> isPasswordSufficient() async {
    return await _passwordBridge.isActivePasswordSufficient();
  }

  Future<void> openPasswordChangeScreen() async {
    await _passwordBridge.openSetPasswordScreen();
  }

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final isPasswordSufficient = await this.isPasswordSufficient();
      final passwordPolicy = await getCurrentPasswordPolicy();

      final isLocked = await _keyguardManager.isLocked;
      final hasSecureLock = await _keyguardManager.hasSecureLock;
      final isDeviceOwner = await _keyguardManager.isDeviceOwner;
      final disabledFeatures = await _keyguardManager.disabledFeatures;
      final maxLockTimeout = await _keyguardManager.maxLockTimeout;

      return {
        'password': {
          'isSufficient': isPasswordSufficient,
          'policy': passwordPolicy != null
              ? {
                  'quality': passwordPolicy.quality,
                  'complexityLevel': passwordPolicy.complexityLevel,
                  'minLength': passwordPolicy.minLength,
                  'minNumeric': passwordPolicy.minNumeric,
                  'minSymbols': passwordPolicy.minSymbols,
                  'minUpperCase': passwordPolicy.minUpperCase,
                  'minLowerCase': passwordPolicy.minLowerCase,
                }
              : null,
        },
        'keyguard': {
          'isLocked': isLocked,
          'hasSecureLock': hasSecureLock,
          'isDeviceOwner': isDeviceOwner,
          'disabledFeatures': disabledFeatures,
          'maxLockTimeoutSeconds': maxLockTimeout?.inSeconds,
        },
      };
    }, defaultValue: {});
  }
}
