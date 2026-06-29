import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:drip_talk/features/auth/profile_setup/data/models/brands_model.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_localized_content.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_shared_widgets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfileSetupBrandPickerSheet extends StatefulWidget {
  const ProfileSetupBrandPickerSheet({
    super.key,
    required this.title,
    required this.brands,
    required this.initialSelectedValues,
    required this.onApplied,
  });

  final String title;
  final List<BrandData> brands;
  final List<String> initialSelectedValues;
  final ValueChanged<List<String>> onApplied;

  @override
  State<ProfileSetupBrandPickerSheet> createState() =>
      _ProfileSetupBrandPickerSheetState();
}

class _ProfileSetupBrandPickerSheetState
    extends State<ProfileSetupBrandPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _selectedValues;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedValues = [...widget.initialSelectedValues];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredBrands = widget.brands
        .where(_matchesQuery)
        .toList(growable: false);

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D1747), Color(0xFF1A1230)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.pureWhite.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
            ),
            const AppGap(AppSizes.s16),
            ProfileSetupSheetHeader(title: widget.title),
            const AppGap(AppSizes.s10),
            _BrandSearchField(
              controller: _searchController,
              hintText: l10n.profileSetupSearchBrandHint,
              onChanged: (value) => setState(() => _query = value),
            ),
            const AppGap(AppSizes.s12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s12,
                  vertical: AppSizes.s8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.26),
                  ),
                ),
                child: AppText(
                  text: l10n.profileSetupTapToSelectBrandsHint,
                  style: AppTextStyles.ts12(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.86),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const AppGap(AppSizes.s16),
            Expanded(
              child: filteredBrands.isEmpty
                  ? const _ProfileSetupEmptyBrandResults()
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: AppSizes.s14,
                            crossAxisSpacing: AppSizes.s14,
                            childAspectRatio: 0.84,
                          ),
                      itemCount: filteredBrands.length,
                      itemBuilder: (context, index) {
                        final brand = filteredBrands[index];
                        final isSelected =
                            ProfileSetupLocalizedContent.containsValue(
                              _selectedValues,
                              brand.name ?? '',
                            );
                        return ProfileSetupBrandCard(
                          brand: brand,
                          selected: isSelected,
                          onTap: () => _toggleBrand(brand.name),
                        );
                      },
                    ),
            ),
            const AppGap(AppSizes.s16),
            AppButton(
              text:
                  '${l10n.profileSetupApplyAction} (${_selectedValues.length})',
              width: double.infinity,
              borderRadius: AppRadius.circular,
              gradientColors: const [AppColors.secondary, AppColors.primary],
              onPressed: () => widget.onApplied(_selectedValues),
            ),
          ],
        ),
      ),
    );
  }

  bool _matchesQuery(BrandData brand) {
    final brandName = brand.name?.trim() ?? '';
    if (_query.trim().isEmpty) {
      return brandName.isNotEmpty;
    }

    return brandName.toLowerCase().contains(_query.trim().toLowerCase());
  }

  void _toggleBrand(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return;
    }

    setState(() {
      if (ProfileSetupLocalizedContent.containsValue(
        _selectedValues,
        normalized,
      )) {
        _selectedValues = _selectedValues
            .where(
              (selectedValue) => !ProfileSetupLocalizedContent.matchesValue(
                selectedValue,
                normalized,
              ),
            )
            .toList(growable: false);
        return;
      }

      _selectedValues = [..._selectedValues, normalized];
    });
  }
}

class ProfileSetupBrandCard extends StatelessWidget {
  const ProfileSetupBrandCard({
    super.key,
    required this.brand,
    required this.selected,
    required this.onTap,
  });

  final BrandData brand;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brandName = brand.name?.trim() ?? '';
    final logoUrl = _resolveLogoUrl(brand.logo);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r24),
          border: Border.all(
            color: selected
                ? AppColors.secondary
                : AppColors.secondary.withValues(alpha: 0.35),
            width: selected ? 2 : 1,
          ),
          color:  AppColors.pureWhite,
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x30FF499E),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.s18),
                child: logoUrl == null
                    ? Center(
                        child: AppText(
                          text: brandName,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: AppTextStyles.ts18(
                            context,
                            color: selected
                                ? AppColors.pureWhite
                                : AppColors.pureBlack,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : AppCachedNetworkImage(
                        imageUrl: logoUrl,
                        fit: BoxFit.contain,
                        errorWidget: Center(
                          child: AppText(
                            text: brandName,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: AppTextStyles.ts16(
                              context,
                              color: selected
                                  ? AppColors.pureWhite
                                  : AppColors.pureBlack,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(AppRadius.r24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.transparent,
                        AppColors.pureBlack.withValues(alpha: 0.06),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.secondary, AppColors.secondary],
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.pureWhite,
                    size: AppSizes.s16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BrandSearchField extends StatelessWidget {
  const _BrandSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.ts14(
        context,
        color: AppColors.pureWhite,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.ts14(
          context,
          color: AppColors.pureWhite.withValues(alpha: 0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.pureWhite.withValues(alpha: 0.72),
        ),
        filled: true,
        fillColor: AppColors.pureWhite.withValues(alpha: 0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          borderSide: BorderSide(
            color: AppColors.pureWhite.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          borderSide: const BorderSide(color: AppColors.secondary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          borderSide: BorderSide(
            color: AppColors.pureWhite.withValues(alpha: 0.12),
          ),
        ),
      ),
    );
  }
}

class _ProfileSetupEmptyBrandResults extends StatelessWidget {
  const _ProfileSetupEmptyBrandResults();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: AppText(
        text: l10n.profileSetupSearchNoResults,
        textAlign: TextAlign.center,
        style: AppTextStyles.ts14(
          context,
          color: AppColors.pureWhite.withValues(alpha: 0.72),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

String? _resolveLogoUrl(String? value) {
  final normalized = value?.trim();
  if (normalized == null ||
      normalized.isEmpty ||
      normalized.toLowerCase() == 'null') {
    return null;
  }

  final uri = Uri.tryParse(normalized);
  if (uri != null && uri.hasScheme) {
    return normalized;
  }

  return Uri.parse(ApiConstants.baseUrl).resolve(normalized).toString();
}
