import 'package:flutter/material.dart';

import 'break_points.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  bool get isMobile => screenWidth < Breakpoints.tablet;
  bool get isTablet =>
      screenWidth >= Breakpoints.tablet && screenWidth < Breakpoints.desktop;
  bool get isDesktop => screenWidth >= Breakpoints.desktop;

  /// Returns a specific value based on screen size
  /// Example: double padding = context.responsive(16.0, tablet: 24.0, desktop: 40.0);
  T responsive<T>(T mobile, {T? tablet, T? tabletLarge, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (screenWidth >= Breakpoints.tabletLarge && tabletLarge != null) {
      return tabletLarge;
    }
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
