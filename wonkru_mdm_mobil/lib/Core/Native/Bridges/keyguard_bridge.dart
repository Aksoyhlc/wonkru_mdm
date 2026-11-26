import 'package:wonkrumdm/Core/Native/Bridges/base_bridge.dart';
import 'package:wonkrumdm/Core/Native/Generated/keyguard_api.g.dart';

class KeyguardBridge extends BaseBridge {
  static final KeyguardBridge _instance = KeyguardBridge._internal();
  factory KeyguardBridge() => _instance;
  KeyguardBridge._internal();

  final _api = KeyguardAPI();

  @override
  String get bridgeName => "KeyguardBridge";

  Future<bool> setKeyguardDisabledFeatures({
    bool disableSecureCamera = false,
    bool disableUnredactedNotifications = false,
    bool disableFingerprint = false,
    bool disableFace = false,
    bool disableIris = false,
    bool disableBiometrics = false,
    bool disableTrustAgents = false,
    bool disableAll = false,
  }) async {
    final features = KeyguardFeatures(
      disableSecureCamera: disableSecureCamera,
      disableUnredactedNotifications: disableUnredactedNotifications,
      disableFingerprint: disableFingerprint,
      disableFace: disableFace,
      disableIris: disableIris,
      disableBiometrics: disableBiometrics,
      disableTrustAgents: disableTrustAgents,
      disableAll: disableAll,
    );

    final (success, _) = await mdmResultSafeCall<Object>(
      () async => await _api.setKeyguardDisabledFeatures(features),
      logMessage: "$bridgeName: Keyguard features updated",
    );
    return success;
  }

  Future<Map<String, bool>?> getKeyguardDisabledFeatures() async {
    return await safeCall<Map<String, bool>?>(() async {
      final result = await _api.getKeyguardDisabledFeatures();
      if (result['success'] == true && result['data'] != null) {
        final data = result['data'] as Map<Object?, Object?>;
        final features = data['features'] as Map<Object?, Object?>?;
        if (features != null) {
          return features.map((k, v) => MapEntry(k.toString(), v as bool));
        }
      }
      return null;
    }, defaultValue: null);
  }

  Future<Duration?> getMaximumTimeToLock() async {
    return await safeCall<Duration?>(() async {
      final ms = await _api.getMaximumTimeToLock();
      return Duration(milliseconds: ms);
    }, defaultValue: null);
  }

  Future<bool> isDeviceOwner() async {
    return await safeCall<bool>(() async => await _api.isDeviceOwner(), defaultValue: false);
  }

  Future<bool> isKeyguardLocked() async {
    return await safeCall<bool>(() async => await _api.isKeyguardLocked(), defaultValue: false);
  }

  Future<bool> isKeyguardSecure() async {
    return await safeCall<bool>(() async => await _api.isKeyguardSecure(), defaultValue: false);
  }
}
