import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/service/upload_limit_settings.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import '../support/settings_form_fixture.dart';

SettingsFormState _state({
  int apk = 256,
  int file = 256,
  int certificate = 10,
  int launcherBackground = 2,
  int deviceKb = 51200,
}) => validSettingsForm().copyWith(
  deviceUploadMaxSizeKb: deviceKb,
  uploadApkMaxSizeMb: apk,
  uploadFileMaxSizeMb: file,
  uploadCertificateMaxSizeMb: certificate,
  uploadLauncherBackgroundMaxSizeMb: launcherBackground,
);

Matcher _rejects(String field) => throwsA(
  isA<AdminSettingsException>().having((e) => e.field, 'field', field),
);

void main() {
  const ceilingMb = 288;

  group('validateUploadLimits', () {
    test('default limits stay below the ceiling', () {
      expect(
        () => UploadLimitSettings.validate(_state(), ceilingMb),
        returnsNormally,
      );
    });

    test('a limit equal to the ceiling is accepted', () {
      expect(
        () => UploadLimitSettings.validate(
          _state(file: ceilingMb),
          ceilingMb,
        ),
        returnsNormally,
      );
    });

    test('a limit exceeding the ceiling is rejected with the field name', () {
      expect(
        () => UploadLimitSettings.validate(
          _state(apk: ceilingMb + 1),
          ceilingMb,
        ),
        _rejects('uploadApkMaxSizeMb'),
      );
    });

    test('a limit below 1 MB is rejected', () {
      expect(
        () => UploadLimitSettings.validate(
          _state(certificate: 0),
          ceilingMb,
        ),
        _rejects('uploadCertificateMaxSizeMb'),
      );
    });

    test('the device upload limit (KB) is also subject to the ceiling', () {
      expect(
        () => UploadLimitSettings.validate(
          _state(deviceKb: ceilingMb * 1024 + 1),
          ceilingMb,
        ),
        _rejects('deviceUploadMaxSizeKb'),
      );
    });
  });
}
