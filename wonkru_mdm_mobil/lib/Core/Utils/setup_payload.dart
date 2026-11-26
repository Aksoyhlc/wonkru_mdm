import 'dart:convert';

/// Values a QR code or an intent can carry to enroll a device.
///
/// Three shapes are recognized:
/// - the provisioning QR JSON, where the values live under
///   `android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE`,
/// - a flat JSON object with `server_url` / `enrollment_key` / `device_code`,
/// - a bare enrollment key as plain text.
class SetupPayload {
  const SetupPayload({this.serverUrl, this.enrollmentKey, this.deviceCode});

  static const extrasBundleKey =
      'android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE';

  final String? serverUrl;
  final String? enrollmentKey;
  final String? deviceCode;

  /// Parses [raw], or returns `null` when it carries no usable value.
  static SetupPayload? parse(String? raw) {
    final trimmed = raw?.trim() ?? '';
    if (trimmed.isEmpty) return null;

    final Object? decoded;
    try {
      decoded = jsonDecode(trimmed);
    } on FormatException {
      // Not JSON: a bare key is accepted, other text is not.
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) return null;
      return SetupPayload(enrollmentKey: trimmed);
    }

    if (decoded is! Map) return null;

    final extras = decoded[extrasBundleKey];
    final source = extras is Map ? extras : decoded;

    String? read(String key) {
      final value = source[key];
      if (value is! String) return null;
      final trimmedValue = value.trim();
      return trimmedValue.isEmpty ? null : trimmedValue;
    }

    final serverUrl = read('server_url');
    final enrollmentKey = read('enrollment_key');
    final deviceCode = read('device_code');
    if (serverUrl == null && enrollmentKey == null && deviceCode == null) {
      return null;
    }

    return SetupPayload(
      serverUrl: serverUrl,
      enrollmentKey: enrollmentKey,
      deviceCode: deviceCode,
    );
  }
}
