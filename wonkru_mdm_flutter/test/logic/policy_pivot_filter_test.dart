import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/pivot_enums.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_pivot_picker.dart';

void main() {
  const options = [
    PolicyPivotOption(
      id: 1,
      label: 'System + versioned',
      isSystemApp: true,
      hasVersions: true,
    ),
    PolicyPivotOption(
      id: 2,
      label: 'User + versioned',
      isSystemApp: false,
      hasVersions: true,
    ),
    PolicyPivotOption(
      id: 3,
      label: 'User + unversioned',
      isSystemApp: false,
      hasVersions: false,
    ),
    PolicyPivotOption(id: 4, label: 'No meta'),
  ];

  List<int> ids(List<PolicyPivotOption> list) => list.map((o) => o.id).toList();

  test('all options are returned without filters', () {
    expect(ids(filterPivotOptions(options)), [1, 2, 3, 4]);
  });

  test('system filter', () {
    expect(ids(filterPivotOptions(options, system: PivotSystemFilter.system)), [
      1,
    ]);
    expect(ids(filterPivotOptions(options, system: PivotSystemFilter.user)), [
      2,
      3,
    ]);
  });

  test('installability filter', () {
    expect(
      ids(
        filterPivotOptions(
          options,
          installable: PivotInstallableFilter.installable,
        ),
      ),
      [1, 2],
    );
    expect(
      ids(
        filterPivotOptions(
          options,
          installable: PivotInstallableFilter.notInstallable,
        ),
      ),
      [3],
    );
  });

  test('combined filter excludes entries without metadata', () {
    expect(
      ids(
        filterPivotOptions(
          options,
          system: PivotSystemFilter.user,
          installable: PivotInstallableFilter.installable,
        ),
      ),
      [2],
    );
  });
}
