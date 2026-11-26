import '../../../../../Core/Constants/Enums/policy_enums.dart';
import '../policy_field_spec.dart';

const PolicySettingsTabSpec policyBatteryTab = PolicySettingsTabSpec(
  title: 'common.battery',
  groups: [
    PolicyFieldGroupSpec(
      title: 'policies.group_battery_thresholds',
      fields: [
        PolicyFieldSpec(
          path: 'battery_settings.low_battery_threshold',
          label: 'policies.field_low_battery_threshold',
          type: PolicyFieldType.number,
          min: 0,
          max: 100,
          helper: 'policies.helper_low_battery',
        ),
        PolicyFieldSpec(
          path: 'battery_settings.critical_battery_threshold',
          label: 'policies.field_critical_battery_threshold',
          type: PolicyFieldType.number,
          min: 0,
          max: 100,
          helper: 'policies.helper_critical_battery',
        ),
      ],
    ),
  ],
);
