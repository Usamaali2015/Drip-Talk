import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/utils/responsive/responsive_layout.dart';
import 'responsive_view/desktop_forgot_password_view.dart';
import 'responsive_view/mobile_forgot_password_view.dart';
import 'responsive_view/tablet_forgot_password_view.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ResponsiveLayout(
        mobile: const MobileForgotPasswordView(),
        tablet: const TabletForgotPasswordView(),
        tabletLarge: const TabletForgotPasswordView(),
        desktop: const DesktopForgotPasswordView(),
      ),
    );
  }
}
