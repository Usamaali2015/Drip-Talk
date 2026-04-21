import 'package:drip_talk/features/product/data/models/product_details_model.dart';
import 'package:drip_talk/features/product/domain/bloc/product_bloc.dart';
import 'package:drip_talk/features/product/domain/bloc/product_event.dart';
import 'package:drip_talk/features/product/view/widgets/product_size_guide_sheet.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ProductSizeSelector extends StatelessWidget {
  const ProductSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSizeId,
    required this.sizeGuide,
  });

  final List<ProductAvailableSize> sizes;
  final int? selectedSizeId;
  final List<ProductSizeGuide> sizeGuide;

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final hasSizeGuide = sizeGuide.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: l10n.productSelectSize,
              variant: AppTextVariant.ts16,
              textColor: AppColors.cyan,
              fontWeight: FontWeight.w700,
            ),
            GestureDetector(
              onTap: hasSizeGuide ? () => _openSizeGuide(context) : null,
              child: AppText(
                text: l10n.productSizeGuide,
                variant: AppTextVariant.ts12,
                textColor: hasSizeGuide
                    ? AppColors.secondary
                    : AppColors.pureWhite38,
                textDecoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        const AppGap(AppSizes.s16),
        Wrap(
          spacing: AppSizes.s12,
          runSpacing: AppSizes.s12,
          children: sizes.map((size) {
            final sizeId = size.id;
            final isSelected = sizeId != null && selectedSizeId == sizeId;

            return GestureDetector(
              onTap: sizeId == null
                  ? null
                  : () => context.read<ProductBloc>().add(
                      SelectProductSize(sizeId),
                    ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: AppSizes.s55,
                height: AppSizes.s55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryLight
                      : AppColors.lightBg,
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.primary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: AppText(
                  text: size.name ?? '--',
                  variant: AppTextVariant.ts16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _openSizeGuide(BuildContext context) async {
    final selectedSizeId = await ProductSizeGuideSheet.show(
      context,
      sizes: sizes,
      sizeGuide: sizeGuide,
      initialSelectedSizeId: this.selectedSizeId,
    );

    if (!context.mounted || selectedSizeId == null) {
      return;
    }

    context.read<ProductBloc>().add(SelectProductSize(selectedSizeId));
  }
}
