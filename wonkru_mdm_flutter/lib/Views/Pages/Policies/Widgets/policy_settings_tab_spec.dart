import 'policy_field_group.dart';

class PolicySettingsTabSpec {
  const PolicySettingsTabSpec({
    required this.title,
    required this.groups,
    this.id,
  });

  final String title;

  final List<PolicyFieldGroupSpec> groups;

  final String? id;
}
