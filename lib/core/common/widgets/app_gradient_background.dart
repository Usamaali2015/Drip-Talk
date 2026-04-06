import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final bool showBottomNav;
  final Widget? bottomNav;
  final PreferredSizeWidget? appBar;

  const CustomScaffold({
    super.key,
    required this.child,
    this.showBottomNav = false,
    this.bottomNav,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      bottomNavigationBar: showBottomNav ? bottomNav : null,
      body: Container(
        height: AppSizes.fitHeight,
        width: AppSizes.fitWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
