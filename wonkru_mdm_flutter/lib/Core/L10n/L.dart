// ignore_for_file: file_names

import 'L/activity_l.dart';
import 'L/applications_l.dart';
import 'L/certificates_l.dart';
import 'L/common_l.dart';
import 'L/dashboard_l.dart';
import 'L/device_groups_l.dart';
import 'L/device_logs_l.dart';
import 'L/device_syncs_l.dart';
import 'L/devices_l.dart';
import 'L/files_l.dart';
import 'L/notifications_l.dart';
import 'L/policies_l.dart';
import 'L/profile_l.dart';
import 'L/provisioning_l.dart';
import 'L/settings_l.dart';
import 'L/users_l.dart';

abstract final class L {
  L._();

  static const common = CommonL();
  static const policies = PoliciesL();
  static const devices = DevicesL();
  static const deviceGroups = DeviceGroupsL();
  static const deviceLogs = DeviceLogsL();
  static const deviceSyncs = DeviceSyncsL();
  static const settings = SettingsL();
  static const profile = ProfileL();
  static const users = UsersL();
  static const notifications = NotificationsL();
  static const applications = ApplicationsL();
  static const certificates = CertificatesL();
  static const files = FilesL();
  static const provisioning = ProvisioningL();
  static const dashboard = DashboardL();
  static const activity = ActivityL();
}
