import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:flutter/material.dart';
import 'mobile_profile_setup_view.dart';

class ProfileSetupView extends StatelessWidget {
  const ProfileSetupView({super.key, this.isEditMode = false});

  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      showHeaderDivider: false,
      useSafeArea: false,
      mobileMaxWidth: 430,
      tabletMaxWidth: 560,
      tabletLargeMaxWidth: 640,
      desktopMaxWidth: 720,
      pageBuilder: (context, _) =>
          MobileProfileSetupView(isEditMode: isEditMode),
    );
  }
}
