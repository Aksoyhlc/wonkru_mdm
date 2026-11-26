import 'dart:io';

class AppConfig {
  const AppConfig._();

  static String get name => Platform.environment['APP_NAME'] ?? 'Wonkru MDM';

  static int get deviceUploadMaxSizeKb =>
      int.tryParse(Platform.environment['DEVICE_UPLOAD_MAX_SIZE_KB'] ?? '') ??
      50 * 1024;

  /// Advertised in the provisioning payload as the `server_url` an agent
  /// talks to.
  static String get url =>
      Platform.environment['APP_URL'] ?? 'http://localhost:8090';
}
