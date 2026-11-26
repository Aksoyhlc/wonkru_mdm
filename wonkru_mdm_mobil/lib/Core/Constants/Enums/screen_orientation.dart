import 'package:wonkrumdm/Core/Extensions/enum.dart';

enum ScreenOrientation implements IntEnum {
  portrait(0),
  landscape(1),
  reversePortrait(2),
  reverseLandscape(3),
  auto(-1);

  final int value;
  const ScreenOrientation(this.value);
}

enum RotationPolicy implements IntEnum {
  free(0),
  locked(1),
  systemDefault(2);

  final int value;
  const RotationPolicy(this.value);
}