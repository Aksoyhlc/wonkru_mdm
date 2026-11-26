import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/service/enrollment_key_service.dart';

import '../test_tools/serverpod_test_tools.dart';

/// The enrollment key is created in the test database on first call.
Future<DeviceRegisterRequest> enrolled(
  TestSessionBuilder sessionBuilder, {
  String? model,
}) async => DeviceRegisterRequest(
  model: model,
  enrollmentKey: await EnrollmentKeyService.current(sessionBuilder.build()),
);
