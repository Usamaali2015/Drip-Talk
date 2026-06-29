import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/features/address/data/models/address_list_model.dart';
import 'package:drip_talk/features/auth/auth_repository/password_reset_source.dart';
import 'package:drip_talk/features/address/domain/bloc/add_address_bloc.dart';
import 'package:drip_talk/features/address/domain/bloc/my_addresses_bloc.dart';
import 'package:drip_talk/features/address/domain/bloc/my_addresses_event.dart';
import 'package:drip_talk/features/chat/domain/chat_bloc.dart';
import 'package:drip_talk/features/chat/domain/chat_event.dart';
import 'package:drip_talk/features/contact_support/domain/bloc/contact_support_bloc.dart';
import 'package:drip_talk/features/contact_support/domain/bloc/contact_support_event.dart';
import 'package:drip_talk/features/auth/two_factor/data/models/login_two_factor_challenge.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_bloc.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_event.dart';
import 'package:drip_talk/features/auth/two_factor/domain/bloc/two_factor_login_bloc.dart';
import 'package:drip_talk/features/dashboard/profile/domain/bloc/edit_profile_bloc.dart';
import 'package:drip_talk/features/dashboard/profile/domain/bloc/edit_profile_event.dart';
import 'package:drip_talk/features/help_center/domain/bloc/help_center_bloc.dart';
import 'package:drip_talk/features/help_center/domain/bloc/help_center_event.dart';
import 'package:drip_talk/features/legal_pages/data/repository/legal_pages_repository.dart';
import 'package:drip_talk/features/legal_pages/domain/bloc/legal_page_bloc.dart';
import 'package:drip_talk/features/legal_pages/domain/bloc/legal_page_event.dart';
import 'package:drip_talk/features/legal_pages/legal_page_type.dart';
import 'package:drip_talk/features/payment_methods/domain/bloc/payment_methods_bloc.dart';
import 'package:drip_talk/features/payment_methods/domain/bloc/payment_methods_event.dart';
import 'package:drip_talk/features/product/domain/bloc/product_bloc.dart';
import 'package:drip_talk/features/product/domain/bloc/product_event.dart';
import 'package:drip_talk/features/product/view/product_view.dart';
import 'package:drip_talk/features/return_policy/domain/bloc/return_policy_bloc.dart';
import 'package:drip_talk/features/return_policy/domain/bloc/return_policy_event.dart';
import 'package:drip_talk/features/reviews/domain/bloc/my_reviews_bloc.dart';
import 'package:drip_talk/features/reviews/domain/bloc/my_reviews_event.dart';
import 'package:drip_talk/features/reviews/domain/bloc/product_review_bloc.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_bloc.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_event.dart';
import 'package:drip_talk/features/wardrobe/barrels/wardrobe_barrels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'routes_barrels.dart';
import 'package:drip_talk/core/common/constants/app_colors.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: AppKeys.navigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: Listenable.merge([
      AuthGuard.isLoggedIn,
      AuthGuard.isProfileSetupRequired,
      AuthGuard.isRecommendationsFlowRequired,
    ]),
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final loggedIn = AuthGuard.isLoggedIn.value;
      final profileSetupRequired = AuthGuard.isProfileSetupRequired.value;
      final recommendationsFlowRequired =
          AuthGuard.isRecommendationsFlowRequired.value;
      final String location = state.matchedLocation;
      final authRoutes = [
        RoutePaths.login,
        RoutePaths.signup,
        RoutePaths.forgotPassword,
        RoutePaths.otp,
        RoutePaths.twoFactorLogin,
        RoutePaths.onboarding,
        RoutePaths.splash,
        RoutePaths.resetPassword,
      ];

      final isAuthRoute = authRoutes.contains(state.matchedLocation);

      if (!loggedIn && !isAuthRoute) {
        return RoutePaths.onboarding;
      }

      if (loggedIn &&
          profileSetupRequired &&
          location != RoutePaths.profileSetup) {
        return RoutePaths.profileSetup;
      }

      if (loggedIn &&
          !profileSetupRequired &&
          recommendationsFlowRequired &&
          location != RoutePaths.chat &&
          location != RoutePaths.profileSetup) {
        return RoutePaths.chat;
      }

      if (loggedIn &&
          (location == RoutePaths.login ||
              location == RoutePaths.onboarding ||
              location == RoutePaths.splash)) {
        // ── Redirect to Wardrobe screen (Milestone 1)
        // TODO: Change to RoutePaths.home in milestone 2 when Home is unhidden
        return RoutePaths.wardrobes;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) =>
            _buildPageTransition(child: const SplashView(), state: state),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            _buildPageTransition(child: const OnBoardingView(), state: state),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: AppRoutes.login,
        pageBuilder: (context, state) => _buildPageTransition(
          child: LoginView(
            initialMessage: state.uri.queryParameters['message'],
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: AppRoutes.signup,
        pageBuilder: (context, state) =>
            _buildPageTransition(child: const SignUpView(), state: state),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: AppRoutes.forgotPassword,
        pageBuilder: (context, state) => _buildPageTransition(
          child: ForgotPasswordView(
            initialEmail: state.uri.queryParameters['email'],
            source: passwordResetSourceFromQuery(
              state.uri.queryParameters['source'],
            ),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.otp,
        name: AppRoutes.otp,
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final type = state.uri.queryParameters['type'] ?? 'signup';
          final source = passwordResetSourceFromQuery(
            state.uri.queryParameters['source'],
          );
          return _buildPageTransition(
            child: OtpVerificationView(
              email: email,
              type: type,
              source: source,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.twoFactorLogin,
        name: AppRoutes.twoFactorLogin,
        pageBuilder: (context, state) {
          final challenge = state.extra is LoginTwoFactorChallenge
              ? state.extra as LoginTwoFactorChallenge
              : null;

          final child = challenge == null
              ? const LoginView()
              : BlocProvider<TwoFactorLoginBloc>(
                  create: (_) => getIt<TwoFactorLoginBloc>(),
                  child: TwoFactorLoginView(challenge: challenge),
                );

          return _buildPageTransition(child: child, state: state);
        },
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        name: AppRoutes.resetPassword,
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final resetToken = state.uri.queryParameters['reset_token'] ?? '';
          final source = passwordResetSourceFromQuery(
            state.uri.queryParameters['source'],
          );
          return _buildPageTransition(
            child: ResetPasswordView(
              email: email,
              resetToken: resetToken,
              source: source,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.profileSetup,
        name: AppRoutes.profileSetup,
        pageBuilder: (context, state) {
          final isEditMode = state.extra == true;
          return _buildPageTransition(
            child: BlocProvider<ProfileSetupBloc>(
              create: (_) =>
                  getIt<ProfileSetupBloc>()
                    ..add(const ProfileSetupInitialized()),
              child: ProfileSetupView(isEditMode: isEditMode),
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.chat,
        name: AppRoutes.chat,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider(
            create: (_) =>
                getIt<ChatBloc>()..add(const InitializeChatRequested()),
            child: const ChatView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.contactSupport,
        name: AppRoutes.contactSupport,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<ContactSupportBloc>(
            create: (_) =>
                getIt<ContactSupportBloc>()
                  ..add(const InitializeContactSupportRequested()),
            child: const ContactSupportView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.helpCenter,
        name: AppRoutes.helpCenter,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<HelpCenterBloc>(
            create: (_) =>
                getIt<HelpCenterBloc>()..add(const LoadHelpCenterRequested()),
            child: const HelpCenterView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.returnPolicy,
        name: AppRoutes.returnPolicy,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<ReturnPolicyBloc>(
            create: (_) =>
                getIt<ReturnPolicyBloc>()
                  ..add(const LoadReturnPolicyRequested()),
            child: const ReturnPolicyView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.privacyPolicy,
        name: AppRoutes.privacyPolicy,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<LegalPageBloc>(
            create: (_) => LegalPageBloc(
              getIt<LegalPagesRepository>(),
              LegalPageType.privacyPolicy,
            )..add(const LoadLegalPageRequested()),
            child: const LegalPageView(pageType: LegalPageType.privacyPolicy),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.termsAndConditions,
        name: AppRoutes.termsAndConditions,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<LegalPageBloc>(
            create: (_) => LegalPageBloc(
              getIt<LegalPagesRepository>(),
              LegalPageType.termsAndConditions,
            )..add(const LoadLegalPageRequested()),
            child: const LegalPageView(
              pageType: LegalPageType.termsAndConditions,
            ),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.paymentMethods,
        name: AppRoutes.paymentMethods,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<PaymentMethodsBloc>(
            create: (_) =>
                getIt<PaymentMethodsBloc>()
                  ..add(const LoadPaymentMethodsRequested()),
            child: const PaymentMethodsView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.reviews,
        name: AppRoutes.reviews,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<MyReviewsBloc>(
            create: (_) =>
                getIt<MyReviewsBloc>()..add(const LoadMyReviewsRequested()),
            child: const MyReviewsView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        name: AppRoutes.editProfile,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<EditProfileBloc>(
            create: (_) =>
                getIt<EditProfileBloc>()..add(const LoadEditProfileRequested()),
            child: const EditProfileView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.myAddresses,
        name: AppRoutes.myAddresses,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<MyAddressesBloc>(
            create: (_) =>
                getIt<MyAddressesBloc>()..add(const LoadMyAddressesRequested()),
            child: const MyAddressesView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.addAddress,
        name: AppRoutes.addAddress,
        pageBuilder: (context, state) {
          final initialAddress = state.extra is AddressListItem
              ? state.extra as AddressListItem
              : null;

          return _buildPageTransition(
            child: BlocProvider<AddAddressBloc>(
              create: (_) => getIt<AddAddressBloc>(),
              child: AddAddressView(initialAddress: initialAddress),
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.products,
        name: AppRoutes.products,
        pageBuilder: (context, state) {
          final productId = int.tryParse(state.pathParameters['id'] ?? '');
          final child = productId == null
              ? const _InvalidProductView()
              : MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          getIt<ProductBloc>()
                            ..add(LoadProductDetails(productId)),
                    ),
                    BlocProvider(create: (_) => getIt<ProductReviewBloc>()),
                  ],
                  child: const ProductView(),
                );

          return _buildPageTransition(child: child, state: state);
        },
      ),
      GoRoute(
        path: RoutePaths.cart,
        name: AppRoutes.cart,
        pageBuilder: (context, state) =>
            _buildPageTransition(child: const CartView(), state: state),
      ),
      GoRoute(
        path: RoutePaths.savedItems,
        name: AppRoutes.savedItems,
        pageBuilder: (context, state) =>
            _buildPageTransition(child: const WishListView(), state: state),
      ),
      GoRoute(
        path: RoutePaths.aiCuratedCollections,
        name: AppRoutes.aiCuratedCollections,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider(
            create: (_) => getIt<ShopBloc>(),
            child: const AiCuratedCollectionsView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.aiCuratedCollectionDetails,
        name: AppRoutes.aiCuratedCollectionDetails,
        pageBuilder: (context, state) {
          final collectionId = int.tryParse(state.pathParameters['id'] ?? '');
          final child = collectionId == null
              ? const _InvalidAiCuratedCollectionView()
              : BlocProvider(
                  create: (_) =>
                      getIt<AiCuratedCollectionDetailsBloc>()
                        ..add(LoadAiCuratedCollectionDetails(collectionId)),
                  child: const AiCuratedCollectionDetailsView(),
                );

          return _buildPageTransition(child: child, state: state);
        },
      ),
      GoRoute(
        path: RoutePaths.wardrobeCreate,
        name: AppRoutes.wardrobeCreate,
        pageBuilder: (context, state) => _buildPageTransition(
          child: BlocProvider<CreateWardrobeBloc>(
            create: (_) => getIt<CreateWardrobeBloc>(),
            child: const CreateWardrobeView(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        path: RoutePaths.wardrobeDetails,
        name: AppRoutes.wardrobeDetails,
        pageBuilder: (context, state) {
          final wardrobeId = int.tryParse(state.pathParameters['id'] ?? '');
          final initialWardrobe = state.extra is WardrobeModel
              ? state.extra as WardrobeModel
              : null;

          final child = wardrobeId == null
              ? const _InvalidWardrobeView()
              : BlocProvider<WardrobeDetailsBloc>(
                  create: (_) => getIt<WardrobeDetailsBloc>()
                    ..add(
                      LoadWardrobeDetailsRequested(
                        wardrobeId: wardrobeId,
                        initialWardrobe: initialWardrobe,
                      ),
                    ),
                  child: WardrobeDetailsView(
                    wardrobeId: wardrobeId,
                    initialWardrobe: initialWardrobe,
                  ),
                );

          return _buildPageTransition(child: child, state: state);
        },
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) {
          return DashboardShell(
            navigationShell: navigationShell,
            currentLocation: state.matchedLocation,
          );
        },
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: AppRoutes.home,
                redirect: (_, _) => RoutePaths.wardrobes,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.shop,
                name: AppRoutes.shop,
                builder: (_, _) => const ShopView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.wardrobes,
                name: AppRoutes.wardrobes,
                builder: (_, _) => BlocProvider<WardrobeListBloc>(
                  create: (_) =>
                      getIt<WardrobeListBloc>()
                        ..add(const LoadWardrobesRequested()),
                  child: const WardrobeListView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profiles,
                name: AppRoutes.profiles,
                builder: (_, _) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static CustomTransitionPage _buildPageTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}

class _InvalidProductView extends StatelessWidget {
  const _InvalidProductView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.pureBlack,
      body: Center(
        child: Text(
          'Invalid product',
          style: TextStyle(color: AppColors.pureWhite),
        ),
      ),
    );
  }
}

class _InvalidAiCuratedCollectionView extends StatelessWidget {
  const _InvalidAiCuratedCollectionView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.pureBlack,
      body: Center(
        child: Text(
          'Invalid collection',
          style: TextStyle(color: AppColors.pureWhite),
        ),
      ),
    );
  }
}

class _InvalidWardrobeView extends StatelessWidget {
  const _InvalidWardrobeView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.pureBlack,
      body: Center(
        child: Text(
          'Invalid wardrobe',
          style: TextStyle(color: AppColors.pureWhite),
        ),
      ),
    );
  }
}

class AnimatedBranchContainer extends StatelessWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.02),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(currentIndex),
        child: children[currentIndex],
      ),
    );
  }
}
