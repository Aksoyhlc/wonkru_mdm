import 'package:wonkrumdm/Core/Extensions/enum.dart';

enum ErrorType implements StringEnum {
  network('network'),
  permission('permission'),
  device('device'),
  validation('validation'),
  business('business'),
  unknown('unknown');

  final String _value;
  const ErrorType(this._value);

  @override
  String get value => _value;
}