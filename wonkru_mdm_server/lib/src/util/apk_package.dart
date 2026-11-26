/// Pure Dart helpers that read only the package name from the binary (`AXML`)
/// `AndroidManifest.xml` inside an APK. The server needs nothing but the package
/// name to verify that an uploaded APK belongs to the right application. Input
/// never throws; malformed or unexpected input returns `null`.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// `ResChunk_header` types (AOSP `ResourceTypes.h`).
const int _resStringPoolType = 0x0001;
const int _resXmlType = 0x0003;
const int _resXmlStartElementType = 0x0102;

/// `Res_value` data types (AOSP `ResourceTypes.h`).
const int _typeReference = 0x01;
const int _typeString = 0x03;

/// Never throws; the caller treats `null` as "could not verify."
String? apkPackageName(Uint8List apkBytes) {
  if (apkBytes.isEmpty) return null;

  try {
    final archive = ZipDecoder().decodeBytes(apkBytes);
    final entry = archive.findFile('AndroidManifest.xml');
    if (entry == null) return null;

    final xmlBytes = entry.readBytes();
    if (xmlBytes == null || xmlBytes.isEmpty) return null;

    return _AxmlPackageReader(xmlBytes).parse();
  } catch (_) {
    return null;
  }
}

class _AxmlPackageReader {
  _AxmlPackageReader(Uint8List bytes)
    : _bytes = bytes,
      _data = ByteData.sublistView(bytes);

  final Uint8List _bytes;
  final ByteData _data;

  _StringPool? _strings;
  String? _packageName;

  String? parse() {
    var offset = 0;
    while (offset + 8 <= _bytes.length) {
      final type = _data.getUint16(offset, Endian.little);
      final headerSize = _data.getUint16(offset + 2, Endian.little);
      final chunkSize = _data.getUint32(offset + 4, Endian.little);

      // The XML container chunk spans the whole file: step past its header to
      // reach the child chunks.
      if (type == _resXmlType) {
        offset += headerSize < 8 ? 8 : headerSize;
        continue;
      }

      // Invalid or truncated chunk: nothing past it can be trusted.
      if (headerSize < 8 ||
          chunkSize < headerSize ||
          offset + chunkSize > _bytes.length) {
        break;
      }

      switch (type) {
        case _resStringPoolType:
          _strings = _StringPool.parse(
            _bytes,
            _data,
            offset,
            headerSize,
            chunkSize,
          );
        case _resXmlStartElementType:
          _readStartElement(offset, headerSize);
          if (_packageName != null) return _packageName;
      }
      offset += chunkSize;
    }

    return _packageName;
  }

  void _readStartElement(int offset, int headerSize) {
    if (headerSize < 16) return;

    final base = offset + headerSize;
    if (base + 20 > _bytes.length) return;

    final nameIndex = _data.getUint32(base + 4, Endian.little);
    final attributeStart = _data.getUint16(base + 8, Endian.little);
    final attributeSize = _data.getUint16(base + 10, Endian.little);
    final attributeCount = _data.getUint16(base + 12, Endian.little);

    // The package name only lives on the <manifest> node.
    if (_strings?.get(nameIndex) != 'manifest' || attributeSize < 20) return;

    final attributesBase = base + attributeStart;
    for (var i = 0; i < attributeCount; i++) {
      final attr = attributesBase + i * attributeSize;
      if (attr + 20 > _bytes.length) return;

      final attrNameIndex = _data.getUint32(attr + 4, Endian.little);
      if (_strings?.get(attrNameIndex) != 'package') continue;

      final rawValueIndex = _data.getUint32(attr + 8, Endian.little);
      final valueType = _data.getUint8(attr + 15);
      final valueData = _data.getUint32(attr + 16, Endian.little);

      _packageName = _stringOf(valueType, valueData, rawValueIndex);
      return;
    }
  }

  /// Resource references (`@string/...`) deliberately return `null`.
  String? _stringOf(int valueType, int valueData, int rawValueIndex) {
    if (valueType == _typeReference) return null;

    if (valueType == _typeString) {
      final value = _strings?.get(valueData);
      if (value != null && value.isNotEmpty) return value;
    }

    // Some vendors leave the type unset and keep the value in the raw string.
    final raw = _strings?.get(rawValueIndex);
    if (raw != null && raw.isNotEmpty) return raw;

    return null;
  }
}

/// AXML string pool (UTF-8 or UTF-16).
class _StringPool {
  _StringPool._(this._strings);

  final List<String?> _strings;

  static _StringPool parse(
    Uint8List bytes,
    ByteData data,
    int chunkOffset,
    int headerSize,
    int chunkSize,
  ) {
    if (chunkOffset + headerSize > bytes.length) return _StringPool._(const []);

    final count = data.getUint32(chunkOffset + 8, Endian.little);
    final flags = data.getUint32(chunkOffset + 16, Endian.little);
    final stringsStart = data.getUint32(chunkOffset + 20, Endian.little);

    final isUtf8 = (flags & 0x0100) != 0;
    final offsetTable = chunkOffset + headerSize;
    final dataStart = chunkOffset + stringsStart;

    final strings = List<String?>.filled(count, null, growable: false);
    for (var i = 0; i < count; i++) {
      final entryPos = offsetTable + i * 4;
      if (entryPos + 4 > bytes.length) break;

      final stringOffset = data.getUint32(entryPos, Endian.little);
      final pos = dataStart + stringOffset;
      if (pos < 0 || pos >= bytes.length) continue;

      strings[i] = isUtf8
          ? _readUtf8(bytes, data, pos)
          : _readUtf16(bytes, data, pos);
    }

    return _StringPool._(strings);
  }

  String? get(int index) {
    if (index < 0 || index >= _strings.length) return null;
    return _strings[index];
  }

  /// A UTF-8 pool length is two varints: character count, then byte count.
  /// Reading only the byte count drops the string's last byte (e.g.
  /// "Azan Time Pro" -> "Azan Time Pr").
  static String? _readUtf8(Uint8List bytes, ByteData data, int pos) {
    var cursor = pos;

    final charCount = _readVarint(bytes, data, cursor);
    if (charCount == null) return null;
    cursor = charCount.end;

    final byteCount = _readVarint(bytes, data, cursor);
    if (byteCount == null) return null;
    cursor = byteCount.end;

    if (byteCount.value == 0) return '';
    if (cursor + byteCount.value > bytes.length) return null;

    return utf8.decode(
      bytes.sublist(cursor, cursor + byteCount.value),
      allowMalformed: true,
    );
  }

  /// Reads a one-byte length, or two bytes when the high bit is set.
  static ({int value, int end})? _readVarint(
    Uint8List bytes,
    ByteData data,
    int pos,
  ) {
    if (pos >= bytes.length) return null;

    var value = data.getUint8(pos);
    var cursor = pos + 1;
    if (value & 0x80 != 0) {
      if (cursor >= bytes.length) return null;
      value = ((value & 0x7f) << 8) | data.getUint8(cursor);
      cursor += 1;
    }

    return (value: value, end: cursor);
  }

  static String? _readUtf16(Uint8List bytes, ByteData data, int pos) {
    var cursor = pos;
    if (cursor + 2 > bytes.length) return null;

    var length = data.getUint16(cursor, Endian.little);
    cursor += 2;
    if (length & 0x8000 != 0) {
      if (cursor + 2 > bytes.length) return null;
      length =
          ((length & 0x7fff) << 16) | data.getUint16(cursor, Endian.little);
      cursor += 2;
    }
    if (length == 0) return '';
    if (cursor + length * 2 > bytes.length) return null;

    final units = List<int>.generate(
      length,
      (i) => data.getUint16(cursor + i * 2, Endian.little),
    );
    return String.fromCharCodes(units);
  }
}
