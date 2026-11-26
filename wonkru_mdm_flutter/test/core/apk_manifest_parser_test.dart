import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Utils/apk_manifest_parser.dart';

void main() {
  group('parseApkManifest', () {
    test('parses a manifest with a UTF-8 string pool', () {
      final apk = _apk(_manifestBytes(utf8: true));

      final manifest = parseApkManifest(apk);

      expect(manifest, isNotNull);
      expect(manifest!.packageName, 'com.example.app');
      expect(manifest.versionName, '1.2.3');
      expect(manifest.versionCode, 42);
      expect(manifest.minSdkVersion, 24);
      expect(manifest.targetSdkVersion, 34);
      expect(manifest.permissions, {
        'android.permission.CAMERA': 'ask',
        'android.permission.INTERNET': 'allow',
      });
    });

    test('parses a manifest with a UTF-16 string pool', () {
      final manifest = parseApkManifest(_apk(_manifestBytes(utf8: false)));

      expect(manifest, isNotNull);
      expect(manifest!.packageName, 'com.example.app');
      expect(manifest.versionName, '1.2.3');
      expect(manifest.permissions.keys, contains('android.permission.CAMERA'));
    });

    test('reads a hex-typed version code', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(versionCode: 0x2a, versionCodeType: 0x11)),
      );

      expect(manifest!.versionCode, 42);
    });

    test('parses a boolean-typed version code as 1/0', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(versionCode: 1, versionCodeType: 0x12)),
      );

      expect(manifest!.versionCode, 1);
    });

    test('converts a string-typed version code to a number', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(versionCodeAsString: '42')),
      );

      expect(manifest!.versionCode, 42);
    });

    test('treats a resource-referenced version code as unknown', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(versionCode: 0x7f050000, versionCodeType: 0x01)),
      );

      expect(manifest, isNotNull);
      expect(manifest!.versionCode, isNull);
      expect(manifest.packageName, 'com.example.app');
      expect(manifest.versionName, '1.2.3');
    });

    test('SDK fields stay null when uses-sdk is absent', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(minSdk: null, targetSdk: null)),
      );

      expect(manifest, isNotNull);
      expect(manifest!.minSdkVersion, isNull);
      expect(manifest.targetSdkVersion, isNull);
    });

    test('version code is preserved when name fields are missing', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(packageName: null, versionName: null)),
      );

      expect(manifest, isNotNull);
      expect(manifest!.versionCode, 42);
      expect(manifest.permissions, isNotEmpty);
    });

    test('permissions stay empty when the permission list is empty', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(permissions: const [])),
      );

      expect(manifest, isNotNull);
      expect(manifest!.permissions, isEmpty);
    });

    test('app name is read directly when it is a plain string', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(appLabel: 'Wonkru MDM')),
      );

      expect(manifest!.appName, 'Wonkru MDM');
    });

    test('app name is resolved from resources.arsc when it is a resource reference', () {
      const labelId = 0x7f010000;
      final apk = _apk(
        _manifestBytes(appLabelRef: labelId),
        resources: _resourcesArsc(resourceId: labelId, value: 'Wonkru MDM'),
      );

      final manifest = parseApkManifest(apk);

      expect(manifest!.appName, 'Wonkru MDM');
    });

    test('app name stays null when resources.arsc is absent', () {
      final manifest = parseApkManifest(
        _apk(_manifestBytes(appLabelRef: 0x7f010000)),
      );

      expect(manifest!.appName, isNull);
      expect(manifest.packageName, 'com.example.app');
    });

    test('corrupt resources.arsc returns null without crashing', () {
      final apk = _apk(
        _manifestBytes(appLabelRef: 0x7f010000),
        resources: Uint8List.fromList(List.generate(32, (i) => i)),
      );

      final manifest = parseApkManifest(apk);

      expect(manifest!.appName, isNull);
    });

    test('empty input returns null', () {
      expect(parseApkManifest(Uint8List(0)), isNull);
    });

    test('non-ZIP input returns null', () {
      expect(
        parseApkManifest(Uint8List.fromList(List.generate(64, (i) => i))),
        isNull,
      );
    });

    test('APK without AndroidManifest.xml returns null', () {
      final archive = Archive()
        ..add(ArchiveFile.bytes('classes.dex', Uint8List.fromList([1, 2, 3])));
      final apk = ZipEncoder().encodeBytes(archive);

      expect(parseApkManifest(apk), isNull);
    });

    test('APK with an empty manifest returns null', () {
      expect(parseApkManifest(_apk(Uint8List(0))), isNull);
    });

    test('truncated AXML returns null without crashing', () {
      final truncated = _manifestBytes().sublist(0, 20);

      expect(parseApkManifest(_apk(truncated)), isNull);
    });
  });

  group('ApkManifest', () {
    test('isEmpty returns true when all fields are empty', () {
      expect(const ApkManifest().isEmpty, isTrue);
      expect(
        const ApkManifest(packageName: 'com.example.app').isEmpty,
        isFalse,
      );
      expect(
        const ApkManifest(
          permissions: {'android.permission.CAMERA': 'allow'},
        ).isEmpty,
        isFalse,
      );
    });
  });
}

Uint8List _apk(Uint8List manifestBytes, {Uint8List? resources}) {
  final archive = Archive()
    ..add(ArchiveFile.bytes('AndroidManifest.xml', manifestBytes))
    ..add(ArchiveFile.bytes('classes.dex', Uint8List.fromList([0])));
  if (resources != null) {
    archive.add(ArchiveFile.bytes('resources.arsc', resources));
  }
  return ZipEncoder().encodeBytes(archive);
}

Uint8List _resourcesArsc({required int resourceId, required String value}) {
  final packageId = (resourceId >> 24) & 0xff;
  final typeId = (resourceId >> 16) & 0xff;
  final entryIndex = resourceId & 0xffff;

  final valuePool = _stringPool([value], utf8: true);
  final typePool = _stringPool(['string'], utf8: true);
  final keyPool = _stringPool(['app_name'], utf8: true);

  // ResTable_type: header(8) + id/flags/reserved(4) + entryCount(4) +
  // entriesStart(4) + config(64).
  const typeHeaderSize = 84;
  final entryCount = entryIndex + 1;
  final offsets = <int>[
    for (var i = 0; i < entryIndex; i++) ..._u32(0xffffffff),
    ..._u32(0),
  ];
  final entriesStart = typeHeaderSize + entryCount * 4;
  final entry = <int>[
    ..._u16(8), // ResTable_entry.size
    ..._u16(0), // flags: simple entry
    ..._u32(0), // key: index into the key pool
    ..._u16(8), // Res_value.size
    0, // res0
    _typeString,
    ..._u32(0), // index into the value pool
  ];
  final typeChunk = <int>[
    ..._u16(0x0201),
    ..._u16(typeHeaderSize),
    ..._u32(typeHeaderSize + offsets.length + entry.length),
    typeId, 0, ..._u16(0),
    ..._u32(entryCount),
    ..._u32(entriesStart),
    ..._u32(64), // config.size
    ...List<int>.filled(60, 0), // default config (language/country zero)
    ...offsets,
    ...entry,
  ];

  const packageHeaderSize = 288;
  final packageBody = <int>[...typePool, ...keyPool, ...typeChunk];
  final packageChunk = <int>[
    ..._u16(0x0200),
    ..._u16(packageHeaderSize),
    ..._u32(packageHeaderSize + packageBody.length),
    ..._u32(packageId),
    ...List<int>.filled(256, 0), // name[128] (UTF-16)
    ..._u32(packageHeaderSize), // typeStrings
    ..._u32(0), // lastPublicType
    ..._u32(packageHeaderSize + typePool.length), // keyStrings
    ..._u32(0), // lastPublicKey
    ..._u32(0), // typeIdOffset
    ...packageBody,
  ];

  const tableHeaderSize = 12;
  final body = <int>[...valuePool, ...packageChunk];
  return Uint8List.fromList([
    ..._u16(0x0002),
    ..._u16(tableHeaderSize),
    ..._u32(tableHeaderSize + body.length),
    ..._u32(1), // packageCount
    ...body,
  ]);
}

Uint8List _manifestBytes({
  bool utf8 = true,
  String? packageName = 'com.example.app',
  String? versionName = '1.2.3',
  int? versionCode = 42,
  int versionCodeType = 0x10,
  String? versionCodeAsString,
  int? minSdk = 24,
  int? targetSdk = 34,
  List<String> permissions = const [
    'android.permission.CAMERA',
    'android.permission.INTERNET',
  ],
  String? appLabel,
  int? appLabelRef,
}) {
  final table = _StringTable();
  int add(String value) => table.add(value);

  final manifestIdx = add('manifest');
  final packageIdx = add('package');
  final versionNameIdx = add('versionName');
  final versionCodeIdx = add('versionCode');
  final usesSdkIdx = add('uses-sdk');
  final minSdkIdx = add('minSdkVersion');
  final targetSdkIdx = add('targetSdkVersion');
  final usesPermissionIdx = add('uses-permission');
  final nameIdx = add('name');
  final applicationIdx = add('application');
  final labelIdx = add('label');

  final packageValue = packageName == null ? null : add(packageName);
  final versionNameValue = versionName == null ? null : add(versionName);
  final permissionValues = <String, int>{
    for (final permission in permissions) permission: add(permission),
  };
  final versionCodeStringValue = versionCodeAsString == null
      ? null
      : add(versionCodeAsString);

  final elements = <List<int>>[];

  elements.add(
    _startElement(manifestIdx, [
      if (packageValue != null)
        _attr(packageIdx, packageValue, _typeString, packageValue),
      if (versionNameValue != null)
        _attr(versionNameIdx, versionNameValue, _typeString, versionNameValue),
      if (versionCodeStringValue != null)
        _attr(
          versionCodeIdx,
          versionCodeStringValue,
          _typeString,
          versionCodeStringValue,
        )
      else if (versionCode != null)
        _attr(versionCodeIdx, _noValue, versionCodeType, versionCode),
    ]),
  );

  if (appLabel != null || appLabelRef != null) {
    final labelValue = appLabel == null ? null : add(appLabel);
    elements.add(
      _startElement(applicationIdx, [
        if (labelValue != null)
          _attr(labelIdx, labelValue, _typeString, labelValue)
        else
          _attr(labelIdx, _noValue, _typeReference, appLabelRef!),
      ]),
    );
  }

  if (minSdk != null || targetSdk != null) {
    elements.add(
      _startElement(usesSdkIdx, [
        if (minSdk != null) _attr(minSdkIdx, _noValue, _typeIntDec, minSdk),
        if (targetSdk != null)
          _attr(targetSdkIdx, _noValue, _typeIntDec, targetSdk),
      ]),
    );
  }

  for (final permission in permissions) {
    elements.add(
      _startElement(usesPermissionIdx, [
        _attr(
          nameIdx,
          permissionValues[permission]!,
          _typeString,
          permissionValues[permission]!,
        ),
      ]),
    );
  }

  final stringPool = _stringPool(table.values, utf8: utf8);
  final resourceMap = _resourceMap(table.values);

  final body = <int>[
    ...stringPool,
    ...resourceMap,
    ...elements.expand((e) => e),
  ];
  return Uint8List.fromList([
    ..._u16(0x0003),
    ..._u16(8),
    ..._u32(8 + body.length),
    ...body,
  ]);
}

const int _typeReference = 0x01;
const int _typeString = 0x03;
const int _typeIntDec = 0x10;
const int _noValue = 0xffffffff;

/// AXML attribute resource IDs (fallback when the name string is absent).
const Map<String, int> _resourceIds = {
  'label': 0x01010001,
  'name': 0x01010003,
  'minSdkVersion': 0x0101020c,
  'versionCode': 0x0101021b,
  'versionName': 0x0101021c,
  'targetSdkVersion': 0x01010270,
};

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
    ..._u16(0x0001),
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

List<int> _resourceMap(List<String> values) {
  return [
    ..._u16(0x0180),
    ..._u16(8),
    ..._u32(8 + values.length * 4),
    for (final value in values) ..._u32(_resourceIds[value] ?? 0),
  ];
}

List<int> _startElement(int nameIndex, List<List<int>> attrs) {
  const headerSize = 16;
  const attrExtSize = 20;
  const attrSize = 20;

  return [
    ..._u16(0x0102),
    ..._u16(headerSize),
    ..._u32(headerSize + attrExtSize + attrs.length * attrSize),
    ..._u32(0),
    ..._u32(_noValue),
    ..._u32(_noValue),
    ..._u32(nameIndex),
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
    ..._u32(_noValue),
    ..._u32(nameIndex),
    ..._u32(rawValueIndex),
    ..._u16(8),
    0,
    type,
    ..._u32(data),
  ];
}

/// UTF-8 pool entry: character count, byte count, bytes, terminator.
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
  if (units.length > 0x7fff) {
    out.addAll(_u16(0x8000 | (units.length >> 16)));
    out.addAll(_u16(units.length & 0xffff));
  } else {
    out.addAll(_u16(units.length));
  }
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

class _StringTable {
  final List<String> _values = [];
  final Map<String, int> _index = {};

  int add(String value) {
    final existing = _index[value];
    if (existing != null) return existing;
    _values.add(value);
    final index = _values.length - 1;
    _index[value] = index;
    return index;
  }

  List<String> get values => List.unmodifiable(_values);
}
