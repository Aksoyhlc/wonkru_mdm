import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show
        CertificateFormat,
        CertificateType,
        FileOperationType,
        PolicyApplicationAction;
import 'package:wonkru_mdm_server/src/config/storage_config.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/policy_payload_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a policy payload', (sessionBuilder, endpoints) {
    Future<void> storeBytes(
      String path,
      String body, {
      String storageId = StorageConfig.publicDisk,
    }) async {
      final session = sessionBuilder.build();
      await session.storage.storeFile(
        storageId: storageId,
        path: path,
        byteData: ByteData.sublistView(Uint8List.fromList(utf8.encode(body))),
      );
    }

    Future<String?> publicUrlOrNull(String path) async {
      final session = sessionBuilder.build();
      final urls = await session.storage.publicDownloadUrls(
        storageId: StorageConfig.publicDisk,
        paths: [path],
      );
      return urls.first?.toString();
    }

    Future<String> storageUrl(String path) async =>
        (await publicUrlOrNull(path))!;

    Future<Policy> createPolicy() async {
      final session = sessionBuilder.build();
      return Policy.db.insertRow(session, Policy(name: 'Payload policy'));
    }

    Future<Map<String, dynamic>> buildPayload(Policy policy) async {
      final session = sessionBuilder.build();
      return PolicyPayloadService.buildMap(session, policy);
    }

    Future<FileAsset> attachFile(
      Policy policy, {
      required String name,
      required String filePath,
      String? publicUrl,
      int sizeBytes = 3,
      StorageDisk? disk,
    }) async {
      final session = sessionBuilder.build();
      final file = await FileAsset.db.insertRow(
        session,
        FileAsset(
          name: name,
          filePath: filePath,
          publicUrl: publicUrl,
          sizeBytes: sizeBytes,
          disk: disk ?? StorageDisk.public,
        ),
      );

      await PolicyFile.db.insertRow(
        session,
        PolicyFile(
          policyId: policy.id!,
          fileId: file.id!,
          usageType: FileOperationType.download,
        ),
      );

      return file;
    }

    test('when a distributed file is in the storage then public_url is its '
        'link.', () async {
      const path = 'device-uploads/report.log';
      await storeBytes(path, 'log contents');
      final policy = await createPolicy();
      await attachFile(policy, name: 'report.log', filePath: path);

      final payload = await buildPayload(policy);

      final files = payload['files'] as List;
      expect(files, hasLength(1));

      final entry = files.single as Map;
      expect((entry['file'] as Map)['public_url'], await storageUrl(path));
    });

    test('when the bytes are missing from the storage then public_url is '
        'null.', () async {
      final policy = await createPolicy();
      await attachFile(
        policy,
        name: 'missing.bin',
        filePath: 'device-uploads/missing.bin',
      );

      final payload = await buildPayload(policy);

      final entry = (payload['files'] as List).single as Map;
      expect((entry['file'] as Map)['public_url'], isNull);
    });

    test(
      'when the row already carries a public url then it is kept.',
      () async {
        const pinned = 'https://cdn.example.test/pinned.bin';
        final policy = await createPolicy();
        await attachFile(
          policy,
          name: 'pinned.bin',
          filePath: 'device-uploads/pinned.bin',
          publicUrl: pinned,
        );

        final payload = await buildPayload(policy);

        final entry = (payload['files'] as List).single as Map;
        expect((entry['file'] as Map)['public_url'], pinned);
      },
    );

    test('when a file lives on the private disk then public_url is a signed '
        'private link.', () async {
      const path = 'files/secret.txt';
      await storeBytes(
        path,
        'secret contents',
        storageId: StorageConfig.privateDisk,
      );
      final policy = await createPolicy();
      await attachFile(
        policy,
        name: 'secret.txt',
        filePath: path,
        disk: StorageDisk.private,
      );

      final payload = await buildPayload(policy);

      final url = (payload['files'] as List).single as Map;
      final publicUrl = (url['file'] as Map)['public_url'] as String?;
      expect(publicUrl, isNotNull);
      // Bytes live only on the private disk, so public resolution is empty.
      expect(await publicUrlOrNull(path), isNull);
      // The test runner uses Serverpod's built-in (database) storage, where the
      // signature parameter is `key`; production LocalFileCloudStorage emits
      // `token` instead. A `/private/` segment in the path is not a signature,
      // since an unsigned private URL carries the same path, so look for a
      // non-empty signature parameter in the query.
      final query = Uri.parse(publicUrl!).queryParameters;
      final signature = query['token'] ?? query['key'];
      expect(
        signature,
        allOf(isNotNull, isNotEmpty),
        reason: 'a secret file must not be downloadable unsigned: $publicUrl',
      );
    });

    test('when a file lives on the public disk then public_url is the ordinary '
        'public link.', () async {
      const path = 'files/handout.pdf';
      await storeBytes(
        path,
        'handout contents',
        storageId: StorageConfig.publicDisk,
      );
      final policy = await createPolicy();
      await attachFile(
        policy,
        name: 'handout.pdf',
        filePath: path,
        disk: StorageDisk.public,
      );

      final payload = await buildPayload(policy);

      final publicUrl =
          ((payload['files'] as List).single as Map)['file']['public_url']
              as String?;
      final expected = await storageUrl(path);
      expect(publicUrl, expected);
      expect(Uri.parse(publicUrl!).queryParameters['token'], isNull);
    });

    test('when an application version is in the storage then download_url is '
        'its link.', () async {
      const path = 'applications/example.apk';
      await storeBytes(path, 'apk bytes');
      final policy = await createPolicy();

      final session = sessionBuilder.build();
      final application = await Application.db.insertRow(
        session,
        Application(packageName: 'com.example.app', appName: 'Example'),
      );
      final version = await ApplicationVersion.db.insertRow(
        session,
        ApplicationVersion(
          applicationId: application.id!,
          versionName: '1.0.0',
          versionCode: 7,
          filePath: path,
        ),
      );
      await PolicyApplication.db.insertRow(
        session,
        PolicyApplication(
          policyId: policy.id!,
          applicationId: application.id!,
          targetVersionId: version.id!,
          action: PolicyApplicationAction.install,
        ),
      );

      final payload = await buildPayload(policy);

      final applications =
          (payload['applications'] as Map)['management_apps'] as List;
      expect(applications, hasLength(1));

      final entry = applications.single as Map;
      final versionPayload = entry['application_version'] as Map;
      expect(versionPayload['version_code'], 7);
      expect(versionPayload['download_url'], await storageUrl(path));
    });

    test('when an application version has no file then download_url is '
        'null.', () async {
      final policy = await createPolicy();

      final session = sessionBuilder.build();
      final application = await Application.db.insertRow(
        session,
        Application(packageName: 'com.example.empty', appName: 'Empty'),
      );
      final version = await ApplicationVersion.db.insertRow(
        session,
        ApplicationVersion(
          applicationId: application.id!,
          versionName: '1.0.0',
          versionCode: 1,
        ),
      );
      await PolicyApplication.db.insertRow(
        session,
        PolicyApplication(
          policyId: policy.id!,
          applicationId: application.id!,
          targetVersionId: version.id!,
          action: PolicyApplicationAction.install,
        ),
      );

      final payload = await buildPayload(policy);

      final entry =
          ((payload['applications'] as Map)['management_apps'] as List).single
              as Map;
      expect((entry['application_version'] as Map)['download_url'], isNull);
    });

    test('when a certificate has no stored bytes then download_url is '
        'null.', () async {
      final policy = await createPolicy();

      final session = sessionBuilder.build();
      final certificate = await Certificate.db.insertRow(
        session,
        Certificate(
          name: 'Root CA',
          certificateType: CertificateType.CA,
          certificateData: '-----BEGIN CERTIFICATE-----',
          format: CertificateFormat.PEM,
          filePath: 'certificates/root.pem',
        ),
      );
      await PolicyCertificate.db.insertRow(
        session,
        PolicyCertificate(
          policyId: policy.id!,
          certificateId: certificate.id!,
        ),
      );

      final payload = await buildPayload(policy);

      final certificates = payload['certificates'] as List;
      expect(certificates, hasLength(1));
      expect((certificates.single as Map)['download_url'], isNull);
    });
  });
}
