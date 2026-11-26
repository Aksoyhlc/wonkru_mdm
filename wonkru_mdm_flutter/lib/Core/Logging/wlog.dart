import 'package:flutter/foundation.dart';

class WLog {
  const WLog._();

  static void d(String tag, String message) => debugPrint('[$tag] $message');
  static void e(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) => debugPrint('[$tag] $message${error == null ? '' : ' | $error'}');
  static void i(String tag, String message) => debugPrint('[$tag] $message');
}
