import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'break_points.dart';
import 'responsive_bloc.dart';
import 'responsive_event.dart';

/// Renders the appropriate child widget based on available width, falling back
/// gracefully: desktop → tabletLarge → tablet → mobile when a variant is
/// absent.
///
/// Also fires [ScreenSizeChanged] into the nearest [ResponsiveBloc] (if one is
/// present) so the rest of the app can read the current device tier without
/// their own [LayoutBuilder].
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.tabletLarge,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? tabletLarge;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // Keep the ResponsiveBloc in sync — safe even if the bloc is absent.
        _notifyBloc(context, width, height);

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

  void _notifyBloc(BuildContext context, double width, double height) {
    try {
      context.read<ResponsiveBloc>().add(
        ScreenSizeChanged(width: width, height: height),
      );
    } catch (_) {
      // No ResponsiveBloc in the widget tree — silently skip.
    }
  }
}
