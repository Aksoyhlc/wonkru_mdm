import 'package:wonkrumdm/Core/Extensions/enum.dart';

enum OnOff implements IntEnum {
  off(0),
  on(1),
  def(2);

  final int value;
  const OnOff(this.value);

  bool get isRestricted => this == OnOff.on;

  bool get isEnabled => this == OnOff.on;

  /// Maps a `*_config_restriction` flag to a restriction state:
  /// `true` → [OnOff.on] (user cannot change), `false` → [OnOff.off] (free),
  /// `null` → [OnOff.def] (leave alone).
  static OnOff fromRestrictionBool(bool? value) {
    if (value == null) return OnOff.def;
    return value ? OnOff.on : OnOff.off;
  }
}