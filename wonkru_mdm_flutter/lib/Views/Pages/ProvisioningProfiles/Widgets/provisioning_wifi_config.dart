import '../../../../Core/L10n/L.dart';

class ProvisioningWifiConfig {
  const ProvisioningWifiConfig({
    this.ssid = '',
    this.security = wpa,
    this.password = '',
    this.hidden = false,
    this.eapMethod = '',
  });

  static const open = 'NONE';
  static const wpa = 'WPA';
  static const wep = 'WEP';
  static const eap = 'EAP';
  static const securityTypes = [wpa, open, wep, eap];
  static const eapMethods = [
    'PEAP',
    'TLS',
    'TTLS',
    'PWD',
    'SIM',
    'AKA',
    'AKA_PRIME',
  ];

  static const _prefix = 'android.app.extra.PROVISIONING_WIFI_';
  static const _ssidKey = '${_prefix}SSID';
  static const _securityKey = '${_prefix}SECURITY_TYPE';
  static const _passwordKey = '${_prefix}PASSWORD';
  static const _hiddenKey = '${_prefix}HIDDEN';
  static const _eapMethodKey = '${_prefix}EAP_METHOD';
  static const _enterpriseKeys = [
    _eapMethodKey,
    '${_prefix}IDENTITY',
    '${_prefix}ANONYMOUS_IDENTITY',
    '${_prefix}PHASE2_AUTH',
    '${_prefix}DOMAIN',
    '${_prefix}CA_CERTIFICATE',
    '${_prefix}USER_CERTIFICATE',
  ];

  final String ssid;
  final String security;
  final String password;
  final bool hidden;
  final String eapMethod;

  bool get hasNetwork => ssid.trim().isNotEmpty;
  bool get requiresPassword => security == wpa || security == wep;

  factory ProvisioningWifiConfig.fromPayload(Map<String, dynamic> payload) {
    String read(String key) =>
        payload[key] is String ? payload[key] as String : '';
    final ssid = read(_ssidKey);
    final password = read(_passwordKey);
    final security = read(_securityKey).trim().toUpperCase();
    return ProvisioningWifiConfig(
      ssid: ssid,
      security: security.isNotEmpty
          ? security
          : ssid.isNotEmpty && password.isEmpty
          ? open
          : wpa,
      password: password,
      hidden: payload[_hiddenKey] == true,
      eapMethod: read(_eapMethodKey).trim().toUpperCase(),
    );
  }

  String? get validationError {
    if (!hasNetwork) return L.provisioning.wifiSsidRequired;
    if (!securityTypes.contains(security)) {
      return L.provisioning.wifiInvalidSecurity;
    }
    if (requiresPassword && password.isEmpty) {
      return L.provisioning.wifiPasswordRequired;
    }
    if (security == eap && !eapMethods.contains(eapMethod)) {
      return L.provisioning.wifiEapMethodRequired;
    }
    return null;
  }

  static void copyExtras(
    Map<String, dynamic> source,
    Map<String, dynamic> target,
  ) {
    target.addEntries(
      source.entries.where((entry) => entry.key.startsWith(_prefix)),
    );
  }

  void writeTo(Map<String, dynamic> payload) {
    if (!hasNetwork) {
      payload.removeWhere((key, _) => key.startsWith(_prefix));
      return;
    }
    payload
      ..[_ssidKey] = ssid
      ..[_securityKey] = security
      ..[_hiddenKey] = hidden;
    if (security == open || password.isEmpty) {
      payload.remove(_passwordKey);
    } else {
      payload[_passwordKey] = password;
    }
    if (security == eap) {
      if (eapMethod.isEmpty) {
        payload.remove(_eapMethodKey);
      } else {
        payload[_eapMethodKey] = eapMethod;
      }
    } else {
      for (final key in _enterpriseKeys) {
        payload.remove(key);
      }
    }
  }
}
