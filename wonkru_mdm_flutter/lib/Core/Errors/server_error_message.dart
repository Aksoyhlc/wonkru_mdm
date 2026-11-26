import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../L10n/L.dart';

/// Converts an error from a server call into a user-facing (localized) message.
///
/// Network failures and the server's own 5xx errors are kept distinct: showing
/// "server unreachable" for both would mislead, since the server did respond
/// and the fault is server-side (e.g. a missing environment variable).
///
/// The server's typed business errors already carry a message meant for the
/// admin, so that text is shown as is.
String serverErrorMessage(Object error) {
  final businessMessage = switch (error) {
    AdminTotpException(:final message) ||
    AdminPolicyValidationException(:final message) ||
    AdminSettingsException(:final message) ||
    AdminUploadException(:final message) ||
    ApplicationConflictException(:final message) ||
    CertificateParseException(:final message) ||
    DeviceCommandValidationException(:final message) ||
    RateLimitExceededException(:final message) => message,
    _ => null,
  };
  if (businessMessage != null) return businessMessage;

  if (error is ServerpodClientUnauthorized) {
    return L.common.sessionExpired;
  }
  if (error is ServerpodClientForbidden) {
    return L.common.forbidden;
  }
  if (error is ServerpodClientNetworkException) {
    return L.common.serverUnreachable;
  }
  if (error is ServerpodClientHttpException && error.statusCode >= 500) {
    return L.common.serverError;
  }
  if (error is ServerpodClientException) {
    return L.common.requestFailed;
  }
  return L.common.unexpectedError;
}
