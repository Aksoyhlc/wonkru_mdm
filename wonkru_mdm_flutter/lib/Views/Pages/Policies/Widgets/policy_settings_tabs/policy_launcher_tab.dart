import '../../../../../Core/Constants/Enums/policy_enums.dart';
import '../policy_field_spec.dart';

const PolicySettingsTabSpec policyLauncherTab = PolicySettingsTabSpec(
  title: 'Launcher',
  groups: [
    PolicyFieldGroupSpec(
      title: 'policies.group_launcher_mode',
      fields: [
        PolicyFieldSpec(
          path: 'launcher.mode',
          label: 'policies.field_launcher_mode_enabled',
          type: PolicyFieldType.toggle,
          helper: 'policies.helper_launcher_mode',
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_grid',
      fields: [
        PolicyFieldSpec(
          path: 'launcher.design.columns',
          label: 'policies.field_grid_columns',
          type: PolicyFieldType.number,
          min: 1,
          max: 6,
          helper: 'policies.helper_grid_columns',
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_background',
      fields: [
        PolicyFieldSpec(
          path: 'launcher.design.background.type',
          label: 'policies.field_background_type',
          type: PolicyFieldType.select,
          options: <String, String>{
            'color': 'policies.option_color',
            'image': 'policies.option_image',
          },
        ),
        PolicyFieldSpec(
          path: 'launcher.design.background.color',
          label: 'policies.field_background_color',
          type: PolicyFieldType.color,
          helper: 'policies.helper_background_color',
          visibleWhenPath: 'launcher.design.background.type',
          visibleWhenValue: 'color',
        ),
        PolicyFieldSpec(
          path: 'launcher.design.background.image',
          label: 'policies.field_background_image',
          type: PolicyFieldType.fileUpload,
          purpose: 'launcherBackground',
          options: <String, String>{
            'png': 'PNG',
            'jpg': 'JPG',
            'jpeg': 'JPEG',
            'webp': 'WebP',
          },
          helper: 'policies.helper_background_image',
          visibleWhenPath: 'launcher.design.background.type',
          visibleWhenValue: 'image',
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_app_display',
      fields: [
        PolicyFieldSpec(
          path: 'launcher.design.item_display.icon_size',
          label: 'policies.field_icon_size',
          type: PolicyFieldType.select,
          options: <String, String>{
            'small': 'policies.option_small',
            'medium': 'policies.option_medium',
            'large': 'policies.option_large',
          },
        ),
        PolicyFieldSpec(
          path: 'launcher.design.item_display.show_label',
          label: 'policies.field_show_label',
          type: PolicyFieldType.toggle,
        ),
        PolicyFieldSpec(
          path: 'launcher.design.item_display.label_color',
          label: 'policies.field_label_color',
          type: PolicyFieldType.color,
          helper: 'policies.helper_label_color',
        ),
        PolicyFieldSpec(
          path: 'launcher.design.item_display.background_color',
          label: 'policies.field_item_background_color',
          type: PolicyFieldType.color,
          helper: 'policies.helper_item_background_color',
        ),
        PolicyFieldSpec(
          path: 'launcher.design.item_display.border_radius',
          label: 'policies.field_border_radius',
          type: PolicyFieldType.number,
          min: 0,
        ),
        PolicyFieldSpec(
          path: 'launcher.design.item_display.label_font_size',
          label: 'policies.field_label_font_size',
          type: PolicyFieldType.number,
          min: 0,
          allowDecimal: true,
        ),
        PolicyFieldSpec(
          path: 'launcher.design.item_display.long_press_settings_open',
          label: 'policies.field_long_press_settings',
          type: PolicyFieldType.toggle,
        ),
      ],
    ),
    PolicyFieldGroupSpec(
      title: 'policies.group_header_widgets',
      fields: [
        PolicyFieldSpec(
          path: 'launcher.header_widgets.left',
          label: 'policies.field_header_left',
          type: PolicyFieldType.toggle,
        ),
        PolicyFieldSpec(
          path: 'launcher.header_widgets.center',
          label: 'policies.field_header_center',
          type: PolicyFieldType.toggle,
        ),
        PolicyFieldSpec(
          path: 'launcher.header_widgets.right',
          label: 'policies.field_header_right',
          type: PolicyFieldType.toggle,
        ),
      ],
    ),
  ],
);
