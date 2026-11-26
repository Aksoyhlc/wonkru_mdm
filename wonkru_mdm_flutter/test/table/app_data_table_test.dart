import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Data/Models/paged_result.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/app_data_table.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/table_column.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/Base/paged_table_controller.dart';

class _FakeTableController extends PagedTableController<int> {
  int fetchCount = 0;

  @override
  Future<PagedResult<int>> fetch(ListQuery query) async {
    fetchCount++;
    return const PagedResult(items: [1, 2, 3], total: 45);
  }
}

Future<void> _pumpTable(
  WidgetTester tester,
  _FakeTableController controller,
) async {
  Get.testMode = true;
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: AppDataTable<int>(
          controller: controller,
          columns: [
            AppColumn<int>(
              title: 'ID',
              cell: (row) => Text('Row $row'),
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('loads once and renders rows', (tester) async {
    final controller = _FakeTableController();

    await _pumpTable(tester, controller);

    expect(controller.hasLoaded, isTrue);
    expect(controller.fetchCount, 1);
    expect(find.text('Row 1'), findsOneWidget);
    expect(find.text('Row 2'), findsOneWidget);
    expect(find.text('Row 3'), findsOneWidget);
  });

  testWidgets('keeps the pager in sync with the controller page', (
    tester,
  ) async {
    final controller = _FakeTableController();

    await _pumpTable(tester, controller);

    final pager = tester.widget<SfDataPager>(find.byType(SfDataPager));
    expect(pager.pageCount, 3);
    expect(pager.controller!.selectedPageIndex, 0);

    await controller.setPage(1);
    await tester.pumpAndSettle();

    expect(pager.controller!.selectedPageIndex, 1);
    expect(controller.page.value, 1);
  });

  testWidgets('does not fetch again when the controller already loaded', (
    tester,
  ) async {
    final controller = _FakeTableController();
    await controller.load();

    await _pumpTable(tester, controller);

    expect(controller.fetchCount, 1);
  });
}
