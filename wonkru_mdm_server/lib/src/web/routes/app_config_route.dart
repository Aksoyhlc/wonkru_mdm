import 'package:serverpod/serverpod.dart';

import '../widgets/app_config_widget.dart';

class AppConfigRoute extends WidgetRoute {
  AppConfigWidget widget;

  AppConfigRoute({
    required final ServerConfig apiConfig,
  }) : widget = AppConfigWidget(apiUrl: apiConfig.apiUrl.toString());

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return widget;
  }
}

extension on ServerConfig {
  Uri get apiUrl => Uri(
    scheme: publicScheme,
    host: publicHost,
    port: publicPort,
  );
}
