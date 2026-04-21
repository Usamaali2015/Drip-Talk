import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:flutter/material.dart';
import 'mobile_sign_up_view.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      showHeaderDivider: false,
      useSafeArea: false,
      mobileMaxWidth: 430,
      tabletMaxWidth: 520,
      tabletLargeMaxWidth: 560,
      desktopMaxWidth: 600,
      pageBuilder: (context, _) => const MobileSignUpView(),
    );
  }
}
