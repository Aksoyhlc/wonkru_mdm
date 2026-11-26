library;

import '../policy_field_spec.dart';
import 'policy_audio_tab.dart';
import 'policy_battery_tab.dart';
import 'policy_display_tab.dart';
import 'policy_launcher_tab.dart';
import 'policy_other_tab.dart';
import 'policy_restriction_tab.dart';
import 'policy_security_tab.dart';
import 'policy_storage_tab.dart';

export 'policy_audio_tab.dart';
export 'policy_battery_tab.dart';
export 'policy_display_tab.dart';
export 'policy_general_tab.dart';
export 'policy_launcher_tab.dart';
export 'policy_other_tab.dart';
export 'policy_restriction_tab.dart';
export 'policy_security_tab.dart';
export 'policy_storage_tab.dart';

/// Order of the settings tabs after the general tab.
const List<PolicySettingsTabSpec> policySettingsTabs = <PolicySettingsTabSpec>[
  policyBatteryTab,
  policyStorageTab,
  policyAudioTab,
  policyDisplayTab,
  policySecurityTab,
  policyRestrictionTab,
  policyLauncherTab,
  policyOtherTab,
];
