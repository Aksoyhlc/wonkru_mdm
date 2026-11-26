import 'package:wonkrumdm/Core/Utils/json_parse.dart';

import 'restrict_model.dart';

class RestrictPolicy {
  List<RestrictModel>? restrictions;

  RestrictPolicy({this.restrictions});

  RestrictPolicy.fromJson(Map<String, dynamic> json) {
    if (json['restrictions'] != null) {
      restrictions = JsonParse.listOf(json['restrictions'], RestrictModel.fromJson, field: 'restrictions');
    }
  }
}