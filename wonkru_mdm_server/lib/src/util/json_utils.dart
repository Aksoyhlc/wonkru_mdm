/// Small coercion helpers for decoding agent supplied JSON.
library;

import 'dart:convert';

Map<String, dynamic> asMap(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return const {};
}

List<dynamic> asList(dynamic value) => value is List ? value : const [];

String? asString(dynamic value) => value?.toString();

int? asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '');
}

double? asDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '');
}

bool asBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  final normalized = value?.toString().toLowerCase();
  return normalized == 'true' || normalized == '1';
}

/// Like [asBool] but keeps the distinction between "absent" and `false`.
bool? asBoolOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  final normalized = value.toString().toLowerCase();
  if (normalized == 'true' || normalized == '1') {
    return true;
  }
  if (normalized == 'false' || normalized == '0') {
    return false;
  }
  return null;
}

Map<String, dynamic> decodeJsonMap(String? raw) {
  if (raw == null || raw.isEmpty) {
    return const {};
  }
  try {
    final decoded = jsonDecode(raw);
    return decoded is Map ? Map<String, dynamic>.from(decoded) : const {};
  } on FormatException {
    return const {};
  }
}

dynamic deepGet(dynamic value, String path) {
  var current = value;
  for (final segment in path.split('.')) {
    if (current is Map) {
      current = current[segment];
    } else {
      return null;
    }
  }
  return current;
}

/// Decodes [raw] as JSON, or returns null for empty, blank or malformed input.
dynamic decodeJsonValue(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  try {
    return jsonDecode(raw);
  } on FormatException {
    return null;
  }
}
