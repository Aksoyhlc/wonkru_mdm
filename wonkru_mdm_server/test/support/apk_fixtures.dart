import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

Uint8List minimalApk({
  String? packageName = 'com.example.app',
  bool utf8 = true,
}) {
  final table = <String>[];
  int add(String value) {
    final existing = table.indexOf(value);
    if (existing >= 0) return existing;
    table.add(value);
    return table.length - 1;
  }

  final manifestIdx = add('manifest');
  final packageIdx = add('package');
  final packageValueIdx = packageName == null ? null : add(packageName);

  final element = _startElement(manifestIdx, [
    if (packageValueIdx != null)
      _attr(packageIdx, packageValueIdx, _typeString, packageValueIdx),
  ]);

  final body = <int>[..._stringPool(table, utf8: utf8), ...element];
  final manifest = Uint8List.fromList([
    ..._u16(0x0003), // RES_XML_TYPE
    ..._u16(8),
    ..._u32(8 + body.length),
    ...body,
  ]);

  return _zip({'AndroidManifest.xml': manifest});
}

Uint8List apkWithoutManifest() => _zip({
  'classes.dex': Uint8List.fromList([1, 2, 3]),
});

Uint8List _zip(Map<String, Uint8List> files) {
  final archive = Archive();
  for (final entry in files.entries) {
    archive.add(ArchiveFile.bytes(entry.key, entry.value));
  }
  return ZipEncoder().encodeBytes(archive);
}

const int _typeString = 0x03;
const int _noValue = 0xffffffff;

List<int> _stringPool(List<String> values, {required bool utf8}) {
  final offsets = <int>[];
  final data = <int>[];
  for (final value in values) {
    offsets.add(data.length);
    data.addAll(utf8 ? _encodeUtf8(value) : _encodeUtf16(value));
  }

  const headerSize = 28;
  final stringsStart = headerSize + values.length * 4;
  return [
    ..._u16(0x0001), // RES_STRING_POOL_TYPE
    ..._u16(headerSize),
    ..._u32(stringsStart + data.length),
    ..._u32(values.length),
    ..._u32(0),
    ..._u32(utf8 ? 0x0100 : 0x0000),
    ..._u32(stringsStart),
    ..._u32(0),
    for (final offset in offsets) ..._u32(offset),
    ...data,
  ];
}

List<int> _startElement(int nameIndex, List<List<int>> attrs) {
  const headerSize = 16;
  const attrExtSize = 20;
  const attrSize = 20;

  return [
    ..._u16(0x0102), // RES_XML_START_ELEMENT_TYPE
    ..._u16(headerSize),
    ..._u32(headerSize + attrExtSize + attrs.length * attrSize),
    ..._u32(0), // lineNumber
    ..._u32(_noValue), // comment
    ..._u32(_noValue), // ns
    ..._u32(nameIndex), // name
    ..._u16(attrExtSize),
    ..._u16(attrSize),
    ..._u16(attrs.length),
    ..._u16(0),
    ..._u16(0),
    ..._u16(0),
    ...attrs.expand((attr) => attr),
  ];
}

List<int> _attr(int nameIndex, int rawValueIndex, int type, int data) {
  return [
    ..._u32(_noValue), // ns
    ..._u32(nameIndex),
    ..._u32(rawValueIndex),
    ..._u16(8), // Res_value.size
    0, // res0
    type,
    ..._u32(data),
  ];
}

/// UTF-8 string-pool entry: character count, byte count, bytes, terminator.
List<int> _encodeUtf8(String value) {
  final bytes = utf8.encode(value);

  void writeLength(List<int> out, int length) {
    if (length > 0x7f) {
      out.add(0x80 | (length >> 8));
      out.add(length & 0xff);
    } else {
      out.add(length);
    }
  }

  final out = <int>[];
  writeLength(out, value.length);
  writeLength(out, bytes.length);
  out.addAll(bytes);
  out.add(0);
  return out;
}

List<int> _encodeUtf16(String value) {
  final units = value.codeUnits;
  final out = <int>[];
  out.addAll(_u16(units.length));
  for (final unit in units) {
    out.addAll(_u16(unit));
  }
  out.addAll(_u16(0));
  return out;
}

List<int> _u16(int value) => [value & 0xff, (value >> 8) & 0xff];

List<int> _u32(int value) => [
  value & 0xff,
  (value >> 8) & 0xff,
  (value >> 16) & 0xff,
  (value >> 24) & 0xff,
];
