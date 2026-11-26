{{flutter_js}}
{{flutter_build_config}}

const options = {};
const serviceWorkerVersion = {{flutter_service_worker_version}};

if (!window.isSecureContext) {
  // Plain HTTP uses the JavaScript build and the bundled CanvasKit files.
  options.config = {
    renderer: 'canvaskit',
    canvasKitBaseUrl: new URL('canvaskit/', document.baseURI).href,
  };
} else if (serviceWorkerVersion != null) {
  options.serviceWorkerSettings = { serviceWorkerVersion };
}

_flutter.loader.load(options);
