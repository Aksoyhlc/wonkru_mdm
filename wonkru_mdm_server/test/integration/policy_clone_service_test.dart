import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show
        CertificateAction,
        CertificateFormat,
        CertificateType,
        FileOperationType,
        PolicyApplicationAction;
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/policy_clone_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  group('Given PolicyCloneService.slugify', () {
    test('when the name carries Turkish characters then they are folded to '
        'ascii.', () {
      expect(
        PolicyCloneService.slugify('Şirket Politikası'),
        'sirket-politikasi',
      );
      expect(
        PolicyCloneService.slugify('Değirmen Öğütücü'),
        'degirmen-ogutucu',
      );
    });

    test('when the name has runs of separators then they collapse into a '
        'single dash.', () {
      expect(PolicyCloneService.slugify('  A   B  '), 'a-b');
    });

    test('when the name has no usable character then the slug is empty.', () {
      expect(PolicyCloneService.slugify('###'), isEmpty);
    });
  });

  withServerpod('Given PolicyCloneService.duplicate', (sessionBuilder, _) {
    Future<Policy> seedPolicy({
      String name = 'Source',
      String slug = 'source',
      int version = 5,
    }) {
      final session = sessionBuilder.build();

      return Policy.db.insertRow(
        session,
        Policy(
          name: name,
          slug: slug,
          version: version,
          description: 'a description',
          adminPassword:
              r'$argon2id$v=19$m=65536,t=3,p=4$c2FsdHNhbHRzYWx0c2FsdA$Zm9vYmFyYmF6cXV1eA',
          batterySettings: '{"battery":1}',
        ),
      );
    }

    Future<Application> seedApplication(String packageName) {
      final session = sessionBuilder.build();

      return Application.db.insertRow(
        session,
        Application(packageName: packageName, appName: packageName),
      );
    }

    test('when the source is cloned then the settings are carried over and '
        'the copy is not the default.', () async {
      final source = await seedPolicy();
      final session = sessionBuilder.build();

      final copy = await PolicyCloneService.duplicate(session, source);

      expect(copy.id, isNot(source.id));
      expect(copy.name, 'Source${PolicyCloneService.copySuffix}');
      expect(copy.slug, 'source-copy');
      expect(copy.description, source.description);
      expect(copy.adminPassword, source.adminPassword);
      expect(copy.batterySettings, source.batterySettings);
      expect(copy.isActive, source.isActive);

      // A cloned policy starts at version 1 and explicitly drops the default
      // flag.
      expect(copy.version, 1);
      expect(copy.defaultPolicy, isFalse);

      final stored = await Policy.db.findById(session, copy.id!);
      expect(stored, isNotNull);
      expect(stored!.version, 1);
    });

    test('when a name is supplied then it is used and the slug follows '
        'it.', () async {
      final source = await seedPolicy();
      final session = sessionBuilder.build();

      final copy = await PolicyCloneService.duplicate(
        session,
        source,
        newName: 'Custom Name',
      );

      expect(copy.name, 'Custom Name');
      expect(copy.slug, 'custom-name');
    });

    test('when the generated slug is taken then the next one is '
        'suffixed.', () async {
      final source = await seedPolicy();
      final session = sessionBuilder.build();

      final first = await PolicyCloneService.duplicate(session, source);
      final second = await PolicyCloneService.duplicate(session, source);

      expect(first.slug, 'source-copy');
      expect(second.slug, 'source-copy-1');
      expect(second.slug, isNot(first.slug));
    });

    test('when the source has related rows then they are copied onto the '
        'copy.', () async {
      final source = await seedPolicy();
      final session = sessionBuilder.build();

      final application = await seedApplication('com.example.app');
      final certificate = await Certificate.db.insertRow(
        session,
        Certificate(
          name: 'Root CA',
          certificateType: CertificateType.CA,
          certificateData: 'PEM',
          format: CertificateFormat.PEM,
        ),
      );
      final file = await FileAsset.db.insertRow(
        session,
        FileAsset(name: 'notes.txt', filePath: 'files/notes.txt', sizeBytes: 5),
      );

      await PolicyApplication.db.insertRow(
        session,
        PolicyApplication(
          policyId: source.id!,
          applicationId: application.id!,
          action: PolicyApplicationAction.install,
          uninstallBlock: true,
        ),
      );
      await PolicyCertificate.db.insertRow(
        session,
        PolicyCertificate(
          policyId: source.id!,
          certificateId: certificate.id!,
          action: CertificateAction.install,
        ),
      );
      await PolicyFile.db.insertRow(
        session,
        PolicyFile(
          policyId: source.id!,
          fileId: file.id!,
          usageType: FileOperationType.open,
          destinationPath: '/sdcard/notes.txt',
          replaceIfExists: false,
          openAfterDownload: true,
        ),
      );

      final copy = await PolicyCloneService.duplicate(session, source);
      final copyId = copy.id!;

      final applications = await PolicyApplication.db.find(
        session,
        where: (t) => t.policyId.equals(copyId),
      );
      expect(applications, hasLength(1));

      final copiedApplication = applications.single;
      expect(copiedApplication.applicationId, application.id);
      expect(copiedApplication.action, PolicyApplicationAction.install);
      expect(copiedApplication.sort, 1);
      expect(copiedApplication.uninstallBlock, isTrue);

      final certificates = await PolicyCertificate.db.find(
        session,
        where: (t) => t.policyId.equals(copyId),
      );
      expect(certificates, hasLength(1));
      expect(certificates.single.certificateId, certificate.id);
      expect(certificates.single.action, CertificateAction.install);

      final files = await PolicyFile.db.find(
        session,
        where: (t) => t.policyId.equals(copyId),
      );
      expect(files, hasLength(1));
      expect(files.single.fileId, file.id);
      expect(files.single.usageType, FileOperationType.open);
      expect(files.single.destinationPath, '/sdcard/notes.txt');
      expect(files.single.replaceIfExists, isFalse);
      expect(files.single.openAfterDownload, isTrue);
    });

    test('when the source has several applications then the sort order is '
        'appended.', () async {
      final source = await seedPolicy();
      final session = sessionBuilder.build();

      final first = await seedApplication('com.example.one');
      final second = await seedApplication('com.example.two');

      for (final application in [first, second]) {
        await PolicyApplication.db.insertRow(
          session,
          PolicyApplication(
            policyId: source.id!,
            applicationId: application.id!,
            action: PolicyApplicationAction.install,
          ),
        );
      }

      final copy = await PolicyCloneService.duplicate(session, source);

      final applications = await PolicyApplication.db.find(
        session,
        where: (t) => t.policyId.equals(copy.id!),
        orderByList: (t) => [t.sort.asc()],
      );

      expect(applications.map((entry) => entry.applicationId), [
        first.id,
        second.id,
      ]);
      expect(applications.map((entry) => entry.sort), [1, 2]);
    });
  });
}
