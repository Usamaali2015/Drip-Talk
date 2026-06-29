import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/core/utils/routes/route_paths.dart';
import 'package:drip_talk/features/auth/barrels/auth_barrels.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  static const Duration _minimumDisplayDuration = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final stopwatch = Stopwatch()..start();

    await restoreStartupAuthSession();
    await AuthGuard.initialize();
    if (!mounted) return;

    final authSessionRepository = getIt<AuthSessionRepository>();
    final sessionValues = await Future.wait<String?>([
      authSessionRepository.getPendingVerificationEmail(),
      authSessionRepository.getEmailVerifiedAt(),
      authSessionRepository.getAuthToken(),
    ]);
    if (!mounted) return;

    final pendingEmail = sessionValues[0];
    final emailVerifiedAt = sessionValues[1];
    final token = sessionValues[2];
    final hasPendingEmailVerification =
        pendingEmail != null && emailVerifiedAt == null;

    final remainingDisplayDuration =
        _minimumDisplayDuration - stopwatch.elapsed;
    if (remainingDisplayDuration > Duration.zero) {
      await Future.delayed(remainingDisplayDuration);
      if (!mounted) return;
    }

    if (hasPendingEmailVerification) {
      context.goNamed(
        AppRoutes.otp,
        queryParameters: {'email': pendingEmail, 'type': 'signup'},
      );
      return;
    }

    if (token != null && token.isNotEmpty) {
      if (AuthGuard.isProfileSetupRequired.value) {
        context.go(RoutePaths.profileSetup);
        return;
      }

      if (AuthGuard.isRecommendationsFlowRequired.value) {
        context.go(RoutePaths.chat);
        return;
      }

      context.go(RoutePaths.wardrobes);
    } else {
      context.go(RoutePaths.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      showHeaderDivider: false,
      headerBuilder: (context, _) => const SizedBox.shrink(),
      bodyBuilder: (context, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppAssetImage(assetPath: Assets.iconsLogo)],
        );
      },
    );
  }
}
