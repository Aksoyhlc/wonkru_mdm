import 'package:wonkrumdm/Core/Extensions/enum.dart';

enum BatteryChargingState implements StringEnum {
  charging('charging'),
  discharging('discharging'),
  full('full'),
  connectedNotCharging('connected_not_charging'),
  unknown('unknown');

  final String _value;

  const BatteryChargingState(this._value);

  @override
  String get value => _value;
}

enum BatteryHealth implements StringEnum {
  good('good'),
  overheat('overheat'),
  dead('dead'),
  overVoltage('over_voltage'),
  unspecifiedFailure('unspecified_failure'),
  cold('cold'),
  unknown('unknown');

  final String _value;

  const BatteryHealth(this._value);

  @override
  String get value => _value;
}
