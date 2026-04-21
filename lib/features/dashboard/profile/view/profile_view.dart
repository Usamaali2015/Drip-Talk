import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/features/dashboard/barrels/dashboard_barrels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mobile_profile_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (_) =>
          getIt<EditProfileBloc>()..add(const LoadEditProfileRequested()),
      child: AppResponsivePageLayout(
        showHeaderDivider: false,
        wrapWithScaffold: false,
        useSafeArea: false,
        mobileMaxWidth: 430,
        tabletMaxWidth: 560,
        tabletLargeMaxWidth: 680,
        desktopMaxWidth: 760,
        backgroundGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.transparent],
        ),
        pageBuilder: (context, _) => const MobileProfileView(),
      ),
    );
  }
}
