import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Table/table_pager.dart';

class _Delegate extends DataGridSource {
  @override
  List<DataGridRow> get rows => const [];

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) => null;
}

Future<void> pumpPager(
  WidgetTester tester, {
  required int pageCount,
  double width = 900,
  int total = 40,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 300);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: TablePager(
            page: 0,
            pageCount: pageCount,
            perPage: 15,
            total: total,
            delegate: _Delegate(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('pager button fits its box, not clipped', (tester) async {
    await pumpPager(tester, pageCount: 3, width: 500);

    final pager = tester.getSize(find.byType(SfDataPager));
    expect(pager.height, 44);
    expect(tester.takeException(), isNull);
  });

  testWidgets('page buttons are hidden on a single page', (tester) async {
    await pumpPager(tester, pageCount: 1, total: 3);

    expect(find.byType(SfDataPager), findsNothing);
    expect(find.textContaining('of 3'), findsOneWidget);
  });

  testWidgets('no bar on a single page at narrow width', (tester) async {
    await pumpPager(tester, pageCount: 1, width: 400, total: 3);

    expect(find.byType(SfDataPager), findsNothing);
    expect(tester.getSize(find.byType(TablePager)).height, 0);
  });

  testWidgets('buttons are visible across multiple pages', (tester) async {
    await pumpPager(tester, pageCount: 4);

    expect(find.byType(SfDataPager), findsOneWidget);
  });
}
