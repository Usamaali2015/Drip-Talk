import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/on_boarding/barrels/on_boarding_barrels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: AppResponsivePageLayout(
        showHeaderDivider: false,
        useSafeArea: false,
        mobileMaxWidth: 430,
        tabletMaxWidth: 640,
        tabletLargeMaxWidth: 760,
        desktopMaxWidth: 860,
        pageBuilder: (context, _) => const MobileOnBoardingView(),
      ),
    );
  }
}
