import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Data/Models/list_query.dart';
import 'package:wonkru_mdm_flutter/Data/Models/paged_result.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/device_applications_controller.dart';

class _FakeController extends DeviceApplicationsController {
  _FakeController(this.all) : super(1);

  final List<DeviceApplication> all;

  @override
  Future<PagedResult<DeviceApplication>> fetch(ListQuery query) async =>
      buildPage(all, query);
}

DeviceApplication app(String name, String pkg, {bool system = false}) =>
    DeviceApplication(
      deviceId: 1,
      appName: name,
      packageName: pkg,
      isSystemApp: system,
    );

void main() {
  late _FakeController controller;

  setUp(() {
    controller = _FakeController([
      app('Chrome', 'com.android.chrome', system: true),
      app('Files', 'com.google.android.apps.nbu.files'),
      app('wonkrumdm', 'com.wonkrumdm'),
    ]);
  });

  test('search matches on name and package name', () async {
    await controller.setSearch('nbu');

    expect(controller.total.value, 1);
    expect(controller.rows.single.appName, 'Files');
  });

  test('default sorting puts user apps first', () async {
    await controller.load();

    expect(controller.rows.first.isSystemApp, isFalse);
    expect(controller.rows.last.appName, 'Chrome');
  });

  test('can be sorted descending by name', () async {
    await controller.setSort('appName', false);

    expect(controller.rows.first.appName, 'wonkrumdm');
  });

  test('can filter to user apps only', () async {
    await controller.setFilter('isSystemApp', false);

    expect(controller.total.value, 2);
    expect(controller.rows.every((app) => !app.isSystemApp), isTrue);
  });

  test('can filter to system apps only', () async {
    await controller.setFilter('isSystemApp', true);

    expect(controller.total.value, 1);
    expect(controller.rows.single.appName, 'Chrome');
  });

  test('the full list returns when the filter is cleared', () async {
    await controller.setFilter('isSystemApp', true);
    await controller.setFilter('isSystemApp', null);

    expect(controller.filters.length, 0);
    expect(controller.total.value, 3);
  });

  test('the type filter works together with search', () async {
    await controller.setFilter('isSystemApp', false);
    await controller.setSearch('wonkru');

    expect(controller.total.value, 1);
    expect(controller.rows.single.appName, 'wonkrumdm');
  });
}
