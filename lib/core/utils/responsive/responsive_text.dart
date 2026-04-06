import 'package:flutter/material.dart';
import 'break_points.dart';

class ResponsiveFont {
  static double scale(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    final dpr = MediaQuery.of(context).devicePixelRatio;

    double factor = 1.0;

    if (width >= Breakpoints.desktop) {
      factor = 1.15;
    } else if (width >= Breakpoints.tabletLarge) {
      factor = 1.08;
    } else if (width >= Breakpoints.tablet) {
      factor = 1.04;
    }


    if (dpr < 2) factor *= 0.95;
    if (dpr > 3) factor *= 1.05;

    return baseSize * factor;
  }
}

