import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show FileOperationType;
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_application_endpoint.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_file_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/file_asset_service.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminFileEndpoint', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';
    const body = 'id,name\n1,alpha\n';

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

    Future<FileAsset> createFile(
      Session session, {
      String name = 'Report',
      String? customName,
      String? fileExtension = 'csv',
      String filePath = 'files/report.csv',
      String? mimeType = 'text/csv',
      StorageDisk? disk = StorageDisk.public,
    }) {
      return FileAsset.db.insertRow(
        session,
        FileAsset(
          name: name,
          customName: customName,
          fileExtension: fileExtension,
          filePath: filePath,
          mimeType: mimeType,
          sizeBytes: 16,
          disk: disk,
        ),
      );
    }

    AdminFileUploadRequest uploadRequest({
      String fileName = 'report.csv',
      String? disk,
      String? mimeType = 'text/csv',
      List<int>? bytes,
    }) {
      return AdminFileUploadRequest(
        fileName: fileName,
        disk: disk,
        mimeType: mimeType,
        byteData: ByteData.sublistView(
          Uint8List.fromList(bytes ?? utf8.encode(body)),
        ),
      );
    }

    group('list', () {
      test('when files exist then the requested page is returned in '
          'order.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        for (var index = 1; index <= 5; index++) {
          await createFile(session, name: 'File $index');
        }

        final page = await endpoints.adminFile.list(
          adminBuilder,
          FileListRequest(page: 2, perPage: 2, sortBy: 'name'),
        );

        expect(page.total, 5);
        expect(page.page, 2);
        expect(page.perPage, 2);
        expect(page.items.map((file) => file.name), ['File 3', 'File 4']);
      });

      test('when a search is given then every searchable column matches on '
          'its own.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await FileAsset.db.insertRow(
          session,
          FileAsset(
            name: 'Invoice',
            customName: 'Kasim faturasi',
            filePath: 'files/q4-rapor.pdf',
            publicUrl: 'https://cdn.example.test/indir-777',
            sizeBytes: 10,
            fileHashSha256: 'aabbcc',
          ),
        );
        await createFile(session, name: 'Other', filePath: 'files/other.csv');

        for (final term in [
          'invoice',
          'kasim',
          'q4-rapor',
          'indir-777',
          'AABBCC',
        ]) {
          final page = await endpoints.adminFile.list(
            adminBuilder,
            FileListRequest(search: term),
          );
          expect(
            page.items.map((file) => file.name),
            ['Invoice'],
            reason: term,
          );
        }
      });

      test('when the extension and mime filters are given then only matching '
          'files are returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await createFile(session, name: 'Table');
        await createFile(
          session,
          name: 'Script',
          fileExtension: 'sh',
          filePath: 'files/run.sh',
          mimeType: 'text/x-shellscript',
        );

        final byExtension = await endpoints.adminFile.list(
          adminBuilder,
          FileListRequest(extensions: ['sh']),
        );
        expect(byExtension.total, 1);
        expect(byExtension.items.single.name, 'Script');

        final byMime = await endpoints.adminFile.list(
          adminBuilder,
          FileListRequest(mimeTypes: ['text/csv']),
        );
        expect(byMime.total, 1);
        expect(byMime.items.single.name, 'Table');
      });

      test('when the group filter is given then only members are '
          'returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await FileGroup.db.insertRow(
          session,
          FileGroup(name: 'Installers'),
        );
        final member = await createFile(session, name: 'Member');
        await createFile(session, name: 'Loose');

        await FileGroupMember.db.insertRow(
          session,
          FileGroupMember(fileId: member.id!, fileGroupId: group.id!),
        );

        final page = await endpoints.adminFile.list(
          adminBuilder,
          FileListRequest(fileGroupIds: [group.id!]),
        );

        expect(page.total, 1);
        expect(page.items.single.name, 'Member');
      });

      test('when the group filter names an empty group then nothing is '
          'returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await FileGroup.db.insertRow(
          session,
          FileGroup(name: 'Empty'),
        );
        await createFile(session);

        final page = await endpoints.adminFile.list(
          adminBuilder,
          FileListRequest(fileGroupIds: [group.id!]),
        );

        expect(page.total, 0);
        expect(page.items, isEmpty);
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile();

        final page = await endpoints.adminFile.list(
          adminBuilder,
          FileListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminFileEndpoint.maxPerPage);
      });
    });

    group('get', () {
      test('when the file exists then it is returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final file = await createFile(session, name: 'Lookup');

        final fetched = await endpoints.adminFile.get(adminBuilder, file.id!);

        expect(fetched.name, 'Lookup');
      });

      test('when the file does not exist then it is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminFile.get(adminBuilder, 987654),
          throwsExceptionWith('File 987654 does not exist.'),
        );
      });
    });

    group('create', () {
      test('when a file is created then it is stored without the id the panel '
          'sent.', () async {
        await createProfile();

        final created = await endpoints.adminFile.create(
          adminBuilder,
          FileAsset(
            id: 4242,
            name: 'Fresh',
            filePath: 'files/fresh.csv',
            sizeBytes: 8,
          ),
        );

        expect(created.id, isNot(4242));
        expect(created.name, 'Fresh');
      });
    });

    group('update', () {
      test('when a file is updated then every policy shipping it is '
          'bumped.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final file = await createFile(session);
        final policy = await Policy.db.insertRow(
          session,
          Policy(name: 'Shipping', version: 3),
        );
        await PolicyFile.db.insertRow(
          session,
          PolicyFile(
            policyId: policy.id!,
            fileId: file.id!,
            usageType: FileOperationType.download,
          ),
        );

        final saved = await endpoints.adminFile.update(
          adminBuilder,
          file.copyWith(name: 'Renamed'),
        );

        expect(saved.name, 'Renamed');
        expect((await Policy.db.findById(session, policy.id!))!.version, 4);
      });

      test(
        'when the file does not exist then the update is rejected.',
        () async {
          await createProfile();

          await expectLater(
            endpoints.adminFile.update(
              adminBuilder,
              FileAsset(id: 987654, name: 'Ghost', filePath: 'x', sizeBytes: 1),
            ),
            throwsExceptionWith('File 987654 does not exist.'),
          );
        },
      );
    });

    group('delete', () {
      test('when a file is deleted then its bytes, its row and the policy '
          'bump are handled.', () async {
        await createProfile();

        final uploaded = await endpoints.adminFile.uploadFile(
          adminBuilder,
          uploadRequest(disk: 'public'),
        );
        final session = sessionBuilder.build();
        final file = await FileAsset.db.insertRow(
          session,
          FileAsset(
            name: 'Stored',
            filePath: uploaded.filePath,
            disk: StorageDisk.values.byName(uploaded.disk),
            sizeBytes: uploaded.sizeBytes,
          ),
        );
        final policy = await Policy.db.insertRow(
          session,
          Policy(name: 'Shipping', version: 3),
        );
        await PolicyFile.db.insertRow(
          session,
          PolicyFile(
            policyId: policy.id!,
            fileId: file.id!,
            usageType: FileOperationType.download,
          ),
        );

        final deleted = await endpoints.adminFile.delete(adminBuilder, [
          file.id!,
        ]);

        expect(deleted, 1);
        expect(await FileAsset.db.findById(session, file.id!), isNull);
        expect(
          await session.storage.fileExists(
            storageId: uploaded.disk,
            path: uploaded.filePath,
          ),
          isFalse,
        );
        expect((await Policy.db.findById(session, policy.id!))!.version, 4);
      });

      test('when no file is given then nothing is deleted.', () async {
        await createProfile();

        expect(await endpoints.adminFile.delete(adminBuilder, []), 0);
      });
    });

    group('assignGroups', () {
      test('when groups are assigned then the memberships are '
          'replaced.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final file = await createFile(session);
        final kept = await FileGroup.db.insertRow(
          session,
          FileGroup(name: 'Kept'),
        );
        final removed = await FileGroup.db.insertRow(
          session,
          FileGroup(name: 'Removed'),
        );
        final added = await FileGroup.db.insertRow(
          session,
          FileGroup(name: 'Added'),
        );

        await FileGroupMember.db.insertRow(
          session,
          FileGroupMember(fileId: file.id!, fileGroupId: kept.id!),
        );
        await FileGroupMember.db.insertRow(
          session,
          FileGroupMember(fileId: file.id!, fileGroupId: removed.id!),
        );

        final assigned = await endpoints.adminFile.assignGroups(
          adminBuilder,
          [file.id!],
          [kept.id!, added.id!],
        );

        expect(assigned, 1);
        final groupIds = await endpoints.adminFile.groupIds(
          adminBuilder,
          file.id!,
        );
        expect(groupIds.toSet(), {kept.id, added.id});
      });
    });

    group('groupMembersForFiles', () {
      test('when files belong to groups then every membership is returned in '
          'one list.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createFile(session, name: 'First');
        final second = await createFile(session, name: 'Second');
        final loose = await createFile(session, name: 'Loose');
        final alpha = await FileGroup.db.insertRow(
          session,
          FileGroup(name: 'Alpha'),
        );
        final beta = await FileGroup.db.insertRow(
          session,
          FileGroup(name: 'Beta'),
        );

        await FileGroupMember.db.insertRow(
          session,
          FileGroupMember(fileId: first.id!, fileGroupId: alpha.id!),
        );
        await FileGroupMember.db.insertRow(
          session,
          FileGroupMember(fileId: second.id!, fileGroupId: beta.id!),
        );

        final members = await endpoints.adminFile.groupMembersForFiles(
          adminBuilder,
          [first.id!, second.id!, loose.id!],
        );

        expect(members, hasLength(2));
        expect(
          {
            for (final member in members)
              '${member.fileId}:${member.fileGroupId}',
          },
          {'${first.id}:${alpha.id}', '${second.id}:${beta.id}'},
        );
      });

      test('when no file id is given then the result is empty.', () async {
        await createProfile();

        expect(
          await endpoints.adminFile.groupMembersForFiles(adminBuilder, []),
          isEmpty,
        );
      });
    });

    group('downloadUrl', () {
      test(
        'when the file is public then its public url is returned.',
        () async {
          await createProfile();

          final uploaded = await endpoints.adminFile.uploadFile(
            adminBuilder,
            uploadRequest(disk: 'public'),
          );
          final session = sessionBuilder.build();
          final file = await FileAsset.db.insertRow(
            session,
            FileAsset(
              name: 'Public',
              filePath: uploaded.filePath,
              disk: StorageDisk.public,
              sizeBytes: uploaded.sizeBytes,
            ),
          );

          final url = await endpoints.adminFile.downloadUrl(
            adminBuilder,
            file.id!,
          );

          expect(url, isNotNull);
          expect(url, contains('/serverpod_cloud_storage'));
        },
      );

      test(
        'when the file is private then a temporary url is returned.',
        () async {
          await createProfile();

          final uploaded = await endpoints.adminFile.uploadFile(
            adminBuilder,
            uploadRequest(),
          );
          final session = sessionBuilder.build();
          final file = await FileAsset.db.insertRow(
            session,
            FileAsset(
              name: 'Private',
              filePath: uploaded.filePath,
              disk: StorageDisk.private,
              sizeBytes: uploaded.sizeBytes,
            ),
          );

          final url = await endpoints.adminFile.downloadUrl(
            adminBuilder,
            file.id!,
          );

          expect(url, isNotNull);
          expect(url, contains('method=temporaryFile'));
        },
      );

      test('when the file does not exist then null is returned.', () async {
        await createProfile();

        expect(
          await endpoints.adminFile.downloadUrl(adminBuilder, 987654),
          isNull,
        );
      });
    });

    group('AdminUploadEndpoint.getUploadDescription', () {
      test(
        'when the file purpose names the public disk then it is used.',
        () async {
          await createProfile();

          final description = await endpoints.adminUpload.getUploadDescription(
            adminBuilder,
            'file',
            'photo.png',
            128,
            disk: 'public',
          );

          expect(description.storageId, 'public');
          expect(
            description.path,
            startsWith('${AdminFileEndpoint.storagePrefix}/'),
          );
        },
      );

      test('when the file purpose omits the disk then the private storage is '
          'used.', () async {
        await createProfile();

        final description = await endpoints.adminUpload.getUploadDescription(
          adminBuilder,
          'file',
          'photo.png',
          128,
        );

        expect(description.storageId, 'private');
      });

      test('when the file purpose names an unknown disk then it is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminUpload.getUploadDescription(
            adminBuilder,
            'file',
            'photo.png',
            128,
            disk: 'floppy',
          ),
          throwsExceptionWith('Unknown storage "floppy".'),
        );
      });

      test('when the apk exceeds the cap then a typed upload exception '
          'carries the numbers.', () async {
        await createProfile();

        const oversize = 400 * 1024 * 1024;
        await expectLater(
          endpoints.adminUpload.getUploadDescription(
            adminBuilder,
            'apk',
            'app.apk',
            oversize,
          ),
          throwsA(
            isA<AdminUploadException>()
                .having((e) => e.purpose, 'purpose', 'apk')
                .having((e) => e.sizeBytes, 'sizeBytes', oversize)
                .having((e) => e.maxSizeBytes, 'maxSizeBytes', isNotNull),
          ),
        );
      });

      test('when the apk is 107 MB then it is accepted.', () async {
        await createProfile();

        final description = await endpoints.adminUpload.getUploadDescription(
          adminBuilder,
          'apk',
          'app.apk',
          107 * 1024 * 1024,
        );

        expect(description.storageId, 'public');
        expect(
          description.path,
          startsWith('${AdminApplicationEndpoint.storagePrefix}/'),
        );
      });

      test('when another purpose names a disk then its own storage is '
          'kept.', () async {
        await createProfile();

        final description = await endpoints.adminUpload.getUploadDescription(
          adminBuilder,
          'certificate',
          'cert.pem',
          128,
          disk: 'public',
        );

        // Certificates always go to the private disk; the requested disk is ignored.
        expect(description.storageId, 'private');
      });
    });

    group('uploadFile', () {
      test('when the file goes to the public storage then its url is '
          'returned.', () async {
        await createProfile();

        final response = await endpoints.adminFile.uploadFile(
          adminBuilder,
          uploadRequest(disk: 'public'),
        );

        expect(response.disk, 'public');
        expect(
          response.filePath,
          startsWith('${AdminFileEndpoint.storagePrefix}/'),
        );
        expect(response.filePath, endsWith('.csv'));
        expect(response.fileExtension, 'csv');
        expect(response.mimeType, 'text/csv');
        expect(response.sizeBytes, utf8.encode(body).length);
        expect(
          response.fileHashSha256,
          sha256.convert(utf8.encode(body)).toString(),
        );
        expect(response.publicUrl, isNotNull);
        expect(response.publicUrl, contains('/serverpod_cloud_storage'));

        final session = sessionBuilder.build();
        final stored = await session.storage.retrieveFile(
          storageId: 'public',
          path: response.filePath,
        );
        expect(
          utf8.decode(
            stored.buffer.asUint8List(
              stored.offsetInBytes,
              stored.lengthInBytes,
            ),
          ),
          body,
        );
      });

      test('when the disk is omitted then the private storage is '
          'used.', () async {
        await createProfile();

        final response = await endpoints.adminFile.uploadFile(
          adminBuilder,
          uploadRequest(),
        );

        expect(response.disk, AdminFileEndpoint.defaultDisk);
        expect(response.publicUrl, isNull);

        final session = sessionBuilder.build();
        expect(
          await session.storage.fileExists(
            storageId: AdminFileEndpoint.defaultDisk,
            path: response.filePath,
          ),
          isTrue,
        );
      });

      test('when the disk is unknown then the upload is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminFile.uploadFile(
            adminBuilder,
            uploadRequest(disk: 'floppy'),
          ),
          throwsExceptionWith('Unknown storage "floppy".'),
        );
      });
    });

    group('FileAssetService.storageIdFor', () {
      test(
        'when a disk is given then it maps onto its storage id.',
        () {
          expect(FileAssetService.storageIdFor(StorageDisk.private), 'private');
          expect(FileAssetService.storageIdFor(StorageDisk.public), 'public');
          expect(FileAssetService.storageIdFor(null), 'private');
        },
      );
    });
  });
}
