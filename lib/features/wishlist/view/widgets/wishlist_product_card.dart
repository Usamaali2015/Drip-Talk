import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_cached_network_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_price_formatter.dart';
import 'package:drip_talk/features/wishlist/data/models/wishlist_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WishlistProductCard extends StatelessWidget {
  const WishlistProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCartTap,
    this.onRemoveTap,
  });

  final WishListItem product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCartTap;
  final VoidCallback? onRemoveTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r24),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          gradient: const LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(AppRadius.r20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.s10,
                    AppSizes.s10,
                    AppSizes.s10,
                    AppSizes.s8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: AppCachedNetworkImage(
                      imageUrl: product.resolvedThumbnail ?? '',
                      fit: BoxFit.cover,
                      width: AppSizes.fitWidth,
                      placeholder: const _WishlistCardImagePlaceholder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.s10,
                  0,
                  AppSizes.s10,
                  AppSizes.s10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: product.title ?? '',
                      variant: AppTextVariant.ts12,
                      textColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                    ),
                    const AppGap(AppSizes.s4),
                    AppText(
                      text: formatCartPrice(
                        product.resolvedPriceValue,
                        currency: product.currency,
                      ),
                      variant: AppTextVariant.ts12,
                      textColor: AppColors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    const AppGap(AppSizes.s10),
                    Row(
                      children: [
                        Expanded(
                          child: _WishlistActionButton(
                            label: l10n.shopAddToCart,
                            icon: Icons.shopping_cart_rounded,
                            onTap: onAddToCartTap,
                            isPrimary: true,
                          ),
                        ),
                        const AppGap(AppSizes.s8, axis: Axis.horizontal),
                        _WishlistActionButton(
                          label: 'x',
                          icon: Icons.close_rounded,
                          onTap: onRemoveTap,
                          isPrimary: false,
                          width: AppSizes.s50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WishlistActionButton extends StatelessWidget {
  const _WishlistActionButton({
    required this.label,
    required this.icon,
    this.onTap,
    required this.isPrimary,
    this.width,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.circular),
        child: Ink(
          height: AppSizes.s32,
          width: width,
          decoration: BoxDecoration(
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                  )
                : null,
            color: isPrimary ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.circular),
            border: Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : AppColors.white.withValues(alpha: 0.18),
            ),
          ),
          child: Center(
            child: isPrimary
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: AppColors.white, size: AppSizes.s10),
                      const AppGap(AppSizes.s4, axis: Axis.horizontal),
                      Flexible(
                        child: AppText(
                          text: label,
                          variant: AppTextVariant.ts8,
                          textColor: AppColors.white,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )
                : Icon(icon, color: AppColors.white, size: AppSizes.s16),
          ),
        ),
      ),
    );
  }
}

class _WishlistCardImagePlaceholder extends StatelessWidget {
  const _WishlistCardImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.grey.shade500,
        child: Container(
          padding: AppPadding.allExtraSmall,
          color: AppColors.lightBg,
        ),
      ),
    );
  }
}
