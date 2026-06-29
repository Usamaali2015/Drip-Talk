import 'break_points.dart';

/// Semantic tiers for device display sizes.
enum DeviceType {
  /// Phone – width < 600 px
  mobile,

  /// Small tablet – 600 ≤ width < 900 px
  tablet,

  /// Large tablet / small laptop – 900 ≤ width < 1200 px
  tabletLarge,

  /// Desktop / large screen – width ≥ 1200 px
  desktop,
}

extension DeviceTypeX on DeviceType {
  bool get isMobile => this == DeviceType.mobile;
  bool get isTablet => this == DeviceType.tablet;
  bool get isTabletLarge => this == DeviceType.tabletLarge;
  bool get isDesktop => this == DeviceType.desktop;

  bool get isAtLeastTablet => !isMobile;
  bool get isAtLeastTabletLarge => isTabletLarge || isDesktop;

  /// Returns the [DeviceType] that corresponds to the given logical [width].
  static DeviceType fromWidth(double width) {
    if (width >= Breakpoints.desktop) return DeviceType.desktop;
    if (width >= Breakpoints.tabletLarge) return DeviceType.tabletLarge;
    if (width >= Breakpoints.tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}
