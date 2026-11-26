import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_applications_section/application_version_selection.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_files_section/policy_file_operations.dart';

ApplicationVersion _version(
  int id, {
  required int code,
  bool isDefault = false,
  bool isActive = true,
}) => ApplicationVersion(
  id: id,
  applicationId: 1,
  versionName: 'v$code',
  versionCode: code,
  isDefault: isDefault,
  isActive: isActive,
);

void main() {
  group('selectDefaultApplicationVersion', () {
    test('empty list returns null', () {
      expect(selectDefaultApplicationVersion(const []), isNull);
    });

    test('default version takes precedence', () {
      final versions = [
        _version(1, code: 10),
        _version(2, code: 3, isDefault: true),
      ];

      expect(selectDefaultApplicationVersion(versions)?.id, 2);
    });

    test('when no default exists, the highest versionCode is selected', () {
      final versions = [
        _version(1, code: 4),
        _version(2, code: 9),
        _version(3, code: 7),
      ];

      expect(selectDefaultApplicationVersion(versions)?.id, 2);
    });

    test('inactive versions are ignored', () {
      final versions = [
        _version(1, code: 100, isActive: false),
        _version(2, code: 5, isActive: false),
        _version(3, code: 6),
      ];

      expect(selectDefaultApplicationVersion(versions)?.id, 3);
    });

    test('when no active version exists, the whole list is evaluated', () {
      final versions = [
        _version(1, code: 100, isActive: false),
        _version(2, code: 5, isActive: false),
      ];

      expect(selectDefaultApplicationVersion(versions)?.id, 1);
    });
  });

  group('policyFileOperations', () {
    test('carries the FileOperationType values in policy order', () {
      expect(policyFileOperations, [
        FileOperationType.open,
        FileOperationType.download,
        FileOperationType.delete,
      ]);
    });
  });

  group('filesForOperation', () {
    final entries = [
      PolicyFile(policyId: 1, fileId: 10, usageType: FileOperationType.open),
      PolicyFile(
        policyId: 1,
        fileId: 11,
        usageType: FileOperationType.download,
      ),
      PolicyFile(
        policyId: 1,
        fileId: 12,
        usageType: FileOperationType.download,
      ),
      PolicyFile(policyId: 1, fileId: 13, usageType: FileOperationType.delete),
    ];

    test('returns only the requested operation type', () {
      expect(
        filesForOperation(
          entries,
          FileOperationType.download,
        ).map((e) => e.fileId),
        [11, 12],
      );
    });

    test('empty input list returns an empty list', () {
      expect(filesForOperation(const [], FileOperationType.open), isEmpty);
    });
  });
}
