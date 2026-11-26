/// The numeric values are the Android constants the agent applies.
library;

enum RotationPolicy {
  free(0),
  locked(1),
  systemDefault(2);

  const RotationPolicy(this.value);

  final int value;

  static RotationPolicy? fromValue(int? value) {
    for (final policy in values) {
      if (policy.value == value) {
        return policy;
      }
    }
    return null;
  }
}

enum ScreenOrientation {
  portrait(0),
  landscape(1),
  reversePortrait(2),
  reverseLandscape(3),
  auto(-1);

  const ScreenOrientation(this.value);

  final int value;

  static ScreenOrientation? fromValue(int? value) {
    for (final orientation in values) {
      if (orientation.value == value) {
        return orientation;
      }
    }
    return null;
  }
}

enum IconSize {
  small('small'),
  medium('medium'),
  large('large');

  const IconSize(this.value);

  final String value;

  static IconSize? fromValue(String? value) {
    if (value == null) {
      return null;
    }
    for (final size in values) {
      if (size.value == value) {
        return size;
      }
    }
    return null;
  }
}
