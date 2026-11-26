import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/auth_enums.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/auth_controller.dart';
import 'package:wonkru_mdm_flutter/Logic/UI/app_toast_controller.dart';

class _FakeAuthController extends AuthController {
  _FakeAuthController({
    this.session,
    this.signedIn = true,
    this.signInThrows = false,
  });

  final AdminSessionInfo? session;
  final bool signedIn;
  final bool signInThrows;

  @override
  Future<void> awaitSessionRestored() async {}

  @override
  bool get isSignedIn => signedIn;

  @override
  Future<AdminSessionInfo> fetchSession() async {
    final value = session;
    if (value == null) throw Exception('network error');
    return value;
  }

  @override
  Future<void> requestSignIn(String email, String password) async {
    if (signInThrows) throw Exception('network error');
  }
}

AdminSessionInfo _session({
  AdminAccountStatus? status,
  bool hasAdminScope = false,
  bool needsBootstrap = false,
}) => AdminSessionInfo(
  status: status,
  hasAdminScope: hasAdminScope,
  needsBootstrap: needsBootstrap,
);

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    // AppToast.show resolves its controller via Get.find.
    Get.put(AppToastController());
  });

  test('signedOut when there is no session', () async {
    final controller = _FakeAuthController(signedIn: false);

    await controller.init();

    expect(controller.status.value, AuthStatus.signedOut);
    expect(controller.needsBootstrap.value, isFalse);
  });

  test('failed when me() errors and carries a message to the user', () async {
    final controller = _FakeAuthController();

    await controller.init();

    expect(controller.status.value, AuthStatus.failed);
    expect(controller.errorMessage.value, isNotNull);
  });

  test('ready when active with scope', () async {
    final controller = _FakeAuthController(
      session: _session(
        status: AdminAccountStatus.active,
        hasAdminScope: true,
      ),
    );

    await controller.init();

    expect(controller.status.value, AuthStatus.ready);
  });

  test('noAccess when active without scope (loop guard)', () async {
    final controller = _FakeAuthController(
      session: _session(status: AdminAccountStatus.active),
    );

    await controller.init();

    expect(controller.status.value, AuthStatus.noAccess);
  });

  test('sign-in RPC error returns false and does not open a session', () async {
    final controller = _FakeAuthController(
      session: _session(
        status: AdminAccountStatus.active,
        hasAdminScope: true,
      ),
      signInThrows: true,
    );
    await controller.init();
    expect(controller.status.value, AuthStatus.ready);

    final ok = await controller.signIn('admin@example.com', 'wrong');

    expect(ok, isFalse);
    expect(controller.status.value, AuthStatus.ready);
  });
}
