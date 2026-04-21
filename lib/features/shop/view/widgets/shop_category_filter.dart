import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_event.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ShopCategoryFilter extends StatelessWidget {
  const ShopCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories ||
          previous.selectedCategoryId != current.selectedCategoryId,
      builder: (context, state) {
        if (state.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: AppSizes.s40,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              final categoryId = category.id.toString();
              final isSelected = state.selectedCategoryId == categoryId;
              final categoryName = category.id == -1
                  ? l10n.shopCategoryAll
                  : (category.name ?? '');

              return GestureDetector(
                onTap: isSelected
                    ? null
                    : () {
                        context.read<ShopBloc>().add(
                          SelectCategory(categoryId),
                        );
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: AppSizes.s8),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppColors.secondary, AppColors.primary],
                          )
                        : null,
                    color: isSelected ? null : AppColors.darkBg,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.transparent
                          : AppColors.pureWhite24,
                    ),
                  ),
                  child: AppText(
                    text: categoryName,
                    style: AppTextStyles.ts12(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
