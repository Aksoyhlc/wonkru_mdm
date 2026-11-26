import 'dart:math';

abstract class IntEnum {
  int get value;
}

abstract class StringEnum {
  String get value;
}

extension IntEnumIterableX<T extends IntEnum> on Iterable<T> {
  T? fromInt(dynamic val) {
    if (val == null) return null;

    final intValue = val is int ? val : int.tryParse(val.toString());
    if (intValue == null) return null;

    try {
      return firstWhere((e) => e.value == intValue);
    } catch (_) {
      return null;
    }
  }

  T fromIntOrDefault(dynamic val, T defaultValue) {
    return fromInt(val) ?? defaultValue;
  }
}

extension EnumIterableX<T extends Enum> on Iterable<T> {
  T fromValue(dynamic value, {T? defaultValue}) {
    if (value == null) {
      if (defaultValue != null) return defaultValue;
      throw ArgumentError("Value cannot be null for enum conversion");
    }

    final strValue = value.toString();
    final intValue = value is int ? value : int.tryParse(strValue);

    if (strValue.isEmpty) {
      if (defaultValue != null) return defaultValue;
      throw ArgumentError("Value cannot be empty for enum conversion");
    }

    try {
      return firstWhere((e) {
        if (intValue != null && e is IntEnum && (e as IntEnum).value == intValue) {
          return true;
        }

        if (e is StringEnum && (e as StringEnum).value == strValue) return true;

        if (e.name == strValue) return true;

        if (e.name.toLowerCase() == strValue.toLowerCase()) return true;

        final camelCase = strValue.replaceAllMapped(RegExp(r'_([a-z])'), (Match m) => m[1]!.toUpperCase());
        if (e.name == camelCase) return true;

        return false;
      });
    } catch (e) {
      if (defaultValue != null) return defaultValue;
      throw ArgumentError("Enum value '$strValue' not found in $T");
    }
  }

  T? tryFromValue(dynamic value) {
    if (value == null) return null;
    final strValue = value.toString();
    if (strValue.isEmpty) return null;
    try {
      return fromValue(strValue);
    } catch (_) {
      return null;
    }
  }

  List<String> get names => map((e) => e.name).toList();

  Map<String, T> get asMap => {for (var e in this) e.name: e};

  T random() {
    final list = toList();
    return list[Random().nextInt(list.length)];
  }
}

extension EnumValueX on Enum {
  String toJson() => name;

  bool isOneOf<T extends Enum>(List<T> list) => list.contains(this);

  bool isNotOneOf<T extends Enum>(List<T> list) => !list.contains(this);

  String get label => name;
}