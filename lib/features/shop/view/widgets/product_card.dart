import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_cached_network_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/features/shop/data/models/shop_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final Items product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCartTap;
  final VoidCallback? onSaveTap;
  final bool isAddingToCart;
  final bool isSaved;
  final bool isSavePending;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCartTap,
    this.onSaveTap,
    this.isAddingToCart = false,
    this.isSaved = false,
    this.isSavePending = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r24),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r15),
          gradient: LinearGradient(
            colors: [AppColors.transparent, AppColors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          width: AppSizes.s180,
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(AppRadius.r15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.r15),
                  ),
                  child: AppCachedNetworkImage(
                    imageUrl: product.thumbnail ?? '',
                    fit: BoxFit.cover,
                    width: AppSizes.fitWidth,
                    placeholder: const _ProductCardImagePlaceholder(),
                  ),
                ),
              ),
              Padding(
                padding: AppPadding.allExtraSmall,
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
                      text: '${product.price} ${product.currency ?? ''}',
                      variant: AppTextVariant.ts12,
                      textColor: AppColors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    const AppGap(AppSizes.s8),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.shopping_cart,
                            label: l10n.shopAddToCart,
                            isGradient: true,
                            onTap: onAddToCartTap,
                            isLoading: isAddingToCart,
                          ),
                        ),
                        const AppGap(AppSizes.s6, axis: Axis.horizontal),
                        _SaveButton(
                          label: l10n.shopSave,
                          isSaved: isSaved,
                          isPending: isSavePending,
                          onTap: onSaveTap,
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

class _ProductCardImagePlaceholder extends StatelessWidget {
  const _ProductCardImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.grey.shade500,
        child: Container(color: AppColors.lightBg),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isGradient;
  final VoidCallback? onTap;
  final bool isLoading;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isGradient = false,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.circular),
        child: Ink(
          height: AppSizes.s32,
          decoration: BoxDecoration(
            gradient: isGradient
                ? LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                  )
                : null,
            color: isGradient ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.circular),
            border: isGradient
                ? null
                : Border.all(color: AppColors.white.withValues(alpha: 0.14)),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: AppSizes.s14,
                    height: AppSizes.s14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: 10),
                      const AppGap(AppSizes.s4, axis: Axis.horizontal),
                      AppText(
                        text: label,
                        variant: AppTextVariant.ts8,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final String label;
  final bool isSaved;
  final bool isPending;
  final VoidCallback? onTap;

  const _SaveButton({
    required this.label,
    required this.isSaved,
    required this.isPending,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isPending ? 0.72 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isPending ? null : onTap,
          borderRadius: BorderRadius.circular(AppRadius.circular),
          child: Ink(
            height: AppSizes.s32,
            width: AppSizes.s55,
            decoration: BoxDecoration(
              color: isSaved
                  ? AppColors.secondary.withValues(alpha: 0.16)
                  : Colors.transparent,
              border: Border.all(
                color: Colors.pinkAccent.withValues(alpha: isSaved ? 0.8 : 0.3),
              ),
              borderRadius: BorderRadius.circular(AppRadius.circular),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: 14,
                ),
                const AppGap(2, axis: Axis.horizontal),
                AppText(
                  text: label,
                  variant: AppTextVariant.ts8,
                  textColor: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
