import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import '../test_tools/serverpod_test_tools.dart';

/// The test server does not run `server.dart`, so auth services must be
/// installed globally. Tests that create email accounts must call this in
/// `setUpAll`.
void installTestAuthServices() {
  AuthServices.set(
    tokenManagerBuilders: [
      ServerSideSessionsConfig(sessionKeyHashPepper: 'wonkru-test-pepper'),
    ],
    identityProviderBuilders: [
      const EmailIdpConfig(secretHashPepper: 'wonkru-test-secret-pepper'),
    ],
  );
}

class TestAdmin {
  TestAdmin({
    required this.userId,
    required this.profile,
    required this.builder,
  });

  final UuidValue userId;
  final AdminProfile profile;
  final TestSessionBuilder builder;
}

var _counter = 0;

UuidValue nextTestUserId() {
  _counter++;
  final tail = _counter.toRadixString(16).padLeft(12, '0');
  return UuidValue.fromString('00000000-0000-4000-8000-$tail');
}

TestSessionBuilder adminSessionFor(
  TestSessionBuilder sessionBuilder,
  UuidValue userId, {
  Set<Scope>? scopes,
  String? authId,
}) => sessionBuilder.copyWith(
  authentication: AuthenticationOverride.authenticationInfo(
    userId.uuid,
    scopes ?? {Scope('admin')},
    authId: authId,
  ),
);

Future<TestAdmin> createAdmin(
  Session session,
  TestSessionBuilder sessionBuilder, {
  UuidValue? userId,
  AdminAccountStatus status = AdminAccountStatus.active,
}) async {
  final id = userId ?? nextTestUserId();
  final now = DateTime.now().toUtc();
  final profile = await AdminProfile.db.insertRow(
    session,
    AdminProfile(userId: id, status: status, createdAt: now, updatedAt: now),
  );
  return TestAdmin(
    userId: id,
    profile: profile,
    builder: adminSessionFor(sessionBuilder, id),
  );
}

/// [installTestAuthServices] must be called beforehand.
Future<TestAdmin> createEmailAdmin(
  Session session,
  TestSessionBuilder sessionBuilder, {
  required String email,
  required String password,
  AdminAccountStatus status = AdminAccountStatus.active,
}) async {
  final authUser = await AuthServices.instance.authUsers.create(session);
  await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
    session,
    authUserId: authUser.id,
    email: email,
    password: password,
  );
  await AuthServices.instance.userProfiles.createUserProfile(
    session,
    authUser.id,
    UserProfileData(email: email),
  );
  return createAdmin(
    session,
    sessionBuilder,
    userId: authUser.id,
    status: status,
  );
}
