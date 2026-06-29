import 'package:drip_talk/features/help_center/data/help_center_content.dart';
import 'package:drip_talk/features/help_center/data/models/help_center_model.dart';
import 'package:drip_talk/features/help_center/domain/bloc/help_center_bloc.dart';
import 'package:drip_talk/features/help_center/domain/bloc/help_center_event.dart';
import 'package:drip_talk/features/help_center/view/widgets/help_center_category_card.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class HelpCenterCategoriesSection extends StatelessWidget {
  const HelpCenterCategoriesSection({
    super.key,
    required this.title,
    required this.categories,
    required this.selectedCategoryId,
    required this.categoryColumns,
    required this.categoryAspectRatio,
  });

  final String title;
  final List<HelpCenterItem> categories;
  final int? selectedCategoryId;
  final int categoryColumns;
  final double categoryAspectRatio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          style: AppTextStyles.ts20(
            context,
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const AppGap(AppSizes.s16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: categoryColumns,
            mainAxisSpacing: AppSizes.s12,
            crossAxisSpacing: AppSizes.s12,
            childAspectRatio: categoryAspectRatio,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            final categoryTitle = category.displayName.isEmpty
                ? l10n.helpCenter
                : category.displayName;

            return HelpCenterCategoryCard(
              title: categoryTitle,
              iconAsset: HelpCenterContent.iconAssetFor(category),
              iconUrl: category.illustrationUrl,
              isSelected: selectedCategoryId == category.id,
              onTap: category.id == null
                  ? null
                  : () => context.read<HelpCenterBloc>().add(
                      HelpCenterCategorySelected(category.id!),
                    ),
            );
          },
        ),
      ],
    );
  }
}
