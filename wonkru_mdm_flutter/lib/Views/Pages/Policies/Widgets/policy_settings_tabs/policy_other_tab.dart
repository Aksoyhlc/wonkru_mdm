import '../../../../../Core/Constants/Enums/policy_enums.dart';
import '../policy_field_spec.dart';

const PolicySettingsTabSpec policyOtherTab = PolicySettingsTabSpec(
  title: 'policies.tab_other',
  groups: [
    PolicyFieldGroupSpec(
      title: 'Bluetooth',
      fields: [
        PolicyFieldSpec(
          path: 'restriction_settings.no_config_bluetooth',
          label: 'policies.field_no_config_bluetooth',
          type: PolicyFieldType.restrictionShortcut,
          helper: 'policies.helper_no_config_bluetooth',
        ),
        PolicyFieldSpec(
          path: 'restriction_settings.no_bluetooth',
          label: 'policies.field_no_bluetooth',
          type: PolicyFieldType.restrictionShortcut,
          helper: 'policies.helper_no_bluetooth',
        ),
        PolicyFieldSpec(
          path: 'restriction_settings.no_bluetooth_sharing',
          label: 'policies.field_no_bluetooth_sharing',
          type: PolicyFieldType.restrictionShortcut,
          helper: 'policies.helper_no_bluetooth_sharing',
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_datetime_settings',
      fields: [
        PolicyFieldSpec(
          path: 'other_settings.auto_time',
          label: 'policies.field_auto_time',
          type: PolicyFieldType.triState,
        ),
        PolicyFieldSpec(
          path: 'other_settings.auto_time_zone',
          label: 'policies.field_auto_time_zone',
          type: PolicyFieldType.triState,
        ),
        PolicyFieldSpec(
          path: 'other_settings.time_zone',
          label: 'policies.field_time_zone',
          type: PolicyFieldType.timeZone,
        ),
        PolicyFieldSpec(
          path: 'other_settings.time_12_24',
          label: 'policies.field_time_format',
          type: PolicyFieldType.select,
          options: <String, String>{
            '12': 'policies.option_hours_12',
            '24': 'policies.option_hours_24',
          },
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'common.security',
      fields: [
        PolicyFieldSpec(
          path: 'restriction_settings.no_physical_media',
          label: 'policies.field_no_physical_media',
          type: PolicyFieldType.restrictionShortcut,
          helper: 'policies.helper_no_physical_media',
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_hardware',
      fields: [
        PolicyFieldSpec(
          path: 'restriction_settings.no_camera',
          label: 'policies.field_no_camera',
          type: PolicyFieldType.restrictionShortcut,
          helper: 'policies.helper_no_camera',
        ),
        PolicyFieldSpec(
          path: 'other_settings.required_wifi',
          label: 'policies.field_required_wifi',
          type: PolicyFieldType.toggle,
        ),
      ],
    ),
  ],
);
