import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_button.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/features/product/data/models/product_details_model.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProductSizeGuideSheet extends StatefulWidget {
  const ProductSizeGuideSheet({
    super.key,
    required this.sizes,
    required this.sizeGuide,
    required this.initialSelectedSizeId,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.heightFactor = 0.85,
    this.primaryActionPinned = true,
  });

  final List<ProductAvailableSize> sizes;
  final List<ProductSizeGuide> sizeGuide;
  final int? initialSelectedSizeId;
  final String? primaryActionLabel;
  final Future<bool> Function(int? selectedSizeId)? onPrimaryAction;
  final double heightFactor;
  final bool primaryActionPinned;

  static Future<int?> show(
    BuildContext context, {
    required List<ProductAvailableSize> sizes,
    required List<ProductSizeGuide> sizeGuide,
    required int? initialSelectedSizeId,
    String? primaryActionLabel,
    Future<bool> Function(int? selectedSizeId)? onPrimaryAction,
    double heightFactor = 0.85,
    bool primaryActionPinned = true,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductSizeGuideSheet(
        sizes: sizes,
        sizeGuide: sizeGuide,
        initialSelectedSizeId: initialSelectedSizeId,
        primaryActionLabel: primaryActionLabel,
        onPrimaryAction: onPrimaryAction,
        heightFactor: heightFactor,
        primaryActionPinned: primaryActionPinned,
      ),
    );
  }

  @override
  State<ProductSizeGuideSheet> createState() => _ProductSizeGuideSheetState();
}

class _ProductSizeGuideSheetState extends State<ProductSizeGuideSheet> {
  late int? _selectedSizeId = _resolveInitialSelectedSizeId();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGuide = _selectedGuide;
    final canSubmit = widget.sizes.isEmpty || _selectedSizeId != null;
    final primaryButton = AppButton(
      text: widget.primaryActionLabel ?? l10n.productSaveSizeSelection,
      height: 54,
      isLoading: _isSubmitting,
      borderRadius: 28,
      gradientColors: const [AppColors.secondary, Color(0xFFFF1E87)],
      onPressed: !canSubmit || _isSubmitting
          ? null
          : () => _handlePrimaryAction(context),
    );

    return FractionallySizedBox(
      heightFactor: widget.heightFactor,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2B1B55),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          border: Border(top: BorderSide(width: 4, color: AppColors.secondary)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 56,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 22),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(
                              AppRadius.circular,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _SheetIconButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const AppGap(AppSizes.s14, axis: Axis.horizontal),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: l10n.productSizeGuide,
                                  variant: AppTextVariant.ts18,
                                  textColor: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                const AppGap(2),
                                AppText(
                                  text: l10n.productSizeGuideSubtitle,
                                  variant: AppTextVariant.ts14,
                                  textColor: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const AppGap(AppSizes.s24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.secondary),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.16),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.circular,
                                ),
                              ),
                              child: AppText(
                                text: l10n.productSizeGuideAiBadge,
                                variant: AppTextVariant.ts10,
                                textColor: AppColors.white,
                                fontWeight: FontWeight.w700,
                                maxLines: 4,
                              ),
                            ),
                            const AppGap(AppSizes.s14),
                            AppText(
                              text: l10n.productSizeGuideHeroTitle,
                              variant: AppTextVariant.ts20,
                              textColor: AppColors.white,
                              fontWeight: FontWeight.w800,
                              maxLines: 4,
                            ),
                            const AppGap(AppSizes.s10),
                            AppText(
                              text: l10n.productSizeGuideHeroDescription,
                              variant: AppTextVariant.ts14,
                              textColor: Colors.white70,
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      const AppGap(AppSizes.s24),
                      AppText(
                        text: l10n.productSelectSize,
                        variant: AppTextVariant.ts18,
                        textColor: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      const AppGap(AppSizes.s16),
                      Wrap(
                        spacing: AppSizes.s12,
                        runSpacing: AppSizes.s12,
                        children: widget.sizes.map((size) {
                          final sizeId = size.id;
                          final isSelected =
                              sizeId != null && _selectedSizeId == sizeId;

                          return GestureDetector(
                            onTap: sizeId == null
                                ? null
                                : () =>
                                      setState(() => _selectedSizeId = sizeId),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              constraints: const BoxConstraints(minWidth: 58),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          AppColors.secondary,
                                          Color(0xFFFF1E87),
                                        ],
                                      )
                                    : null,
                                color: isSelected ? null : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.circular,
                                ),
                                border: Border.all(
                                  color: AppColors.secondary,
                                  width: 1.2,
                                ),
                              ),
                              child: AppText(
                                text: size.name ?? '--',
                                variant: AppTextVariant.ts16,
                                textAlign: TextAlign.center,
                                textColor: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const AppGap(AppSizes.s20),
                      Container(
                        width: AppSizes.fitWidth,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.secondary.withValues(alpha: 0.9),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.straighten_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const AppGap(
                                  AppSizes.s12,
                                  axis: Axis.horizontal,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: l10n.productBodyMeasurements,
                                        variant: AppTextVariant.ts16,
                                        textColor: AppColors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      const AppGap(2),
                                      AppText(
                                        text: l10n.productMeasurementsReference,
                                        variant: AppTextVariant.ts12,
                                        textColor: Colors.white70,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const AppGap(AppSizes.s18),
                            _MeasurementRow(
                              label: l10n.productSizeGuideChest.toUpperCase(),
                              value: selectedGuide?.chest,
                            ),
                            const AppGap(AppSizes.s12),
                            _MeasurementRow(
                              label: l10n.productSizeGuideWaist.toUpperCase(),
                              value: selectedGuide?.waist,
                            ),
                            const AppGap(AppSizes.s12),
                            _MeasurementRow(
                              label: l10n.productSizeGuideLength.toUpperCase(),
                              value: selectedGuide?.length,
                            ),
                          ],
                        ),
                      ),
                      if (!widget.primaryActionPinned) ...[
                        const AppGap(AppSizes.s24),
                        primaryButton,
                        const AppGap(AppSizes.s24),
                      ],
                    ],
                  ),
                ),
              ),
              if (widget.primaryActionPinned) ...[
                const AppGap(AppSizes.s20),
                primaryButton,
              ],
            ],
          ),
        ),
      ),
    );
  }

  int? _resolveInitialSelectedSizeId() {
    final initialSelectedSizeId = widget.initialSelectedSizeId;
    if (initialSelectedSizeId != null &&
        widget.sizes.any((size) => size.id == initialSelectedSizeId)) {
      return initialSelectedSizeId;
    }

    if (widget.sizes.isEmpty) {
      return null;
    }

    return widget.sizes.first.id;
  }

  ProductSizeGuide? get _selectedGuide {
    if (widget.sizeGuide.isEmpty) {
      return null;
    }

    ProductAvailableSize? selectedSize;
    for (final size in widget.sizes) {
      if (size.id == _selectedSizeId) {
        selectedSize = size;
        break;
      }
    }

    for (final guide in widget.sizeGuide) {
      if (_selectedSizeId != null && guide.id == _selectedSizeId) {
        return guide;
      }
    }

    final selectedName = selectedSize?.name?.trim().toLowerCase();
    if (selectedName != null && selectedName.isNotEmpty) {
      for (final guide in widget.sizeGuide) {
        if (guide.name?.trim().toLowerCase() == selectedName) {
          return guide;
        }
      }
    }

    return widget.sizeGuide.first;
  }

  Future<void> _handlePrimaryAction(BuildContext context) async {
    final onPrimaryAction = widget.onPrimaryAction;
    if (onPrimaryAction == null) {
      Navigator.of(context).pop(_selectedSizeId);
      return;
    }

    final navigator = Navigator.of(context);
    setState(() => _isSubmitting = true);
    final shouldClose = await onPrimaryAction(_selectedSizeId);
    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);
    if (shouldClose) {
      navigator.pop(_selectedSizeId);
    }
  }
}

class _MeasurementRow extends StatelessWidget {
  const _MeasurementRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              text: label,
              variant: AppTextVariant.ts16,
              textColor: Colors.white70,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppText(
            text: value ?? '--',
            variant: AppTextVariant.ts16,
            textColor: AppColors.secondary,
            fontWeight: FontWeight.w800,
          ),
        ],
      ),
    );
  }
}

class _SheetIconButton extends StatelessWidget {
  const _SheetIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}
