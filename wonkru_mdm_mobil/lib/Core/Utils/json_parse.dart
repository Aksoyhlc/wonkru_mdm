import 'package:wonkrumdm/Core/Constants/Enums/on_off.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';

const _tag = 'JsonParse';

/// Tolerant readers for policy JSON: an unparseable value nulls only that field
/// (or falls back to `OnOff.def`) instead of throwing and dropping the whole
/// policy.
class JsonParse {
  const JsonParse._();

  static int? toInt(Object? value) {
    if (value is int) return value;
    if (value is double) return value.isFinite ? value.round() : null;
    if (value is String) {
      final text = value.trim();
      final asInt = int.tryParse(text);
      if (asInt != null) return asInt;
      final asDouble = double.tryParse(text);
      if (asDouble != null && asDouble.isFinite) return asDouble.round();
    }
    return null;
  }

  static double? toDouble(Object? value) {
    if (value is num) return value.isFinite ? value.toDouble() : null;
    if (value is String) {
      final parsed = double.tryParse(value.trim());
      return parsed != null && parsed.isFinite ? parsed : null;
    }
    return null;
  }

  static bool? toBool(Object? value) {
    if (value is bool) return value;
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
      return null;
    }
    if (value is String) {
      final text = value.trim().toLowerCase();
      if (text == 'true' || text == '1') return true;
      if (text == 'false' || text == '0') return false;
    }
    return null;
  }

  static String? toStr(Object? value) {
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return null;
  }

  static Map<String, dynamic>? toMap(Object? value) {
    if (value is! Map) return null;
    return <String, dynamic>{for (final entry in value.entries) entry.key.toString(): entry.value};
  }

  static List<dynamic>? toList(Object? value) => value is List ? value : null;

  static List<String>? toStringList(Object? value) {
    if (value is! List) return null;
    return [
      for (final item in value)
        if (item != null) item.toString(),
    ];
  }

  static OnOff? toOnOff(Object? value) {
    if (value is bool) return value ? OnOff.on : OnOff.off;
    if (value is String) {
      final text = value.trim().toLowerCase();
      if (text == 'true') return OnOff.on;
      if (text == 'false') return OnOff.off;
    }
    // A fractional value (1.5) is ambiguous; only whole numbers are accepted.
    final number = value is double && value != value.roundToDouble() ? null : toInt(value);
    for (final item in OnOff.values) {
      if (item.value == number) return item;
    }
    return null;
  }

  static OnOff toOnOffOrDef(Object? value) => toOnOff(value) ?? OnOff.def;

  static bool? toTriStateBool(Object? value) {
    if (value == 2 || (value is String && value.trim() == '2')) return null;
    return toBool(value);
  }

  static DateTime? toDate(Object? value) => value is String ? DateTime.tryParse(value) : null;

  static T? nested<T>(Object? value, T Function(Map<String, dynamic>) parse, {required String field}) {
    final map = toMap(value);
    if (map == null) return null;
    try {
      return parse(map);
    } catch (e, st) {
      WLog.w(_tag, '$field could not be parsed, ignoring', error: e, stackTrace: st);
      return null;
    }
  }

  static List<T> listOf<T>(Object? value, T Function(Map<String, dynamic>) parse, {required String field}) {
    final list = toList(value);
    if (list == null) return <T>[];
    final result = <T>[];
    for (final item in list) {
      final parsed = nested(item, parse, field: field);
      if (parsed != null) result.add(parsed);
    }
    return result;
  }
}
