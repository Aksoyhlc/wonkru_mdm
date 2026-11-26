import 'dart:convert';

import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import 'provisioning_wifi_config.dart';

class ProvisioningConfig {
  const ProvisioningConfig({
    this.componentName = '',
    this.apkUrl = '',
    this.signatureChecksum = '',
    this.packageChecksum = '',
    this.timeZone = 'Europe/Istanbul',
    this.locale = 'tr_TR',
    this.organization = 'Wonkru MDM',
    this.serverUrl = '',
    this.deviceCode = '',
    this.enrollmentKey = '',
  });

  static const componentNameKey =
      'android.app.extra.PROVISIONING_DEVICE_ADMIN_COMPONENT_NAME';
  static const signatureChecksumKey =
      'android.app.extra.PROVISIONING_DEVICE_ADMIN_SIGNATURE_CHECKSUM';
  static const packageChecksumKey =
      'android.app.extra.PROVISIONING_DEVICE_ADMIN_PACKAGE_CHECKSUM';
  static const apkUrlKey =
      'android.app.extra.PROVISIONING_DEVICE_ADMIN_PACKAGE_DOWNLOAD_LOCATION';
  static const timeZoneKey = 'android.app.extra.PROVISIONING_TIME_ZONE';
  static const localeKey = 'android.app.extra.PROVISIONING_LOCALE';
  static const organizationKey =
      'android.app.extra.PROVISIONING_ORGANIZATION_NAME';
  static const adminExtrasBundleKey =
      'android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE';

  static const serverUrlKey = 'server_url';
  static const deviceCodeKey = 'device_code';
  static const enrollmentKeyKey = 'enrollment_key';

  static const defaultComponentName =
      'com.wonkrumdm/com.wonkrumdm.core.receivers.MdmDeviceAdminReceiver';

  final String componentName;
  final String apkUrl;
  final String signatureChecksum;
  final String packageChecksum;
  final String timeZone;
  final String locale;
  final String organization;
  final String serverUrl;
  final String deviceCode;
  final String enrollmentKey;

  static const ProvisioningConfig defaults = ProvisioningConfig(
    componentName: defaultComponentName,
  );

  static ProvisioningConfig? tryParse(String raw) {
    final decoded = _decodeObject(raw);
    if (decoded == null) {
      return null;
    }

    final bundleRaw = decoded[adminExtrasBundleKey];
    final bundle = bundleRaw is Map
        ? bundleRaw.cast<String, dynamic>()
        : const <String, dynamic>{};

    return ProvisioningConfig(
      componentName: _string(decoded[componentNameKey]),
      apkUrl: _string(decoded[apkUrlKey]),
      signatureChecksum: _string(decoded[signatureChecksumKey]),
      packageChecksum: _string(decoded[packageChecksumKey]),
      timeZone: _nonEmpty(decoded[timeZoneKey]) ?? 'Europe/Istanbul',
      locale: _nonEmpty(decoded[localeKey]) ?? 'tr_TR',
      organization: _nonEmpty(decoded[organizationKey]) ?? 'Wonkru MDM',
      serverUrl: _string(bundle[serverUrlKey]),
      deviceCode: _string(bundle[deviceCodeKey]),
      enrollmentKey: _string(bundle[enrollmentKeyKey]),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      componentNameKey: componentName,
      if (signatureChecksum.isNotEmpty) signatureChecksumKey: signatureChecksum,
      if (packageChecksum.isNotEmpty) packageChecksumKey: packageChecksum,
      apkUrlKey: apkUrl,
      timeZoneKey: timeZone,
      localeKey: locale,
      organizationKey: organization,
      adminExtrasBundleKey: <String, dynamic>{
        serverUrlKey: serverUrl,
        deviceCodeKey: deviceCode,
        if (enrollmentKey.isNotEmpty) enrollmentKeyKey: enrollmentKey,
      },
    };
  }

  String toJson({String? baseJson}) {
    final updated = toMap();
    final base = baseJson == null ? null : _decodeObject(baseJson);
    if (base == null) {
      return const JsonEncoder.withIndent('  ').convert(updated);
    }

    final previousExtras = base[adminExtrasBundleKey];
    final extras = previousExtras is Map<String, dynamic>
        ? previousExtras
        : <String, dynamic>{};
    extras
      ..remove(enrollmentKeyKey)
      ..addAll(updated[adminExtrasBundleKey] as Map<String, dynamic>);
    base
      ..remove(signatureChecksumKey)
      ..remove(packageChecksumKey)
      ..addAll(updated)
      ..[adminExtrasBundleKey] = extras;
    _removeAssignmentFields(base);
    return const JsonEncoder.withIndent('  ').convert(base);
  }

  static ProvisioningWifiConfig wifiFrom(String raw) =>
      ProvisioningWifiConfig.fromPayload(_decodeObject(raw) ?? {});

  static String? withWifi(String raw, ProvisioningWifiConfig wifi) {
    final decoded = _decodeObject(raw);
    if (decoded == null) return null;
    _removeAssignmentFields(decoded);
    wifi.writeTo(decoded);
    return const JsonEncoder.withIndent('  ').convert(decoded);
  }

  static String templateWithWifi(String template, String current) {
    final source = _decodeObject(current);
    final target = _decodeObject(template);
    if (source == null || target == null) return template;

    ProvisioningWifiConfig.copyExtras(source, target);
    return const JsonEncoder.withIndent('  ').convert(target);
  }

  static String? canonicalPayload(String raw) {
    final decoded = _normalize(raw);
    if (decoded == null || decoded.isEmpty) {
      return null;
    }

    return jsonEncode(decoded);
  }

  static String? formattedJson(String raw) {
    final decoded = _normalize(raw);
    if (decoded == null) return null;
    return const JsonEncoder.withIndent('  ').convert(decoded);
  }

  static String? validate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return L.provisioning.configEmpty;
    }
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map<String, dynamic>) {
        return L.provisioning.configNotObject;
      }
      return ProvisioningWifiConfig.fromPayload(decoded).validationError;
    } on FormatException catch (e) {
      return L.provisioning.invalidJson.trParams({'message': e.message});
    }
  }

  static Map<String, dynamic>? _decodeObject(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    Object? decoded;
    try {
      decoded = jsonDecode(trimmed);
    } on FormatException {
      return null;
    }
    if (decoded is! Map) {
      return null;
    }
    return decoded.cast<String, dynamic>();
  }

  static Map<String, dynamic>? _normalize(String raw) {
    final decoded = _decodeObject(raw);
    if (decoded == null) return null;
    ProvisioningWifiConfig.fromPayload(decoded).writeTo(decoded);
    _removeAssignmentFields(decoded);
    return decoded;
  }

  static void _removeAssignmentFields(Map<String, dynamic> payload) {
    final bundle = payload[adminExtrasBundleKey];
    for (final key in const ['policy_id', 'group_id']) {
      payload.remove(key);
      if (bundle is Map<String, dynamic>) bundle.remove(key);
    }
  }

  static String _string(Object? value) => value?.toString() ?? '';

  static String? _nonEmpty(Object? value) {
    final text = value?.toString() ?? '';
    return text.trim().isEmpty ? null : text;
  }
}
