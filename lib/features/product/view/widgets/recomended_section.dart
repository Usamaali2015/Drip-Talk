import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_padding.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_cached_network_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/product/data/models/product_details_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key, required this.relatedProducts});

  final List<ProductRelatedProduct> relatedProducts;

  @override
  Widget build(BuildContext context) {
    if (relatedProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: l10n.productYouMightAlsoLike,
          variant: AppTextVariant.ts18,
          textColor: AppColors.cyan,
          fontWeight: FontWeight.w700,
        ),
        const AppGap(AppSizes.s16),
        SizedBox(
          height: AppSizes.s220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: relatedProducts.length,
            separatorBuilder: (_, _) =>
                const AppGap(AppSizes.s16, axis: Axis.horizontal),
            itemBuilder: (context, index) =>
                _RelatedProductCard(product: relatedProducts[index]),
          ),
        ),
      ],
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  const _RelatedProductCard({required this.product});

  final ProductRelatedProduct product;

  @override
  Widget build(BuildContext context) {
    final productId = product.id;

    return InkWell(
      onTap: productId == null
          ? null
          : () => context.pushNamed(
              AppRoutes.products,
              pathParameters: {'id': productId.toString()},
            ),
      borderRadius: BorderRadius.circular(AppRadius.r24),
      child: Container(
        width: AppSizes.s176,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.08),
              AppColors.secondary.withValues(alpha: 0.55),
            ],
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
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.r20),
                  ),
                  child: AppCachedNetworkImage(
                    imageUrl: product.thumbnail ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: Container(color: AppColors.primaryLight),
                    errorWidget: Container(
                      color: AppColors.primaryLight,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: AppPadding.allExtraSmall,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if ((product.category?.name ?? '').isNotEmpty) ...[
                    //   AppText(
                    //     text: product.category!.name!,
                    //     variant: AppTextVariant.ts8,
                    //     textColor: Colors.white54,
                    //     fontWeight: FontWeight.w600,
                    //     maxLines: 1,
                    //   ),
                    //   const AppGap(AppSizes.s4),
                    // ],
                    AppText(
                      text: product.title ?? '--',
                      variant: AppTextVariant.ts12,
                      textColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                    ),
                    const AppGap(AppSizes.s8),
                    AppText(
                      text: _formatPrice(
                        amount: product.primaryPrice,
                        currency: product.currency,
                      ),
                      variant: AppTextVariant.ts12,
                      textColor: AppColors.cyan,
                      fontWeight: FontWeight.w700,
                    ),
                    if ((product.comparePrice ?? '').isNotEmpty) ...[
                      const AppGap(AppSizes.s4),
                      AppText(
                        text: _formatPrice(
                          amount: product.comparePrice,
                          currency: product.currency,
                        ),
                        variant: AppTextVariant.ts10,
                        textColor: Colors.white38,
                        textDecoration: TextDecoration.lineThrough,
                      ),
                    ],
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

String _formatPrice({required String? amount, required String? currency}) {
  final normalizedAmount = amount?.trim();
  if (normalizedAmount == null || normalizedAmount.isEmpty) {
    return '--';
  }

  final normalizedCurrency = currency?.trim();
  if (normalizedCurrency == null || normalizedCurrency.isEmpty) {
    return normalizedAmount;
  }

  return '$normalizedAmount $normalizedCurrency';
}
