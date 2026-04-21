import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

enum TrailingType { arrow, toggle, language }

class GradientListItem {
  final String subtitle;
  final String? iconPath;
  final VoidCallback? onTap;
  final TrailingType trailingType;
  final bool switchValue;
  final String selectedLanguage;
  final Function(bool)? onToggle;
  final Function(String)? onLanguageChange;

  GradientListItem({
    required this.subtitle,
    this.iconPath,
    this.onTap,
    this.trailingType = TrailingType.arrow,
    this.switchValue = false,
    this.selectedLanguage = 'ENG',
    this.onToggle,
    this.onLanguageChange,
  });
}

class GradientContainer extends StatelessWidget {
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final Color? bgColor;
  final double? borderRadius;
  final double borderWidth;
  final Widget? child;

  final bool showListTile;
  final String? listTitle;
  final String? listAssetPath;
  final List<GradientListItem>? items;

  const GradientContainer({
    super.key,
    this.colors,
    this.begin,
    this.end,
    this.bgColor,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.child,
    this.showListTile = false,
    this.listTitle,
    this.listAssetPath,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.r20;

    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors:
              colors ??
              [AppColors.secondary, AppColors.cyan, AppColors.primary],
          begin: begin ?? Alignment.topLeft,
          end: end ?? Alignment.bottomRight,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.lightBg,
          borderRadius: BorderRadius.circular(
            (radius - borderWidth).clamp(0, radius),
          ),
        ),
        child:
            child ??
            (showListTile
                ? _buildListContent(context)
                : const SizedBox.shrink()),
      ),
    );
  }

  Widget _buildListContent(BuildContext context) {
    return ListTileWidget(
      title: listTitle,
      assetPath: listAssetPath,
      items: items ?? [],
    );
  }
}

class ListTileWidget extends StatelessWidget {
  final String? assetPath;
  final String? title;
  final List<GradientListItem> items;
  final List<Color>? titleGradient;

  const ListTileWidget({
    super.key,
    this.assetPath,
    this.title,
    required this.items,
    this.titleGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.allMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (assetPath != null) AppAssetImage(assetPath: assetPath!),
              AppGap(AppSizes.s8, axis: Axis.horizontal),
              Expanded(
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      LinearGradient(
                        colors:
                            titleGradient ??
                            [AppColors.secondary, AppColors.cyan],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: AppText(
                    text: title ?? '',
                    style: AppTextStyles.ts18(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppGap(AppSizes.s14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => AppGap(AppSizes.s4),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
                child: ListTile(
                  horizontalTitleGap: AppSizes.s6,
                  onTap: item.trailingType == TrailingType.arrow
                      ? item.onTap
                      : null,
                  leading: item.iconPath != null
                      ? AppAssetImage(assetPath: item.iconPath!)
                      : null,
                  title: AppText(
                    text: item.subtitle,
                    style: AppTextStyles.ts15(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: _buildTrailing(item),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrailing(GradientListItem item) {
    switch (item.trailingType) {
      case TrailingType.toggle:
        return Switch(
          value: item.switchValue,
          onChanged: item.onToggle,
          activeThumbColor: AppColors.secondary,
        );
      case TrailingType.language:
        return Container(
          height: AppSizes.s28,
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ['ENG', 'AR'].map((lang) {
              bool isSelected = item.selectedLanguage == lang;
              return GestureDetector(
                onTap: () => item.onLanguageChange?.call(lang),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                  ),
                  child: Center(
                    child: AppText(
                      text: lang,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.pureWhite
                            : AppColors.materialGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      case TrailingType.arrow:
        return const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.pureWhite,
          size: 16,
        );
    }
  }
}
