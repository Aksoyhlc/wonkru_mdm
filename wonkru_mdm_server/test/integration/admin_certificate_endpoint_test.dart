import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show CertificateAction, CertificateFormat, CertificateType;
import 'package:wonkru_mdm_server/src/enums/upload_limit.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_certificate_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_upload_service.dart';

import '../support/certificate_fixtures.dart';
import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminCertificateEndpoint', (sessionBuilder, endpoints) {
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

    Certificate certificate({
      int? id,
      String name = 'Root CA',
      String? description,
      CertificateType certificateType = CertificateType.CA,
      CertificateFormat format = CertificateFormat.PEM,
      String certificateData =
          '-----BEGIN CERTIFICATE-----\nMIIB\n-----END CERTIFICATE-----',
      String? issuer,
      String? subject,
      String? filePath,
      String? fileHash,
      bool isActive = true,
    }) {
      return Certificate(
        id: id,
        name: name,
        description: description,
        certificateType: certificateType,
        format: format,
        certificateData: certificateData,
        issuer: issuer,
        subject: subject,
        filePath: filePath,
        fileHash: fileHash,
        isActive: isActive,
      );
    }

    AdminCertificateUploadRequest uploadRequest({
      String fileName = 'root.pem',
      List<int>? bytes,
    }) {
      return AdminCertificateUploadRequest(
        fileName: fileName,
        byteData: ByteData.sublistView(
          Uint8List.fromList(bytes ?? utf8.encode('certificate body')),
        ),
      );
    }

    Future<Policy> installedOnPolicy(Session session, int certificateId) async {
      final policy = await Policy.db.insertRow(
        session,
        Policy(name: 'Installing', version: 3),
      );

      await PolicyCertificate.db.insertRow(
        session,
        PolicyCertificate(
          policyId: policy.id!,
          certificateId: certificateId,
          action: CertificateAction.install,
        ),
      );

      return policy;
    }

    group('list', () {
      test('when certificates exist then the requested page is returned in '
          'order.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        for (var index = 1; index <= 5; index++) {
          await Certificate.db.insertRow(
            session,
            certificate(name: 'Certificate $index'),
          );
        }

        final page = await endpoints.adminCertificate.list(
          adminBuilder,
          AdminListRequest(page: 2, perPage: 2, sortBy: 'name'),
        );

        expect(page.total, 5);
        expect(page.page, 2);
        expect(page.perPage, 2);
        expect(page.items.map((row) => row.name), [
          'Certificate 3',
          'Certificate 4',
        ]);
      });

      test('when a search is given then name, issuer and subject are '
          'matched.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await Certificate.db.insertRow(
          session,
          certificate(name: 'Fleet root', issuer: 'Example CA'),
        );
        await Certificate.db.insertRow(
          session,
          certificate(name: 'Other', subject: 'example.test'),
        );

        final byIssuer = await endpoints.adminCertificate.list(
          adminBuilder,
          AdminListRequest(search: 'Example CA'),
        );
        expect(byIssuer.total, 1);
        expect(byIssuer.items.single.name, 'Fleet root');

        final bySubject = await endpoints.adminCertificate.list(
          adminBuilder,
          AdminListRequest(search: 'example.test'),
        );
        expect(bySubject.total, 1);
        expect(bySubject.items.single.name, 'Other');
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile();

        final page = await endpoints.adminCertificate.list(
          adminBuilder,
          AdminListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminCertificateEndpoint.maxPerPage);
      });
    });

    group('get', () {
      test('when the certificate exists then it is returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final stored = await Certificate.db.insertRow(
          session,
          certificate(name: 'Lookup'),
        );

        final fetched = await endpoints.adminCertificate.get(
          adminBuilder,
          stored.id!,
        );

        expect(fetched.name, 'Lookup');
      });

      test(
        'when the certificate does not exist then it is rejected.',
        () async {
          await createProfile();

          await expectLater(
            endpoints.adminCertificate.get(adminBuilder, 987654),
            throwsExceptionWith('Certificate 987654 does not exist.'),
          );
        },
      );
    });

    group('parse', () {
      // Self-signed `CN=Test Root CA` certificate, valid for a year from
      // 2026-09-20 12:01:53 UTC.
      const testCertificate =
          '-----BEGIN CERTIFICATE-----\n'
          'MIIDZzCCAk+gAwIBAgIUdxfv9ZcsIbum/nbZmRwCEufoqGwwDQYJKoZIhvcNAQEL\n'
          'BQAwQzELMAkGA1UEBhMCVFIxDzANBgNVBAoMBldvbmtydTEMMAoGA1UECwwDTURN\n'
          'MRUwEwYDVQQDDAxUZXN0IFJvb3QgQ0EwHhcNMjYwOTIwMTIwMTUzWhcNMjcwOTIw\n'
          'MTIwMTUzWjBDMQswCQYDVQQGEwJUUjEPMA0GA1UECgwGV29ua3J1MQwwCgYDVQQL\n'
          'DANNRE0xFTATBgNVBAMMDFRlc3QgUm9vdCBDQTCCASIwDQYJKoZIhvcNAQEBBQAD\n'
          'ggEPADCCAQoCggEBAJ4I19iWRvyadBMfbT8TjGNR3hUd9fodkE7RcRiLpzK44MVY\n'
          'Vvs5SsKgwcsqNqCF3t0oOYkE+2GuMVPlKHDJc1xqY6bkA8FEfLZG293UUQQfoQ3B\n'
          'SZJhGa69RqBxfmAhten+tVff/XIuYMJr6jUIfqJMwgiG8WEEBRshAfUsqh0sFM7c\n'
          '498NPIBGijuG0yyhjhwfrjUE7ryc1klQNRFCkBKkdbRP/1skUHLBHY68pA8Rsh9P\n'
          'WONZxXJX9s8W4IK/JXUCIYS9mXNNriZwMdSWiThljkl/5NUZsy55yjHaAJz5B4LH\n'
          'dbULeiaUBw56KXrfXN9E3jTpK/zLiYbjAq4fgCMCAwEAAaNTMFEwHQYDVR0OBBYE\n'
          'FCMGpjFt2q1YEYt5jIs9OPMFvK1gMB8GA1UdIwQYMBaAFCMGpjFt2q1YEYt5jIs9\n'
          'OPMFvK1gMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBABF69tv6\n'
          'ttJ06ZOuwuntEIILLUCzXPQtpztEcG7Q4joAar9DmssBpfmK1jK82SAx0/dDjF7M\n'
          'RjKgZGKloIAwBNXpM7IL+nbfA/G+7u394BGBCkipgVAD9ZQ4tw0/LQ+oQhbmgZ7n\n'
          'e2l0IyHxz5tGFX7mjctTgEk5ZTjiIEw2Xm3Y8YwGScRhfxuH+ChucIww7IL4zZby\n'
          'WjR4q94UOePoKSxuJixo4NzPpBQ3NqyZblXmsDOtreqeSyiG5Bq7Ne1gbzepXPqt\n'
          'KB632byDhuGdbcdc8telcSvL3ugkrcrL7NnqYeVR9VTbEq3HHIPA34sOAxY1k7yY\n'
          'CLebRyz8kcXO79M=\n'
          '-----END CERTIFICATE-----\n';

      test(
        'when the certificate is valid then its metadata is returned.',
        () async {
          await createProfile();

          final info = await endpoints.adminCertificate.parse(
            adminBuilder,
            testCertificate,
          );

          expect(info.issuer, 'CN=Test Root CA, O=Wonkru, OU=MDM, C=TR');
          expect(info.subject, 'CN=Test Root CA, O=Wonkru, OU=MDM, C=TR');
          expect(info.serialNumber, '7717EFF5972C21BBA6FE76D9991C0212E7E8A86C');
          expect(
            info.fingerprintSha256,
            '45D66A5175A5C04F378BD5BB549C69613D11B37E8959418469D726051DD1639C',
          );
          expect(info.format, 'PEM');
          expect(info.certificateType, 'CA');
          expect(info.validFrom, isNotNull);
          expect(info.validUntil, isNotNull);
          expect(
            info.validUntil!.isAfter(info.validFrom!.toUtc()),
            isTrue,
          );
        },
      );

      test('when the input cannot be parsed then it is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminCertificate.parse(adminBuilder, 'not a certificate'),
          throwsA(isA<CertificateParseException>()),
        );
      });

      test('when a PKCS#12 store is opened with a wrong password then a '
          'readable error is returned.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminCertificate.parse(
            adminBuilder,
            certificateFixturePkcs12ModernBase64,
            password: 'wrong-password',
          ),
          throwsA(
            isA<CertificateParseException>().having(
              (error) => error.message,
              'message',
              'Incorrect PKCS12 password or corrupt file.',
            ),
          ),
        );
      });

      test('when a PKCS#12 store is opened with the right password then its '
          'certificate is returned.', () async {
        await createProfile();

        final info = await endpoints.adminCertificate.parse(
          adminBuilder,
          certificateFixturePkcs12ModernBase64,
          password: certificateFixturePassword,
        );

        expect(info.format, 'PKCS12');
        expect(info.certificateType, 'CA');
        expect(info.subject, 'CN=Wonkru Test Root CA, O=Wonkru, OU=MDM, C=TR');
        expect(info.certificatePem, contains('-----BEGIN CERTIFICATE-----'));
      });

      test('when the session is not authenticated then parsing is '
          'rejected.', () async {
        await expectLater(
          endpoints.adminCertificate.parse(sessionBuilder, testCertificate),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('create', () {
      test('when a certificate is created then it is stored without the id '
          'the panel sent.', () async {
        await createProfile();

        final created = await endpoints.adminCertificate.create(
          adminBuilder,
          certificate(
            id: 4242,
            name: 'Fresh',
            certificateType: CertificateType.CLIENT,
          ),
        );

        expect(created.id, isNot(4242));
        expect(created.name, 'Fresh');
        expect(created.certificateType, CertificateType.CLIENT);
      });
    });

    group('update', () {
      test('when a certificate is updated then every policy installing it is '
          'bumped.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final stored = await Certificate.db.insertRow(
          session,
          certificate(name: 'Rotating'),
        );
        final policy = await installedOnPolicy(session, stored.id!);

        final saved = await endpoints.adminCertificate.update(
          adminBuilder,
          stored.copyWith(name: 'Rotated'),
        );

        expect(saved.name, 'Rotated');
        final reloaded = await Policy.db.findById(session, policy.id!);
        expect(reloaded!.version, 4);
      });

      test('when the certificate does not exist then the update is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminCertificate.update(
            adminBuilder,
            certificate(id: 987654, name: 'Ghost'),
          ),
          throwsExceptionWith('Certificate 987654 does not exist.'),
        );
      });
    });

    group('delete', () {
      test('when certificates are deleted then every policy installing them '
          'is bumped.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final stored = await Certificate.db.insertRow(
          session,
          certificate(name: 'Doomed'),
        );
        final policy = await installedOnPolicy(session, stored.id!);

        final deleted = await endpoints.adminCertificate.delete(adminBuilder, [
          stored.id!,
        ]);

        expect(deleted, 1);
        expect(await Certificate.db.findById(session, stored.id!), isNull);
        final reloaded = await Policy.db.findById(session, policy.id!);
        expect(reloaded!.version, 4);
      });

      test('when no certificate is given then nothing is deleted.', () async {
        await createProfile();

        expect(await endpoints.adminCertificate.delete(adminBuilder, []), 0);
      });
    });

    group('uploadFile', () {
      test(
        'when the upload is valid then the bytes are stored and hashed.',
        () async {
          await createProfile();

          const body = 'certificate body';
          final response = await endpoints.adminCertificate.uploadFile(
            adminBuilder,
            uploadRequest(),
          );

          expect(
            response.filePath,
            startsWith('${AdminCertificateEndpoint.storagePrefix}/'),
          );
          expect(response.filePath, endsWith('.pem'));
          expect(
            response.fileHash,
            sha256.convert(utf8.encode(body)).toString(),
          );
          expect(response.sizeBytes, utf8.encode(body).length);
          expect(response.publicUrl, isNotNull);

          final session = sessionBuilder.build();
          final stored = await session.storage.retrieveFile(
            storageId: DeviceUploadService.storageId,
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
        },
      );

      test('when the extension is not accepted then the upload is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminCertificate.uploadFile(
            adminBuilder,
            uploadRequest(fileName: 'payload.exe'),
          ),
          throwsExceptionWith('Unsupported certificate file type.'),
        );
      });

      test('when the file exceeds the limit then the upload is '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminCertificate.uploadFile(
            adminBuilder,
            uploadRequest(
              bytes: List<int>.filled(
                UploadLimit.certificate.defaultMb * UploadLimit.mebibyte + 1,
                0,
              ),
            ),
          ),
          throwsExceptionWith('Certificate file is too large.'),
        );
      });
    });

    group('downloadUrl', () {
      test('when the certificate has a stored file then its url is '
          'returned.', () async {
        await createProfile();

        final uploaded = await endpoints.adminCertificate.uploadFile(
          adminBuilder,
          uploadRequest(),
        );
        final session = sessionBuilder.build();
        final stored = await Certificate.db.insertRow(
          session,
          certificate(filePath: uploaded.filePath, fileHash: uploaded.fileHash),
        );

        final url = await endpoints.adminCertificate.downloadUrl(
          adminBuilder,
          stored.id!,
        );

        expect(url, isNotNull);
        expect(url, contains('/serverpod_cloud_storage'));
      });

      test(
        'when the certificate has no file then no url is returned.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          final stored = await Certificate.db.insertRow(
            session,
            certificate(),
          );

          expect(
            await endpoints.adminCertificate.downloadUrl(
              adminBuilder,
              stored.id!,
            ),
            isNull,
          );
        },
      );
    });
  });
}
