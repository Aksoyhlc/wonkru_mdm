import 'policy_field.dart';

class PolicyFieldGroupSpec {
  const PolicyFieldGroupSpec({this.title, required this.fields});

  final String? title;

  final List<PolicyFieldSpec> fields;
}
