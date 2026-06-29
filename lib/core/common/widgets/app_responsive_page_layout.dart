import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';

class AppResponsivePageLayout extends StatelessWidget {
  const AppResponsivePageLayout({
    super.key,
    this.headerBuilder,
    this.bodyBuilder,
    this.pageBuilder,
    this.mobileMaxWidth = 430,
    this.tabletMaxWidth = 720,
    this.tabletLargeMaxWidth = 960,
    this.desktopMaxWidth = 1180,
    this.showHeaderDivider = true,
    this.backgroundGradient,
    this.wrapWithScaffold = true,
    this.useSafeArea = true,
    this.showBottomNav = false,
    this.bottomNav,
    this.appBar,
  }) : assert(
         pageBuilder != null || (headerBuilder != null && bodyBuilder != null),
         'Provide pageBuilder or both headerBuilder and bodyBuilder.',
       );

  final Widget Function(BuildContext context, double contentWidth)?
  headerBuilder;
  final Widget Function(BuildContext context, double contentWidth)? bodyBuilder;
  final Widget Function(BuildContext context, double contentWidth)? pageBuilder;
  final double mobileMaxWidth;
  final double tabletMaxWidth;
  final double tabletLargeMaxWidth;
  final double desktopMaxWidth;
  final bool showHeaderDivider;
  final Gradient? backgroundGradient;
  final bool wrapWithScaffold;
  final bool useSafeArea;
  final bool showBottomNav;
  final Widget? bottomNav;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsive(
      16.0,
      tablet: 24.0,
      tabletLarge: 32.0,
      desktop: 40.0,
    );
    final headerTopPadding = context.responsive(
      12.0,
      tablet: 16.0,
      tabletLarge: 18.0,
      desktop: 20.0,
    );
    final headerBottomPadding = context.responsive(
      14.0,
      tablet: 16.0,
      tabletLarge: 18.0,
      desktop: 20.0,
    );
    final bodyTopPadding = context.responsive(
      14.0,
      tablet: 18.0,
      tabletLarge: 20.0,
      desktop: 24.0,
    );
    final bodyBottomPadding = context.responsive(
      32.0,
      tablet: 36.0,
      tabletLarge: 40.0,
      desktop: 48.0,
    );

    Widget content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsive(
            mobileMaxWidth,
            tablet: tabletMaxWidth,
            tabletLarge: tabletLargeMaxWidth,
            desktop: desktopMaxWidth,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (pageBuilder != null) {
              return pageBuilder!(context, constraints.maxWidth);
            }

            final contentWidth = constraints.maxWidth;
            final innerWidth = contentWidth > (horizontalPadding * 2)
                ? contentWidth - (horizontalPadding * 2)
                : 0.0;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    headerTopPadding,
                    horizontalPadding,
                    headerBottomPadding,
                  ),
                  child: headerBuilder!(context, innerWidth),
                ),
                if (showHeaderDivider)
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppColors.secondary.withValues(alpha: 0.34),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      bodyTopPadding,
                      horizontalPadding,
                      bodyBottomPadding,
                    ),
                    child: bodyBuilder!(context, innerWidth),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    content = Container(
      decoration: BoxDecoration(
        gradient:
            backgroundGradient ??
            const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.responsiveGradientTop,
                AppColors.responsiveGradientMiddle,
                AppColors.responsiveGradientBottom,
              ],
            ),
      ),
      child: content,
    );

    if (!wrapWithScaffold) {
      return content;
    }

    return CustomScaffold(
      showBottomNav: showBottomNav,
      bottomNav: bottomNav,
      appBar: appBar,
      child: content,
    );
  }
}
