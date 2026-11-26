extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty || this == "null" || this == "NULL";

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  String get toDateTime {
    var a = DateTime.tryParse(this ?? "");
    if (a == null) {
      return "";
    }
    return a.toString().split(".").first;
  }
}
