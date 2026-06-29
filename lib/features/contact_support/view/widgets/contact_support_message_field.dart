import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class ContactSupportMessageField extends StatelessWidget {
  const ContactSupportMessageField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.currentLength,
    required this.maxLength,
    required this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final int currentLength;
  final int maxLength;
  final String? errorText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.ts14(context, color: AppColors.pureWhite),
            children: [
              TextSpan(
                text: ' *',
                style: AppTextStyles.ts14(context, color: AppColors.red),
              ),
            ],
          ),
        ),
        const AppGap(AppSizes.s6),
        TextField(
          controller: controller,
          minLines: 4,
          maxLines: 5,
          maxLength: maxLength,
          inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
          onChanged: onChanged,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: AppTextStyles.ts14(context, color: AppColors.pureBlack),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.ts14(
              context,
              color: AppColors.materialGrey.withValues(alpha: 0.8),
            ),
            errorText: errorText,
            counterText: '',
            filled: true,
            fillColor: AppColors.pureWhite,
            contentPadding: const EdgeInsets.all(AppSizes.s14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r15),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r15),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r15),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r15),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.r15),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.s6, right: AppSizes.s4),
          child: Align(
            alignment: Alignment.centerRight,
            child: AppText(
              text: '$currentLength/$maxLength characters',
              style: AppTextStyles.ts10(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
