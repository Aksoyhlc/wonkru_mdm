import 'package:wonkrumdm/Core/Extensions/enum.dart';

enum AppAction implements StringEnum {
  install('install'),
  remove('remove'),
  configure('configure');

  final String _value;
  const AppAction(this._value);

  @override
  String get value => _value;
}
