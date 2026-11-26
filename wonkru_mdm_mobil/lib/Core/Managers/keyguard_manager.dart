import 'package:wonkrumdm/Core/Managers/base_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/keyguard_bridge.dart';
import 'package:wonkrumdm/Data/Models/Features/keyguard_config.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

import '../Logging/wlog.dart';

const _tag = 'KeyguardManager';

class KeyguardManager extends BaseManager<KeyguardConfig> {
  static final KeyguardManager _instance = KeyguardManager._internal();
  factory KeyguardManager() => _instance;
  KeyguardManager._internal();

  @override
  Future<Map<String, dynamic>> getData() async {
    return await safeCall<Map<String, dynamic>>(() async {
      final isLocked = await this.isLocked;
      final hasSecureLock = await this.hasSecureLock;
      final isDeviceOwner = await this.isDeviceOwner;
      final disabledFeatures = await this.disabledFeatures;
      final maxLockTimeout = await this.maxLockTimeout;

      return {
        'isLocked': isLocked,
        'hasSecureLock': hasSecureLock,
        'isDeviceOwner': isDeviceOwner,
        'disabledFeatures': disabledFeatures,
        'maxLockTimeoutSeconds': maxLockTimeout?.inSeconds,
      };
    }, defaultValue: {});
  }

  final _bridge = KeyguardBridge();

  KeyguardConfig? get _currentConfig => DeviceController.to.config.value.securitySettings?.keyguardConfig;

  Future<bool> get isLocked => _bridge.isKeyguardLocked();

  Future<bool> get hasSecureLock => _bridge.isKeyguardSecure();

  Future<bool> get isDeviceOwner => _bridge.isDeviceOwner();

  Future<Map<String, bool>?> get disabledFeatures => _bridge.getKeyguardDisabledFeatures();

  Future<Duration?> get maxLockTimeout => _bridge.getMaximumTimeToLock();

  @override
  Future<void> applyConfiguration(KeyguardConfig config) async {
    await safeExecute(() async {
      if (config.isAllDefault) {
        WLog.d(_tag, 'All keyguard features default, skipping');
        return;
      }
      WLog.d(_tag, 'Applying config...');

      // Android writes the flags as a single bit mask. Null fields keep the
      // device's current bit; otherwise setting one field would force the
      // others on.
      final current = await _bridge.getKeyguardDisabledFeatures() ?? const <String, bool>{};
      final flags = mergeKeyguardFlags(config, current);

      await _bridge.setKeyguardDisabledFeatures(
        disableSecureCamera: flags['secure_camera']!,
        disableUnredactedNotifications: flags['unredacted_notifications']!,
        disableFingerprint: flags['fingerprint']!,
        disableFace: flags['face']!,
        disableIris: flags['iris']!,
        disableBiometrics: flags['biometrics']!,
        disableTrustAgents: flags['trust_agents']!,
      );
    }, logMessage: "KeyguardManager: Config applied");
  }

  KeyguardConfig? get currentConfig => _currentConfig;

  static Map<String, bool> mergeKeyguardFlags(KeyguardConfig config, Map<String, bool> current) {
    bool pick(bool? policy, String key) => policy ?? current[key] ?? false;
    return {
      'secure_camera': pick(config.disableLockScreenCamera, 'secure_camera'),
      'unredacted_notifications': pick(config.hideNotificationContent, 'unredacted_notifications'),
      'fingerprint': pick(config.disableFingerprint, 'fingerprint'),
      'face': pick(config.disableFaceUnlock, 'face'),
      'iris': pick(config.disableIris, 'iris'),
      'biometrics': pick(config.disableAllBiometrics, 'biometrics'),
      'trust_agents': pick(config.disableSmartLock, 'trust_agents'),
    };
  }
}
