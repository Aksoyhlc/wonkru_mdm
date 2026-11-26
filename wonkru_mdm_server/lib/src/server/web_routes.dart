import 'dart:io';

import '../cache_busting.dart';
import '../generated/serverpod.dart';
import '../storage/local_file_cloud_storage.dart';
import '../web/routes/app_config_route.dart';
import '../web/routes/local_ca_route.dart';
import '../web/routes/storage_download_route.dart';
import '../web/routes/storage_upload_route.dart';
import '../web/storage_cors_middleware.dart';
import 'storage_setup.dart';

/// Registers every web server route, in the order the mounts must line up.
///
/// Static assets and the panel come first, then the storage routes, whose CORS
/// middleware must be in place before the browser preflights an upload.
Future<void> registerWebRoutes(Serverpod pod) async {
  // Serve all files in the web/static relative directory under /web.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/assets/assets/config.json',
  );

  // Serves the local CA (PEM) from `LOCAL_CA_PATH` (default
  // `certs/local-ca.crt`); agents download it during bootstrap.
  pod.webServer.addRoute(LocalCaRoute(), '/downloads/local-ca');

  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // The panel compiles to WASM; Skia's WASM renderer needs
        // `SharedArrayBuffer`, which requires a cross-origin isolated page. This
        // adds the required COOP/COEP headers, without which the app falls back
        // to the single-threaded renderer.
        enableWasmHeaders: true,
      ),
      '/',
    );
  } else {
    final defaultRoute = StaticRoute.file(
      File(Uri(path: 'web/pages/build_flutter_app.html').toFilePath()),
    );

    pod.webServer.addMiddleware(
      FallbackMiddleware(
        fallback: defaultRoute,
        on: (response) => response.statusCode == 404,
      ).call,
      '/',
    );

    pod.webServer.addRoute(defaultRoute, '/**');
  }

  final storage = await configureStorage(pod);

  registerStorageCors(pod.webServer.addMiddleware, pod.config.allowedOrigins);

  
  pod.webServer.addRoute(
    StorageUploadRoute(
      storages: storage.localStorages,
      signature: storage.signature,
    ),
    LocalFileCloudStorage.uploadPath,
  );
  
  pod.webServer.addRoute(
    StorageDownloadRoute(
      storages: storage.localStorages,
      signature: storage.signature,
    ),
    LocalFileCloudStorage.downloadPath,
  );
}
