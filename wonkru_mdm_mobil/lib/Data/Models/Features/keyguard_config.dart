import 'package:wonkrumdm/Core/Utils/json_parse.dart';

class KeyguardConfig {
  final bool? disableLockScreenCamera;

  final bool? hideNotificationContent;

  final bool? disableFingerprint;

  final bool? disableFaceUnlock;

  final bool? disableIris;

  final bool? disableAllBiometrics;

  final bool? disableSmartLock;

  KeyguardConfig({
    this.disableLockScreenCamera,
    this.hideNotificationContent,
    this.disableFingerprint,
    this.disableFaceUnlock,
    this.disableIris,
    this.disableAllBiometrics,
    this.disableSmartLock,
  });

  /// Every field is tri-state: `true` disables the feature, `false` leaves it
  /// on, absent/`2` is default (the device's current bit is kept untouched).
  factory KeyguardConfig.fromJson(Map<String, dynamic> json) {
    return KeyguardConfig(
      disableLockScreenCamera: JsonParse.toTriStateBool(json['disable_lock_screen_camera']),
      hideNotificationContent: JsonParse.toTriStateBool(json['hide_notification_content']),
      disableFingerprint: JsonParse.toTriStateBool(json['disable_fingerprint']),
      disableFaceUnlock: JsonParse.toTriStateBool(json['disable_face_unlock']),
      disableIris: JsonParse.toTriStateBool(json['disable_iris']),
      disableAllBiometrics: JsonParse.toTriStateBool(json['disable_all_biometrics']),
      disableSmartLock: JsonParse.toTriStateBool(json['disable_smart_lock']),
    );
  }

  bool get isAllDefault =>
      disableLockScreenCamera == null &&
      hideNotificationContent == null &&
      disableFingerprint == null &&
      disableFaceUnlock == null &&
      disableIris == null &&
      disableAllBiometrics == null &&
      disableSmartLock == null;

  Map<String, dynamic> toJson() {
    return {
      if (disableLockScreenCamera != null) 'disable_lock_screen_camera': disableLockScreenCamera,
      if (hideNotificationContent != null) 'hide_notification_content': hideNotificationContent,
      if (disableFingerprint != null) 'disable_fingerprint': disableFingerprint,
      if (disableFaceUnlock != null) 'disable_face_unlock': disableFaceUnlock,
      if (disableIris != null) 'disable_iris': disableIris,
      if (disableAllBiometrics != null) 'disable_all_biometrics': disableAllBiometrics,
      if (disableSmartLock != null) 'disable_smart_lock': disableSmartLock,
    };
  }

  factory KeyguardConfig.noBiometrics() {
    return KeyguardConfig(disableAllBiometrics: true, disableSmartLock: true);
  }

  factory KeyguardConfig.secureLockScreen() {
    return KeyguardConfig(disableLockScreenCamera: true, hideNotificationContent: true, disableSmartLock: true);
  }

  factory KeyguardConfig.maxSecurity() {
    return KeyguardConfig(
      disableLockScreenCamera: true,
      hideNotificationContent: true,
      disableAllBiometrics: true,
      disableSmartLock: true,
    );
  }
}