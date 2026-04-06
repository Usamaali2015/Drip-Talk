import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/features/product/data/models/product_details_model.dart';
import 'package:drip_talk/features/product/domain/bloc/product_bloc.dart';
import 'package:drip_talk/features/product/domain/bloc/product_event.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductColorSelector extends StatelessWidget {
  const ProductColorSelector({
    super.key,
    required this.colors,
    required this.selectedColorId,
  });

  final List<ProductAvailableColor> colors;
  final int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final selectedColor = colors.where((color) => color.id == selectedColorId);
    final selectedColorName = selectedColor.isEmpty
        ? null
        : selectedColor.first.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              text: l10n.productChooseColor,
              variant: AppTextVariant.ts16,
              textColor: AppColors.cyan,
              fontWeight: FontWeight.w700,
            ),
            if (selectedColorName != null &&
                selectedColorName.trim().isNotEmpty) ...[
              const AppGap(AppSizes.s8, axis: Axis.horizontal),
              Expanded(
                child: AppText(
                  text: selectedColorName,
                  variant: AppTextVariant.ts12,
                  textColor: Colors.white70,
                  maxLines: 1,
                ),
              ),
            ],
          ],
        ),
        const AppGap(AppSizes.s16),
        Wrap(
          spacing: AppSizes.s10,
          runSpacing: AppSizes.s10,
          children: colors.map((color) {
            final colorId = color.id;
            final isSelected = colorId != null && selectedColorId == colorId;
            final swatchColor = _colorFromHex(color.hexCode);

            return GestureDetector(
              onTap: colorId == null
                  ? null
                  : () => context.read<ProductBloc>().add(
                        SelectProductColor(colorId),
                      ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: swatchColor.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: CircleAvatar(
                  radius: AppRadius.r24,
                  backgroundColor: swatchColor,
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: AppSizes.s18,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

Color _colorFromHex(String? hexCode) {
  final normalized = hexCode?.replaceAll('#', '').trim();
  if (normalized == null || normalized.isEmpty) {
    return Colors.grey.shade700;
  }

  final buffer = StringBuffer();
  if (normalized.length == 6) {
    buffer.write('ff');
  }
  buffer.write(normalized);

  final value = int.tryParse(buffer.toString(), radix: 16);
  if (value == null) {
    return Colors.grey.shade700;
  }

  return Color(value);
}
