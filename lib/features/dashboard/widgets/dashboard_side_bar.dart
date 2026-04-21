import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:drip_talk/core/common/constants/app_colors.dart';

class DashboardSidebar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardSidebar({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: AppSizes.s280,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          const AppGap(AppSizes.s40),
          _SidebarItem(
            icon: Icons.home_outlined,
            label: l10n.navHome,
            index: 0,
            shell: navigationShell,
            onTap: _onTap,
          ),
          _SidebarItem(
            icon: Icons.search,
            label: l10n.navSearch,
            index: 1,
            shell: navigationShell,
            onTap: _onTap,
          ),
          _SidebarItem(
            icon: Icons.favorite,
            label: l10n.navFavorites,
            index: 2,
            shell: navigationShell,
            onTap: _onTap,
          ),
          _SidebarItem(
            icon: Icons.settings,
            label: l10n.navSettings,
            index: 3,
            shell: navigationShell,
            onTap: _onTap,
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final StatefulNavigationShell shell;
  final Function(int) onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.shell,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool active = shell.currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: active
              ? colorScheme.primary.withValues(alpha: 0.08)
              : AppColors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: active
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
