import 'package:wonkru_mdm_client/wonkru_mdm_client.dart' show SystemAlertType;

import '../../L10n/L.dart';

export 'package:wonkru_mdm_client/wonkru_mdm_client.dart' show SystemAlertType;

extension SystemAlertTypePanel on SystemAlertType {
  String get label => switch (this) {
    SystemAlertType.device_offline => L.common.alertDeviceOffline,
    SystemAlertType.policy_update_pending => L.common.alertPolicyUpdatePending,
    SystemAlertType.security_info => L.common.alertSecurityInfo,
  };
}

SystemAlertType? systemAlertTypeFromValue(String? value) {
  if (value == null) return null;
  for (final type in SystemAlertType.values) {
    if (type.name == value) return type;
  }
  return null;
}
