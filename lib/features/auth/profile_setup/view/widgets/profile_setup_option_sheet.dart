import 'dart:math' as math;

import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_localized_content.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_shared_widgets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfileSetupOptionSheet extends StatefulWidget {
  const ProfileSetupOptionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.searchHintText,
  });

  final String title;
  final List<ProfileSetupOption> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;
  final String? searchHintText;

  @override
  State<ProfileSetupOptionSheet> createState() =>
      _ProfileSetupOptionSheetState();
}

class _ProfileSetupOptionSheetState extends State<ProfileSetupOptionSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usesExpandedLayout = widget.searchHintText != null;
    final filteredOptions = _filterOptions(widget.options, _query);

    return _ProfileSetupSheetContainer(
      title: widget.title,
      expandToAvailableSpace: usesExpandedLayout,
      searchHintText: widget.searchHintText,
      searchController: _searchController,
      onSearchChanged: (value) => setState(() => _query = value),
      body: filteredOptions.isEmpty
          ? const _ProfileSetupEmptyResults()
          : ListView.separated(
              shrinkWrap: !usesExpandedLayout,
              padding: EdgeInsets.zero,
              primary: false,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: filteredOptions.length,
              separatorBuilder: (_, _) =>
                  Divider(color: AppColors.pureWhite.withValues(alpha: 0.08)),
              itemBuilder: (context, index) {
                final option = filteredOptions[index];
                final isSelected = ProfileSetupLocalizedContent.matchesValue(
                  option.value,
                  widget.selectedValue,
                );
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: AppText(
                    text: option.label,
                    style: AppTextStyles.ts16(
                      context,
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.pureWhite,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.secondary,
                        )
                      : null,
                  onTap: () => widget.onSelected(option.value),
                );
              },
            ),
    );
  }
}

class ProfileSetupMultiSelectSheet extends StatefulWidget {
  const ProfileSetupMultiSelectSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initialSelectedValues,
    required this.onApplied,
    this.searchHintText,
  });

  final String title;
  final List<ProfileSetupOption> options;
  final List<String> initialSelectedValues;
  final ValueChanged<List<String>> onApplied;
  final String? searchHintText;

  @override
  State<ProfileSetupMultiSelectSheet> createState() =>
      _ProfileSetupMultiSelectSheetState();
}

class _ProfileSetupMultiSelectSheetState
    extends State<ProfileSetupMultiSelectSheet> {
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
    final filteredOptions = _filterOptions(widget.options, _query);

    return _ProfileSetupSheetContainer(
      title: widget.title,
      expandToAvailableSpace: true,
      searchHintText: widget.searchHintText,
      searchController: _searchController,
      onSearchChanged: (value) => setState(() => _query = value),
      footer: AppButton(
        text: l10n.profileSetupApplyAction,
        width: double.infinity,
        borderRadius: AppRadius.circular,
        gradientColors: const [AppColors.secondary, AppColors.primary],
        onPressed: () => widget.onApplied(_selectedValues),
      ),
      body: filteredOptions.isEmpty
          ? const _ProfileSetupEmptyResults()
          : ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: filteredOptions.length,
              separatorBuilder: (_, _) =>
                  Divider(color: AppColors.pureWhite.withValues(alpha: 0.08)),
              itemBuilder: (context, index) {
                final option = filteredOptions[index];
                final isSelected = ProfileSetupLocalizedContent.containsValue(
                  _selectedValues,
                  option.value,
                );
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: AppText(
                    text: option.label,
                    style: AppTextStyles.ts16(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => _toggleValue(option.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.secondary,
                                  AppColors.primary,
                                ],
                              )
                            : null,
                        color: isSelected ? null : AppColors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.transparent
                              : AppColors.secondary.withValues(alpha: 0.9),
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.pureWhite,
                              size: AppSizes.s16,
                            )
                          : null,
                    ),
                  ),
                  onTap: () => _toggleValue(option.value),
                );
              },
            ),
    );
  }

  void _toggleValue(String value) {
    setState(() {
      if (ProfileSetupLocalizedContent.containsValue(_selectedValues, value)) {
        _selectedValues = _selectedValues
            .where(
              (selectedValue) => !ProfileSetupLocalizedContent.matchesValue(
                selectedValue,
                value,
              ),
            )
            .toList(growable: false);
        return;
      }

      _selectedValues = [..._selectedValues, value];
    });
  }
}

class _ProfileSetupSheetContainer extends StatelessWidget {
  const _ProfileSetupSheetContainer({
    required this.title,
    required this.body,
    required this.searchController,
    required this.onSearchChanged,
    required this.expandToAvailableSpace,
    this.searchHintText,
    this.footer,
  });

  final String title;
  final Widget body;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final bool expandToAvailableSpace;
  final String? searchHintText;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final safeAreaBottom = mediaQuery.padding.bottom;
    final availableHeight = math
        .max(
          mediaQuery.size.height -
              mediaQuery.padding.top -
              keyboardInset -
              AppSizes.s24,
          1,
        )
        .toDouble();
    final maxHeight = math
        .min(mediaQuery.size.height * 0.78, availableHeight)
        .toDouble();
    final compactMaxHeight = math
        .min(mediaQuery.size.height * 0.6, availableHeight)
        .toDouble();
    final minHeight = math
        .min(
          maxHeight,
          mediaQuery.size.height * (searchHintText != null ? 0.58 : 0.46),
        )
        .toDouble();

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            minHeight: expandToAvailableSpace ? minHeight : 0,
            maxHeight: expandToAvailableSpace ? maxHeight : compactMaxHeight,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2D1747), Color(0xFF1A1230)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.fromLTRB(20, 18, 20, 16 + safeAreaBottom),
          child: Column(
            mainAxisSize: expandToAvailableSpace
                ? MainAxisSize.max
                : MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
              ),
              const AppGap(AppSizes.s18),
              ProfileSetupSheetHeader(title: title),
              if (searchHintText != null) ...[
                const AppGap(AppSizes.s16),
                _ProfileSetupSheetSearchField(
                  controller: searchController,
                  hintText: searchHintText!,
                  onChanged: onSearchChanged,
                ),
              ],
              const AppGap(AppSizes.s12),
              if (expandToAvailableSpace)
                Expanded(child: body)
              else
                Flexible(fit: FlexFit.loose, child: body),
              if (footer != null) ...[const AppGap(AppSizes.s16), footer!],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSetupSheetSearchField extends StatelessWidget {
  const _ProfileSetupSheetSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.12)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.ts14(context, color: AppColors.pureWhite),
        cursorColor: AppColors.secondary,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.ts14(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.56),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.secondary,
            size: AppSizes.s20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s14,
          ),
        ),
      ),
    );
  }
}

class _ProfileSetupEmptyResults extends StatelessWidget {
  const _ProfileSetupEmptyResults();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s24),
        child: AppText(
          text: l10n.profileSetupSearchNoResults,
          textAlign: TextAlign.center,
          style: AppTextStyles.ts14(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.78),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

List<ProfileSetupOption> _filterOptions(
  List<ProfileSetupOption> options,
  String query,
) {
  final normalizedQuery = query.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return options;
  }

  return options
      .where(
        (option) =>
            option.label.toLowerCase().contains(normalizedQuery) ||
            option.value.toLowerCase().contains(normalizedQuery),
      )
      .toList(growable: false);
}
