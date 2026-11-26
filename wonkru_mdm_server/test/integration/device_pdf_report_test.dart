import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_pdf_report_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminDeviceEndpoint PDF report', (
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

    Future<void> createProfile(String userId) async {
      final session = sessionBuilder.build();
      await AdminProfile.db.insertRow(
        session,
        AdminProfile(
          userId: UuidValue.fromString(userId),
          status: AdminAccountStatus.active,
        ),
      );
    }

    Future<Device> createDevice(Session session, {required String code}) {
      return Device.db.insertRow(
        session,
        Device(
          code: code,
          uuid: 'uuid-$code',
          name: 'Report Device',
          manufacturer: 'Samsung',
          model: 'Galaxy Tab',
          androidVersion: '14',
          sdkVersion: 34,
          batteryLevel: 87,
        ),
      );
    }

    List<int> asBytes(ByteData data) =>
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // PDF content streams are compressed and address glyphs by embedded-font
    // id, so text cannot be searched. Uncompressed document info (the title)
    // and page objects are still readable from the raw bytes.
    String rawOf(ByteData data) => latin1.decode(asBytes(data));

    int pageCount(ByteData data) =>
        RegExp(r'/Type\s*/Page\b(?!s)').allMatches(rawOf(data)).length;

    Future<void> insertApps(Session session, Device device, int count) async {
      await DeviceApplication.db.insert(session, [
        for (var i = 0; i < count; i++)
          DeviceApplication(
            deviceId: device.id!,
            packageName: 'com.example.app${i.toString().padLeft(4, '0')}',
            appName: 'Application ${i.toString().padLeft(4, '0')}',
            versionName: '1.0.0',
          ),
      ]);
    }

    group('reportPdf', () {
      test('when the device has synced data then a non-empty PDF is '
          'returned.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'PDF001');

        final sync = await DeviceSync.db.insertRow(
          session,
          DeviceSync(
            deviceId: device.id!,
            collectedAt: DateTime.utc(2026, 9, 20, 9, 16),
            createdAt: DateTime.utc(2026, 9, 20, 9, 16),
          ),
        );
        await DeviceStateCache.db.insertRow(
          session,
          DeviceStateCache(
            deviceId: device.id!,
            deviceSyncId: sync.id!,
            collectedAt: DateTime.utc(2026, 9, 20, 9, 16),
            updatedAt: DateTime.utc(2026, 9, 20, 9, 16),
            batteryLevel: 87,
            batteryState: 'charging',
            isOnline: true,
            totalStorageBytes: 64 * 1024 * 1024 * 1024,
            usedStorageBytes: 16 * 1024 * 1024 * 1024,
            storageUsagePct: 25,
            isRooted: false,
            encryptionStatus: 'encrypted',
            hasSecureLock: true,
            passwordIsSufficient: true,
          ),
        );
        await DeviceApplication.db.insertRow(
          session,
          DeviceApplication(
            deviceId: device.id!,
            packageName: 'com.example.app',
            appName: 'Sample Application',
            versionName: '1.2.3',
          ),
        );
        await DeviceLog.db.insertRow(
          session,
          DeviceLog(
            deviceId: device.id!,
            message: 'Device synced successfully',
            level: 2,
            tag: 'sync',
            loggedAt: DateTime.utc(2026, 9, 20, 9, 16),
          ),
        );

        final data = await endpoints.adminDevice.reportPdf(
          adminBuilder,
          device.id!,
          'tr',
        );
        final bytes = asBytes(data);

        expect(String.fromCharCodes(bytes.sublist(0, 5)), '%PDF-');
        expect(rawOf(data), contains('/Title(Cihaz Raporu - PDF001)'));
      });

      test('when the device has no sync, app or log then the report is still '
          'produced.', () async {
        await createProfile(adminUserId);

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'PDF002');

        final data = await endpoints.adminDevice.reportPdf(
          adminBuilder,
          device.id!,
          'tr',
        );
        final bytes = asBytes(data);

        expect(bytes, isNotEmpty);
        expect(String.fromCharCodes(bytes.sublist(0, 5)), '%PDF-');
      });

      test('when the device has more applications than the cap then the '
          'listing stops at the cap.', () async {
        await createProfile(adminUserId);
        final session = sessionBuilder.build();
        final atCap = await createDevice(session, code: 'CAP');
        final overCap = await createDevice(session, code: 'OVER');
        final underCap = await createDevice(session, code: 'UNDER');
        const cap = DevicePdfReportService.maxApplications;
        await insertApps(session, atCap, cap);
        await insertApps(session, overCap, cap + 120);
        await insertApps(session, underCap, cap - 120);

        Future<int> pagesOf(Device device) async => pageCount(
          await endpoints.adminDevice.reportPdf(adminBuilder, device.id!, 'tr'),
        );

        final pagesAtCap = await pagesOf(atCap);
        expect(await pagesOf(overCap), pagesAtCap);
        // Counter-check: rows really do consume pages.
        expect(await pagesOf(underCap), lessThan(pagesAtCap));
      });

      test('when the device does not exist then a clear error is '
          'thrown.', () async {
        await createProfile(adminUserId);

        await expectLater(
          endpoints.adminDevice.reportPdf(adminBuilder, 999999, 'tr'),
          throwsA(
            isA<Exception>().having(
              (error) => error.toString(),
              'message',
              contains('does not exist'),
            ),
          ),
        );
      });
    });
  });
}
