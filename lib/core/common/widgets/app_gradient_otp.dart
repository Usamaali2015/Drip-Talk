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

  static const Map<String, String> _localizedDigits = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  String _normalizeOtpValue(String value) {
    if (value.isEmpty) {
      return '';
    }

    final normalized = value.characters
        .map((char) => _localizedDigits[char] ?? char)
        .join();

    return normalized.characters.last;
  }

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
            width: AppSizes.s40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.otpFieldBackground,
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textDirection: TextDirection.ltr,
              onTapOutside: (v) {
                focusNode.unfocus();
              },
              maxLength: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: AppTextStyles.ts22(context, color: AppColors.pureWhite),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                final normalizedValue = _normalizeOtpValue(value);

                if (controller.text != normalizedValue) {
                  controller.value = TextEditingValue(
                    text: normalizedValue,
                    selection: TextSelection.collapsed(
                      offset: normalizedValue.length,
                    ),
                  );
                }

                if (normalizedValue.isNotEmpty) {
                  if (nextFocus != null) {
                    nextFocus!.requestFocus();
                  } else {
                    focusNode.unfocus();
                  }
                }

                if (normalizedValue.isEmpty && previousFocus != null) {
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
