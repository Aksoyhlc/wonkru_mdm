import '../../../../../Core/Constants/Enums/policy_enums.dart';
import '../policy_field_spec.dart';

const PolicySettingsTabSpec policyStorageTab = PolicySettingsTabSpec(
  title: 'common.storage',
  groups: [
    PolicyFieldGroupSpec(
      title: 'policies.group_storage_thresholds',
      fields: [
        PolicyFieldSpec(
          path: 'storage_settings.warning_threshold',
          label: 'policies.field_warning_threshold',
          type: PolicyFieldType.number,
          min: 0,
          max: 100,
          helper: 'policies.helper_warning_threshold',
        ),
        PolicyFieldSpec(
          path: 'storage_settings.critical_threshold',
          label: 'policies.field_critical_threshold',
          type: PolicyFieldType.number,
          min: 0,
          max: 100,
          helper: 'policies.helper_critical_threshold',
        ),
      ],
    ),
  ],
);
