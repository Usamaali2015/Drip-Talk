import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ProductBottomBar extends StatelessWidget {
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onAddToCartPressed;
  final VoidCallback? onBuyNowPressed;
  final bool isOutOfStock;
  final bool isAddToCartLoading;
  final bool isFavoriteSelected;
  final bool isFavoritePending;

  const ProductBottomBar({
    super.key,
    this.onFavoritePressed,
    this.onAddToCartPressed,
    this.onBuyNowPressed,
    this.isOutOfStock = false,
    this.isAddToCartLoading = false,
    this.isFavoriteSelected = false,
    this.isFavoritePending = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.cyan, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(AppRadius.r24),
      ),
      child: Container(
        padding: AppPadding.smallAll,
        decoration: BoxDecoration(
          color: AppColors.lightBg,
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Row(
          children: [
            Opacity(
              opacity: isFavoritePending ? 0.72 : 1,
              child: Container(
                height: AppSizes.s50,
                width: AppSizes.s50,
                decoration: BoxDecoration(
                  color: isFavoriteSelected
                      ? AppColors.secondary.withValues(alpha: 0.16)
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(
                    color: isFavoriteSelected
                        ? AppColors.secondary.withValues(alpha: 0.75)
                        : AppColors.pureWhite.withValues(alpha: 0.14),
                  ),
                ),
                child: IconButton(
                  onPressed: isFavoritePending ? null : onFavoritePressed,
                  icon: Icon(
                    isFavoriteSelected ? Icons.favorite : Icons.favorite_border,
                    color: isFavoriteSelected
                        ? AppColors.red
                        : AppColors.pureWhite,
                  ),
                ),
              ),
            ),
            const AppGap(AppSizes.s12, axis: Axis.horizontal),
            Expanded(
              flex: 2,
              child: AppButton(
                text: l10n.shopAddToCart,
                iconGap: AppSizes.s2,
                height: 50,
                fontSize: 14,
                borderRadius: AppRadius.r12,
                gradientColors: const [AppColors.secondary, AppColors.primary],
                isLoading: isAddToCartLoading,
                leadingIcon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.pureWhite,
                  size: 20,
                ),
                onPressed: onAddToCartPressed,
              ),
            ),
            const AppGap(AppSizes.s12, axis: Axis.horizontal),
            Expanded(
              flex: 2,
              child: AppButton(
                iconGap: AppSizes.s2,
                text: isOutOfStock
                    ? l10n.productOutOfStock
                    : l10n.productBuyNow,
                height: 50,
                fontSize: 14,
                borderRadius: AppRadius.r12,
                backgroundColor: isOutOfStock
                    ? AppColors.pureWhite12
                    : AppColors.materialGreen,
                leadingIcon: const Icon(
                  Icons.bolt,
                  color: AppColors.pureWhite,
                  size: 20,
                ),
                onPressed: isOutOfStock ? null : onBuyNowPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
