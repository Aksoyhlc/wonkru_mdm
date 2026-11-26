import 'package:wonkru_mdm_client/wonkru_mdm_client.dart' show NotificationType;

import '../../L10n/L.dart';

export 'package:wonkru_mdm_client/wonkru_mdm_client.dart' show NotificationType;

extension NotificationTypePanel on NotificationType {
  String get label => switch (this) {
    NotificationType.normal => L.common.notificationTypeNormal,
  };
}

Map<String, String> get notificationTypeKeyValues => {
  for (final type in NotificationType.values) type.name: type.label,
};

NotificationType? notificationTypeFromValue(String? value) {
  if (value == null) return null;
  for (final type in NotificationType.values) {
    if (type.name == value) return type;
  }
  return null;
}
