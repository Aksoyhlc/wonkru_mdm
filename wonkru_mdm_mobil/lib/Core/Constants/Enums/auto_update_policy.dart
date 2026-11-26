import 'package:wonkrumdm/Core/Extensions/enum.dart';

enum AutoUpdatePolicy implements StringEnum {
  always('always'),
  wifiOnly('wifi_only'),
  never('never');

  @override
  final String value;
  const AutoUpdatePolicy(this.value);
}