import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProductBottomBar extends StatelessWidget {
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onAddToCartPressed;
  final VoidCallback? onBuyNowPressed;
  final bool isOutOfStock;
  final bool isAddToCartLoading;

  const ProductBottomBar({
    super.key,
    this.onFavoritePressed,
    this.onAddToCartPressed,
    this.onBuyNowPressed,
    this.isOutOfStock = false,
    this.isAddToCartLoading = false,
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
            Container(
              height: AppSizes.s50,
              width: AppSizes.s50,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: IconButton(
                onPressed: onFavoritePressed,
                icon: const Icon(Icons.favorite_border, color: Colors.white),
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
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: isOutOfStock ? null : onAddToCartPressed,
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
                    ? Colors.white12
                    : AppColors.green,
                leadingIcon: const Icon(
                  Icons.bolt,
                  color: Colors.white,
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
