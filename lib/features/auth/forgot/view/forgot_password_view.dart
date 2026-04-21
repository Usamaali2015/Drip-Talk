import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/auth/barrels/forgot_password_barrels.dart';
import 'package:flutter/material.dart';
import 'mobile_forgot_password_view.dart';

class ForgotPasswordView extends StatelessWidget {
  final String? initialEmail;
  final PasswordResetSource source;

  const ForgotPasswordView({
    super.key,
    this.initialEmail,
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
      pageBuilder: (context, _) => MobileForgotPasswordView(
        initialEmail: initialEmail,
        source: source,
      ),
    );
  }
}
