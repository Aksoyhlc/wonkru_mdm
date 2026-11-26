import 'package:test/test.dart';

/// Bare `throwsA(isA<Exception>())` cannot distinguish a validation error from
/// a not-found or database error, so a test could pass for the wrong reason.
Matcher throwsExceptionWith(String fragment) => throwsA(
  isA<Exception>().having((e) => e.toString(), 'message', contains(fragment)),
);
