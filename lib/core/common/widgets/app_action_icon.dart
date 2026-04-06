import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_asset_image.dart';
import 'package:flutter/material.dart';

class AppActionIcon extends StatelessWidget {
  const AppActionIcon({super.key, required this.icon, this.badge, this.onTap});

  final String icon;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.s12),
              decoration: BoxDecoration(
                color: AppColors.lightBg,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: AppAssetImage(assetPath: icon),
            ),
          ),
          if (badge != null && badge!.trim().isNotEmpty)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                height: AppSizes.s18,
                constraints: const BoxConstraints(minWidth: AppSizes.s18),
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s4),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  border: Border.all(color: AppColors.lightBg, width: 1.2),
                ),
                alignment: Alignment.center,
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
