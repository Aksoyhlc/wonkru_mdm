import 'package:wonkrumdm/Core/Native/Generated/password_policy_api.g.dart';
import 'package:wonkrumdm/Core/Utils/json_parse.dart';
import 'package:wonkrumdm/Data/Models/Features/keyguard_config.dart';

class SecurityConfig {
  final NativePasswordConfig? passwordPolicy;
  final KeyguardConfig? keyguardConfig;

  final List<String>? allowedAccessibilityApps;

  SecurityConfig({this.passwordPolicy, this.keyguardConfig, this.allowedAccessibilityApps});

  factory SecurityConfig.fromJson(Map<String, dynamic> json) {
    NativePasswordConfig? pwdConfig;
    final p = JsonParse.toMap(json['password_policy']);
    if (p != null) {
      pwdConfig = NativePasswordConfig(
        complexityLevel: JsonParse.toInt(p['complexity_level']),
        quality: JsonParse.toInt(p['quality']),
        minLength: JsonParse.toInt(p['min_length']),
        minUpperCase: JsonParse.toInt(p['min_upper_case']),
        minLowerCase: JsonParse.toInt(p['min_lower_case']),
        minLetters: JsonParse.toInt(p['min_letters']),
        minNumeric: JsonParse.toInt(p['min_numeric']),
        minSymbols: JsonParse.toInt(p['min_symbols']),
        minNonLetter: JsonParse.toInt(p['min_non_letter']),
        historyLength: JsonParse.toInt(p['history_length']),
        expirationTimeoutMs: JsonParse.toInt(p['expiration_timeout_ms']),
        maxFailedAttempts: JsonParse.toInt(p['max_failed_attempts']),
      );
    }

    final keyguard = JsonParse.nested(json['keyguard'], KeyguardConfig.fromJson, field: 'keyguard');

    List<String>? allowedAccessibilityApps = JsonParse.toStringList(
      json['allowed_accessibility_apps'],
    )?.map((e) => e.trim()).where((s) => s.isNotEmpty).toList();
    if (allowedAccessibilityApps != null && allowedAccessibilityApps.isEmpty) allowedAccessibilityApps = null;

    return SecurityConfig(
      passwordPolicy: pwdConfig,
      keyguardConfig: keyguard,
      allowedAccessibilityApps: allowedAccessibilityApps,
    );
  }
}
