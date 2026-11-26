import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show FileOperationType;
import 'package:wonkru_mdm_server/src/config/storage_config.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/policy_payload_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the policy contract', (sessionBuilder, endpoints) {
    const adminUserId = '44444444-4444-4444-8444-444444444444';
    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<Map<String, dynamic>> payloadFor(Policy policy) async {
      final session = sessionBuilder.build();
      final stored = await Policy.db.insertRow(session, policy);
      return PolicyPayloadService.buildMap(session, stored);
    }

    Future<void> storePublic(String path) async {
      await sessionBuilder.build().storage.storeFile(
        storageId: StorageConfig.publicDisk,
        path: path,
        byteData: ByteData.sublistView(Uint8List.fromList(utf8.encode('img'))),
      );
    }

    Future<String?> publicUrl(String path) async {
      final urls = await sessionBuilder.build().storage.publicDownloadUrls(
        storageId: StorageConfig.publicDisk,
        paths: [path],
      );
      return urls.first?.toString();
    }

    test('a restriction with no value in the record defaults to 2', () async {
      final payload = await payloadFor(
        Policy(
          name: 'r',
          restrictionSettings:
              '{"restrictions":[{"restriction":"no_camera"},'
              '{"restriction":"no_sms","value":true},'
              '{"restriction":"no_usb_file_transfer","value":"0"}]}',
        ),
      );
      final values = [
        for (final entry
            in (payload['restriction_settings'] as Map)['restrictions'] as List)
          (entry as Map)['value'],
      ];
      expect(values, [2, 1, 0]);
    });

    test('legacy bool auto_time and text-converted fields are normalized', () async {
      final payload = await payloadFor(
        Policy(
          name: 'o',
          otherSettings:
              '{"auto_time":true,"auto_time_zone":false,'
              '"time_12_24":"24"}',
          displaySettings:
              '{"lock_screen_message":1234,'
              '"screen_capture_policy":"2"}',
        ),
      );
      final other = payload['other_settings'] as Map;
      expect(other['auto_time'], 1);
      expect(other['auto_time_zone'], 0);
      expect(other['time_12_24'], 24);
      final display = payload['display_settings'] as Map;
      expect(display['lock_screen_message'], '1234');
      expect(display['screen_capture_policy'], 2);
    });

    test('a corrupt JSON column only empties that column', () async {
      final payload = await payloadFor(
        Policy(name: 'b', audioSettings: '{broken', batterySettings: '{}'),
      );
      expect(payload['audio_settings'], isNull);
      expect(payload['battery_settings'], isA<Map>());
    });

    test('launcher background path is converted to a download URL', () async {
      const path = 'launcher-backgrounds/bg.png';
      await storePublic(path);
      final payload = await payloadFor(
        Policy(
          name: 'l',
          launcher: jsonEncode({
            'design': {
              'background': {'type': 'image', 'image': path},
            },
          }),
        ),
      );
      final background =
          ((payload['launcher'] as Map)['design'] as Map)['background'] as Map;
      expect(background['image'], await publicUrl(path));
      expect(background['image'], startsWith('http'));
    });

    test('an absolute launcher background URL is preserved as-is', () async {
      const external = 'https://cdn.example.test/bg.png';
      final payload = await payloadFor(
        Policy(
          name: 'l2',
          launcher: jsonEncode({
            'design': {
              'background': {'type': 'image', 'image': external},
            },
          }),
        ),
      );
      final background =
          ((payload['launcher'] as Map)['design'] as Map)['background'] as Map;
      expect(background['image'], external);
      // An unwritten `mode` defaults to false (kiosk not forced).
      expect((payload['launcher'] as Map)['mode'], isFalse);
    });

    test('a launcher path with no bytes becomes null', () async {
      final payload = await payloadFor(
        Policy(
          name: 'l3',
          launcher: jsonEncode({
            'design': {
              'background': {'image': 'launcher-backgrounds/missing.png'},
            },
          }),
        ),
      );
      final background =
          ((payload['launcher'] as Map)['design'] as Map)['background'] as Map;
      expect(background['image'], isNull);
    });

    test('a file entry carries a name and the URL is built from the path', () async {
      const path = 'files/handout.pdf';
      await storePublic(path);
      final session = sessionBuilder.build();
      final policy = await Policy.db.insertRow(session, Policy(name: 'f'));
      final file = await FileAsset.db.insertRow(
        session,
        FileAsset(
          name: 'handout',
          customName: 'Handout note',
          filePath: path,
          // An existing absolute publicUrl is ignored because the path
          // resolves.
          publicUrl: 'http://eski-sunucu:8080/storage/handout.pdf',
          sizeBytes: 3,
          disk: StorageDisk.public,
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

      final payload = await PolicyPayloadService.buildMap(session, policy);
      final entry = (payload['files'] as List).single as Map;
      expect(entry['name'], 'Handout note');
      expect((entry['file'] as Map)['public_url'], await publicUrl(path));
    });

    test('the panel rejects a record with min_brightness > max_brightness', () async {
      await AdminProfile.db.insertRow(
        sessionBuilder.build(),
        AdminProfile(
          userId: UuidValue.fromString(adminUserId),
          status: AdminAccountStatus.active,
        ),
      );
      await expectLater(
        endpoints.adminPolicy.create(
          adminBuilder,
          Policy(
            name: 'brightness',
            displaySettings: '{"min_brightness":80,"max_brightness":20}',
          ),
        ),
        throwsA(
          isA<AdminPolicyValidationException>().having(
            (e) => e.field,
            'field',
            'display_settings.min_brightness',
          ),
        ),
      );
    });
  });
}
