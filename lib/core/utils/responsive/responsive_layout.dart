import 'package:flutter/material.dart';
import 'break_points.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? tabletLarge;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.tabletLarge,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= Breakpoints.desktop && desktop != null) {
          return desktop!;
        }
        if (width >= Breakpoints.tabletLarge && tabletLarge != null) {
          return tabletLarge!;
        }
        if (width >= Breakpoints.tablet && tablet != null) {
          return tablet!;
        }

        return mobile;
      },
    );
  }
}
