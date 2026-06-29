import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/auth/barrels/two_factor_barrels.dart';
import 'package:flutter/material.dart';

class TwoFactorLoginView extends StatelessWidget {
  const TwoFactorLoginView({super.key, required this.challenge});

  final LoginTwoFactorChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      showHeaderDivider: false,
      useSafeArea: false,
      mobileMaxWidth: 430,
      tabletMaxWidth: 520,
      tabletLargeMaxWidth: 560,
      desktopMaxWidth: 600,
      pageBuilder: (context, _) => MobileTwoFactorLoginView(
        challenge: challenge,
      ),
    );
  }
}
