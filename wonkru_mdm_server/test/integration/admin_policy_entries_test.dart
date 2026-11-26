import 'dart:convert';

import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';

import 'support/admin_fixture.dart';
import 'support/device_enrollment.dart';
import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Entry updates take the client's row, but the owning policy and creation
/// time stay the server's; moving an entry to another policy leaves that
/// policy's devices unaware of the change.
void main() {
  withServerpod('Given the policy entry endpoints', (
    sessionBuilder,
    endpoints,
  ) {
    late TestAdmin admin;
    late Policy policy;
    late Policy other;

    final oldCreatedAt = DateTime.utc(2021, 5, 5);

    setUp(() async {
      final session = sessionBuilder.build();
      admin = await createAdmin(session, sessionBuilder);
      policy = await Policy.db.insertRow(
        session,
        Policy(name: 'Target', version: 3),
      );
      other = await Policy.db.insertRow(
        session,
        Policy(name: 'Other', version: 7),
      );
    });

    Future<int> versionOf(Policy p) async =>
        (await Policy.db.findById(sessionBuilder.build(), p.id!))!.version;

    Future<PolicyApplication> attachedApplication() async {
      final session = sessionBuilder.build();
      final application = await Application.db.insertRow(
        session,
        Application(packageName: 'com.example.entry', appName: 'Entry'),
      );
      return PolicyApplication.db.insertRow(
        session,
        PolicyApplication(
          policyId: policy.id!,
          applicationId: application.id!,
          action: PolicyApplicationAction.install,
          sort: 1,
          createdAt: oldCreatedAt,
        ),
      );
    }

    Future<PolicyFile> attachedFile() async {
      final session = sessionBuilder.build();
      final file = await FileAsset.db.insertRow(
        session,
        FileAsset(name: 'f.txt', filePath: 'files/f.txt', sizeBytes: 1),
      );
      return PolicyFile.db.insertRow(
        session,
        PolicyFile(
          policyId: policy.id!,
          fileId: file.id!,
          usageType: FileOperationType.values.first,
          createdAt: oldCreatedAt,
        ),
      );
    }

    Future<PolicyCertificate> attachedCertificate() async {
      final session = sessionBuilder.build();
      final certificate = await Certificate.db.insertRow(
        session,
        Certificate(
          name: 'c',
          certificateType: CertificateType.values.first,
          certificateData: 'data',
          format: CertificateFormat.values.first,
        ),
      );
      return PolicyCertificate.db.insertRow(
        session,
        PolicyCertificate(
          policyId: policy.id!,
          certificateId: certificate.id!,
          createdAt: oldCreatedAt,
        ),
      );
    }

    group('entry updates', () {
      test('updateApplication writes the change, bumps its own policy and '
          'keeps the owner and creation time', () async {
        final entry = await attachedApplication();

        final saved = await endpoints.adminPolicy.updateApplication(
          admin.builder,
          entry.copyWith(
            action: PolicyApplicationAction.remove,
            policyId: other.id,
            createdAt: DateTime.utc(1999),
          ),
        );

        expect(saved.action, PolicyApplicationAction.remove);
        expect(saved.policyId, policy.id);
        expect(saved.createdAt, oldCreatedAt);
        expect(await versionOf(policy), 4);
        expect(await versionOf(other), 7);
      });

      test('updateFile keeps the owner and creation time and bumps the '
          'policy', () async {
        final entry = await attachedFile();

        final saved = await endpoints.adminPolicy.updateFile(
          admin.builder,
          entry.copyWith(
            destinationPath: '/sdcard/new',
            policyId: other.id,
            createdAt: DateTime.utc(1999),
          ),
        );

        expect(saved.destinationPath, '/sdcard/new');
        expect(saved.policyId, policy.id);
        expect(saved.createdAt, oldCreatedAt);
        expect(await versionOf(policy), 4);
        expect(await versionOf(other), 7);
      });

      test('updateCertificate keeps the owner and creation time and bumps '
          'the policy', () async {
        final entry = await attachedCertificate();

        final saved = await endpoints.adminPolicy.updateCertificate(
          admin.builder,
          entry.copyWith(policyId: other.id, createdAt: DateTime.utc(1999)),
        );

        expect(saved.policyId, policy.id);
        expect(saved.createdAt, oldCreatedAt);
        expect(await versionOf(policy), 4);
        expect(await versionOf(other), 7);
      });

      test('updating an entry that does not exist is rejected', () async {
        final entry = await attachedApplication();
        final file = await attachedFile();
        final certificate = await attachedCertificate();

        await expectLater(
          endpoints.adminPolicy.updateApplication(
            admin.builder,
            entry.copyWith(id: 987654),
          ),
          throwsExceptionWith('987654 does not exist'),
        );
        await expectLater(
          endpoints.adminPolicy.updateFile(
            admin.builder,
            file.copyWith(id: 987654),
          ),
          throwsExceptionWith('987654 does not exist'),
        );
        await expectLater(
          endpoints.adminPolicy.updateCertificate(
            admin.builder,
            certificate.copyWith(id: 987654),
          ),
          throwsExceptionWith('987654 does not exist'),
        );
        expect(await versionOf(policy), 3);
      });
    });

    group('entry detach', () {
      test('detachFile and detachCertificate remove the entry and bump the '
          'policy; an unknown id is a no-op', () async {
        final file = await attachedFile();
        final certificate = await attachedCertificate();

        await endpoints.adminPolicy.detachFile(admin.builder, file.id!);
        expect(await versionOf(policy), 4);
        await endpoints.adminPolicy.detachCertificate(
          admin.builder,
          certificate.id!,
        );
        expect(await versionOf(policy), 5);

        final session = sessionBuilder.build();
        expect(await PolicyFile.db.findById(session, file.id!), isNull);
        expect(
          await PolicyCertificate.db.findById(session, certificate.id!),
          isNull,
        );

        await endpoints.adminPolicy.detachFile(admin.builder, 987654);
        await endpoints.adminPolicy.detachCertificate(admin.builder, 987654);
        expect(await versionOf(policy), 5, reason: 'unknown id does not bump');
      });
    });

    group('reads', () {
      test('entry lists return only the policy\'s own entries', () async {
        await attachedApplication();
        await attachedFile();
        await attachedCertificate();

        final apps = await endpoints.adminPolicy.applications(
          admin.builder,
          policy.id!,
        );
        final files = await endpoints.adminPolicy.files(
          admin.builder,
          policy.id!,
        );
        final certificates = await endpoints.adminPolicy.certificates(
          admin.builder,
          policy.id!,
        );

        expect(apps.map((e) => e.policyId), [policy.id]);
        expect(files.map((e) => e.policyId), [policy.id]);
        expect(certificates.map((e) => e.policyId), [policy.id]);
        expect(
          await endpoints.adminPolicy.applications(admin.builder, other.id!),
          isEmpty,
        );
      });

      test('get returns the stored policy and rejects an unknown id', () async {
        final fetched = await endpoints.adminPolicy.get(
          admin.builder,
          policy.id!,
        );

        expect(fetched.name, 'Target');
        await expectLater(
          endpoints.adminPolicy.get(admin.builder, 987654),
          throwsExceptionWith('Policy 987654 does not exist'),
        );
      });

      test(
        'preview is the payload JSON the devices of the policy get',
        () async {
          await attachedApplication();

          final preview =
              jsonDecode(
                    await endpoints.adminPolicy.preview(
                      admin.builder,
                      policy.id!,
                    ),
                  )
                  as Map<String, dynamic>;

          expect(preview, containsPair('id', policy.id));
          expect(preview['applications'], hasLength(1));
        },
      );

      test('duplicate copies the entries under a new name and leaves the '
          'source untouched', () async {
        await attachedApplication();
        await attachedFile();
        await attachedCertificate();

        final copy = await endpoints.adminPolicy.duplicate(
          admin.builder,
          policy.id!,
          newName: 'Copy',
        );

        final session = sessionBuilder.build();
        expect(copy.id, isNot(policy.id));
        expect(copy.name, 'Copy');
        expect(
          await PolicyApplication.db.count(
            session,
            where: (t) => t.policyId.equals(copy.id!),
          ),
          1,
        );
        expect(
          await PolicyFile.db.count(
            session,
            where: (t) => t.policyId.equals(copy.id!),
          ),
          1,
        );
        expect(
          await PolicyCertificate.db.count(
            session,
            where: (t) => t.policyId.equals(copy.id!),
          ),
          1,
        );
        expect(await versionOf(policy), 3);
      });
    });

    test('when the default policy is deleted then new devices can still '
        'enroll and get no dangling policy', () async {
      await endpoints.adminPolicy.setDefault(admin.builder, policy.id!);

      await endpoints.adminPolicy.delete(admin.builder, policy.id!);

      final session = sessionBuilder.build();
      expect(
        await SettingService.getInt(session, SettingService.defaultPolicyKey),
        isNull,
        reason: 'setting must not point to the deleted policy',
      );
      final registered = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'no-default'),
      );
      final device = await Device.db.findFirstRow(
        session,
        where: (t) => t.uuid.equals(registered.uuid),
      );
      expect(device!.policyId, isNull);
    });

    test('when the default setting already points at a missing policy then '
        'enrollment still succeeds without a policy', () async {
      // The default-policy setting can point at a policy that no longer
      // exists; a foreign-key violation must not drop enrollment.
      final session = sessionBuilder.build();
      await Setting.db.deleteWhere(
        session,
        where: (t) => t.name.equals(SettingService.defaultPolicyKey),
      );
      await Setting.db.insertRow(
        session,
        Setting(name: SettingService.defaultPolicyKey, value: '987654'),
      );

      final registered = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'stale-setting'),
      );

      final device = await Device.db.findFirstRow(
        session,
        where: (t) => t.uuid.equals(registered.uuid),
      );
      expect(device!.policyId, isNull);
    });
  });
}
