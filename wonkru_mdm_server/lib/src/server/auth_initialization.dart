import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../generated/serverpod.dart';
import '../service/email_idp_sender.dart';

/// Initializes the auth services for the API server and the admin CLI.
///
/// Both entry points must run this before touching `AuthServices.instance`;
/// the CLI starts a maintenance-mode pod, so it never reaches
/// `ServerBootstrap` on its own.
void initializeAuthServices(Serverpod pod) {
  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      EmailIdpSender.config(),
    ],
  );
}
