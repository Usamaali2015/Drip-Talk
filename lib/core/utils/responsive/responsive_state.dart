import 'package:equatable/equatable.dart';

import 'device_type.dart';
import 'responsive_sizes.dart';

/// Immutable snapshot of the current display-size tier and raw screen
/// dimensions.  Emitted by [ResponsiveBloc] in response to [ScreenSizeChanged].
class ResponsiveState extends Equatable {
  const ResponsiveState({
    this.deviceType = DeviceType.mobile,
    this.screenWidth = 0,
    this.screenHeight = 0,
  });

  final DeviceType deviceType;
  final double screenWidth;
  final double screenHeight;

  // ── Convenience booleans ───────────────────────────────────────────────────

  bool get isMobile => deviceType.isMobile;
  bool get isTablet => deviceType.isAtLeastTablet && !deviceType.isDesktop;
  bool get isDesktop => deviceType.isDesktop;
  bool get isAtLeastTablet => deviceType.isAtLeastTablet;

  // ── Adaptive sizing via ResponsiveSizes ────────────────────────────────────

  double get horizontalPadding => ResponsiveSizes.horizontalPadding(deviceType);
  double get contentMaxWidth => ResponsiveSizes.contentMaxWidth(deviceType);
  double get formMaxWidth => ResponsiveSizes.formMaxWidth(deviceType);
  double get cardBorderRadius => ResponsiveSizes.cardBorderRadius(deviceType);
  int get gridCrossAxisCount => ResponsiveSizes.gridCrossAxisCount(deviceType);

  // ── copyWith ───────────────────────────────────────────────────────────────

  ResponsiveState copyWith({
    DeviceType? deviceType,
    double? screenWidth,
    double? screenHeight,
  }) => ResponsiveState(
    deviceType: deviceType ?? this.deviceType,
    screenWidth: screenWidth ?? this.screenWidth,
    screenHeight: screenHeight ?? this.screenHeight,
  );

  @override
  List<Object?> get props => [deviceType, screenWidth, screenHeight];
}
