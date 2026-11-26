import '../../../../Core/Constants/Enums/policy_enums.dart';

/// [path] is a dotted path **inside** its settings column; its first segment
/// is the snake_case column prefix (e.g. `sync_settings.full_sync_cron`).
/// The column mapping is the const table in `policy_settings_codec.dart`.
class PolicyFieldSpec {
  const PolicyFieldSpec({
    required this.path,
    required this.label,
    this.type = PolicyFieldType.text,
    this.options,
    this.helper,
    this.min,
    this.max,
    this.allowDecimal = false,
    this.defaultValue,
    this.purpose,
    this.visibleWhenPath,
    this.visibleWhenValue,
    this.notAbovePath,
    this.fullWidth = false,
  });

  final String path;

  final String label;

  final PolicyFieldType type;

  /// For `select`: value → label. For `fileUpload`: accepted extensions as
  /// keys (e.g. `{'png': 'PNG'}`).
  final Map<String, String>? options;

  final String? helper;

  final num? min;

  final num? max;

  final bool allowDecimal;

  final num? defaultValue;

  final String? purpose;

  /// When `policy.<visibleWhenPath>` equals [visibleWhenValue] the field is
  /// shown; otherwise it is hidden. `null` means always visible.
  final String? visibleWhenPath;

  final String? visibleWhenValue;

  /// This field's value may not exceed `policy.<notAbovePath>` (e.g.
  /// `min_brightness` ≤ `max_brightness`). Saving enforces this too.
  final String? notAbovePath;

  final bool fullWidth;
}
