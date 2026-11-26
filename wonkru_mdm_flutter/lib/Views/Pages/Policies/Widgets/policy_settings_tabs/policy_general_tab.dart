import '../../../../../Core/Constants/Enums/policy_enums.dart';
import '../policy_field_spec.dart';

const PolicySettingsTabSpec policyGeneralTab = PolicySettingsTabSpec(
  title: 'common.general',
  groups: [
    PolicyFieldGroupSpec(
      title: 'policies.group_active_time_ranges',
      fields: [
        PolicyFieldSpec(
          path: 'active_time_ranges',
          label: 'policies.field_active_time_ranges',
          type: PolicyFieldType.timeRanges,
          helper: 'policies.helper_active_time_ranges',
          fullWidth: true,
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_sync_settings',
      fields: [
        PolicyFieldSpec(
          path: 'sync_settings.full_sync_cron',
          label: 'policies.field_full_sync_cron',
          helper: 'policies.helper_full_sync_cron',
        ),
        PolicyFieldSpec(
          path: 'sync_settings.max_interval_minutes',
          label: 'policies.field_max_interval',
          type: PolicyFieldType.number,
          min: 1,
          helper: 'policies.helper_max_interval',
        ),
      ],
    ),
  ],
);
