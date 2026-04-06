import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WishlistSortChips extends StatelessWidget {
  const WishlistSortChips({
    super.key,
    required this.selectedSort,
    required this.onSortSelected,
  });

  final String? selectedSort;
  final ValueChanged<String?> onSortSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = <_WishlistSortOption>[
      _WishlistSortOption(label: l10n.wishlistTrending, value: null),
      _WishlistSortOption(
        label: l10n.shopFilterSortPriceLowToHigh,
        value: 'price_asc',
      ),
      _WishlistSortOption(
        label: l10n.shopFilterSortPriceHighToLow,
        value: 'price_desc',
      ),
    ];

    return SizedBox(
      height: AppSizes.s40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option.value == selectedSort;
          return _WishlistSortChip(
            label: option.label,
            isSelected: isSelected,
            onTap: () => onSortSelected(option.value),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: AppSizes.s12),
        itemCount: options.length,
      ),
    );
  }
}

class _WishlistSortChip extends StatelessWidget {
  const _WishlistSortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.s24),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s18,
            vertical: AppSizes.s10,
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                  )
                : null,
            color: isSelected ? null : AppColors.darkBg.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(AppSizes.s24),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.18),
            ),
          ),
          child: Center(
            child: AppText(
              text: label,
              style: AppTextStyles.ts12(
                context,
                color: isSelected
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WishlistSortOption {
  const _WishlistSortOption({required this.label, required this.value});

  final String label;
  final String? value;
}
