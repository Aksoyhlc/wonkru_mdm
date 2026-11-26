import 'package:serverpod/serverpod.dart';

import '../service/setting_service.dart';

/// Size limits for panel uploads — single source of truth.
///
/// Every limit has a default ([defaultMb]) and a key in the `settings` table
/// ([settingKey]). A value changed from the settings page takes effect on the
/// next upload without a restart; when no setting has been saved the default is
/// used.
///
/// Limits cannot exceed Serverpod's `maxRequestSize` configuration (see
/// [ceilingBytes]): that value is read at server startup and the server rejects
/// an upload request larger than it.
///
/// The devices' own upload limit (`device_upload_max_size_kb`) lives in
/// `DeviceUploadService`.
enum UploadLimit {
  apk('upload_apk_max_size_mb', 256),

  file('upload_file_max_size_mb', 256),

  certificate('upload_certificate_max_size_mb', 10),

  launcherBackground('upload_launcher_background_max_size_mb', 2);

  const UploadLimit(this.settingKey, this.defaultMb);

  final String settingKey;

  final int defaultMb;

  static const mebibyte = 1024 * 1024;

  Future<int> megabytes(Session session, {Transaction? transaction}) async {
    final value = await SettingService.getInt(
      session,
      settingKey,
      fallback: defaultMb,
      transaction: transaction,
    );
    return value == null || value <= 0 ? defaultMb : value;
  }

  Future<int> maxBytes(Session session, {Transaction? transaction}) async =>
      await megabytes(session, transaction: transaction) * mebibyte;

  static int ceilingBytes(Session session) =>
      session.serverpod.config.maxRequestSize;

  static int ceilingMb(Session session) => ceilingBytes(session) ~/ mebibyte;
}
