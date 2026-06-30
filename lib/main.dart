import 'package:flutter/services.dart';
import 'main_barrels.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemUtils.setPortraitOnly();

  SystemUtils.setStatusBar(
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light,
  );

  EnvConfig.init(AppEnvironment.dev);

  await setupServices();

  runApp(const DripTalk());
}

class DripTalk extends StatelessWidget {
  const DripTalk({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ── Responsive ─────────────────────────────────────────────────────
        BlocProvider<ResponsiveBloc>(create: (_) => ResponsiveBloc()),
        // ── Localisation ───────────────────────────────────────────────────
        BlocProvider<LocalizationBloc>(
          create: (_) => getIt<LocalizationBloc>(),
        ),
        // ── Auth ───────────────────────────────────────────────────────────
        BlocProvider<ResetPasswordBloc>(
          create: (_) => getIt<ResetPasswordBloc>(),
        ),
        BlocProvider<SignUpBloc>(create: (_) => getIt<SignUpBloc>()),
        BlocProvider<OtpBloc>(create: (_) => getIt<OtpBloc>()),
        BlocProvider<LoginBloc>(create: (_) => getIt<LoginBloc>()),
        BlocProvider<ForgotPasswordBloc>(
          create: (_) => getIt<ForgotPasswordBloc>(),
        ),

        // ── Dashboard ──────────────────────────────────────────────────────
        BlocProvider<HomeBloc>(create: (_) => getIt<HomeBloc>()),
        BlocProvider<CartBloc>(create: (_) => getIt<CartBloc>()),
        BlocProvider<WishlistBloc>(create: (_) => getIt<WishlistBloc>()),
      ],
      child: const _DripTalkBootstrap(),
    );
  }
}

class _DripTalkBootstrap extends StatefulWidget {
  const _DripTalkBootstrap();

  @override
  State<_DripTalkBootstrap> createState() => _DripTalkBootstrapState();
}

class _DripTalkBootstrapState extends State<_DripTalkBootstrap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrapStartupSession();
    });
  }

  Future<void> _bootstrapStartupSession() async {
    await restoreStartupAuthSession();
    await AuthGuard.initialize();
    if (!mounted ||
        !AuthGuard.isLoggedIn.value ||
        AuthGuard.isProfileSetupRequired.value ||
        AuthGuard.isRecommendationsFlowRequired.value) {
      return;
    }

    context.read<CartBloc>().add(
      const LoadCart(showLoader: false, silent: true),
    );
    context.read<WishlistBloc>().add(
      const LoadWishlist(showLoader: false, silent: true),
    );
  }

  /// Unlocks landscape for tablet/desktop, locks portrait for mobile.
  void _applyOrientation(DeviceType deviceType) {
    if (deviceType.isAtLeastTablet) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } else {
      SystemUtils.setPortraitOnly();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResponsiveBloc, ResponsiveState>(
      listenWhen: (prev, curr) => prev.deviceType != curr.deviceType,
      listener: (_, state) => _applyOrientation(state.deviceType),
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, localizationState) {
          final isArabic = localizationState.locale.languageCode == 'ar';

          return MaterialApp.router(
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.transparent,
              fontFamily: isArabic ? 'Tajawal' : 'RedHatDisplay',
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            supportedLocales: L10n.all,
            locale: localizationState.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        context.read<CartBloc>().add(
                          const LoadCart(showLoader: false, silent: true),
                        );
                        context.read<WishlistBloc>().add(
                          const LoadWishlist(showLoader: false, silent: true),
                        );
                      } else if (state is LogoutSuccess ||
                          state is DeleteAccountSuccess ||
                          state is LoginVerificationRequired ||
                          state is LoginTwoFactorRequired) {
                        context.read<CartBloc>().add(const ClearCartSession());
                        context.read<WishlistBloc>().add(
                          const ClearWishlistSession(),
                        );
                      }
                    },
                  ),
                  BlocListener<CartBloc, CartState>(
                    listenWhen: (prev, curr) =>
                        prev.feedbackMessage != curr.feedbackMessage &&
                        curr.feedbackMessage != null,
                    listener: (context, state) {
                      final message = state.feedbackMessage;
                      if (message == null || message.trim().isEmpty) {
                        return;
                      }
                      final toastType = switch (state.feedbackType) {
                        CartFeedbackType.success => ToastType.success,
                        CartFeedbackType.error => ToastType.error,
                        CartFeedbackType.info => ToastType.info,
                      };
                      ToastUtils.show(context, message, type: toastType);
                      context.read<CartBloc>().add(const ClearCartFeedback());
                    },
                  ),
                  BlocListener<WishlistBloc, WishlistState>(
                    listenWhen: (prev, curr) =>
                        prev.feedbackMessage != curr.feedbackMessage &&
                        curr.feedbackMessage != null,
                    listener: (context, state) {
                      final message = state.feedbackMessage;
                      if (message == null || message.trim().isEmpty) {
                        return;
                      }
                      final toastType = switch (state.feedbackType) {
                        WishlistFeedbackType.success => ToastType.success,
                        WishlistFeedbackType.error => ToastType.error,
                        WishlistFeedbackType.info => ToastType.info,
                      };
                      ToastUtils.show(context, message, type: toastType);
                      context.read<WishlistBloc>().add(
                        const ClearWishlistFeedback(),
                      );
                    },
                  ),
                ],
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
