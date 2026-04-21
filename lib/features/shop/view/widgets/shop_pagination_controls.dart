import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ShopPaginationControls extends StatelessWidget {
  const ShopPaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    this.centerContent = false,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final pageItems = _buildPageItems(currentPage, totalPages);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isRTL = Directionality.of(context) == TextDirection.rtl;
        final paginationRow = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PaginationArrowButton(
              icon: isRTL ? Icons.chevron_right : Icons.chevron_left,
              enabled: currentPage > 1,
              onTap: () => onPageSelected(currentPage - 1),
            ),
            const AppGap(AppSizes.s8, axis: Axis.horizontal),
            ...pageItems.map(
              (item) => Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSizes.s8),
                child: item.isEllipsis
                    ? const SizedBox(
                        width: AppSizes.s36,
                        child: Center(
                          child: AppText(
                            text: '...',
                            variant: AppTextVariant.ts12,
                            textColor: AppColors.pureWhite54,
                          ),
                        ),
                      )
                    : _PaginationPageChip(
                        page: item.page!,
                        isSelected: item.page == currentPage,
                        onTap: item.page == currentPage
                            ? null
                            : () => onPageSelected(item.page!),
                      ),
              ),
            ),
            _PaginationArrowButton(
              icon: isRTL ? Icons.chevron_left : Icons.chevron_right,
              enabled: currentPage < totalPages,
              onTap: () => onPageSelected(currentPage + 1),
            ),
          ],
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: centerContent
              ? ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Padding(
                    padding: AppPadding.horizontalMedium,
                    child: paginationRow,
                  ),
                )
              : Padding(
                  padding: AppPadding.horizontalMedium,
                  child: paginationRow,
                ),
        );
      },
    );
  }

  List<_PaginationItem> _buildPageItems(int currentPage, int totalPages) {
    if (totalPages <= 5) {
      return List.generate(
        totalPages,
        (index) => _PaginationItem.page(index + 1),
      );
    }

    final pageNumbers = <int>{
      1,
      totalPages,
      currentPage,
      if (currentPage > 1) currentPage - 1,
      if (currentPage < totalPages) currentPage + 1,
    }.toList()..sort();

    final items = <_PaginationItem>[];

    for (var index = 0; index < pageNumbers.length; index++) {
      final page = pageNumbers[index];
      if (index > 0 && page - pageNumbers[index - 1] > 1) {
        items.add(const _PaginationItem.ellipsis());
      }
      items.add(_PaginationItem.page(page));
    }

    return items;
  }
}

class _PaginationArrowButton extends StatelessWidget {
  const _PaginationArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: AppSizes.s40,
          width: AppSizes.s40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.secondary
                : AppColors.secondary.withValues(alpha: 0.6),
            shape: BoxShape.circle,
            border: Border.all(
              color: enabled ? AppColors.pureWhite24 : AppColors.pureWhite12,
            ),
          ),
          child: Icon(
            icon,
            color: enabled ? AppColors.pureWhite : AppColors.pureWhite24,
            size: AppSizes.s24,
          ),
        ),
      ),
    );
  }
}

class _PaginationPageChip extends StatelessWidget {
  const _PaginationPageChip({
    required this.page,
    required this.isSelected,
    this.onTap,
  });

  final int page;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: AppSizes.s40,
          width: AppSizes.s40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                  )
                : null,
            color: isSelected ? null : AppColors.darkBg,
            border: Border.all(
              color: isSelected ? AppColors.transparent : AppColors.pureWhite24,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.35),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: AppText(
            text: '$page',
            variant: AppTextVariant.ts12,
            textColor: AppColors.pureWhite,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PaginationItem {
  const _PaginationItem.page(this.page) : isEllipsis = false;
  const _PaginationItem.ellipsis() : page = null, isEllipsis = true;

  final int? page;
  final bool isEllipsis;
}
