import 'package:flutter/material.dart';

import 'break_points.dart';
import 'device_type.dart';
import 'responsive_sizes.dart';

extension ResponsiveExtension on BuildContext {
  // ── Raw dimensions ─────────────────────────────────────────────────────────

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // ── Boolean helpers ────────────────────────────────────────────────────────

  bool get isMobile => screenWidth < Breakpoints.tablet;
  bool get isTablet =>
      screenWidth >= Breakpoints.tablet && screenWidth < Breakpoints.desktop;
  bool get isDesktop => screenWidth >= Breakpoints.desktop;
  bool get isAtLeastTablet => !isMobile;
  bool get isWideScreen => screenWidth >= Breakpoints.tabletLarge;

  // ── Device type ────────────────────────────────────────────────────────────

  /// The current [DeviceType] derived from [screenWidth].
  DeviceType get deviceType => DeviceTypeX.fromWidth(screenWidth);

  // ── Adaptive sizes (direct shortcuts) ─────────────────────────────────────

  double get responsiveHorizontalPadding =>
      ResponsiveSizes.horizontalPadding(deviceType);
  double get responsiveContentMaxWidth =>
      ResponsiveSizes.contentMaxWidth(deviceType);
  double get responsiveFormMaxWidth => ResponsiveSizes.formMaxWidth(deviceType);
  int get responsiveGridColumns =>
      ResponsiveSizes.gridCrossAxisCount(deviceType);

  // ── Generic value picker ───────────────────────────────────────────────────

  /// Returns the most-specific non-null value for the current breakpoint.
  ///
  /// ```dart
  /// double padding = context.responsive(16.0, tablet: 24.0, desktop: 40.0);
  /// ```
  T responsive<T>(T mobile, {T? tablet, T? tabletLarge, T? desktop}) {
    if (isDesktop && desktop != null) {
      return desktop;
    }
    if (screenWidth >= Breakpoints.tabletLarge && tabletLarge != null) {
      return tabletLarge;
    }
    if (isTablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}
