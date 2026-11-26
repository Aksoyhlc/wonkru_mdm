import 'dart:convert';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/policy_enums.dart';
import 'policy_field_spec.dart';

const Map<String, String> policySettingsPrefixToColumn = <String, String>{
  'battery_settings': 'batterySettings',
  'storage_settings': 'storageSettings',
  'audio_settings': 'audioSettings',
  'display_settings': 'displaySettings',
  'security_settings': 'securitySettings',
  'restriction_settings': 'restrictionSettings',
  'other_settings': 'otherSettings',
  'sync_settings': 'syncSettings',
  'launcher': 'launcher',
  'active_time_ranges': 'activeTimeRanges',
};

/// Each non-empty column is `jsonDecode`d: objects spread into dotted paths
/// (`sync_settings.full_sync_cron`) and the column root is written as compact
/// JSON (KeyValue fields read the root). Numbers become `'20'`, bools
/// `'true'`/`'false'`, arrays a JSON string; invalid JSON is skipped.
Map<String, String> flattenSettings(Policy policy) {
  final result = <String, String>{};

  for (final entry in policySettingsPrefixToColumn.entries) {
    final prefix = entry.key;
    final raw = _columnValue(policy, entry.value)?.trim();
    if (raw == null || raw.isEmpty) continue;

    Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      continue;
    }

    if (decoded is Map) {
      result[prefix] = jsonEncode(decoded);
      _flattenMap(result, prefix, decoded);
    } else {
      result[prefix] = _stringify(decoded);
    }
  }

  return result;
}

/// Values are grouped by their first segment; only known prefixes are
/// processed, other columns are left untouched. A group containing only empty
/// values sets its column to `null`.
///
/// With [fields] (full path → field spec) each value is converted per field
/// type: text/color stay text (`"1234"` and `"000000"` are not turned into
/// numbers), numbers become numbers, toggles bools, selects follow the option
/// key type, tri-states `0/1/2` or `true/false`. Paths without a spec keep the
/// natural-type coercion.
Policy applySettings(
  Policy base,
  Map<String, dynamic> flatValues, {
  Map<String, PolicyFieldSpec> fields = const <String, PolicyFieldSpec>{},
}) {
  final groups = <String, Map<String, dynamic>>{};

  for (final entry in flatValues.entries) {
    final parts = entry.key.split('.');
    final prefix = parts.first;
    if (!policySettingsPrefixToColumn.containsKey(prefix)) continue;
    final rest = parts.skip(1).join('.');
    (groups[prefix] ??= <String, dynamic>{})[rest] = entry.value;
  }

  var result = base;
  for (final entry in groups.entries) {
    final column = policySettingsPrefixToColumn[entry.key]!;
    result = _withColumn(
      result,
      column,
      _buildColumn(entry.key, entry.value, fields),
    );
  }
  return result;
}

Map<String, PolicyFieldSpec> policyFieldsByPath(
  Iterable<PolicySettingsTabSpec> tabs,
) {
  return <String, PolicyFieldSpec>{
    for (final tab in tabs)
      for (final group in tab.groups)
        for (final field in group.fields) field.path: field,
  };
}

/// Also accepts bool values (`'true'`/`'false'`); empty or unknown becomes the
/// default `'2'`.
String normalizeTriStateInt(String raw) {
  switch (raw.trim().toLowerCase()) {
    case '1':
    case 'true':
      return '1';
    case '0':
    case 'false':
      return '0';
    default:
      return '2';
  }
}

/// Collapses to `'true'`/`'false'`/`''`; empty, `'2'` or unknown is the
/// default `''`.
String normalizeTriStateBool(String raw) {
  switch (raw.trim().toLowerCase()) {
    case '1':
    case 'true':
      return 'true';
    case '0':
    case 'false':
      return 'false';
    default:
      return '';
  }
}

List<String> policyRangeViolations(
  Map<String, dynamic> flat,
  Iterable<PolicyFieldSpec> fields,
) {
  final violations = <String>[];
  for (final field in fields) {
    final other = field.notAbovePath;
    if (other == null) continue;
    final value = num.tryParse('${flat[field.path] ?? ''}'.trim());
    final limit = num.tryParse('${flat[other] ?? ''}'.trim());
    if (value != null && limit != null && value > limit) {
      violations.add(field.path);
    }
  }
  return violations;
}

String? _buildColumn(
  String prefix,
  Map<String, dynamic> entries,
  Map<String, PolicyFieldSpec> fields,
) {
  Map<String, dynamic>? root;
  final nested = <String, dynamic>{};

  for (final entry in entries.entries) {
    if (entry.key.isEmpty) {
      final decoded = _tryDecodeObject(entry.value);
      if (decoded != null) {
        root = decoded;
      } else if (entry.value is String &&
          (entry.value as String).trim().isEmpty) {
        // Empty root: cleared setting.
      } else {
        return _encodeValue(_coerce(entry.value));
      }
    } else {
      nested[entry.key] = entry.value;
    }
  }

  final map = <String, dynamic>{...?root};
  for (final entry in nested.entries) {
    final spec = fields['$prefix.${entry.key}'];
    final value = spec == null
        ? _coerce(entry.value)
        : _coerceFor(entry.value, spec);
    if (value is String && value.isEmpty) continue;
    _assignNested(map, entry.key.split('.'), value);
  }

  if (map.isEmpty) return null;
  return jsonEncode(map);
}

/// Empty string means "omit": the caller skips the key.
Object? _coerceFor(dynamic value, PolicyFieldSpec spec) {
  if (value is! String) return value;
  final text = value.trim();
  switch (spec.type) {
    case PolicyFieldType.text:
    case PolicyFieldType.textarea:
    case PolicyFieldType.color:
    case PolicyFieldType.fileUpload:
    case PolicyFieldType.timeZone:
      return value;
    case PolicyFieldType.number:
    case PolicyFieldType.slider:
      if (text.isEmpty) return '';
      return num.tryParse(text) ?? value;
    case PolicyFieldType.toggle:
      if (text == 'true') return true;
      if (text == 'false') return false;
      return '';
    case PolicyFieldType.select:
      if (text.isEmpty) return '';
      final keys = spec.options?.keys ?? const <String>[];
      final numericKeys =
          keys.isNotEmpty && keys.every((key) => int.tryParse(key) != null);
      return numericKeys ? (int.tryParse(text) ?? value) : value;
    case PolicyFieldType.triState:
      if (text.isEmpty) return '';
      return int.parse(normalizeTriStateInt(text));
    case PolicyFieldType.triStateBool:
      final normalized = normalizeTriStateBool(text);
      if (normalized.isEmpty) return '';
      return normalized == 'true';
    case PolicyFieldType.tags:
      if (text.isEmpty) return '';
      try {
        final decoded = jsonDecode(text);
        if (decoded is List) return decoded;
      } catch (_) {}
      return '';
    case PolicyFieldType.keyValue:
    case PolicyFieldType.timeRanges:
    case PolicyFieldType.restrictionShortcut:
      return _coerce(value);
  }
}

void _assignNested(Map<String, dynamic> map, List<String> keys, Object? value) {
  var current = map;
  for (var i = 0; i < keys.length - 1; i++) {
    final existing = current[keys[i]];
    if (existing is Map<String, dynamic>) {
      current = existing;
    } else {
      final created = <String, dynamic>{};
      current[keys[i]] = created;
      current = created;
    }
  }
  current[keys.last] = value;
}

/// Only for paths without a field spec; typed fields go through [_coerceFor].
Object? _coerce(dynamic value) {
  if (value is! String) return value;
  if (value == 'true') return true;
  if (value == 'false') return false;
  final number = num.tryParse(value);
  if (number != null) return number;
  final trimmed = value.trim();
  if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is List) return decoded;
    } catch (_) {}
  }
  return value;
}

Map<String, dynamic>? _tryDecodeObject(dynamic value) {
  if (value is! String) return value is Map<String, dynamic> ? value : null;
  if (!value.trim().startsWith('{')) return null;
  try {
    final decoded = jsonDecode(value);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}

String _encodeValue(Object? value) => jsonEncode(value);

void _flattenMap(
  Map<String, String> out,
  String path,
  Map<dynamic, dynamic> map,
) {
  for (final entry in map.entries) {
    final childPath = '$path.${entry.key}';
    final value = entry.value;
    if (value is Map) {
      _flattenMap(out, childPath, value);
    } else {
      out[childPath] = _stringify(value);
    }
  }
}

String _stringify(Object? value) {
  if (value == null) return '';
  if (value is bool) return value ? 'true' : 'false';
  if (value is num) return value.toString();
  if (value is String) return value;
  return jsonEncode(value);
}

String? _columnValue(Policy policy, String column) {
  return switch (column) {
    'activeTimeRanges' => policy.activeTimeRanges,
    'batterySettings' => policy.batterySettings,
    'storageSettings' => policy.storageSettings,
    'audioSettings' => policy.audioSettings,
    'displaySettings' => policy.displaySettings,
    'securitySettings' => policy.securitySettings,
    'restrictionSettings' => policy.restrictionSettings,
    'launcher' => policy.launcher,
    'syncSettings' => policy.syncSettings,
    'otherSettings' => policy.otherSettings,
    _ => null,
  };
}

Policy _withColumn(Policy base, String column, String? value) {
  return switch (column) {
    'activeTimeRanges' => base.copyWith(activeTimeRanges: value),
    'batterySettings' => base.copyWith(batterySettings: value),
    'storageSettings' => base.copyWith(storageSettings: value),
    'audioSettings' => base.copyWith(audioSettings: value),
    'displaySettings' => base.copyWith(displaySettings: value),
    'securitySettings' => base.copyWith(securitySettings: value),
    'restrictionSettings' => base.copyWith(restrictionSettings: value),
    'launcher' => base.copyWith(launcher: value),
    'syncSettings' => base.copyWith(syncSettings: value),
    'otherSettings' => base.copyWith(otherSettings: value),
    _ => base,
  };
}

const String restrictionAllow = '0';

const String restrictionRestrict = '1';

const String restrictionDefault = '2';

/// [keys] is the canonical order. Keys missing from the stored record become
/// default (`'2'`); an unrecorded restriction never turns into "allow".
/// Recorded `0`/`1` values are preserved. Both shapes are accepted:
/// `{"restrictions":[{"restriction":"no_camera","value":1}, ...]}` and the
/// flat map `{"no_camera":1, ...}`; empty or invalid JSON means all default.
Map<String, String> restrictionSettingsToFlat(
  String? rawJson,
  List<String> keys,
) {
  final saved = _savedRestrictionValues(rawJson);
  return <String, String>{
    for (final key in keys) 'restriction_settings.$key': '${saved[key] ?? 2}',
  };
}

String flatToRestrictionSettings(Map<String, String> flat, List<String> keys) {
  return jsonEncode(<String, dynamic>{
    'restrictions': <Map<String, dynamic>>[
      for (final key in keys)
        <String, dynamic>{
          'restriction': key,
          'value': _restrictionInt(flat['restriction_settings.$key']),
        },
    ],
  });
}

Map<String, int> _savedRestrictionValues(String? rawJson) {
  final result = <String, int>{};
  final text = rawJson?.trim();
  if (text == null || text.isEmpty) return result;

  Object? decoded;
  try {
    decoded = jsonDecode(text);
  } catch (_) {
    return result;
  }
  if (decoded is! Map) return result;

  final raw = decoded['restrictions'];
  if (raw is List) {
    for (final item in raw) {
      if (item is Map && item['restriction'] != null) {
        result[item['restriction'].toString()] = _restrictionInt(item['value']);
      }
    }
    return result;
  }

  if (raw == null) {
    for (final entry in decoded.entries) {
      result[entry.key.toString()] = _restrictionInt(entry.value);
    }
  }
  return result;
}

int _restrictionInt(Object? value) {
  if (value == true) return 1;
  if (value == false) return 0;
  final parsed = value is num
      ? (value == value.roundToDouble() ? value.toInt() : null)
      : int.tryParse(value?.toString().trim() ?? '');
  return parsed == 0 || parsed == 1 ? parsed! : 2;
}
