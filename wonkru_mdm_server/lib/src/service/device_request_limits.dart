import 'package:wonkru_core_server/wonkru_core_server.dart';

/// Field length and list size limits accepted by the device endpoints.
///
/// `register` is unauthenticated and the other endpoints can be abused by a
/// compromised device. Serverpod has no per-endpoint request size limit (only
/// the global `maxRequestSize`), so fields are capped individually here and
/// [DeviceRequestInvalidException] is thrown on overflow.
class DeviceRequestLimits {
  const DeviceRequestLimits._();

  /// Short texts like manufacturer/model/brand/serial no (DB `varchar(255)`).
  static const shortText = 255;

  static const deviceCode = 64;

  static const versionRelease = 64;

  static const enrollmentKey = 256;

  /// Admin password attempt; Argon2 verification is expensive, so oversized
  /// input must not burn CPU.
  static const password = 256;

  /// Sync body (JSON). A full sync with the app list is a few hundred KB; 8 MiB
  /// leaves ample headroom.
  static const syncPayloadChars = 8 * 1024 * 1024;

  static const syncApps = 2000;

  static void requireMaxLength(String? value, int max, String field) {
    if (value != null && value.length > max) {
      throw DeviceRequestInvalidException(
        message: '"$field" is too long (max $max characters).',
        field: field,
      );
    }
  }

  static void checkRegister(DeviceRegisterRequest request) {
    requireMaxLength(request.deviceCode, deviceCode, 'deviceCode');
    requireMaxLength(request.manufacturer, shortText, 'manufacturer');
    requireMaxLength(request.model, shortText, 'model');
    requireMaxLength(request.brand, shortText, 'brand');
    requireMaxLength(request.serialNo, shortText, 'serialNo');
    requireMaxLength(
      request.version?.release,
      versionRelease,
      'version.release',
    );
    requireMaxLength(request.enrollmentKey, enrollmentKey, 'enrollmentKey');
  }
}
