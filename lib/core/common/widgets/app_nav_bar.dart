import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';

class GlassBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const GlassBottomNav({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: AppSizes.s24,
      left: AppSizes.s24,
      right: AppSizes.s24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppSizes.s18, sigmaY: AppSizes.s18),
          child: Container(
            height: AppSizes.s64,
            padding: AppPadding.horizontalLarge,
            decoration: BoxDecoration(
              color: colorScheme.onSecondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.r28),
              border: Border.all(
                color: colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children:
                  [
                    _NavItem(icon: Icons.home_outlined, index: 0),
                    _NavItem(icon: Icons.search, index: 1),
                    _NavItem(icon: Icons.favorite, index: 2),
                    _NavItem(icon: Icons.settings, index: 3),
                  ].map((item) {
                    return GestureDetector(
                      onTap: () => _onTap(item.index),
                      child: Icon(
                        item.icon,
                        size: AppSizes.s24,
                        color: navigationShell.currentIndex == item.index
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final int index;
  _NavItem({required this.icon, required this.index});
}
