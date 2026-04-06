import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/features/auth/login/bloc/login_state.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_event.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_state.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_bloc.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_event.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_state.dart';
import 'features/dashboard/home/domain/bloc/home_bloc.dart';
import 'main_barrels.dart';

void main() async {
  /// Widgets binding
  WidgetsFlutterBinding.ensureInitialized();

  await AuthGuard.initialize();

  /// Orientation lock
  SystemUtils.setPortraitOnly();

  /// System UI
  SystemUtils.setStatusBar(
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light,
  );

  /// Environment setup
  EnvConfig.init(AppEnvironment.dev);

  /// Dependency injection
  await setupServices();

  /// App
  runApp(const DripTalk());
}

class DripTalk extends StatelessWidget {
  const DripTalk({super.key});

  @override
  Widget build(BuildContext context) {
    /// Multi bloc provider
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationBloc>(
          create: (context) => getIt<LocalizationBloc>(),
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (context) => getIt<ResetPasswordBloc>(),
        ),
        BlocProvider<SignUpBloc>(create: (context) => getIt<SignUpBloc>()),
        BlocProvider<OtpBloc>(create: (context) => getIt<OtpBloc>()),
        BlocProvider<LoginBloc>(create: (context) => getIt<LoginBloc>()),
        BlocProvider<ForgotPasswordBloc>(
          create: (context) => getIt<ForgotPasswordBloc>(),
        ),
        BlocProvider<HomeBloc>(create: (context) => getIt<HomeBloc>()),
        BlocProvider<CartBloc>(
          create: (context) =>
              getIt<CartBloc>()
                ..add(const LoadCart(showLoader: false, silent: true)),
        ),
        BlocProvider<WishlistBloc>(
          create: (context) {
            final bloc = getIt<WishlistBloc>();
            if (AuthGuard.isLoggedIn.value) {
              bloc.add(const LoadWishlist(showLoader: false, silent: true));
            }
            return bloc;
          },
        ),
      ],

      /// Builder
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, localizationState) {
          /// App material router
          return MaterialApp.router(
            theme: ThemeData(scaffoldBackgroundColor: AppColors.transparent),
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
                          state is LoginVerificationRequired) {
                        context.read<CartBloc>().add(const ClearCartSession());
                        context.read<WishlistBloc>().add(
                          const ClearWishlistSession(),
                        );
                      }
                    },
                  ),
                  BlocListener<CartBloc, CartState>(
                    listenWhen: (previous, current) =>
                        previous.feedbackMessage != current.feedbackMessage &&
                        current.feedbackMessage != null,
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
                    listenWhen: (previous, current) =>
                        previous.feedbackMessage != current.feedbackMessage &&
                        current.feedbackMessage != null,
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
