import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Data/Models/Features/managed_app.dart';

void main() {
  test('run_on_boot bool true -> on', () {
    final app = ManagedApp.fromJson({'run_on_boot': true});
    expect(app.runOnBoot, OnOff.on);
  });

  test('run_on_boot bool false -> off', () {
    final app = ManagedApp.fromJson({'run_on_boot': false});
    expect(app.runOnBoot, OnOff.off);
  });

  test('run_on_boot int 1 hâlâ on', () {
    expect(ManagedApp.fromJson({'run_on_boot': 1}).runOnBoot, OnOff.on);
  });

  test('run_on_boot int 0 hâlâ off', () {
    expect(ManagedApp.fromJson({'run_on_boot': 0}).runOnBoot, OnOff.off);
  });

  test('run_on_boot int 2 hâlâ def', () {
    expect(ManagedApp.fromJson({'run_on_boot': 2}).runOnBoot, OnOff.def);
  });

  test('run_on_boot yoksa null', () {
    expect(ManagedApp.fromJson({}).runOnBoot, isNull);
  });
}
