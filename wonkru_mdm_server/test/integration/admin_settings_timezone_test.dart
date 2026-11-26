import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/admin_settings_service.dart';

import '../support/settings_form_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given panel timezone setting', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111112';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<void> createProfile() async {
      final session = sessionBuilder.build();
      await AdminProfile.db.insertRow(
        session,
        AdminProfile(
          userId: UuidValue.fromString(adminUserId),
          status: AdminAccountStatus.active,
        ),
      );
    }

    test('read returns null when there is no setting', () async {
      final session = sessionBuilder.build();

      expect((await AdminSettingsService.read(session)).panelTimezone, isNull);
    });

    test('the written zone is read back', () async {
      final session = sessionBuilder.build();

      await AdminSettingsService.persist(
        session,
        validSettingsForm().copyWith(panelTimezone: 'Europe/Istanbul'),
      );

      expect(
        (await AdminSettingsService.read(session)).panelTimezone,
        'Europe/Istanbul',
      );
    });

    test('an unknown zone is rejected and nothing is written', () async {
      final session = sessionBuilder.build();

      await expectLater(
        AdminSettingsService.persist(
          session,
          validSettingsForm().copyWith(panelTimezone: 'Mars/Olympus'),
        ),
        throwsA(
          isA<AdminSettingsException>().having(
            (e) => e.field,
            'field',
            'panelTimezone',
          ),
        ),
      );

      expect((await AdminSettingsService.read(session)).panelTimezone, isNull);
    });

    test('an empty value clears the setting', () async {
      final session = sessionBuilder.build();

      await AdminSettingsService.persist(
        session,
        validSettingsForm().copyWith(panelTimezone: 'Europe/Istanbul'),
      );
      await AdminSettingsService.persist(
        session,
        validSettingsForm().copyWith(panelTimezone: null),
      );

      expect((await AdminSettingsService.read(session)).panelTimezone, isNull);
    });

    test('the endpoint returns the configured zone', () async {
      await createProfile();
      final session = sessionBuilder.build();
      await AdminSettingsService.persist(
        session,
        validSettingsForm().copyWith(panelTimezone: 'America/New_York'),
      );

      expect(
        await endpoints.adminSettings.getTimezone(adminBuilder),
        'America/New_York',
      );
    });
  });
}
