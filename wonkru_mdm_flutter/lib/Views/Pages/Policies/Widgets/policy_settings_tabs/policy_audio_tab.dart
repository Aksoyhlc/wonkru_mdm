import '../../../../../Core/Constants/Enums/policy_enums.dart';
import '../policy_field_spec.dart';

const PolicySettingsTabSpec policyAudioTab = PolicySettingsTabSpec(
  title: 'policies.tab_audio',
  groups: [
    PolicyFieldGroupSpec(
      title: 'policies.group_audio_settings',
      fields: [
        PolicyFieldSpec(
          path: 'audio_settings.fixed_volume_policy',
          label: 'policies.field_fixed_volume_policy',
          type: PolicyFieldType.toggle,
        ),
        PolicyFieldSpec(
          path: 'audio_settings.fixed_volume',
          label: 'policies.field_fixed_volume',
          type: PolicyFieldType.number,
          min: 0,
          max: 100,
        ),
        PolicyFieldSpec(
          path: 'audio_settings.min_volume',
          label: 'policies.field_min_volume',
          type: PolicyFieldType.number,
          min: 0,
          max: 100,
        ),
        PolicyFieldSpec(
          path: 'audio_settings.max_volume',
          label: 'policies.field_max_volume',
          type: PolicyFieldType.number,
          min: 0,
          max: 100,
        ),
      ],
    ),
  ],
);
