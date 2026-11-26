import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'Core/L10n/Language.dart';
import 'Core/Router/app_router.dart';
import 'Core/Theme/app_theme.dart';
import 'Core/Theme/shad_theme.dart';
import 'Logic/Controllers/locale_controller.dart';
import 'Logic/Controllers/theme_controller.dart';
import 'Views/Widgets/Alert/app_toast_overlay.dart';
import 'Views/Widgets/Layout/app_scaler.dart';

class WonkruApp extends StatefulWidget {
  const WonkruApp({super.key, this.home, this.initialLocation});
  final Widget? home;

  final String? initialLocation;

  @override
  State<WonkruApp> createState() => _WonkruAppState();
}

class _WonkruAppState extends State<WonkruApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    if (widget.home == null) {
      _router = createAppRouter(
        initialLocation: widget.initialLocation ?? '/',
      );
    }
  }

  @override
  void dispose() {
    _router?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

    return Obx(() {
      final mode = theme.mode.value;
      final locale = localeController.locale.value;
      return ShadApp.custom(
        themeMode: mode,
        theme: ShadThemeBuilder.light(),
        darkTheme: ShadThemeBuilder.dark(),
        appBuilder: (context) => _app(mode, locale),
      );
    });
  }

  Widget _app(ThemeMode mode, Locale locale) {
    final router = _router;
    if (router == null) {
      return GetMaterialApp(
        title: 'Wonkru MDM',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        translations: AppTranslations(),
        locale: locale,
        fallbackLocale: AppTranslations.fallbackLocale,
        supportedLocales: AppTranslations.supportedLocales,
        localizationsDelegates: AppTranslations.localizationsDelegates,
        home: widget.home,
        builder: _overlayBuilder,
      );
    }

    return GetMaterialApp.router(
      title: 'Wonkru MDM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: AppTranslations.fallbackLocale,
      supportedLocales: AppTranslations.supportedLocales,
      localizationsDelegates: AppTranslations.localizationsDelegates,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      backButtonDispatcher: router.backButtonDispatcher,
      builder: _overlayBuilder,
    );
  }

  /// [AppScaler] holds the navigation stack and toasts; dialogs and popup menus
  /// open in the Navigator's layer and pick up the same scale.
  Widget _overlayBuilder(BuildContext context, Widget? child) => ShadAppBuilder(
    child: Obx(
      () => AppScaler(
        scale: Get.find<ThemeController>().scale.value,
        child: Stack(
          children: [
            ?child,
            const AppToastOverlay(),
          ],
        ),
      ),
    ),
  );
}
