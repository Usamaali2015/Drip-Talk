import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/constants/app_text_styles.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/features/shop/data/models/shop_model.dart';
import 'package:drip_talk/features/shop/domain/shop_filters.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shop_filter_checkbox_option.dart';
import 'shop_filter_choice_chip.dart';
import 'shop_filter_section_card.dart';

class ShopFilterBottomSheet extends StatefulWidget {
  const ShopFilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.categories,
    required this.brandOptions,
    required this.sizeOptions,
    required this.genderOptions,
  });

  final ShopFilters initialFilters;
  final List<Category> categories;
  final List<String> brandOptions;
  final List<String> sizeOptions;
  final List<String> genderOptions;

  @override
  State<ShopFilterBottomSheet> createState() => _ShopFilterBottomSheetState();
}

class _ShopFilterBottomSheetState extends State<ShopFilterBottomSheet> {
  static const List<_SortOption> _sortOptions = [
    _SortOption(value: null, labelKey: _SortLabelKey.defaultOption),
    _SortOption(value: 'price_asc', labelKey: _SortLabelKey.priceLowToHigh),
    _SortOption(value: 'price_desc', labelKey: _SortLabelKey.priceHighToLow),
    _SortOption(value: 'name_asc', labelKey: _SortLabelKey.nameAToZ),
    _SortOption(value: 'name_desc', labelKey: _SortLabelKey.nameZToA),
  ];

  static const List<String> _fallbackSizes = <String>[
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late ShopFilters _draftFilters;
  bool _categoriesExpanded = true;
  bool _sizesExpanded = true;
  bool _brandsExpanded = true;
  bool _sortExpanded = true;

  @override
  void initState() {
    super.initState();
    _draftFilters = widget.initialFilters;
    _minPriceController = TextEditingController(
      text: _formatPriceValue(widget.initialFilters.minPrice),
    );
    _maxPriceController = TextEditingController(
      text: _formatPriceValue(widget.initialFilters.maxPrice),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  List<String> get _sizeOptions {
    final collectedSizes = <String>{
      ...widget.sizeOptions,
      ..._fallbackSizes,
    }.toList();
    collectedSizes.sort(_compareSizeLabels);
    return collectedSizes;
  }

  void _updateDraftFilters(ShopFilters filters) {
    setState(() {
      _draftFilters = filters;
    });
  }

  void _resetFilters() {
    final resetFilters = widget.initialFilters.clearedAdvanced(page: 1);
    _minPriceController.clear();
    _maxPriceController.clear();
    _updateDraftFilters(resetFilters);
  }

  void _applyFilters() {
    final resolvedRange = _resolvePriceRange(
      minInput: _minPriceController.text,
      maxInput: _maxPriceController.text,
    );

    Navigator.of(context).pop(
      _draftFilters
          .copyWith(
            minPrice: resolvedRange.$1,
            maxPrice: resolvedRange.$2,
            page: 1,
          )
          .normalized(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.darkBg2,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.r28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.s16,
                      AppSizes.s20,
                      AppSizes.s16,
                      AppSizes.s24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.tune_rounded,
                              color: AppColors.secondary,
                              size: AppSizes.s20,
                            ),
                            const AppGap(AppSizes.s8, axis: Axis.horizontal),
                            AppText(
                              text: l10n.shopFilterTitle,
                              style: AppTextStyles.ts20(
                                context,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const AppGap(AppSizes.s20, axis: Axis.vertical),
                        AppText(
                          text: l10n.shopFilterPriceRange,
                          style: AppTextStyles.ts14(
                            context,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const AppGap(AppSizes.s12, axis: Axis.vertical),
                        Row(
                          children: [
                            Expanded(
                              child: _PriceField(
                                controller: _minPriceController,
                                hintText: l10n.shopFilterMinPriceHint,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.s8,
                              ),
                              child: AppText(
                                text: l10n.shopFilterTo,
                                style: AppTextStyles.ts12(
                                  context,
                                  color: AppColors.white.withValues(
                                    alpha: 0.78,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _PriceField(
                                controller: _maxPriceController,
                                hintText: l10n.shopFilterMaxPriceHint,
                              ),
                            ),
                          ],
                        ),
                        const AppGap(AppSizes.s16, axis: Axis.vertical),
                        ShopFilterSectionCard(
                          title: l10n.shopFilterCategories,
                          isExpanded: _categoriesExpanded,
                          onToggle: () {
                            setState(() {
                              _categoriesExpanded = !_categoriesExpanded;
                            });
                          },
                          child: _CheckboxOptionsList(
                            options: widget.categories
                                .map(
                                  (category) => _CheckboxOption(
                                    label: category.name ?? '',
                                    isSelected:
                                        _draftFilters.category ==
                                        category.id?.toString(),
                                    onTap: () {
                                      _updateDraftFilters(
                                        _draftFilters.copyWith(
                                          category:
                                              _draftFilters.category ==
                                                  category.id?.toString()
                                              ? null
                                              : category.id?.toString(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                            emptyLabel: l10n.shopFilterNoOptions,
                          ),
                        ),
                        const AppGap(AppSizes.s12, axis: Axis.vertical),
                        ShopFilterSectionCard(
                          title: l10n.shopFilterSizes,
                          isExpanded: _sizesExpanded,
                          onToggle: () {
                            setState(() {
                              _sizesExpanded = !_sizesExpanded;
                            });
                          },
                          child: _TwoColumnChipsGrid(
                            children: _sizeOptions
                                .map(
                                  (size) => ShopFilterChoiceChip(
                                    label: size,
                                    isSelected: _draftFilters.size == size,
                                    onTap: () {
                                      _updateDraftFilters(
                                        _draftFilters.copyWith(
                                          size: _draftFilters.size == size
                                              ? null
                                              : size,
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const AppGap(AppSizes.s12, axis: Axis.vertical),
                        ShopFilterSectionCard(
                          title: l10n.shopFilterBrands,
                          isExpanded: _brandsExpanded,
                          onToggle: () {
                            setState(() {
                              _brandsExpanded = !_brandsExpanded;
                            });
                          },
                          child: _CheckboxOptionsList(
                            options: widget.brandOptions
                                .map(
                                  (brand) => _CheckboxOption(
                                    label: brand,
                                    isSelected: _draftFilters.brand == brand,
                                    onTap: () {
                                      _updateDraftFilters(
                                        _draftFilters.copyWith(
                                          brand: _draftFilters.brand == brand
                                              ? null
                                              : brand,
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                            emptyLabel: l10n.shopFilterNoOptions,
                          ),
                        ),
                        const AppGap(AppSizes.s12, axis: Axis.vertical),
                        ShopFilterSectionCard(
                          title: l10n.shopFilterSortBy,
                          isExpanded: _sortExpanded,
                          onToggle: () {
                            setState(() {
                              _sortExpanded = !_sortExpanded;
                            });
                          },
                          child: _TwoColumnChipsGrid(
                            children: _sortOptions
                                .map(
                                  (sortOption) => ShopFilterChoiceChip(
                                    label: sortOption.label(l10n),
                                    isSelected:
                                        (_draftFilters.sort ?? '') ==
                                        (sortOption.value ?? ''),
                                    onTap: () {
                                      _updateDraftFilters(
                                        _draftFilters.copyWith(
                                          sort:
                                              (_draftFilters.sort ?? '') ==
                                                  (sortOption.value ?? '')
                                              ? null
                                              : sortOption.value,
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const AppGap(AppSizes.s12, axis: Axis.vertical),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.s14),
                          decoration: BoxDecoration(
                            color: AppColors.lightBg.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: l10n.shopFilterGender,
                                style: AppTextStyles.ts14(
                                  context,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const AppGap(AppSizes.s12, axis: Axis.vertical),
                              _TwoColumnChipsGrid(
                                children: widget.genderOptions
                                    .map(
                                      (gender) => ShopFilterChoiceChip(
                                        label: _genderLabel(l10n, gender),
                                        isSelected:
                                            (_draftFilters.gender ?? '')
                                                .toLowerCase() ==
                                            gender.toLowerCase(),
                                        onTap: () {
                                          _updateDraftFilters(
                                            _draftFilters.copyWith(
                                              gender:
                                                  (_draftFilters.gender ?? '')
                                                          .toLowerCase() ==
                                                      gender.toLowerCase()
                                                  ? null
                                                  : gender,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.s16,
                    AppSizes.s12,
                    AppSizes.s16,
                    AppSizes.s16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBg,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BottomActionButton(
                          label: l10n.shopFilterReset,
                          onTap: _resetFilters,
                          isPrimary: false,
                        ),
                      ),
                      const AppGap(AppSizes.s12, axis: Axis.horizontal),
                      Expanded(
                        child: _BottomActionButton(
                          label: l10n.shopFilterApply,
                          onTap: _applyFilters,
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String? _formatPriceValue(double? value) {
    if (value == null) {
      return null;
    }

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  static (double?, double?) _resolvePriceRange({
    required String minInput,
    required String maxInput,
  }) {
    final minPrice = double.tryParse(minInput.trim());
    final maxPrice = double.tryParse(maxInput.trim());

    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      return (maxPrice, minPrice);
    }

    return (minPrice, maxPrice);
  }

  static int _compareSizeLabels(String first, String second) {
    const sizeOrder = <String, int>{
      'xxs': 0,
      'xs': 1,
      's': 2,
      'm': 3,
      'l': 4,
      'xl': 5,
      'xxl': 6,
      'xxxl': 7,
    };

    final firstKey = first.trim().toLowerCase();
    final secondKey = second.trim().toLowerCase();
    final firstOrder = sizeOrder[firstKey];
    final secondOrder = sizeOrder[secondKey];

    if (firstOrder != null && secondOrder != null) {
      return firstOrder.compareTo(secondOrder);
    }

    if (firstOrder != null) {
      return -1;
    }

    if (secondOrder != null) {
      return 1;
    }

    return firstKey.compareTo(secondKey);
  }

  static String _genderLabel(AppLocalizations l10n, String value) {
    switch (value.trim().toLowerCase()) {
      case 'male':
        return l10n.shopFilterGenderMale;
      case 'female':
        return l10n.shopFilterGenderFemale;
      default:
        return value;
    }
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      style: AppTextStyles.ts12(
        context,
        color: AppColors.primaryDark,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        hintText: hintText,
        hintStyle: AppTextStyles.ts12(
          context,
          color: AppColors.primaryDark.withValues(alpha: 0.6),
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r10),
          borderSide: const BorderSide(color: AppColors.secondary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s12,
          vertical: AppSizes.s12,
        ),
      ),
    );
  }
}

class _CheckboxOptionsList extends StatelessWidget {
  const _CheckboxOptionsList({required this.options, required this.emptyLabel});

  final List<_CheckboxOption> options;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return AppText(
        text: emptyLabel,
        style: AppTextStyles.ts12(
          context,
          color: AppColors.white.withValues(alpha: 0.56),
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: AppSizes.s220),
      child: ListView.separated(
        itemCount: options.length,
        shrinkWrap: true,
        primary: false,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final option = options[index];
          return ShopFilterCheckboxOption(
            label: option.label,
            isSelected: option.isSelected,
            onTap: option.onTap,
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}

class _TwoColumnChipsGrid extends StatelessWidget {
  const _TwoColumnChipsGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.s12,
        crossAxisSpacing: AppSizes.s12,
        mainAxisExtent: AppSizes.s40,
      ),
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  const _BottomActionButton({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.circular),
        child: Container(
          height: AppSizes.s56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            gradient: isPrimary
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.8),
                      AppColors.secondary,
                    ],
                  )
                : null,
            color: isPrimary ? null : Colors.transparent,
            border: Border.all(color: AppColors.secondary),
          ),
          alignment: Alignment.center,
          child: AppText(
            text: label,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckboxOption {
  const _CheckboxOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
}

class _SortOption {
  const _SortOption({required this.value, required this.labelKey});

  final String? value;
  final _SortLabelKey labelKey;

  String label(AppLocalizations l10n) {
    switch (labelKey) {
      case _SortLabelKey.defaultOption:
        return l10n.shopFilterSortDefault;
      case _SortLabelKey.priceLowToHigh:
        return l10n.shopFilterSortPriceLowToHigh;
      case _SortLabelKey.priceHighToLow:
        return l10n.shopFilterSortPriceHighToLow;
      case _SortLabelKey.nameAToZ:
        return l10n.shopFilterSortNameAToZ;
      case _SortLabelKey.nameZToA:
        return l10n.shopFilterSortNameZToA;
    }
  }
}

enum _SortLabelKey {
  defaultOption,
  priceLowToHigh,
  priceHighToLow,
  nameAToZ,
  nameZToA,
}
