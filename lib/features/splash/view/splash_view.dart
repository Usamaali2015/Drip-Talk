import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/services/storage/secure_storage.dart';
import 'package:drip_talk/core/utils/responsive/responsive_layout.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/core/utils/routes/route_paths.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'responsive_view/desktop_splash_view.dart';
import 'responsive_view/mobile_splash_view.dart';
import 'responsive_view/tablet_splash_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authSessionRepository = getIt<AuthSessionRepository>();
    final pendingEmail = await authSessionRepository.getPendingVerificationEmail();
    if (!mounted) return;

    if (pendingEmail != null &&
        await authSessionRepository.hasPendingEmailVerification()) {
      if (!mounted) return;
      context.goNamed(
        AppRoutes.otp,
        queryParameters: {'email': pendingEmail, 'type': 'signup'},
      );
      return;
    }

    final token = await SecureStorage.instance.getAuthToken();
    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      context.go(RoutePaths.home);
    } else {
      context.go(RoutePaths.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ResponsiveLayout(
        mobile: const MobileSplashView(),
        tablet: const TabletSplashView(),
        tabletLarge: const TabletSplashView(),
        desktop: const DesktopSplashView(),
      ),
    );
  }
}
