import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';

const String bottomLeftAppName = String.fromEnvironment(
  "BOTTOM_LEFT_APP_NAME",
  defaultValue: "Wonkru MDM",
);

/// Overridden by `--dart-define-from-file`.
const String host = String.fromEnvironment("HOST", defaultValue: "10.0.2.2");
const int port = int.fromEnvironment("PORT", defaultValue: 8090);

/// Enrollment key baked into a controlled/dev build. Empty by default; when set
/// the setup screen's key field is filled automatically.
const String buildEnrollmentKey = String.fromEnvironment("ENROLLMENT_KEY");
const bool publicAgentBuild = bool.fromEnvironment('WONKRU_PUBLIC_AGENT');

const int appLaunchAfterInstallTimeout = 3;

const String scheme = String.fromEnvironment("SCHEME", defaultValue: "http");

/// Serverpod base address (no trailing slash; the gateway adds it).
String get serverUrl {
  final url = BasicStorage.instance.getString(Sk.server_url.name);
  if (url != null && url.isNotEmpty) return url;
  return "$scheme://$host${port != 0 ? ":$port" : ""}";
}

const int commandDebounceSeconds = 10;
const int kConfigFetchIntervalMinutes = 30;

String get btManagementAdminPassword {
  final local = StorageHelper.instance
      .getString(Sk.bt_management_admin_password.name)
      ?.trim();
  if (local != null && local.isNotEmpty) return local;
  if (publicAgentBuild) return '';
  return const String.fromEnvironment(
    "IT_PAGE_PASSWORD",
    defaultValue: "CHANGE_ME",
  );
}
