import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/files_controller.dart';

void main() {
  group('FilesController.buildRequest', () {
    test('page is converted to the one-based backend page', () {
      final first = FilesController.buildRequest(const ListQuery(page: 0));
      final third = FilesController.buildRequest(const ListQuery(page: 2));

      expect(first.page, 1);
      expect(third.page, 3);
    });

    test('perPage, search and sort are mapped straight through', () {
      final request = FilesController.buildRequest(
        const ListQuery(
          pageSize: 50,
          search: 'rapor',
          sortBy: 'sizeBytes',
          sortAsc: false,
        ),
      );

      expect(request.perPage, 50);
      expect(request.search, 'rapor');
      expect(request.sortBy, 'sizeBytes');
      expect(request.sortDesc, isTrue);
    });

    test('sortAsc true maps to sortDesc false', () {
      final request = FilesController.buildRequest(const ListQuery());

      expect(request.sortDesc, isFalse);
    });

    test('single-value filters are wrapped in one-element lists', () {
      final request = FilesController.buildRequest(
        const ListQuery(
          filters: {'extension': 'pdf', 'mimeType': 'application/pdf'},
        ),
      );

      expect(request.extensions, ['pdf']);
      expect(request.mimeTypes, ['application/pdf']);
    });

    test('comma-separated filters split, trim and drop blanks', () {
      final request = FilesController.buildRequest(
        const ListQuery(
          filters: {
            'extension': 'png, jpg , ',
            'mimeType': 'image/png,image/jpeg',
          },
        ),
      );

      expect(request.extensions, ['png', 'jpg']);
      expect(request.mimeTypes, ['image/png', 'image/jpeg']);
    });

    test('blank filters are trimmed away and omitted as null', () {
      final request = FilesController.buildRequest(
        const ListQuery(filters: {'extension': '  ', 'mimeType': ''}),
      );

      expect(request.extensions, isNull);
      expect(request.mimeTypes, isNull);
    });

    test('fileGroupId becomes a one-element list; absent stays null', () {
      final withGroup = FilesController.buildRequest(
        const ListQuery(filters: {'fileGroupId': 7}),
      );
      final withoutGroup = FilesController.buildRequest(const ListQuery());

      expect(withGroup.fileGroupIds, [7]);
      expect(withoutGroup.fileGroupIds, isNull);
    });
  });
}
