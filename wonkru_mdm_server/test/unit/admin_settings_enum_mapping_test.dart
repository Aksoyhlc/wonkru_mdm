import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_settings_service.dart';

void main() {
  group('Given the settings enum mapping', () {
    test(
      'when reading panel_default_theme then unknown falls back to dark',
      () {
        expect(AdminSettingsService.panelThemeFrom('light'), PanelTheme.light);
        expect(AdminSettingsService.panelThemeFrom('dark'), PanelTheme.dark);
        expect(
          AdminSettingsService.panelThemeFrom('system'),
          PanelTheme.system,
        );
        expect(AdminSettingsService.panelThemeFrom('bogus'), PanelTheme.dark);
        expect(AdminSettingsService.panelThemeFrom(null), PanelTheme.dark);
      },
    );

    test('when reading smtp_encryption then empty means none', () {
      expect(AdminSettingsService.smtpEncryptionFrom(''), SmtpEncryption.none);
      expect(
        AdminSettingsService.smtpEncryptionFrom(null),
        SmtpEncryption.none,
      );
      expect(
        AdminSettingsService.smtpEncryptionFrom('tls'),
        SmtpEncryption.tls,
      );
      expect(
        AdminSettingsService.smtpEncryptionFrom('SSL'),
        SmtpEncryption.ssl,
      );
      expect(
        AdminSettingsService.smtpEncryptionFrom('bogus'),
        SmtpEncryption.none,
      );
    });

    test('when writing smtp_encryption then none is stored empty', () {
      expect(
        AdminSettingsService.smtpEncryptionToSetting(SmtpEncryption.none),
        '',
      );
      expect(
        AdminSettingsService.smtpEncryptionToSetting(SmtpEncryption.tls),
        'tls',
      );
      expect(
        AdminSettingsService.smtpEncryptionToSetting(SmtpEncryption.ssl),
        'ssl',
      );
    });
  });
}
