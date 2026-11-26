import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_file_group_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminFileGroupEndpoint', (
    sessionBuilder,
    endpoints,
  ) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';

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

    Future<FileGroup> createGroup(Session session, String name) {
      return FileGroup.db.insertRow(session, FileGroup(name: name));
    }

    Future<FileAsset> createFile(Session session, String name) {
      return FileAsset.db.insertRow(
        session,
        FileAsset(name: name, filePath: 'files/$name', sizeBytes: 4),
      );
    }

    Future<void> joinGroup(
      Session session,
      FileAsset file,
      FileGroup group,
    ) {
      return FileGroupMember.db.insertRow(
        session,
        FileGroupMember(fileId: file.id!, fileGroupId: group.id!),
      );
    }

    group('list', () {
      test('when groups exist then the requested page is returned in '
          'order.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        for (var index = 1; index <= 5; index++) {
          await createGroup(session, 'Group $index');
        }

        final page = await endpoints.adminFileGroup.list(
          adminBuilder,
          AdminListRequest(page: 2, perPage: 2, sortBy: 'name'),
        );

        expect(page.total, 5);
        expect(page.page, 2);
        expect(page.perPage, 2);
        expect(page.items.map((row) => row.group.name), ['Group 3', 'Group 4']);
      });

      test('when a search is given then the name and the description each '
          'match on their own.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await FileGroup.db.insertRow(
          session,
          FileGroup(name: 'Installers', description: 'Deployment payloads'),
        );
        await createGroup(session, 'Office');

        for (final search in ['Deployment', 'install']) {
          final page = await endpoints.adminFileGroup.list(
            adminBuilder,
            AdminListRequest(search: search),
          );
          expect(
            page.items.map((row) => row.group.name),
            ['Installers'],
            reason: search,
          );
        }
      });

      test(
        'when a group holds files then the row carries their count.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          final populated = await createGroup(session, 'Populated');
          await createGroup(session, 'Empty');

          for (final name in ['one', 'two']) {
            final file = await createFile(session, name);
            await joinGroup(session, file, populated);
          }

          final page = await endpoints.adminFileGroup.list(
            adminBuilder,
            AdminListRequest(sortBy: 'name'),
          );

          expect(page.items.first.group.name, 'Empty');
          expect(page.items.first.fileCount, 0);
          expect(page.items.last.group.name, 'Populated');
          expect(page.items.last.fileCount, 2);
        },
      );

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile();

        final page = await endpoints.adminFileGroup.list(
          adminBuilder,
          AdminListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminFileGroupEndpoint.maxPerPage);
      });
    });

    group('get', () {
      test('when the group exists then it is returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await createGroup(session, 'Lookup');

        final fetched = await endpoints.adminFileGroup.get(
          adminBuilder,
          group.id!,
        );

        expect(fetched.name, 'Lookup');
      });

      test('when the group does not exist then it is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminFileGroup.get(adminBuilder, 987654),
          throwsExceptionWith('File group 987654 does not exist.'),
        );
      });
    });

    group('create', () {
      test('when a group is created then it is stored without the id the '
          'panel sent.', () async {
        await createProfile();

        final created = await endpoints.adminFileGroup.create(
          adminBuilder,
          FileGroup(id: 4242, name: 'Fresh', color: '#ff0000'),
        );

        expect(created.id, isNot(4242));
        expect(created.name, 'Fresh');
        expect(created.color, '#ff0000');
        expect(created.isActive, isTrue);
      });
    });

    group('update', () {
      test('when a group is renamed then the change is stored.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await createGroup(session, 'Before');

        final saved = await endpoints.adminFileGroup.update(
          adminBuilder,
          group.copyWith(name: 'After'),
        );

        expect(saved.name, 'After');
        expect(
          (await FileGroup.db.findById(session, group.id!))!.name,
          'After',
        );
      });

      test('when the group does not exist then the update is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminFileGroup.update(
            adminBuilder,
            FileGroup(id: 987654, name: 'Ghost'),
          ),
          throwsExceptionWith('File group 987654 does not exist.'),
        );
      });
    });

    group('delete', () {
      test('when a group is deleted then its memberships go away and the '
          'files stay.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await createGroup(session, 'Doomed');
        final file = await createFile(session, 'kept');
        await joinGroup(session, file, group);

        final deleted = await endpoints.adminFileGroup.delete(adminBuilder, [
          group.id!,
        ]);

        expect(deleted, 1);
        expect(await FileGroup.db.findById(session, group.id!), isNull);
        expect(
          await FileGroupMember.db.find(
            session,
            where: (t) => t.fileGroupId.equals(group.id!),
          ),
          isEmpty,
        );
        expect(await FileAsset.db.findById(session, file.id!), isNotNull);
      });

      test('when no group is given then nothing is deleted.', () async {
        await createProfile();

        expect(await endpoints.adminFileGroup.delete(adminBuilder, []), 0);
      });
    });

    group('assignFiles', () {
      test('when files are assigned then the memberships are '
          'replaced.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final group = await createGroup(session, 'Target');
        final kept = await createFile(session, 'kept');
        final removed = await createFile(session, 'removed');
        final added = await createFile(session, 'added');

        await joinGroup(session, kept, group);
        await joinGroup(session, removed, group);

        final assigned = await endpoints.adminFileGroup.assignFiles(
          adminBuilder,
          group.id!,
          [kept.id!, added.id!],
        );

        expect(assigned, 2);
        final fileIds = await endpoints.adminFileGroup.fileIds(
          adminBuilder,
          group.id!,
        );
        expect(fileIds.toSet(), {kept.id, added.id});

        expect(
          await FileGroupMember.db.find(
            session,
            where: (t) => t.fileId.equals(removed.id!),
          ),
          isEmpty,
        );
      });

      test('when the group does not exist then the assignment is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminFileGroup.assignFiles(adminBuilder, 987654, []),
          throwsExceptionWith('File group 987654 does not exist.'),
        );
      });
    });
  });
}
