/// Pure Dart helpers that decode the binary (`AXML`) `AndroidManifest.xml`
/// inside an APK.
///
/// No browser/platform dependency, and the input never throws; corrupt input
/// returns `null`.
library;

import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../Constants/app_permissions.dart';
import 'axml_string_pool.dart';

/// `ResChunk_header` types (AOSP `ResourceTypes.h`).
const int _resStringPoolType = 0x0001;
const int _resXmlType = 0x0003;
const int _resXmlResourceMapType = 0x0180;
const int _resXmlStartElementType = 0x0102;

/// `resources.arsc` chunk types (AOSP `ResourceTypes.h`).
const int _resTableType = 0x0002;
const int _resTablePackageType = 0x0200;
const int _resTableTypeType = 0x0201;

/// `Res_value` data types (AOSP `ResourceTypes.h`).
const int _typeReference = 0x01;
const int _typeString = 0x03;
const int _typeIntDec = 0x10;
const int _typeIntHex = 0x11;
const int _typeIntBoolean = 0x12;

/// Resource ids of the Android attributes we care about; used as a fallback
/// when the string pool cannot be read.
const int _attrLabel = 0x01010001;
const int _attrName = 0x01010003;
const int _attrVersionCode = 0x0101021b;
const int _attrVersionName = 0x0101021c;
const int _attrMinSdkVersion = 0x0101020c;
const int _attrTargetSdkVersion = 0x01010270;

class ApkManifest {
  const ApkManifest({
    this.appName,
    this.packageName,
    this.versionName,
    this.versionCode,
    this.minSdkVersion,
    this.targetSdkVersion,
    this.permissions = const {},
  });

  /// `<application android:label="...">`; resolved through `resources.arsc`
  /// when it is a resource reference, otherwise `null`.
  final String? appName;

  final String? packageName;

  final String? versionName;

  final int? versionCode;

  final int? minSdkVersion;

  final int? targetSdkVersion;

  /// `<uses-permission android:name="...">` mapped to a default action;
  /// dangerous permissions get `ask`, others `allow` (see
  /// [AppPermissions.defaultAction]).
  final Map<String, String> permissions;

  bool get isEmpty =>
      appName == null &&
      packageName == null &&
      versionName == null &&
      versionCode == null &&
      minSdkVersion == null &&
      targetSdkVersion == null &&
      permissions.isEmpty;
}

/// Decodes the binary `AndroidManifest.xml` from APK (ZIP) bytes.
///
/// Returns `null` on corrupt/unexpected input (not a ZIP, no manifest, broken
/// AXML) and never throws.
ApkManifest? parseApkManifest(Uint8List apkBytes) {
  if (apkBytes.isEmpty) return null;

  try {
    final archive = ZipDecoder().decodeBytes(apkBytes);
    final entry = archive.findFile('AndroidManifest.xml');
    if (entry == null) return null;

    final xmlBytes = entry.readBytes();
    if (xmlBytes == null || xmlBytes.isEmpty) return null;

    final parser = _AxmlParser(xmlBytes);
    var manifest = parser.parse();

    // `android:label` is almost always a `@string/app_name` reference; the
    // real text lives in the resource table.
    final labelId = parser.labelResourceId;
    if (manifest.appName == null && labelId != null) {
      final table = archive.findFile('resources.arsc')?.readBytes();
      final resolved = table == null ? null : _ResourceTable.resolveString(table, labelId);
      if (resolved != null && resolved.isNotEmpty) {
        manifest = ApkManifest(
          appName: resolved,
          packageName: manifest.packageName,
          versionName: manifest.versionName,
          versionCode: manifest.versionCode,
          minSdkVersion: manifest.minSdkVersion,
          targetSdkVersion: manifest.targetSdkVersion,
          permissions: manifest.permissions,
        );
      }
    }

    return manifest.isEmpty ? null : manifest;
  } catch (_) {
    return null;
  }
}

class _AxmlParser {
  _AxmlParser(Uint8List bytes) : _bytes = bytes, _data = ByteData.sublistView(bytes);

  final Uint8List _bytes;
  final ByteData _data;

  AxmlStringPool? _strings;
  List<int> _resourceIds = const [];

  String? _appName;

  int? labelResourceId;

  String? _packageName;
  String? _versionName;
  int? _versionCode;
  int? _minSdkVersion;
  int? _targetSdkVersion;
  final Map<String, String> _permissions = {};

  ApkManifest parse() {
    var offset = 0;
    while (offset + 8 <= _bytes.length) {
      final type = _data.getUint16(offset, Endian.little);
      final headerSize = _data.getUint16(offset + 2, Endian.little);
      final chunkSize = _data.getUint32(offset + 4, Endian.little);

      // The XML container chunk spans the whole file; advance past its header
      // to reach the sub-chunks.
      if (type == _resXmlType) {
        offset += headerSize < 8 ? 8 : headerSize;
        continue;
      }

      if (headerSize < 8 || chunkSize < headerSize || offset + chunkSize > _bytes.length) {
        break;
      }

      switch (type) {
        case _resStringPoolType:
          _strings = AxmlStringPool.parse(
            _bytes,
            _data,
            offset,
            headerSize,
            chunkSize,
          );
        case _resXmlResourceMapType:
          _readResourceMap(offset, headerSize, chunkSize);
        case _resXmlStartElementType:
          _readStartElement(offset, headerSize);
      }
      offset += chunkSize;
    }

    return ApkManifest(
      appName: _appName,
      packageName: _packageName,
      versionName: _versionName,
      versionCode: _versionCode,
      minSdkVersion: _minSdkVersion,
      targetSdkVersion: _targetSdkVersion,
      permissions: Map.unmodifiable(_permissions),
    );
  }

  void _readResourceMap(int offset, int headerSize, int chunkSize) {
    final count = (chunkSize - headerSize) ~/ 4;
    final ids = <int>[];
    for (var i = 0; i < count; i++) {
      final pos = offset + headerSize + i * 4;
      if (pos + 4 > _bytes.length) break;
      ids.add(_data.getUint32(pos, Endian.little));
    }
    _resourceIds = ids;
  }

  void _readStartElement(int offset, int headerSize) {
    if (headerSize < 16) return;

    final base = offset + headerSize;
    if (base + 20 > _bytes.length) return;

    final nameIndex = _data.getUint32(base + 4, Endian.little);
    final attributeStart = _data.getUint16(base + 8, Endian.little);
    final attributeSize = _data.getUint16(base + 10, Endian.little);
    final attributeCount = _data.getUint16(base + 12, Endian.little);

    final element = _strings?.get(nameIndex);
    if (element == null || attributeSize < 20) return;

    final attributesBase = base + attributeStart;
    for (var i = 0; i < attributeCount; i++) {
      final attr = attributesBase + i * attributeSize;
      if (attr + 20 > _bytes.length) return;

      final attrNameIndex = _data.getUint32(attr + 4, Endian.little);
      final rawValueIndex = _data.getUint32(attr + 8, Endian.little);
      final valueType = _data.getUint8(attr + 15);
      final valueData = _data.getUint32(attr + 16, Endian.little);

      final name = _strings?.get(attrNameIndex);
      final resourceId = attrNameIndex < _resourceIds.length ? _resourceIds[attrNameIndex] : null;

      _applyAttribute(
        element: element,
        name: name,
        resourceId: resourceId,
        valueType: valueType,
        valueData: valueData,
        rawValueIndex: rawValueIndex,
      );
    }
  }

  void _applyAttribute({
    required String element,
    required String? name,
    required int? resourceId,
    required int valueType,
    required int valueData,
    required int rawValueIndex,
  }) {
    bool named(String value) => name == value;
    bool identified(int id) => resourceId == id;

    switch (element) {
      case 'application':
        if (named('label') || identified(_attrLabel)) {
          if (valueType == _typeReference) {
            labelResourceId ??= valueData;
          } else {
            _appName ??= _stringOf(valueType, valueData, rawValueIndex);
          }
        }
      case 'manifest':
        if (named('package')) {
          _packageName ??= _stringOf(valueType, valueData, rawValueIndex);
        } else if (named('versionName') || identified(_attrVersionName)) {
          _versionName ??= _stringOf(valueType, valueData, rawValueIndex);
        } else if (named('versionCode') || identified(_attrVersionCode)) {
          _versionCode ??= _intOf(valueType, valueData);
        }
      case 'uses-sdk':
        if (named('minSdkVersion') || identified(_attrMinSdkVersion)) {
          _minSdkVersion ??= _intOf(valueType, valueData);
        } else if (named('targetSdkVersion') || identified(_attrTargetSdkVersion)) {
          _targetSdkVersion ??= _intOf(valueType, valueData);
        }
      case 'uses-permission':
      case 'uses-permission-sdk-23':
        if (named('name') || identified(_attrName)) {
          final permission = _stringOf(valueType, valueData, rawValueIndex);
          if (permission != null && permission.isNotEmpty) {
            _permissions[permission] = AppPermissions.defaultAction(permission);
          }
        }
    }
  }

  /// Reads text from a string-pool reference; deliberately returns `null` for
  /// resource references (`@string/...`).
  String? _stringOf(int valueType, int valueData, int rawValueIndex) {
    if (valueType == _typeReference) return null;

    if (valueType == _typeString) {
      final value = _strings?.get(valueData);
      if (value != null && value.isNotEmpty) return value;
    }

    // Some manufacturers leave the type unspecified and keep the value in the
    // raw string.
    final raw = _strings?.get(rawValueIndex);
    if (raw != null && raw.isNotEmpty) return raw;

    return null;
  }

  int? _intOf(int valueType, int valueData) {
    switch (valueType) {
      case _typeIntDec:
      case _typeIntHex:
        return valueData;
      case _typeIntBoolean:
        return valueData != 0 ? 1 : 0;
      case _typeString:
        return int.tryParse(_strings?.get(valueData) ?? '');
      default:
        return null;
    }
  }
}

/// Resolves a single string resource from `resources.arsc`.
///
/// Not a full resource-table reader: it only finds the plain string for the
/// given id (the app label). Default (language-less) configs are preferred
/// over locale variants; otherwise the first resolved value wins. Corrupt
/// input returns `null` and never throws.
class _ResourceTable {
  const _ResourceTable._();

  static String? resolveString(Uint8List bytes, int resourceId) {
    if (bytes.length < 12) return null;

    try {
      final data = ByteData.sublistView(bytes);
      if (data.getUint16(0, Endian.little) != _resTableType) return null;

      final headerSize = data.getUint16(2, Endian.little);
      final tableSize = data.getUint32(4, Endian.little);
      final limit = tableSize < bytes.length ? tableSize : bytes.length;

      final packageId = (resourceId >> 24) & 0xff;
      final typeId = (resourceId >> 16) & 0xff;
      final entryIndex = resourceId & 0xffff;

      AxmlStringPool? values;
      var offset = headerSize < 12 ? 12 : headerSize;

      while (offset + 8 <= limit) {
        final type = data.getUint16(offset, Endian.little);
        final chunkHeader = data.getUint16(offset + 2, Endian.little);
        final chunkSize = data.getUint32(offset + 4, Endian.little);
        if (chunkHeader < 8 || chunkSize < chunkHeader || offset + chunkSize > limit) {
          break;
        }

        if (type == _resStringPoolType) {
          // The first pool in the table is the global value pool.
          values ??= AxmlStringPool.parse(
            bytes,
            data,
            offset,
            chunkHeader,
            chunkSize,
          );
        } else if (type == _resTablePackageType && values != null) {
          final resolved = _fromPackage(
            bytes,
            data,
            offset,
            chunkHeader,
            chunkSize,
            packageId: packageId,
            typeId: typeId,
            entryIndex: entryIndex,
            values: values,
          );
          if (resolved != null) return resolved;
        }

        offset += chunkSize;
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  static String? _fromPackage(
    Uint8List bytes,
    ByteData data,
    int offset,
    int headerSize,
    int chunkSize, {
    required int packageId,
    required int typeId,
    required int entryIndex,
    required AxmlStringPool values,
  }) {
    if (offset + 12 > bytes.length) return null;
    if (data.getUint32(offset + 8, Endian.little) != packageId) return null;

    String? fallback;
    var cursor = offset + headerSize;
    final end = offset + chunkSize;

    while (cursor + 8 <= end) {
      final type = data.getUint16(cursor, Endian.little);
      final chunkHeader = data.getUint16(cursor + 2, Endian.little);
      final size = data.getUint32(cursor + 4, Endian.little);
      if (chunkHeader < 8 || size < chunkHeader || cursor + size > end) break;

      if (type == _resTableTypeType && cursor + 20 <= bytes.length && data.getUint8(cursor + 8) == typeId) {
        final value = _entryValue(
          bytes,
          data,
          cursor,
          chunkHeader,
          entryIndex: entryIndex,
          values: values,
        );
        if (value != null) {
          final languageAt = cursor + 28;
          final isDefault =
              languageAt + 2 <= bytes.length && data.getUint8(languageAt) == 0 && data.getUint8(languageAt + 1) == 0;
          if (isDefault) return value;
          fallback ??= value;
        }
      }

      cursor += size;
    }

    return fallback;
  }

  static String? _entryValue(
    Uint8List bytes,
    ByteData data,
    int cursor,
    int headerSize, {
    required int entryIndex,
    required AxmlStringPool values,
  }) {
    final entryCount = data.getUint32(cursor + 12, Endian.little);
    final entriesStart = data.getUint32(cursor + 16, Endian.little);
    if (entryIndex >= entryCount) return null;

    final offsetPos = cursor + headerSize + entryIndex * 4;
    if (offsetPos + 4 > bytes.length) return null;

    final entryOffset = data.getUint32(offsetPos, Endian.little);
    if (entryOffset == 0xffffffff) return null;

    final entryPos = cursor + entriesStart + entryOffset;
    if (entryPos + 8 > bytes.length) return null;

    final entrySize = data.getUint16(entryPos, Endian.little);
    final flags = data.getUint16(entryPos + 2, Endian.little);

    if (flags & 0x0001 != 0) return null;

    final valuePos = entryPos + entrySize;
    if (valuePos + 8 > bytes.length) return null;

    if (data.getUint8(valuePos + 3) != _typeString) return null;
    return values.get(data.getUint32(valuePos + 4, Endian.little));
  }
}
