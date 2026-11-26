import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/auth_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/auth_controller.dart';
import '../../../Logic/Controllers/theme_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Brand/app_logo.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Input/custom_text_field.dart';
import '../../Widgets/Input/text_controllers_owner.dart';
import '../../Widgets/Motion/fade_switcher.dart';
import '../../Widgets/Motion/shake_on_signal.dart';
import 'Widgets/auth_backdrop.dart';
import 'Widgets/auth_card.dart';
import 'Widgets/two_factor_form.dart';

/// Sign-in only; there is no sign-up. The admin account is seeded server-side.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TextControllersOwner<LoginPage> {
  late final _emailController = textController();
  late final _passwordController = textController();
  final _passwordFocus = FocusNode();
  late final _setupEmailController = textController();
  late final _setupPasswordController = textController();
  bool _loading = false;
  bool _setupBusy = false;
  int _failCount = 0;

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submitSetup() async {
    if (_setupBusy) return;

    final email = _setupEmailController.text.trim();
    final password = _setupPasswordController.text;

    if (email.isEmpty || !email.contains('@') || password.isEmpty) {
      AppToast.show(L.common.emailPasswordRequired, tone: UiAlertTone.warning);
      return;
    }

    setState(() => _setupBusy = true);
    final ok = await Get.find<AuthController>().bootstrap(email, password);
    if (!mounted) return;
    setState(() => _setupBusy = false);
    if (!ok) {
      AppToast.show(L.common.forbidden, tone: UiAlertTone.danger);
    }
  }

  Future<void> _submit() async {
    if (_loading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      AppToast.show(L.common.emailPasswordRequired, tone: UiAlertTone.warning);
      return;
    }

    setState(() => _loading = true);
    final ok = await Get.find<AuthController>().signIn(email, password);
    // Password managers only offer to save once the autofill context closes,
    // so close it after a successful sign-in to avoid saving rejected input.
    if (ok) TextInput.finishAutofillContext();
    if (mounted) {
      setState(() {
        _loading = false;
        if (!ok) _failCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: AuthBackdrop(
        child: Stack(
          children: [
            const Positioned(
              top: AppSpacing.s24,
              right: AppSpacing.s24,
              child: _ThemeToggle(),
            ),
            Center(
              child: SingleChildScrollView(
                padding: AppInsets.all24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShakeOnSignal(
                      signal: _failCount,
                      child: AuthCard(
                        child: Obx(() {
                          final auth = Get.find<AuthController>();
                          return AnimatedSize(
                            duration: AppMotion.of(context, AppMotion.base),
                            curve: AppMotion.enter,
                            alignment: Alignment.topCenter,
                            child: FadeSwitcher(
                              child: auth.needsBootstrap.value
                                  ? _SetupForm(
                                      key: const ValueKey('setup'),
                                      email: _setupEmailController,
                                      password: _setupPasswordController,
                                      busy: _setupBusy,
                                      onSubmit: _submitSetup,
                                    )
                                  : (auth.status.value ==
                                            AuthStatus.awaitingTwoFactor
                                        ? TwoFactorForm(
                                            key: const ValueKey('two-factor'),
                                            onFailure: () {
                                              if (mounted) {
                                                setState(() => _failCount++);
                                              }
                                            },
                                          )
                                        : KeyedSubtree(
                                            key: const ValueKey('credentials'),
                                            child: _credentialsForm(),
                                          )),
                            ),
                          );
                        }),
                      ),
                    ),
                    AppGap.v24,
                    Text(
                      L.common.appTitle,
                      style: AppText.caption(
                        context,
                      ).copyWith(color: colors.graphite),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Both fields share one autofill context so password managers can pair them.
  Widget _credentialsForm() {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: AppLogo(height: 34)),
          AppGap.v24,
          Text(
            L.common.signInTitle,
            textAlign: TextAlign.center,
            style: AppText.pageTitle(
              context,
            ).copyWith(fontSize: 22, letterSpacing: -0.3),
          ),
          AppGap.v6,
          Text(
            L.common.signInSubtitle,
            textAlign: TextAlign.center,
            style: AppText.bodyMuted(context),
          ),
          AppGap.v32,
          CustomTextField(
            name: 'login_email',
            controller: _emailController,
            label: L.common.email,
            hint: L.common.emailHint,
            enabled: !_loading,
            // Web autofill can anchor before the card entrance settles.
            autofocus: !kIsWeb,
            prefixIcon: LucideIcons.mail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
            onSubmitted: (_) => _passwordFocus.requestFocus(),
          ),
          AppGap.v16,
          CustomTextField(
            name: 'login_password',
            controller: _passwordController,
            focusNode: _passwordFocus,
            label: L.common.password,
            enabled: !_loading,
            obscureText: true,
            prefixIcon: LucideIcons.lock,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) => _submit(),
          ),
          AppGap.v24,
          AppButton(
            label: L.common.signIn,
            expand: true,
            loading: _loading,
            onPressed: _loading ? null : _submit,
          ),
        ],
      ),
    );
  }
}

/// The login screen has no top bar, so this is the only light/dark toggle.
class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppIconButton(
      icon: isDark ? LucideIcons.sun : LucideIcons.moon,
      tooltip: isDark ? L.common.themeSwitchLight : L.common.themeSwitchDark,
      onPressed: theme.toggle,
    );
  }
}

/// Shown only while the server has no admin; the normal sign-in form replaces
/// it once setup completes.
class _SetupForm extends StatelessWidget {
  const _SetupForm({
    super.key,
    required this.email,
    required this.password,
    required this.busy,
    required this.onSubmit,
  });

  final TextEditingController email;
  final TextEditingController password;
  final bool busy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: AppLogo(height: 34)),
          AppGap.v24,
          Text(
            L.common.setupTitle,
            textAlign: TextAlign.center,
            style: AppText.pageTitle(
              context,
            ).copyWith(fontSize: 22, letterSpacing: -0.3),
          ),
          AppGap.v6,
          Text(
            L.common.setupSubtitle,
            textAlign: TextAlign.center,
            style: AppText.bodyMuted(context),
          ),
          AppGap.v32,
          CustomTextField(
            name: 'setup_email',
            controller: email,
            label: L.common.email,
            hint: L.common.emailHint,
            enabled: !busy,
            // Web autofill can anchor before the card entrance settles.
            autofocus: !kIsWeb,
            prefixIcon: LucideIcons.mail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
          ),
          AppGap.v16,
          CustomTextField(
            name: 'setup_password',
            controller: password,
            label: L.common.password,
            enabled: !busy,
            obscureText: true,
            prefixIcon: LucideIcons.lock,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
          ),
          AppGap.v24,
          AppButton(
            label: L.common.setupSubmit,
            expand: true,
            loading: busy,
            onPressed: busy ? null : onSubmit,
          ),
        ],
      ),
    );
  }
}
