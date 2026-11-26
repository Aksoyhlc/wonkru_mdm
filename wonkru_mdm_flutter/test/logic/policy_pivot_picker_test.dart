import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Policies/Widgets/policy_pivot_picker.dart';

void main() {
  group('availablePivotOptions', () {
    const options = [
      PolicyPivotOption(id: 1, label: 'A'),
      PolicyPivotOption(id: 2, label: 'B'),
      PolicyPivotOption(id: 3, label: 'C'),
    ];

    test('empty bound set leaves the list unchanged', () {
      expect(availablePivotOptions(options, {}), options);
    });

    test('bound ids are removed from the list', () {
      final result = availablePivotOptions(options, {2});

      expect(result.map((option) => option.id), [1, 3]);
    });

    test('when all are bound, an empty list is returned', () {
      expect(availablePivotOptions(options, {1, 2, 3}), isEmpty);
    });

    test('ids not present in the list are ignored', () {
      expect(availablePivotOptions(options, {99}).length, 3);
    });
  });
}
