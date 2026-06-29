import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/auth/barrels/reset_password_barrels.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String resetToken;
  final PasswordResetSource source;
  const ResetPasswordView({
    super.key,
    required this.email,
    required this.resetToken,
    this.source = PasswordResetSource.auth,
  });

  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      showHeaderDivider: false,
      useSafeArea: false,
      mobileMaxWidth: 430,
      tabletMaxWidth: 520,
      tabletLargeMaxWidth: 560,
      desktopMaxWidth: 600,
      pageBuilder: (context, _) => MobileResetPasswordView(
        email: email,
        resetToken: resetToken,
        source: source,
      ),
    );
  }
}
