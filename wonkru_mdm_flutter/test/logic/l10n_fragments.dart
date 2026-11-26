import 'package:wonkru_mdm_flutter/Core/L10n/Langs/applications_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/applications_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/certificates_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/certificates_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/common_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/common_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/dashboard_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/dashboard_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/device_groups_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/device_groups_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/device_logs_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/device_logs_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/device_syncs_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/device_syncs_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/devices_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/devices_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/files_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/files_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/notifications_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/notifications_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/policies_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/policies_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/profile_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/profile_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/provisioning_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/provisioning_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/settings_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/settings_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/users_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/users_tr.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/activity_en.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/Langs/activity_tr.dart';

typedef L10nFragment = ({
  String base,
  Map<String, String> tr,
  Map<String, String> en,
});

const l10nFragments = <String, L10nFragment>{
  'common': (base: 'common', tr: commonTr, en: commonEn),
  'policies': (base: 'policies', tr: policiesTr, en: policiesEn),
  'devices': (base: 'devices', tr: devicesTr, en: devicesEn),
  'deviceGroups': (
    base: 'device_groups',
    tr: deviceGroupsTr,
    en: deviceGroupsEn,
  ),
  'deviceLogs': (base: 'device_logs', tr: deviceLogsTr, en: deviceLogsEn),
  'deviceSyncs': (base: 'device_syncs', tr: deviceSyncsTr, en: deviceSyncsEn),
  'settings': (base: 'settings', tr: settingsTr, en: settingsEn),
  'profile': (base: 'profile', tr: profileTr, en: profileEn),
  'users': (base: 'users', tr: usersTr, en: usersEn),
  'notifications': (
    base: 'notifications',
    tr: notificationsTr,
    en: notificationsEn,
  ),
  'applications': (
    base: 'applications',
    tr: applicationsTr,
    en: applicationsEn,
  ),
  'certificates': (
    base: 'certificates',
    tr: certificatesTr,
    en: certificatesEn,
  ),
  'files': (base: 'files', tr: filesTr, en: filesEn),
  'provisioning': (
    base: 'provisioning',
    tr: provisioningTr,
    en: provisioningEn,
  ),
  'dashboard': (base: 'dashboard', tr: dashboardTr, en: dashboardEn),
  'activity': (base: 'activity', tr: activityTr, en: activityEn),
};
