import 'package:serverpod/serverpod.dart';

/// The panel's runtime configuration, served at `/assets/assets/config.json`.
class AppConfigWidget extends JsonWidget {
  AppConfigWidget({required this.apiUrl}) : super(object: {'apiUrl': apiUrl});

  final String apiUrl;
}
