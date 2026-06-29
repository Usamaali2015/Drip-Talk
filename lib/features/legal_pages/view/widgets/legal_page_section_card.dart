import 'package:drip_talk/features/legal_pages/view/widgets/legal_page_backend_icon.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class LegalPageSectionCard extends StatelessWidget {
  const LegalPageSectionCard({
    super.key,
    required this.title,
    required this.iconName,
    required this.htmlContent,
  });

  final String title;
  final String iconName;
  final String htmlContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.fitWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s16,
        vertical: AppSizes.s18,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border(
          left: BorderSide(color: AppColors.secondary, width: AppSizes.s2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.pureBlack.withValues(alpha: 0.14),
            blurRadius: AppSizes.s20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LegalPageBackendIcon(iconName: iconName),
              const AppGap(AppSizes.s8, axis: Axis.horizontal),
              Expanded(
                child: AppText(
                  text: title,
                  style: AppTextStyles.ts20(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const AppGap(AppSizes.s8),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.secondary.withValues(alpha: 0.5),
          ),
          const AppGap(AppSizes.s14),
          AppHtmlContent(
            html: htmlContent,
            textColor: AppColors.pureWhite.withValues(alpha: 0.9),
            fadeColor: AppColors.sectionCardBackground,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            lineHeight: 1.65,
          ),
        ],
      ),
    );
  }
}
