import '../../../../../Core/Constants/Enums/policy_enums.dart';
import '../policy_field_spec.dart';

const PolicySettingsTabSpec policyDisplayTab = PolicySettingsTabSpec(
  title: 'policies.tab_display',
  groups: [
    PolicyFieldGroupSpec(
      title: 'policies.group_screen_lock',
      fields: [
        PolicyFieldSpec(
          path: 'display_settings.lock_screen_message',
          label: 'policies.field_lock_screen_message',
          type: PolicyFieldType.textarea,
          helper: 'policies.helper_lock_screen_message',
        ),
        PolicyFieldSpec(
          path: 'display_settings.screen_capture_policy',
          label: 'policies.field_screen_capture_policy',
          type: PolicyFieldType.triState,
          helper: 'policies.helper_screen_capture_policy',
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_timeout',
      fields: [
        PolicyFieldSpec(
          path: 'display_settings.screen_timeout_ms',
          label: 'policies.field_screen_timeout',
          type: PolicyFieldType.number,
          min: 0,
          helper: 'policies.helper_screen_timeout',
        ),
        PolicyFieldSpec(
          path: 'display_settings.screen_timeout_config_restriction',
          label: 'policies.field_timeout_lock',
          type: PolicyFieldType.triStateBool,
          helper: 'policies.helper_timeout_lock',
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_brightness',
      fields: [
        PolicyFieldSpec(
          path: 'display_settings.brightness_config_restriction',
          label: 'policies.field_brightness_lock',
          type: PolicyFieldType.triStateBool,
          helper: 'policies.helper_brightness_lock',
        ),
        PolicyFieldSpec(
          path: 'display_settings.brightness_level',
          label: 'policies.field_brightness_level',
          type: PolicyFieldType.slider,
          min: 1,
          max: 100,
          defaultValue: 50,
        ),
        PolicyFieldSpec(
          path: 'display_settings.min_brightness',
          label: 'policies.field_min_brightness',
          type: PolicyFieldType.slider,
          min: 1,
          max: 100,
          defaultValue: 1,
          notAbovePath: 'display_settings.max_brightness',
        ),
        PolicyFieldSpec(
          path: 'display_settings.max_brightness',
          label: 'policies.field_max_brightness',
          type: PolicyFieldType.slider,
          min: 1,
          max: 100,
          defaultValue: 100,
        ),
        PolicyFieldSpec(
          path: 'display_settings.auto_brightness_policy',
          label: 'policies.field_auto_brightness_policy',
          type: PolicyFieldType.triState,
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_rotation',
      fields: [
        PolicyFieldSpec(
          path: 'display_settings.rotation_policy',
          label: 'policies.field_rotation_policy',
          type: PolicyFieldType.select,
          options: <String, String>{
            '0': 'policies.option_free',
            '1': 'policies.option_locked',
            '2': 'policies.option_system_default',
          },
        ),
        PolicyFieldSpec(
          path: 'display_settings.locked_orientation',
          label: 'policies.field_locked_orientation',
          type: PolicyFieldType.select,
          options: <String, String>{
            '0': 'policies.option_portrait',
            '1': 'policies.option_landscape',
            '2': 'policies.option_portrait_reverse',
            '3': 'policies.option_landscape_reverse',
            '-1': 'policies.option_auto',
          },
          helper: 'policies.helper_locked_orientation',
        ),
      ],
    ),
  ],
);
