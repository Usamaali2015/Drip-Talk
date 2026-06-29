import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class HelpCenterPopularQuestionsHeading extends StatelessWidget {
  const HelpCenterPopularQuestionsHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: AppSizes.s16,
          width: AppSizes.s16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r4),
            color: AppColors.secondary,
          ),
          child: const Icon(
            Icons.add_rounded,
            size: AppSizes.s12,
            color: AppColors.pureWhite,
          ),
        ),
        const AppGap(AppSizes.s8, axis: Axis.horizontal),
        AppText(
          text: title,
          style: AppTextStyles.ts20(
            context,
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
