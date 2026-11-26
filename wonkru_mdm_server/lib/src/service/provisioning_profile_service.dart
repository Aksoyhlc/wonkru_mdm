import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../config/app_config.dart';
import 'device_service.dart';
import 'enrollment_key_service.dart';
import 'mdm_agent_service.dart';

/// The client renders the QR; the server only produces the starting document.
class ProvisioningProfileService {
  const ProvisioningProfileService._();

  static const deviceAdminComponent =
      'com.wonkrumdm/com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver';
  static const initialProfileSetting = 'initial_provisioning_profile_id';
  static const _componentKey =
      'android.app.extra.PROVISIONING_DEVICE_ADMIN_COMPONENT_NAME';
  static const _urlKey =
      'android.app.extra.PROVISIONING_DEVICE_ADMIN_PACKAGE_DOWNLOAD_LOCATION';
  static const _signatureKey =
      'android.app.extra.PROVISIONING_DEVICE_ADMIN_SIGNATURE_CHECKSUM';
  static const _checksumKey =
      'android.app.extra.PROVISIONING_DEVICE_ADMIN_PACKAGE_CHECKSUM';

  static const timeZone = 'Europe/Istanbul';

  static const locale = 'tr_TR';

  static const organizationName = 'Wonkru MDM';

  static const extrasBundleKey =
      'android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE';

  static const enrollmentKeyExtra = 'enrollment_key';

  static void validateWifi(String config) {
    final decoded = jsonDecode(config);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'A provisioning profile must be a JSON object.',
      );
    }

    const prefix = 'android.app.extra.PROVISIONING_WIFI_';
    String read(String name) {
      final value = decoded['$prefix$name'];
      return value is String ? value : '';
    }

    if (read('SSID').trim().isEmpty) {
      throw const FormatException(
        'The setup Wi-Fi network name (SSID) is required.',
      );
    }
    final password = read('PASSWORD');
    final security = read('SECURITY_TYPE').trim().toUpperCase();
    switch (security) {
      case 'NONE':
        break;
      case 'WPA':
      case 'WEP':
        if (password.isEmpty) {
          throw const FormatException(
            'A Wi-Fi password is required for WPA or WEP.',
          );
        }
      case 'EAP':
        const methods = {
          'PEAP',
          'TLS',
          'TTLS',
          'PWD',
          'SIM',
          'AKA',
          'AKA_PRIME',
        };
        if (!methods.contains(read('EAP_METHOD').trim().toUpperCase())) {
          throw const FormatException(
            'A supported Wi-Fi EAP method is required.',
          );
        }
      default:
        throw const FormatException('Unsupported Wi-Fi security type.');
    }
  }

  /// Stored profiles never keep the key: it is injected on read and stripped on
  /// write, so a renewed key keeps every QR current and no stale copies pile up.
  static String withEnrollmentKey(String config, String? enrollmentKey) {
    final Object? decoded;
    try {
      decoded = jsonDecode(config);
    } on FormatException {
      return config;
    }
    if (decoded is! Map<String, dynamic>) {
      return config;
    }

    final bundle = decoded[extrasBundleKey];
    _removeAssignmentFields(decoded);
    if (bundle is! Map<String, dynamic>) {
      return const JsonEncoder.withIndent('  ').convert(decoded);
    }
    if (enrollmentKey == null) {
      bundle.remove(enrollmentKeyExtra);
    } else {
      bundle[enrollmentKeyExtra] = enrollmentKey;
    }
    return const JsonEncoder.withIndent('  ').convert(decoded);
  }

  static String initialTemplate({String deviceCode = ''}) => jsonEncode(
    <String, dynamic>{
      _componentKey: deviceAdminComponent,
      _urlKey: '',
      'android.app.extra.PROVISIONING_TIME_ZONE': timeZone,
      'android.app.extra.PROVISIONING_LOCALE': locale,
      'android.app.extra.PROVISIONING_ORGANIZATION_NAME': organizationName,
      extrasBundleKey: <String, dynamic>{
        'server_url': '',
        'device_code': deviceCode,
      },
    },
  );

  static Future<String> defaultConfig(Session session) async {
    final code = await DeviceService.generateUniqueCode(session);
    final key = await EnrollmentKeyService.current(session);
    return resolveInitialTemplate(
      session,
      initialTemplate(deviceCode: code),
      key,
    );
  }

  static Future<String> resolveInitialTemplate(
    Session session,
    String template,
    String enrollmentKey,
  ) async {
    final Object? decoded;
    try {
      decoded = jsonDecode(template);
    } on FormatException {
      return template;
    }
    if (decoded is! Map<String, dynamic>) return template;
    final config = decoded;
    final bundle = (config[extrasBundleKey] is Map<String, dynamic>)
        ? config[extrasBundleKey] as Map<String, dynamic>
        : <String, dynamic>{};
    final apk = await MdmAgentService.download(session);
    final package = apk?.package ?? await MdmAgentService.packageName(session);
    final component = config[_componentKey]?.toString() ?? '';
    final receiver = component.contains('/')
        ? component.split('/').last
        : deviceAdminComponent.split('/').last;
    config
      ..[_componentKey] = '$package/$receiver'
      ..[_urlKey] = apk?.url ?? ''
      ..remove(_signatureKey)
      ..remove(_checksumKey);
    final checksum = apk?.checksum;
    if (checksum != null && RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(checksum)) {
      final bytes = [
        for (var i = 0; i < checksum.length; i += 2)
          int.parse(checksum.substring(i, i + 2), radix: 16),
      ];
      config[_checksumKey] = base64Url.encode(bytes);
    }
    bundle
      ..['server_url'] = AppConfig.url
      ..[enrollmentKeyExtra] = enrollmentKey;
    config[extrasBundleKey] = bundle;
    _removeAssignmentFields(config);

    return const JsonEncoder.withIndent('  ').convert(config);
  }

  static void _removeAssignmentFields(Map<String, dynamic> payload) {
    final bundle = payload[extrasBundleKey];
    for (final key in const ['policy_id', 'group_id']) {
      payload.remove(key);
      if (bundle is Map<String, dynamic>) bundle.remove(key);
    }
  }
}
