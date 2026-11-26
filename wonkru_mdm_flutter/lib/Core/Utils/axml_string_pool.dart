import 'dart:convert';
import 'dart:typed_data';

/// Parsed `ResStringPool` chunk of a binary Android resource file.
///
/// Self-contained reader used by both the manifest parser and the resource
/// table; corrupt input yields `null` entries instead of throwing.
class AxmlStringPool {
  AxmlStringPool._(this._strings);

  final List<String?> _strings;

  static AxmlStringPool parse(
    Uint8List bytes,
    ByteData data,
    int chunkOffset,
    int headerSize,
    int chunkSize,
  ) {
    if (chunkOffset + headerSize > bytes.length) {
      return AxmlStringPool._(const []);
    }

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

    return AxmlStringPool._(strings);
  }

  String? get(int index) {
    if (index < 0 || index >= _strings.length) return null;
    return _strings[index];
  }

  /// In a UTF-8 pool the length is written as two varints: first the character
  /// count, then the byte count. Reading only the byte count drops the end of
  /// the string (e.g. "Azan Time Pro" -> "Azan Time Pr").
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
