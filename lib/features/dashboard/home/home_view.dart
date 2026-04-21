import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:flutter/material.dart';
import 'mobile_home_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      showHeaderDivider: false,
      wrapWithScaffold: false,
      useSafeArea: false,
      mobileMaxWidth: 430,
      tabletMaxWidth: 760,
      tabletLargeMaxWidth: 940,
      desktopMaxWidth: 1120,
      backgroundGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.transparent],
      ),
      pageBuilder: (context, _) => const MobileHomeView(),
    );
  }
}
