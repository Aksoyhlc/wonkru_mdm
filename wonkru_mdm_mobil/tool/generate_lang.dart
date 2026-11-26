// ignore_for_file: avoid_print
/// Generate lib/Core/L10n/L.dart from the reference translation keys.
/// Run from the mobile package: dart run tool/generate_lang.dart

import 'dart:io';

void main() {
  final projectRoot = _findProjectRoot();
  if (projectRoot == null) {
    print('Hata: Proje kökü (pubspec.yaml) bulunamadı.');
    exit(1);
  }

  final trPath = projectRoot.path + '/lib/Core/L10n/Langs/tr_tr.dart';
  final outPath = projectRoot.path + '/lib/Core/L10n/L.dart';

  final trFile = File(trPath);
  if (!trFile.existsSync()) {
    print('Hata: $trPath bulunamadı.');
    exit(1);
  }

  final content = trFile.readAsStringSync();
  final keys = _extractKeys(content);
  final paramKeys = _extractParamKeys(content);
  if (keys.isEmpty) {
    print('Uyarı: Hiç key bulunamadı.');
  }

  final dart = _generateL(keys, paramKeys);
  File(outPath).writeAsStringSync(dart);
  print('L.dart oluşturuldu: $outPath (${keys.length} key, ${paramKeys.length} param method)');
}

Directory? _findProjectRoot() {
  var dir = Directory.current;
  while (dir.path != dir.parent.path) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
    dir = dir.parent;
  }
  return File('${dir.path}/pubspec.yaml').existsSync() ? dir : null;
}

final _keyRegex = RegExp(r"'([a-zA-Z][a-zA-Z0-9_]*)'\s*:");

List<String> _extractKeys(String content) {
  final keys = <String>[];
  for (final m in _keyRegex.allMatches(content)) {
    final key = m.group(1)!;
    if (!keys.contains(key)) keys.add(key);
  }
  keys.sort();
  return keys;
}

/// Map translation keys to the @parameters in their values.
Map<String, List<String>> _extractParamKeys(String content) {
  final paramKeys = <String, List<String>>{};
  final keyValueRegex = RegExp(r"'([a-zA-Z][a-zA-Z0-9_]*)'\s*:\s*'([^']*(?:\\'[^']*)*)'");
  for (final m in keyValueRegex.allMatches(content)) {
    final key = m.group(1)!;
    final value = m.group(2) ?? '';
    final params = RegExp(r'@([a-zA-Z][a-zA-Z0-9_]*)').allMatches(value).map((m) => m.group(1)!).toSet().toList();
    if (params.isNotEmpty) paramKeys[key] = params;
  }
  return paramKeys;
}

String _snakeToCamel(String key) {
  final parts = key.split('_');
  if (parts.length == 1) return key;
  return parts.first + parts.skip(1).map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1)).join();
}

String _generateL(List<String> keys, Map<String, List<String>> paramKeys) {
  final buffer = StringBuffer();
  buffer.writeln("// GENERATED FILE. Do not edit by hand. Run: dart run tool/generate_lang.dart");
  buffer.writeln('');
  buffer.writeln("import 'package:get/get.dart';");
  buffer.writeln('');
  buffer.writeln('/// Generated translation getters and parameterized methods.');
  buffer.writeln('abstract final class L {');
  buffer.writeln('  L._();');
  buffer.writeln('');
  for (final key in keys) {
    buffer.writeln("  static String get $key => '$key'.tr;");
  }
  for (final e in paramKeys.entries) {
    final key = e.key;
    final params = e.value;
    final methodName = _snakeToCamel(key);
    final paramList = params.map((p) => 'String $p').join(', ');
    final trParamsMap = params.map((p) => "'$p': $p").join(', ');
    buffer.writeln("  static String $methodName($paramList) => '$key'.trParams({$trParamsMap});");
  }
  buffer.writeln('}');
  buffer.writeln('');
  return buffer.toString();
}
