import '../../../../../Core/Constants/Enums/policy_enums.dart';
import '../policy_field_spec.dart';

const PolicySettingsTabSpec policySecurityTab = PolicySettingsTabSpec(
  title: 'common.security',
  groups: [
    PolicyFieldGroupSpec(
      title: 'policies.group_password_policy',
      fields: [
        PolicyFieldSpec(
          path: 'security_settings.password_policy.complexity_level',
          label: 'policies.field_complexity_level',
          type: PolicyFieldType.select,
          options: <String, String>{
            '0': 'policies.option_custom',
            '1': 'policies.option_low',
            '2': 'policies.option_medium',
            '3': 'policies.option_high',
          },
        ),
        PolicyFieldSpec(
          path: 'security_settings.password_policy.quality',
          label: 'policies.field_password_quality',
          type: PolicyFieldType.select,
          options: <String, String>{
            '0': 'policies.option_unspecified',
            '131072': 'policies.option_numeric',
            '262144': 'policies.option_alpha',
            '327680': 'policies.option_alphanumeric',
            '393216': 'policies.option_complex',
          },
        ),
        ..._passwordNumberFields,
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_keyguard',
      fields: [
        PolicyFieldSpec(
          path: 'security_settings.keyguard.disable_lock_screen_camera',
          label: 'policies.field_disable_lock_screen_camera',
          type: PolicyFieldType.triStateBool,
        ),
        PolicyFieldSpec(
          path: 'security_settings.keyguard.hide_notification_content',
          label: 'policies.field_hide_notification_content',
          type: PolicyFieldType.triStateBool,
        ),
        PolicyFieldSpec(
          path: 'security_settings.keyguard.disable_fingerprint',
          label: 'policies.field_disable_fingerprint',
          type: PolicyFieldType.triStateBool,
        ),
        PolicyFieldSpec(
          path: 'security_settings.keyguard.disable_face_unlock',
          label: 'policies.field_disable_face_unlock',
          type: PolicyFieldType.triStateBool,
        ),
        PolicyFieldSpec(
          path: 'security_settings.keyguard.disable_iris',
          label: 'policies.field_disable_iris',
          type: PolicyFieldType.triStateBool,
        ),
        PolicyFieldSpec(
          path: 'security_settings.keyguard.disable_all_biometrics',
          label: 'policies.field_disable_all_biometrics',
          type: PolicyFieldType.triStateBool,
        ),
        PolicyFieldSpec(
          path: 'security_settings.keyguard.disable_smart_lock',
          label: 'policies.field_disable_smart_lock',
          type: PolicyFieldType.triStateBool,
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_accessibility',
      fields: [
        PolicyFieldSpec(
          path: 'security_settings.allowed_accessibility_apps',
          label: 'policies.field_allowed_accessibility_apps',
          type: PolicyFieldType.tags,
          helper: 'policies.helper_allowed_accessibility_apps',
        ),
      ],
    ),
  ],
);

const List<PolicyFieldSpec> _passwordNumberFields = <PolicyFieldSpec>[
  PolicyFieldSpec(
    path: 'security_settings.password_policy.min_length',
    label: 'policies.field_min_length',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.min_upper_case',
    label: 'policies.field_min_upper_case',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.min_lower_case',
    label: 'policies.field_min_lower_case',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.min_letters',
    label: 'policies.field_min_letters',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.min_numeric',
    label: 'policies.field_min_numeric',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.min_symbols',
    label: 'policies.field_min_symbols',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.min_non_letter',
    label: 'policies.field_min_non_letter',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.history_length',
    label: 'policies.field_history_length',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.expiration_timeout_ms',
    label: 'policies.field_password_expiration',
    type: PolicyFieldType.number,
    min: 0,
  ),
  PolicyFieldSpec(
    path: 'security_settings.password_policy.max_failed_attempts',
    label: 'policies.field_max_failed_attempts',
    type: PolicyFieldType.number,
    min: 0,
  ),
];
