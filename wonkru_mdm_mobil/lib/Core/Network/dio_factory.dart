import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';

const _tag = 'DioFactory';

class DioFactory {
  DioFactory._();

  static Dio create({
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
  }) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: connectTimeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
      ),
    );

    final adapter = dio.httpClientAdapter;
    if (adapter is IOHttpClientAdapter) {
      adapter.createHttpClient = () {
        final b64 = BasicStorage.instance.getString(Sk.bootstrap_ca_cert_b64.name);
        if (b64 == null || b64.isEmpty) {
          return HttpClient();
        }
        try {
          final certBytes = base64Decode(b64);
          final context = SecurityContext(withTrustedRoots: true);
          context.setTrustedCertificatesBytes(certBytes);
          return HttpClient(context: context);
        } catch (e, s) {
          WLog.w(_tag, 'Bootstrap CA parse/load failed, using default trust');
          WLog.e(_tag, 'TLS context creation error', error: e, stackTrace: s);
          return HttpClient();
        }
      };
    }

    return dio;
  }
}