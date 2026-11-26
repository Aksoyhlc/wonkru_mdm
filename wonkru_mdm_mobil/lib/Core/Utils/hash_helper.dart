import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';

const _tag = 'HashHelper';

class HashHelper {
  static Future<String> calculateFileHash(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return '';

      final input = file.openRead();
      Digest? result;
      final sink = ChunkedConversionSink<Digest>.withCallback((chunks) {
        result = chunks.single;
      });
      final digestSink = sha256.startChunkedConversion(sink);

      await for (final chunk in input) {
        digestSink.add(chunk);
      }
      digestSink.close();

      return result?.toString() ?? '';
    } catch (e, st) {
      WLog.e(_tag, 'Hash calculation error', error: e, stackTrace: st);
      return '';
    }
  }
}
