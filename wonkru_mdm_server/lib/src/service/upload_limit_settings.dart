import '../enums/upload_limit.dart';
import '../generated/protocol.dart';

/// Upload-size limit pairing and validation for the settings form.
class UploadLimitSettings {
  const UploadLimitSettings._();

  static List<(UploadLimit, int)> values(SettingsFormState state) => [
    (UploadLimit.apk, state.uploadApkMaxSizeMb),
    (UploadLimit.file, state.uploadFileMaxSizeMb),
    (UploadLimit.certificate, state.uploadCertificateMaxSizeMb),
    (UploadLimit.launcherBackground, state.uploadLauncherBackgroundMaxSizeMb),
  ];

  /// Rejects a limit below 1 MB or above the server's request-size ceiling, so
  /// an invalid value cannot leave a partial settings record.
  static void validate(SettingsFormState state, int ceilingMb) {
    const labels = {
      UploadLimit.apk: ('uploadApkMaxSizeMb', 'APK upload limit'),
      UploadLimit.file: ('uploadFileMaxSizeMb', 'File upload limit'),
      UploadLimit.certificate: (
        'uploadCertificateMaxSizeMb',
        'Certificate upload limit',
      ),
      UploadLimit.launcherBackground: (
        'uploadLauncherBackgroundMaxSizeMb',
        'Launcher background upload limit',
      ),
    };

    for (final (limit, value) in values(state)) {
      final (field, label) = labels[limit]!;
      if (value < 1) {
        throw AdminSettingsException(
          message: '$label must be at least 1 MB.',
          field: field,
        );
      }
      if (value > ceilingMb) {
        throw AdminSettingsException(
          message:
              '$label ($value MB) exceeds the server request-size ceiling '
              '($ceilingMb MB). For larger files, raise the '
              "`maxRequestSize` value in the server configuration.",
          field: field,
        );
      }
    }

    if (state.deviceUploadMaxSizeKb > ceilingMb * 1024) {
      throw AdminSettingsException(
        message:
            'Device upload limit (${state.deviceUploadMaxSizeKb} KB) '
            'exceeds the server request-size ceiling ($ceilingMb MB).',
        field: 'deviceUploadMaxSizeKb',
      );
    }
  }
}
