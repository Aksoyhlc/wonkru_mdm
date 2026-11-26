import 'dart:convert';
import '../enums/policy_wire_kind.dart';

/// Normalises policy setting columns to the schema before they reach a device.
///
/// Only **known** fields are converted to their own type; unknown keys pass
/// through untouched. Text and colour stay text, so `"1234"` or `"000000"` are
/// not coerced into numbers. An unresolvable value drops only its key; the rest
/// of the column survives.
///
/// Tri-state contract: the default ("don't touch") is never turned into
/// on/off; it either stays `2` or the key disappears.
class PolicyPayloadNormalizer {
  const PolicyPayloadNormalizer._();

  /// Column → dotted field path → wire type.
  static const Map<String, Map<String, PolicyWireKind>> schema = {
    'battery_settings': {
      'enabled': PolicyWireKind.boolean,
      'low_battery_threshold': PolicyWireKind.integer,
      'critical_battery_threshold': PolicyWireKind.integer,
    },
    'storage_settings': {
      'enabled': PolicyWireKind.boolean,
      'warning_threshold': PolicyWireKind.integer,
      'critical_threshold': PolicyWireKind.integer,
    },
    'audio_settings': {
      'fixed_volume_policy': PolicyWireKind.boolean,
      'fixed_volume': PolicyWireKind.integer,
      'min_volume': PolicyWireKind.integer,
      'max_volume': PolicyWireKind.integer,
    },
    'display_settings': {
      'lock_screen_message': PolicyWireKind.text,
      'screen_capture_policy': PolicyWireKind.triStateInt,
      'screen_timeout_ms': PolicyWireKind.integer,
      'screen_timeout_config_restriction': PolicyWireKind.triStateBool,
      'brightness_level': PolicyWireKind.integer,
      'min_brightness': PolicyWireKind.integer,
      'max_brightness': PolicyWireKind.integer,
      'auto_brightness_policy': PolicyWireKind.triStateInt,
      'brightness_config_restriction': PolicyWireKind.triStateBool,
      'rotation_policy': PolicyWireKind.integer,
      'locked_orientation': PolicyWireKind.integer,
    },
    'security_settings': {
      'password_policy.complexity_level': PolicyWireKind.integer,
      'password_policy.quality': PolicyWireKind.integer,
      'password_policy.min_length': PolicyWireKind.integer,
      'password_policy.min_upper_case': PolicyWireKind.integer,
      'password_policy.min_lower_case': PolicyWireKind.integer,
      'password_policy.min_letters': PolicyWireKind.integer,
      'password_policy.min_numeric': PolicyWireKind.integer,
      'password_policy.min_symbols': PolicyWireKind.integer,
      'password_policy.min_non_letter': PolicyWireKind.integer,
      'password_policy.history_length': PolicyWireKind.integer,
      'password_policy.expiration_timeout_ms': PolicyWireKind.integer,
      'password_policy.max_failed_attempts': PolicyWireKind.integer,
      'keyguard.disable_lock_screen_camera': PolicyWireKind.triStateBool,
      'keyguard.hide_notification_content': PolicyWireKind.triStateBool,
      'keyguard.disable_fingerprint': PolicyWireKind.triStateBool,
      'keyguard.disable_face_unlock': PolicyWireKind.triStateBool,
      'keyguard.disable_iris': PolicyWireKind.triStateBool,
      'keyguard.disable_all_biometrics': PolicyWireKind.triStateBool,
      'keyguard.disable_smart_lock': PolicyWireKind.triStateBool,
      'allowed_accessibility_apps': PolicyWireKind.stringList,
    },
    'other_settings': {
      'auto_time': PolicyWireKind.triStateInt,
      'auto_time_zone': PolicyWireKind.triStateInt,
      'time_zone': PolicyWireKind.text,
      'time_12_24': PolicyWireKind.integer,
      'required_wifi': PolicyWireKind.boolean,
      'files_to_delete': PolicyWireKind.stringList,
    },
    'launcher': {
      'mode': PolicyWireKind.boolean,
      'design.layout_type': PolicyWireKind.text,
      'design.columns': PolicyWireKind.integer,
      'design.rows': PolicyWireKind.integer,
      'design.background.type': PolicyWireKind.text,
      'design.background.color': PolicyWireKind.color,
      'design.background.image': PolicyWireKind.text,
      'design.item_display.icon_size': PolicyWireKind.text,
      'design.item_display.show_label': PolicyWireKind.boolean,
      'design.item_display.label_color': PolicyWireKind.color,
      'design.item_display.background_color': PolicyWireKind.color,
      'design.item_display.border_radius': PolicyWireKind.integer,
      'design.item_display.label_font_size': PolicyWireKind.number,
      'design.item_display.long_press_settings_open': PolicyWireKind.boolean,
      'header_widgets.left': PolicyWireKind.boolean,
      'header_widgets.center': PolicyWireKind.boolean,
      'header_widgets.right': PolicyWireKind.boolean,
    },
  };

  /// Normalises the decoded JSON of [column] against the schema; a non-object
  /// value is returned as-is.
  static dynamic normalizeColumn(String column, dynamic decoded) {
    if (decoded is! Map) return decoded;
    final fields = schema[column];
    final copy = _deepCopy(decoded) as Map<String, dynamic>;
    if (fields == null) return copy;

    for (final entry in fields.entries) {
      _normalizePath(copy, entry.key.split('.'), entry.value);
    }
    return copy;
  }

  /// Reduces a restriction value to `0` (allow) / `1` (restrict) / `2`
  /// (default). Missing or unresolvable input becomes default, so an absent key
  /// is never forced on or off on the device.
  static int restrictionValue(dynamic raw) => triStateInt(raw) ?? 2;

  static int? triStateInt(dynamic raw) {
    if (raw is bool) return raw ? 1 : 0;
    final value = integer(raw);
    if (value == null) {
      final text = raw?.toString().trim().toLowerCase();
      if (text == 'true') return 1;
      if (text == 'false') return 0;
      return null;
    }
    return value >= 0 && value <= 2 ? value : null;
  }

  /// Resolves an integer; decimals are rounded. Bool is not accepted.
  static int? integer(dynamic raw) {
    if (raw is int) return raw;
    if (raw is double) return raw.isFinite ? raw.round() : null;
    if (raw is String) {
      final text = raw.trim();
      final asInt = int.tryParse(text);
      if (asInt != null) return asInt;
      final asDouble = double.tryParse(text);
      if (asDouble != null && asDouble.isFinite) return asDouble.round();
    }
    return null;
  }

  static bool? boolean(dynamic raw) {
    if (raw is bool) return raw;
    if (raw is num) {
      if (raw == 1) return true;
      if (raw == 0) return false;
      return null;
    }
    final text = raw?.toString().trim().toLowerCase();
    if (text == 'true' || text == '1') return true;
    if (text == 'false' || text == '0') return false;
    return null;
  }

  static void _normalizePath(
    Map<String, dynamic> map,
    List<String> keys,
    PolicyWireKind kind,
  ) {
    var current = map;
    for (var i = 0; i < keys.length - 1; i++) {
      final next = current[keys[i]];
      if (next is! Map<String, dynamic>) return;
      current = next;
    }

    final key = keys.last;
    if (!current.containsKey(key)) return;
    final raw = current[key];
    if (raw == null) {
      current.remove(key);
      return;
    }

    final value = _convert(raw, kind);
    if (value == null) {
      current.remove(key);
    } else {
      current[key] = value;
    }
  }

  static Object? _convert(dynamic raw, PolicyWireKind kind) {
    switch (kind) {
      case PolicyWireKind.integer:
        return integer(raw);
      case PolicyWireKind.number:
        if (raw is num) return raw.isFinite ? raw : null;
        if (raw is String) return num.tryParse(raw.trim());
        return null;
      case PolicyWireKind.boolean:
        return boolean(raw);
      case PolicyWireKind.triStateInt:
        return triStateInt(raw);
      case PolicyWireKind.triStateBool:
        if (raw == 2 || raw?.toString().trim() == '2') return null;
        return boolean(raw);
      case PolicyWireKind.text:
        if (raw is String) return raw;
        if (raw is num || raw is bool) return raw.toString();
        return null;
      case PolicyWireKind.color:
        if (raw is String) return raw;
        if (raw is int) return raw.toString().padLeft(6, '0');
        if (raw is num) return raw.toString();
        return null;
      case PolicyWireKind.stringList:
        return _stringList(raw);
    }
  }

  static List<String>? _stringList(dynamic raw) {
    var value = raw;
    if (value is String) {
      final text = value.trim();
      if (!text.startsWith('[')) return null;
      try {
        value = jsonDecode(text);
      } on FormatException {
        return null;
      }
    }
    if (value is! List) return null;
    return [
      for (final item in value)
        if (item != null) item.toString(),
    ];
  }

  static dynamic _deepCopy(dynamic value) {
    if (value is Map) {
      return <String, dynamic>{
        for (final entry in value.entries)
          entry.key.toString(): _deepCopy(entry.value),
      };
    }
    if (value is List) return value.map(_deepCopy).toList();
    return value;
  }
}
