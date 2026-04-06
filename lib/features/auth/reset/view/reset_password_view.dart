import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/utils/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'responsive_view/mobile_reset_password_view.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String resetToken;
  const ResetPasswordView({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ResponsiveLayout(
        mobile: MobileResetPasswordView(email: email, resetToken: resetToken),
      ),
    );
  }
}
