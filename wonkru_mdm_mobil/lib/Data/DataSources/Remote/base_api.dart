import 'package:dio/dio.dart';
import 'package:wonkrumdm/Core/Network/dio_factory.dart';

class BaseApi {
  String lastMessage = '';
  final emptyMap = <String, dynamic>{};

  Future<Dio> createSecureDio() {
    return Future.value(
      DioFactory.create(
        sendTimeout: const Duration(seconds: 10),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  (bool, String) normalizeDioError(Object error, StackTrace stack) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return (false, 'Connection timeout');
        case DioExceptionType.sendTimeout:
          return (false, 'Request send timeout');
        case DioExceptionType.receiveTimeout:
          return (false, 'Response timeout');
        case DioExceptionType.badResponse:
          final code = error.response?.statusCode;
          return (false, 'HTTP error${code != null ? ' ($code)' : ''}');
        case DioExceptionType.cancel:
          return (false, 'Request cancelled');
        case DioExceptionType.connectionError:
          return (false, 'Connection error');
        case DioExceptionType.unknown:
          return (false, 'Unknown network error');
        case DioExceptionType.badCertificate:
          return (false, 'Invalid/inappropriate certificate');
        case DioExceptionType.transformTimeout:
          return (false, 'Transform timeout');
      }
    }
    return (false, error.toString());
  }
}
