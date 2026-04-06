import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';

class GradientOtpInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? previousFocus;

  const GradientOtpInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.previousFocus,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: AppSizes.s64,
            width: AppSizes.s50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F1A),
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onTapOutside: (v){
                focusNode.unfocus();
              },
              maxLength: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: AppTextStyles.ts22(context,color: AppColors.white),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (nextFocus != null) {
                    nextFocus!.requestFocus();
                  } else {
                    focusNode.unfocus();
                  }
                }

                if (value.isEmpty && previousFocus != null) {
                  previousFocus!.requestFocus();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
