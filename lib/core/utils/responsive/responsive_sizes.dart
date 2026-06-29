import 'device_type.dart';

/// Centralised lookup table for adaptive spacing, sizing, and layout values.
/// All values are in logical pixels.
///
/// Use via [ResponsiveState] convenience getters, [ResponsiveExtension], or
/// call the static helpers directly when you only have a [DeviceType].
class ResponsiveSizes {
  const ResponsiveSizes._();

  // ── Spacing ─────────────────────────────────────────────────────────────────

  static double horizontalPadding(DeviceType type) => switch (type) {
    DeviceType.mobile => 16,
    DeviceType.tablet => 32,
    DeviceType.tabletLarge => 48,
    DeviceType.desktop => 80,
  };

  static double verticalPadding(DeviceType type) => switch (type) {
    DeviceType.mobile => 16,
    DeviceType.tablet => 24,
    DeviceType.tabletLarge => 32,
    DeviceType.desktop => 48,
  };

  // ── Content widths ───────────────────────────────────────────────────────────

  /// Maximum width for the main content column on a page.
  static double contentMaxWidth(DeviceType type) => switch (type) {
    DeviceType.mobile => double.infinity,
    DeviceType.tablet => 640,
    DeviceType.tabletLarge => 800,
    DeviceType.desktop => 1100,
  };

  /// Maximum width for auth / form glass cards.
  static double formMaxWidth(DeviceType type) => switch (type) {
    DeviceType.mobile => double.infinity,
    DeviceType.tablet => 480,
    DeviceType.tabletLarge => 520,
    DeviceType.desktop => 480,
  };

  // ── Appearance ───────────────────────────────────────────────────────────────

  static double cardBorderRadius(DeviceType type) => switch (type) {
    DeviceType.mobile => 16,
    DeviceType.tablet || DeviceType.tabletLarge => 20,
    DeviceType.desktop => 28,
  };

  // ── Grids ────────────────────────────────────────────────────────────────────

  static int gridCrossAxisCount(DeviceType type) => switch (type) {
    DeviceType.mobile => 2,
    DeviceType.tablet => 3,
    DeviceType.tabletLarge => 4,
    DeviceType.desktop => 5,
  };
}
