import 'dart:async';

import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/auth/profile_setup/data/models/brands_model.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_state.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_models.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_brand_picker_sheet.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_localized_content.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_shared_widgets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSetupBasicsSection extends StatelessWidget {
  const ProfileSetupBasicsSection({
    super.key,
    required this.form,
    required this.errors,
    required this.genderOptions,
    required this.countryOptions,
    required this.cityOptions,
    required this.onPhoneChanged,
    required this.onGenderPressed,
    required this.onDatePressed,
    required this.onCountryPressed,
    required this.onCityPressed,
  });

  final ProfileSetupFormData form;
  final ProfileSetupValidationErrors errors;
  final List<ProfileSetupOption> genderOptions;
  final List<ProfileSetupOption> countryOptions;
  final List<ProfileSetupOption> cityOptions;
  final ValueChanged<String> onPhoneChanged;
  final VoidCallback onGenderPressed;
  final VoidCallback onDatePressed;
  final VoidCallback onCountryPressed;
  final VoidCallback onCityPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phoneHintColor = AppColors.pureBlack.withValues(alpha: 0.42);

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileSetupBasicsTextField(
          label: l10n.profileSetupPhoneLabel,
          hintText: l10n.profileSetupPhoneHint,
          initialValue: form.phone,
          keyboardType: TextInputType.phone,
          errorText: errors.phone,
          onChanged: onPhoneChanged,
          hintColor: phoneHintColor,
        ),
        const SizedBox(height: AppSizes.s18),
        _ProfileSetupBasicsSelectionField(
          label: l10n.profileSetupGenderLabel,
          value: ProfileSetupLocalizedContent.resolveLabel(
            genderOptions,
            form.gender,
          ),
          hintText: l10n.profileSetupGenderHint,
          errorText: errors.gender,
          onTap: onGenderPressed,
        ),
        const SizedBox(height: AppSizes.s18),
        _ProfileSetupBasicsSelectionField(
          label: l10n.profileSetupDateOfBirthLabel,
          value: form.dateOfBirth == null
              ? null
              : DateFormat('MM/dd/yyyy').format(form.dateOfBirth!),
          hintText: l10n.profileSetupDateOfBirthHint,
          errorText: errors.dateOfBirth,
          trailing: const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.pureBlack,
            size: AppSizes.s18,
          ),
          onTap: onDatePressed,
        ),
        const SizedBox(height: AppSizes.s18),
        _ProfileSetupBasicsSelectionField(
          label: l10n.profileSetupCountryLabel,
          value: ProfileSetupLocalizedContent.resolveLabel(
            countryOptions,
            form.country,
          ),
          hintText: l10n.profileSetupCountryHint,
          errorText: errors.country,
          onTap: onCountryPressed,
        ),
        const SizedBox(height: AppSizes.s18),
        _ProfileSetupBasicsSelectionField(
          label: l10n.profileSetupCityLabel,
          value: ProfileSetupLocalizedContent.resolveLabel(
            cityOptions,
            form.city,
          ),
          hintText: l10n.profileSetupCityHint,
          errorText: errors.city,
          onTap: onCityPressed,
        ),
      ],
    );
  }
}

class _ProfileSetupBasicsTextField extends StatelessWidget {
  const _ProfileSetupBasicsTextField({
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.keyboardType,
    required this.onChanged,
    this.errorText,
    this.hintColor,
  });

  final String label;
  final String hintText;
  final String initialValue;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final Color? hintColor;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      labelText: label,
      hintText: hintText,
      initialValue: initialValue,
      keyboardType: keyboardType,
      borderRadius: AppRadius.r30,
      errorText: errorText,
      textColor: AppColors.pureBlack,
      hintColor: hintColor,
      fillColor: AppColors.pureWhite,
      onChanged: onChanged,
    );
  }
}

class _ProfileSetupBasicsSelectionField extends StatelessWidget {
  const _ProfileSetupBasicsSelectionField({
    required this.label,
    required this.onTap,
    this.value,
    this.hintText,
    this.errorText,
    this.trailing,
  });

  final String label;
  final String? value;
  final String? hintText;
  final String? errorText;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ProfileSetupSelectionField(
      label: label,
      value: value,
      hintText: hintText,
      errorText: errorText,
      trailing: trailing,
      onTap: onTap,
      borderRadius: AppRadius.r30,
      height: AppSizes.s56,
      horizontalPadding: const EdgeInsets.symmetric(horizontal: AppSizes.s18),
      labelSpacing: AppSizes.s8,
      textStyle: AppTextStyles.ts14(
        context,
        color: AppColors.pureBlack,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: AppTextStyles.ts14(
        context,
        color: AppColors.pureBlack.withValues(alpha: 0.5),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class ProfileSetupBodyTypeSection extends StatelessWidget {
  const ProfileSetupBodyTypeSection({
    super.key,
    required this.errors,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final ProfileSetupValidationErrors errors;
  final List<ProfileSetupBodyTypeOption> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  static const Color _cardBackground = Color(0xFF411746);
  static const Color _cardBorder = Color(0xFFB20B6E);
  static const Color _selectedBackground = Color(0xFFFF1E87);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSizes.s14,
            crossAxisSpacing: AppSizes.s14,
            mainAxisExtent: 152,
          ),
          itemBuilder: (context, index) {
            final option = options[index];
            return _ProfileSetupBodyTypeCard(
              option: option,
              selected: ProfileSetupLocalizedContent.matchesValue(
                option.value,
                selectedValue,
              ),
              backgroundColor: _cardBackground,
              borderColor: _cardBorder,
              selectedBackgroundColor: _selectedBackground,
              onTap: () => onSelected(option.value),
            );
          },
        ),
        if (errors.bodyType != null) ...[
          const SizedBox(height: AppSizes.s10),
          ProfileSetupFieldErrorText(message: errors.bodyType!),
        ],
      ],
    );
  }
}

class ProfileSetupSkinSection extends StatelessWidget {
  const ProfileSetupSkinSection({
    super.key,
    required this.form,
    required this.errors,
    required this.skinToneOptions,
    required this.onSkinToneSelected,
  });

  final ProfileSetupFormData form;
  final ProfileSetupValidationErrors errors;
  final List<ProfileSetupSkinToneOption> skinToneOptions;
  final ValueChanged<ProfileSetupSkinToneOption> onSkinToneSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedTone = skinToneOptions.firstWhere(
      (tone) =>
          ProfileSetupLocalizedContent.matchesValue(tone.value, form.skinTone),
      orElse: () => skinToneOptions.first,
    );
    final displayLabel = Localizations.localeOf(context).languageCode == 'ar'
        ? selectedTone.label
        : selectedTone.label.toUpperCase();

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r30),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3D2A39), Color(0xFF24192E)],
            ),
            border: Border.all(
              color: AppColors.pureWhite.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedTone.color,
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.68),
                    width: 3,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.s18),
              AppText(
                text: displayLabel,
                textAlign: TextAlign.center,
                style: AppTextStyles.ts20(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSizes.s6),
              AppText(
                text: '· ${selectedTone.description} ·',
                textAlign: TextAlign.center,
                style: AppTextStyles.ts12(
                  context,
                  color: AppColors.pureWhite.withValues(alpha: 0.52),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSizes.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: skinToneOptions
                    .map(
                      (tone) => _ProfileSetupSkinToneSwatch(
                        option: tone,
                        selected: ProfileSetupLocalizedContent.matchesValue(
                          tone.value,
                          selectedTone.value,
                        ),
                        onTap: () => onSkinToneSelected(tone),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: AppSizes.s22),
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: selectedTone.color,
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            color: const Color(0xFF61204F),
            borderRadius: BorderRadius.circular(AppRadius.r24),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.58),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFB92D78),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.pureWhite,
                  size: AppSizes.s20,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: AppText(
                  text: l10n.profileSetupSkinToneInfoMessage,
                  maxLines: 3,
                  style: AppTextStyles.ts14(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.94),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errors.skinTone != null) ...[
          const SizedBox(height: AppSizes.s10),
          ProfileSetupFieldErrorText(message: errors.skinTone!),
        ],
      ],
    );
  }
}

class ProfileSetupStyleSection extends StatelessWidget {
  const ProfileSetupStyleSection({
    super.key,
    required this.form,
    required this.errors,
    required this.styleOptions,
    required this.onStyleToggled,
    required this.onMinBudgetChanged,
    required this.onMaxBudgetChanged,
    required this.currencySymbol,
  });

  final ProfileSetupFormData form;
  final ProfileSetupValidationErrors errors;
  final List<ProfileSetupOption> styleOptions;
  final ValueChanged<String> onStyleToggled;
  final ValueChanged<String> onMinBudgetChanged;
  final ValueChanged<String> onMaxBudgetChanged;
  final String currencySymbol;

  static const bool _showBudgetFields = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSetupFieldLabel(text: l10n.profileSetupPreferredStyleLabel),
        const AppGap(AppSizes.s12),
        Wrap(
          spacing: AppSizes.s10,
          runSpacing: AppSizes.s10,
          children: styleOptions
              .map(
                (option) => ProfileSetupChoiceChipTile(
                  label: option.label,
                  selected: ProfileSetupLocalizedContent.containsValue(
                    form.stylePreferences,
                    option.value,
                  ),
                  onTap: () => onStyleToggled(option.value),
                ),
              )
              .toList(growable: false),
        ),
        if (errors.stylePreferences != null) ...[
          const SizedBox(height: AppSizes.s8),
          ProfileSetupFieldErrorText(message: errors.stylePreferences!),
        ],
        if (_showBudgetFields) ...[
          const AppGap(22),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: l10n.profileSetupBudgetMinLabel,
                  hintText: l10n.profileSetupBudgetMinHint,
                  initialValue: form.budgetMin,
                  keyboardType: TextInputType.number,
                  borderRadius: AppRadius.r24,
                  errorText: errors.budgetMin,
                  textColor: AppColors.pureBlack,
                  hintColor: AppColors.pureBlack.withValues(alpha: 0.42),
                  fillColor: AppColors.pureWhite,
                  suffixWidget: _BudgetSuffix(symbol: currencySymbol),
                  onChanged: onMinBudgetChanged,
                ),
              ),
              const SizedBox(width: AppSizes.s14),
              Expanded(
                child: AppTextField(
                  labelText: l10n.profileSetupBudgetMaxLabel,
                  hintText: l10n.profileSetupBudgetMaxHint,
                  initialValue: form.budgetMax,
                  keyboardType: TextInputType.number,
                  borderRadius: AppRadius.r24,
                  errorText: errors.budgetMax,
                  textColor: AppColors.pureBlack,
                  hintColor: AppColors.pureBlack.withValues(alpha: 0.42),
                  fillColor: AppColors.pureWhite,
                  suffixWidget: _BudgetSuffix(symbol: currencySymbol),
                  onChanged: onMaxBudgetChanged,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class ProfileSetupHeightSection extends StatefulWidget {
  const ProfileSetupHeightSection({
    super.key,
    required this.form,
    required this.isInteracted,
    required this.errors,
    required this.onInteractionStarted,
    required this.onUnitChanged,
    required this.onTotalInchesChanged,
    required this.onCentimetersChanged,
  });

  final ProfileSetupFormData form;
  final bool isInteracted;
  final ProfileSetupValidationErrors errors;
  final VoidCallback onInteractionStarted;
  final ValueChanged<ProfileSetupHeightUnit> onUnitChanged;
  final ValueChanged<int> onTotalInchesChanged;
  final ValueChanged<int> onCentimetersChanged;

  @override
  State<ProfileSetupHeightSection> createState() =>
      _ProfileSetupHeightSectionState();
}

class _ProfileSetupHeightSectionState extends State<ProfileSetupHeightSection> {
  static const Duration _commitDelay = Duration(milliseconds: 160);

  late ProfileSetupHeightUnit _selectedUnit;
  late int _selectedTotalInches;
  late int _selectedCentimeters;
  late bool _didNotifyInteraction;
  Timer? _commitTimer;

  @override
  void initState() {
    super.initState();
    _syncFromForm();
  }

  @override
  void didUpdateWidget(covariant ProfileSetupHeightSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.form != widget.form) {
      _syncFromForm();
    }
  }

  @override
  void dispose() {
    _commitTimer?.cancel();
    super.dispose();
  }

  void _syncFromForm() {
    _selectedUnit = widget.form.heightUnit;
    _selectedTotalInches = widget.form.resolvedHeightInches();
    _selectedCentimeters = widget.form.resolvedHeightCentimeters();
    _didNotifyInteraction = widget.isInteracted;
  }

  bool _markInteractionStarted() {
    if (_didNotifyInteraction) {
      return false;
    }

    _didNotifyInteraction = true;
    widget.onInteractionStarted();
    return true;
  }

  void _handleUnitChanged(ProfileSetupHeightUnit unit) {
    if (_selectedUnit == unit) {
      return;
    }

    setState(() {
      _selectedUnit = unit;
      if (unit == ProfileSetupHeightUnit.centimeters) {
        _selectedCentimeters = _clampInt(
          (_selectedTotalInches * 2.54).round(),
          120,
          220,
        );
        return;
      }

      _selectedTotalInches = _clampInt(
        (_selectedCentimeters / 2.54).round(),
        48,
        84,
      );
    });

    widget.onUnitChanged(unit);
  }

  void _handleTotalInchesChanged(int value, {bool commit = false}) {
    final clampedValue = _clampInt(value, 48, 84);
    final startedInteraction = _markInteractionStarted();
    setState(() {
      _selectedTotalInches = clampedValue;
      _selectedCentimeters = _clampInt((clampedValue * 2.54).round(), 120, 220);
    });

    if (startedInteraction) {
      widget.onTotalInchesChanged(clampedValue);
    }

    if (commit) {
      _commitHeightSelection();
      return;
    }

    _scheduleHeightCommit();
  }

  void _handleCentimetersChanged(int value, {bool commit = false}) {
    final clampedValue = _clampInt(value, 120, 220);
    final startedInteraction = _markInteractionStarted();
    setState(() {
      _selectedCentimeters = clampedValue;
      _selectedTotalInches = _clampInt((clampedValue / 2.54).round(), 48, 84);
    });

    if (startedInteraction) {
      widget.onCentimetersChanged(clampedValue);
    }

    if (commit) {
      _commitHeightSelection();
      return;
    }

    _scheduleHeightCommit();
  }

  void _scheduleHeightCommit() {
    _commitTimer?.cancel();
    _commitTimer = Timer(_commitDelay, _commitHeightSelection);
  }

  void _commitHeightSelection() {
    _commitTimer?.cancel();
    if (_selectedUnit == ProfileSetupHeightUnit.feetInches) {
      widget.onTotalInchesChanged(_selectedTotalInches);
      return;
    }

    widget.onCentimetersChanged(_selectedCentimeters);
  }

  @override
  Widget build(BuildContext context) {
    final isFeetMode = _selectedUnit == ProfileSetupHeightUnit.feetInches;
    final totalInches = _selectedTotalInches;
    final centimeters = _selectedCentimeters;
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    final detailLabel = isFeetMode
        ? inches == 0
              ? '$feet Feet'
              : '$feet ft $inches in'
        : '$centimeters CM';

    return Column(
      key: widget.key,
      children: [
        _ProfileSetupMeasurementUnitToggle<ProfileSetupHeightUnit>(
          value: _selectedUnit,
          options: const [
            _MeasurementUnitOption(
              value: ProfileSetupHeightUnit.centimeters,
              label: 'CM',
            ),
            _MeasurementUnitOption(
              value: ProfileSetupHeightUnit.feetInches,
              label: 'FT/IN',
            ),
          ],
          onChanged: _handleUnitChanged,
        ),
        const SizedBox(height: AppSizes.s34),
        _ProfileSetupMeasurementHero(
          value: isFeetMode ? "$feet'$inches" : '$centimeters',
          unit: isFeetMode ? 'FEET' : 'CM',
        ),
        const SizedBox(height: AppSizes.s8),
        _ProfileSetupMeasurementHint(text: 'DRAG TO ADJUST'),
        const SizedBox(height: AppSizes.s24),
        _ProfileSetupMeasurementRuler(
          hasCommittedValue: widget.form.hasAnyHeightSelection,
          value: isFeetMode ? totalInches : centimeters,
          minimum: isFeetMode ? 48 : 120,
          maximum: isFeetMode ? 84 : 220,
          isMajorTick: (value) =>
              isFeetMode ? value % 12 == 0 : value % 10 == 0,
          isMediumTick: (value) => isFeetMode ? value % 6 == 0 : value % 5 == 0,
          majorLabelBuilder: (value) {
            if (isFeetMode) {
              return value % 12 == 0 ? "${value ~/ 12}'" : null;
            }
            return value % 10 == 0 ? '$value' : null;
          },
          onChanged: (value) {
            if (isFeetMode) {
              _handleTotalInchesChanged(value);
              return;
            }
            _handleCentimetersChanged(value);
          },
          onChangeEnd: (value) {
            if (isFeetMode) {
              _handleTotalInchesChanged(value, commit: true);
              return;
            }
            _handleCentimetersChanged(value, commit: true);
          },
        ),
        const SizedBox(height: AppSizes.s24),
        _ProfileSetupMeasurementAdjustRow(
          label: detailLabel,
          onDecrement: () {
            if (isFeetMode) {
              _handleTotalInchesChanged(totalInches - 1, commit: true);
              return;
            }
            _handleCentimetersChanged(centimeters - 1, commit: true);
          },
          onIncrement: () {
            if (isFeetMode) {
              _handleTotalInchesChanged(totalInches + 1, commit: true);
              return;
            }
            _handleCentimetersChanged(centimeters + 1, commit: true);
          },
        ),
        if (widget.errors.height != null) ...[
          const SizedBox(height: AppSizes.s12),
          Align(
            alignment: Alignment.centerLeft,
            child: ProfileSetupFieldErrorText(message: widget.errors.height!),
          ),
        ],
      ],
    );
  }
}

class ProfileSetupWeightSection extends StatefulWidget {
  const ProfileSetupWeightSection({
    super.key,
    required this.form,
    required this.isInteracted,
    required this.errors,
    required this.onInteractionStarted,
    required this.onUnitChanged,
    required this.onWeightChanged,
  });

  final ProfileSetupFormData form;
  final bool isInteracted;
  final ProfileSetupValidationErrors errors;
  final VoidCallback onInteractionStarted;
  final ValueChanged<ProfileSetupWeightUnit> onUnitChanged;
  final ValueChanged<int> onWeightChanged;

  @override
  State<ProfileSetupWeightSection> createState() =>
      _ProfileSetupWeightSectionState();
}

class _ProfileSetupWeightSectionState extends State<ProfileSetupWeightSection> {
  static const Duration _commitDelay = Duration(milliseconds: 160);

  late ProfileSetupWeightUnit _selectedUnit;
  late int _selectedWeight;
  late bool _didNotifyInteraction;
  Timer? _commitTimer;

  @override
  void initState() {
    super.initState();
    _syncFromForm();
  }

  @override
  void didUpdateWidget(covariant ProfileSetupWeightSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.form != widget.form) {
      _syncFromForm();
    }
  }

  @override
  void dispose() {
    _commitTimer?.cancel();
    super.dispose();
  }

  void _syncFromForm() {
    _selectedUnit = widget.form.weightUnit;
    _selectedWeight = widget.form.resolvedWeightValue();
    _didNotifyInteraction = widget.isInteracted;
  }

  bool _markInteractionStarted() {
    if (_didNotifyInteraction) {
      return false;
    }

    _didNotifyInteraction = true;
    widget.onInteractionStarted();
    return true;
  }

  void _handleUnitChanged(ProfileSetupWeightUnit unit) {
    if (_selectedUnit == unit) {
      return;
    }

    setState(() {
      _selectedUnit = unit;
      _selectedWeight = _clampInt(
        unit == ProfileSetupWeightUnit.kilograms
            ? (_selectedWeight / 2.20462).round()
            : (_selectedWeight * 2.20462).round(),
        unit == ProfileSetupWeightUnit.kilograms ? 35 : 80,
        unit == ProfileSetupWeightUnit.kilograms ? 145 : 320,
      );
    });

    widget.onUnitChanged(unit);
  }

  void _handleWeightChanged(int value, {bool commit = false}) {
    final clampedValue = _clampInt(
      value,
      _selectedUnit == ProfileSetupWeightUnit.kilograms ? 35 : 80,
      _selectedUnit == ProfileSetupWeightUnit.kilograms ? 145 : 320,
    );
    final startedInteraction = _markInteractionStarted();
    setState(() {
      _selectedWeight = clampedValue;
    });

    if (startedInteraction) {
      widget.onWeightChanged(clampedValue);
    }

    if (commit) {
      _commitWeightSelection();
      return;
    }

    _scheduleWeightCommit();
  }

  void _scheduleWeightCommit() {
    _commitTimer?.cancel();
    _commitTimer = Timer(_commitDelay, _commitWeightSelection);
  }

  void _commitWeightSelection() {
    _commitTimer?.cancel();
    widget.onWeightChanged(_selectedWeight);
  }

  @override
  Widget build(BuildContext context) {
    final isPoundsMode = _selectedUnit == ProfileSetupWeightUnit.pounds;
    final weightValue = _selectedWeight;
    final detailLabel = '$weightValue ${isPoundsMode ? 'LBS' : 'KG'}';

    return Column(
      key: widget.key,
      children: [
        _ProfileSetupMeasurementUnitToggle<ProfileSetupWeightUnit>(
          value: _selectedUnit,
          options: const [
            _MeasurementUnitOption(
              value: ProfileSetupWeightUnit.kilograms,
              label: 'KG',
            ),
            _MeasurementUnitOption(
              value: ProfileSetupWeightUnit.pounds,
              label: 'LBS',
            ),
          ],
          onChanged: _handleUnitChanged,
        ),
        const SizedBox(height: AppSizes.s34),
        _ProfileSetupMeasurementHero(
          value: '$weightValue',
          unit: isPoundsMode ? 'LBS' : 'KG',
        ),
        const SizedBox(height: AppSizes.s8),
        _ProfileSetupMeasurementHint(text: 'DRAG TO ADJUST'),
        const SizedBox(height: AppSizes.s24),
        _ProfileSetupMeasurementRuler(
          hasCommittedValue: widget.form.hasAnyWeightSelection,
          value: weightValue,
          minimum: isPoundsMode ? 80 : 35,
          maximum: isPoundsMode ? 320 : 145,
          isMajorTick: (value) =>
              isPoundsMode ? value % 10 == 0 : value % 5 == 0,
          isMediumTick: (value) =>
              isPoundsMode ? value % 5 == 0 : value % 2 == 0,
          majorLabelBuilder: (value) => isPoundsMode
              ? (value % 10 == 0 ? '$value' : null)
              : (value % 5 == 0 ? '$value' : null),
          onChanged: _handleWeightChanged,
          onChangeEnd: (value) => _handleWeightChanged(value, commit: true),
        ),
        const SizedBox(height: AppSizes.s24),
        _ProfileSetupMeasurementAdjustRow(
          label: detailLabel,
          onDecrement: () =>
              _handleWeightChanged(weightValue - 1, commit: true),
          onIncrement: () =>
              _handleWeightChanged(weightValue + 1, commit: true),
        ),
        if (widget.errors.weight != null) ...[
          const SizedBox(height: AppSizes.s12),
          Align(
            alignment: Alignment.centerLeft,
            child: ProfileSetupFieldErrorText(message: widget.errors.weight!),
          ),
        ],
      ],
    );
  }
}

class ProfileSetupAvoidsSection extends StatelessWidget {
  const ProfileSetupAvoidsSection({
    super.key,
    required this.form,
    required this.errors,
    required this.options,
    required this.onStyleToggled,
  });

  final ProfileSetupFormData form;
  final ProfileSetupValidationErrors errors;
  final List<ProfileSetupOption> options;
  final ValueChanged<String> onStyleToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedStyles = form.avoidStylesList;
    final hasSelections = selectedStyles.isNotEmpty;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            color: const Color(0xFF61204F),
            borderRadius: BorderRadius.circular(AppRadius.r24),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.58),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFB92D78),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.pureWhite,
                  size: AppSizes.s20,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: hasSelections
                          ? l10n.profileSetupAvoidStylesSelectedTitle(
                              selectedStyles.length,
                            )
                          : l10n.profileSetupAvoidStylesEmptyTitle,
                      maxLines: 2,
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s2),
                    AppText(
                      text: hasSelections
                          ? l10n.profileSetupAvoidStylesSelectedSubtitle
                          : l10n.profileSetupAvoidStylesEmptySubtitle,
                      maxLines: 2,
                      style: AppTextStyles.ts12(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSizes.s12,
            crossAxisSpacing: AppSizes.s12,
            childAspectRatio: 2.12,
          ),
          itemBuilder: (context, index) {
            final option = options[index];
            return _ProfileSetupAvoidStyleChip(
              label: option.label,
              selected: ProfileSetupLocalizedContent.containsValue(
                selectedStyles,
                option.value,
              ),
              onTap: () => onStyleToggled(option.value),
            );
          },
        ),
        if (errors.avoidStyles != null) ...[
          const SizedBox(height: AppSizes.s8),
          ProfileSetupFieldErrorText(message: errors.avoidStyles!),
        ],
      ],
    );
  }
}

class _ProfileSetupBodyTypeCard extends StatelessWidget {
  const _ProfileSetupBodyTypeCard({
    required this.option,
    required this.selected,
    required this.backgroundColor,
    required this.borderColor,
    required this.selectedBackgroundColor,
    required this.onTap,
  });

  final ProfileSetupBodyTypeOption option;
  final bool selected;
  final Color backgroundColor;
  final Color borderColor;
  final Color selectedBackgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = Localizations.localeOf(context).languageCode == 'ar'
        ? option.label
        : option.label.toUpperCase();

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s14,
          ),
          decoration: BoxDecoration(
            color: selected ? selectedBackgroundColor : backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.r24),
            border: Border.all(
              color: selected ? selectedBackgroundColor : borderColor,
              width: 1.2,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x33FF1E87),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: Image.asset(
                    option.assetPath,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
              const Spacer(),
              AppText(
                text: title,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: AppTextStyles.ts16(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSizes.s4),
              AppText(
                text: option.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyles.ts10(
                  context,
                  color: AppColors.pureWhite.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSetupMeasurementHero extends StatelessWidget {
  const _ProfileSetupMeasurementHero({required this.value, required this.unit});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppText(
          text: value,
          style: AppTextStyles.ts40(
            context,
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: AppSizes.s4),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.s6),
          child: AppText(
            text: unit,
            style: AppTextStyles.ts18(
              context,
              color: AppColors.secondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileSetupMeasurementHint extends StatelessWidget {
  const _ProfileSetupMeasurementHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: text,
      style: AppTextStyles.ts12(
        context,
        color: AppColors.pureWhite.withValues(alpha: 0.42),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ProfileSetupSkinToneSwatch extends StatelessWidget {
  const _ProfileSetupSkinToneSwatch({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ProfileSetupSkinToneOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: option.color,
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.transparent,
            width: selected ? 2.4 : 0,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x33FF499E),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: selected
            ? Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: option.color,
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.24),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _ProfileSetupMeasurementUnitToggle<T> extends StatelessWidget {
  const _ProfileSetupMeasurementUnitToggle({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<_MeasurementUnitOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF35195A),
        borderRadius: BorderRadius.circular(AppRadius.r28),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: options
            .map(
              (option) => Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(option.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 44,
                    decoration: BoxDecoration(
                      color: option.value == value
                          ? AppColors.secondary
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      text: option.label,
                      style: AppTextStyles.ts18(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _ProfileSetupAvoidStyleChip extends StatelessWidget {
  const _ProfileSetupAvoidStyleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.secondary],
                )
              : null,
          color: selected ? null : AppColors.lightBg.withValues(alpha: 0.46),
          borderRadius: BorderRadius.circular(AppRadius.r24),
          border: Border.all(
            color: selected
                ? AppColors.transparent
                : AppColors.secondary.withValues(alpha: 0.34),
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x26FF499E),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s8,
            vertical: AppSizes.s10,
          ),
          child: AppText(
            text: label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.ts12(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.96),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileSetupMeasurementAdjustRow extends StatelessWidget {
  const _ProfileSetupMeasurementAdjustRow({
    required this.label,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ProfileSetupMeasurementAdjustButton(
          icon: Icons.remove_rounded,
          onTap: onDecrement,
        ),
        const SizedBox(width: AppSizes.s20),
        SizedBox(
          width: 124,
          child: AppText(
            text: label,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts18(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.s20),
        _ProfileSetupMeasurementAdjustButton(
          icon: Icons.add_rounded,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _ProfileSetupMeasurementAdjustButton extends StatelessWidget {
  const _ProfileSetupMeasurementAdjustButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondary, AppColors.primary],
          ),
        ),
        child: Icon(icon, color: AppColors.pureWhite, size: AppSizes.s28),
      ),
    );
  }
}

class _ProfileSetupMeasurementRuler extends StatefulWidget {
  const _ProfileSetupMeasurementRuler({
    required this.hasCommittedValue,
    required this.value,
    required this.minimum,
    required this.maximum,
    required this.isMajorTick,
    required this.majorLabelBuilder,
    required this.onChanged,
    this.onChangeEnd,
    this.isMediumTick,
  });

  final bool hasCommittedValue;
  final int value;
  final int minimum;
  final int maximum;
  final bool Function(int value) isMajorTick;
  final bool Function(int value)? isMediumTick;
  final String? Function(int value) majorLabelBuilder;
  final ValueChanged<int> onChanged;
  final ValueChanged<int>? onChangeEnd;

  @override
  State<_ProfileSetupMeasurementRuler> createState() =>
      _ProfileSetupMeasurementRulerState();
}

class _ProfileSetupMeasurementRulerState
    extends State<_ProfileSetupMeasurementRuler> {
  static const double _tickSpacing = 11;

  late final ScrollController _controller;
  late int _lastReportedValue;
  int? _lastSettledValue;
  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();
    _lastReportedValue = _clampedValue(widget.value);
    _lastSettledValue = widget.hasCommittedValue ? _lastReportedValue : null;
    _controller = ScrollController();
    _controller.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToValue(_clampedValue(widget.value));
    });
  }

  @override
  void didUpdateWidget(covariant _ProfileSetupMeasurementRuler oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextValue = _clampedValue(widget.value);
    final rangeChanged =
        oldWidget.minimum != widget.minimum ||
        oldWidget.maximum != widget.maximum;
    if (!_controller.hasClients) {
      _lastReportedValue = nextValue;
      _lastSettledValue = widget.hasCommittedValue ? nextValue : null;
      _jumpToValue(nextValue);
      return;
    }

    final currentValue = _valueFromOffset(_controller.offset);
    if (!rangeChanged && currentValue == nextValue) {
      _lastReportedValue = nextValue;
      _lastSettledValue = widget.hasCommittedValue ? nextValue : null;
      return;
    }

    _lastReportedValue = nextValue;
    _lastSettledValue = widget.hasCommittedValue ? nextValue : null;
    _jumpToValue(nextValue, animate: !rangeChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  int _clampedValue(int value) {
    if (value < widget.minimum) {
      return widget.minimum;
    }
    if (value > widget.maximum) {
      return widget.maximum;
    }
    return value;
  }

  double _offsetForValue(int value) =>
      (_clampedValue(value) - widget.minimum) * _tickSpacing;

  int _valueFromOffset(double offset) {
    final rawValue = widget.minimum + (offset / _tickSpacing).round();
    if (rawValue < widget.minimum) {
      return widget.minimum;
    }
    if (rawValue > widget.maximum) {
      return widget.maximum;
    }
    return rawValue;
  }

  void _handleScroll() {
    if (!_controller.hasClients) {
      return;
    }

    final nextValue = _valueFromOffset(_controller.offset);
    if (nextValue == _lastReportedValue) {
      return;
    }

    _lastReportedValue = nextValue;
    widget.onChanged(nextValue);
  }

  void _jumpToValue(int value, {bool animate = false}) {
    if (!_controller.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _jumpToValue(value, animate: animate);
        }
      });
      return;
    }

    final targetOffset = _offsetForValue(value);
    if ((_controller.offset - targetOffset).abs() < 0.5) {
      return;
    }

    if (animate) {
      unawaited(
        _animateToOffset(
          targetOffset,
          duration: const Duration(milliseconds: 180),
        ),
      );
      return;
    }

    _controller.jumpTo(targetOffset);
  }

  Future<void> _animateToOffset(
    double targetOffset, {
    required Duration duration,
  }) async {
    if (!_controller.hasClients) {
      return;
    }

    if ((_controller.offset - targetOffset).abs() < 0.5) {
      return;
    }

    _isProgrammaticScroll = true;
    try {
      await _controller.animateTo(
        targetOffset,
        duration: duration,
        curve: Curves.easeOut,
      );
    } finally {
      _isProgrammaticScroll = false;
    }
  }

  void _snapToClosestValue() {
    if (!_controller.hasClients || _isProgrammaticScroll) {
      return;
    }

    final snappedValue = _valueFromOffset(_controller.offset);
    if (_lastSettledValue == null || snappedValue != _lastSettledValue) {
      _lastSettledValue = snappedValue;
      widget.onChangeEnd?.call(snappedValue);
    }

    final targetOffset = _offsetForValue(snappedValue);
    if ((_controller.offset - targetOffset).abs() < 0.5) {
      return;
    }

    unawaited(
      _animateToOffset(
        targetOffset,
        duration: const Duration(milliseconds: 140),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = ((constraints.maxWidth - _tickSpacing) / 2)
              .clamp(0.0, double.infinity)
              .toDouble();

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  if (notification.depth != 0 || _isProgrammaticScroll) {
                    return false;
                  }
                  _snapToClosestValue();
                  return false;
                },
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: Theme.of(context).platform == TargetPlatform.iOS
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: widget.maximum - widget.minimum + 1,
                  itemBuilder: (context, index) {
                    final value = widget.minimum + index;
                    final isMajorTick = widget.isMajorTick(value);
                    final isMediumTick =
                        widget.isMediumTick?.call(value) ?? false;
                    final tickHeight = isMajorTick
                        ? 30.0
                        : isMediumTick
                        ? 22.0
                        : 16.0;
                    final label = widget.majorLabelBuilder(value);

                    return SizedBox(
                      width: _tickSpacing,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 28,
                            child: label == null
                                ? null
                                : Center(
                                    child: AppText(
                                      text: label,
                                      style: AppTextStyles.ts12(
                                        context,
                                        color: AppColors.pureWhite,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: isMajorTick ? 2 : 1.2,
                              height: tickHeight,
                              decoration: BoxDecoration(
                                color: AppColors.pureWhite.withValues(
                                  alpha: isMajorTick ? 0.72 : 0.32,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.circular,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.s4),
                        ],
                      ),
                    );
                  },
                ),
              ),
              IgnorePointer(
                child: Column(
                  children: [
                    Container(
                      width: 2,
                      height: 74,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(AppRadius.circular),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -5),
                      child: const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: AppColors.secondary,
                        size: AppSizes.s18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MeasurementUnitOption<T> {
  const _MeasurementUnitOption({required this.value, required this.label});

  final T value;
  final String label;
}

int _clampInt(num value, int minimum, int maximum) =>
    value.clamp(minimum, maximum).toInt();

class ProfileSetupBrandsSection extends StatelessWidget {
  const ProfileSetupBrandsSection({
    super.key,
    required this.form,
    required this.errors,
    required this.availableBrands,
    required this.brandLoadStatus,
    required this.brandErrorMessage,
    required this.onBrandToggled,
    required this.onSeeMoreBrandsPressed,
    required this.onRetryBrandsPressed,
  });

  final ProfileSetupFormData form;
  final ProfileSetupValidationErrors errors;
  final List<BrandData> availableBrands;
  final ProfileSetupBrandLoadStatus brandLoadStatus;
  final String? brandErrorMessage;
  final ValueChanged<String> onBrandToggled;
  final VoidCallback onSeeMoreBrandsPressed;
  final VoidCallback onRetryBrandsPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final featuredBrands = _resolveFeaturedBrands();

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSetupFieldLabel(text: l10n.profileSetupPreferredBrandsLabel),
        const AppGap(AppSizes.s14),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s12,
            vertical: AppSizes.s8,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.circular),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.24),
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
        const AppGap(AppSizes.s14),
        if (brandLoadStatus == ProfileSetupBrandLoadStatus.loading &&
            featuredBrands.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.s36),
              child: Shimmer.fromColors(
                baseColor: AppColors.secondary.withValues(alpha: 0.2),
                highlightColor: AppColors.secondary.withValues(alpha: 0.4),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSizes.s14,
                    crossAxisSpacing: AppSizes.s14,
                    childAspectRatio: 0.84,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.r24),
                        color: AppColors.secondary.withValues(alpha: 0.15),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        else if (featuredBrands.isEmpty)
          _ProfileSetupBrandsStatusCard(
            message: brandErrorMessage?.trim().isNotEmpty == true
                ? brandErrorMessage!
                : l10n.profileSetupNoOptionsAvailable,
            actionLabel: brandLoadStatus == ProfileSetupBrandLoadStatus.failure
                ? l10n.retry
                : l10n.profileSetupSeeMoreAction,
            onAction: brandLoadStatus == ProfileSetupBrandLoadStatus.failure
                ? onRetryBrandsPressed
                : onSeeMoreBrandsPressed,
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featuredBrands.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: AppSizes.s14,
              crossAxisSpacing: AppSizes.s14,
              childAspectRatio: 0.84,
            ),
            itemBuilder: (context, index) {
              if (index == featuredBrands.length) {
                return _ProfileSetupBrandSeeMoreCard(
                  label: l10n.profileSetupSeeMoreAction,
                  onTap: onSeeMoreBrandsPressed,
                );
              }

              final brand = featuredBrands[index];
              return ProfileSetupBrandCard(
                brand: brand,
                selected: ProfileSetupLocalizedContent.containsValue(
                  form.preferredBrands,
                  brand.name ?? '',
                ),
                onTap: () => onBrandToggled(brand.name ?? ''),
              );
            },
          ),
        if (form.preferredBrands.isNotEmpty) ...[
          const AppGap(AppSizes.s16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(AppRadius.r28),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.58),
              ),
            ),
            child: AppText(
              text: l10n.profileSetupSelectedCountLabel(
                form.preferredBrands.length,
              ),
              textAlign: TextAlign.center,
              style: AppTextStyles.ts16(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        if (errors.preferredBrands != null) ...[
          const SizedBox(height: AppSizes.s8),
          ProfileSetupFieldErrorText(message: errors.preferredBrands!),
        ],
      ],
    );
  }

  List<BrandData> _resolveFeaturedBrands() {
    final featuredBrands = availableBrands
        .where((brand) => brand.isFeatured)
        .toList(growable: false);
    if (featuredBrands.isNotEmpty) {
      return featuredBrands.take(8).toList(growable: false);
    }

    return availableBrands.take(8).toList(growable: false);
  }
}

class ProfileSetupColorsSection extends StatelessWidget {
  const ProfileSetupColorsSection({
    super.key,
    required this.errors,
    required this.selectedColorOptions,
    required this.onPickColorsPressed,
  });

  final ProfileSetupValidationErrors errors;
  final List<ProfileSetupColorOption> selectedColorOptions;
  final VoidCallback onPickColorsPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSetupFieldLabel(text: l10n.profileSetupPreferredColorsLabel),
        const AppGap(AppSizes.s14),
        ProfileSetupSeeMoreTile(
          label: l10n.profileSetupPickColorsAction,
          onTap: onPickColorsPressed,
        ),
        if (selectedColorOptions.isNotEmpty) ...[
          const AppGap(AppSizes.s14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedColorOptions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSizes.s12,
              crossAxisSpacing: AppSizes.s12,
              childAspectRatio: 1.9,
            ),
            itemBuilder: (context, index) {
              final choice = selectedColorOptions[index];
              return ProfileSetupColorChipTile(
                choice: choice,
                selected: true,
                onTap: onPickColorsPressed,
              );
            },
          ),
        ],
        if (errors.favoriteColors != null) ...[
          const SizedBox(height: AppSizes.s8),
          ProfileSetupFieldErrorText(message: errors.favoriteColors!),
        ],
      ],
    );
  }
}

class _ProfileSetupBrandsStatusCard extends StatelessWidget {
  const _ProfileSetupBrandsStatusCard({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s18),
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          AppText(
            text: message,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.84),
              fontWeight: FontWeight.w500,
            ),
          ),
          const AppGap(AppSizes.s14),
          AppButton(
            text: actionLabel,
            height: AppSizes.s44,
            width: 140,
            borderRadius: AppRadius.circular,
            gradientColors: const [AppColors.secondary, AppColors.primary],
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}

class _ProfileSetupBrandSeeMoreCard extends StatelessWidget {
  const _ProfileSetupBrandSeeMoreCard({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final displayLabel = label.contains(' ')
        ? label.replaceFirst(' ', '\n')
        : label;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pureWhite.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.r24),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.72),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s10,
              vertical: AppSizes.s14,
            ),
            child: AppText(
              text: displayLabel,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppTextStyles.ts16(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BudgetSuffix extends StatelessWidget {
  const _BudgetSuffix({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSizes.s12),
        child: AppText(
          text: symbol,
          style: AppTextStyles.ts18(
            context,
            color: AppColors.pureBlack.withValues(alpha: 0.8),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class ProfileSetupTrainingSection extends StatelessWidget {
  const ProfileSetupTrainingSection({
    super.key,
    required this.form,
    required this.errors,
    required this.onHeightUnitChanged,
    required this.onHeightCmChanged,
    required this.onHeightFeetChanged,
    required this.onHeightInchesChanged,
    required this.onWeightChanged,
    required this.onInspirationsChanged,
    required this.onAvoidStylesChanged,
  });

  final ProfileSetupFormData form;
  final ProfileSetupValidationErrors errors;
  final ValueChanged<ProfileSetupHeightUnit> onHeightUnitChanged;
  final ValueChanged<String> onHeightCmChanged;
  final ValueChanged<String> onHeightFeetChanged;
  final ValueChanged<String> onHeightInchesChanged;
  final ValueChanged<String> onWeightChanged;
  final ValueChanged<String> onInspirationsChanged;
  final ValueChanged<String> onAvoidStylesChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSetupInfoCard(),
        const AppGap(AppSizes.s20),
        ProfileSetupHeightField(
          form: form,
          errorText: errors.height,
          onUnitChanged: onHeightUnitChanged,
          onCentimetersChanged: onHeightCmChanged,
          onFeetChanged: onHeightFeetChanged,
          onInchesChanged: onHeightInchesChanged,
        ),
        const AppGap(AppSizes.s18),
        AppTextField(
          labelText: l10n.profileSetupWeightLabel,
          hintText: l10n.profileSetupWeightHint,
          initialValue: form.weight,
          keyboardType: TextInputType.number,
          borderRadius: AppRadius.r24,
          errorText: errors.weight,
          onChanged: onWeightChanged,
        ),
        const AppGap(AppSizes.s18),
        AppTextField(
          labelText: l10n.profileSetupStyleInspirationsLabel,
          hintText: l10n.profileSetupStyleInspirationsHint,
          initialValue: form.favoriteCelebrities,
          borderRadius: AppRadius.r24,
          maxLines: 3,
          errorText: errors.favoriteCelebrities,
          onChanged: onInspirationsChanged,
        ),
        const AppGap(AppSizes.s18),
        AppTextField(
          labelText: l10n.profileSetupAvoidedStylesLabel,
          hintText: l10n.profileSetupAvoidedStylesHint,
          initialValue: form.avoidStyles,
          borderRadius: AppRadius.r24,
          maxLines: 3,
          errorText: errors.avoidStyles,
          onChanged: onAvoidStylesChanged,
        ),
      ],
    );
  }
}

class ProfileSetupHeightField extends StatelessWidget {
  const ProfileSetupHeightField({
    super.key,
    required this.form,
    required this.errorText,
    required this.onUnitChanged,
    required this.onCentimetersChanged,
    required this.onFeetChanged,
    required this.onInchesChanged,
  });

  final ProfileSetupFormData form;
  final String? errorText;
  final ValueChanged<ProfileSetupHeightUnit> onUnitChanged;
  final ValueChanged<String> onCentimetersChanged;
  final ValueChanged<String> onFeetChanged;
  final ValueChanged<String> onInchesChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSetupFieldLabel(text: l10n.profileSetupHeightLabel),
        const AppGap(AppSizes.s8),
        _HeightUnitSelector(
          selectedUnit: form.heightUnit,
          onUnitChanged: onUnitChanged,
        ),
        const AppGap(AppSizes.s12),
        if (form.heightUnit == ProfileSetupHeightUnit.centimeters)
          AppTextField(
            labelText: 'CM',
            hintText: '170',
            initialValue: form.heightCm,
            keyboardType: TextInputType.number,
            borderRadius: AppRadius.r24,
            onChanged: onCentimetersChanged,
          )
        else
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  labelText: 'Feet',
                  hintText: '5',
                  initialValue: form.heightFeet,
                  keyboardType: TextInputType.number,
                  borderRadius: AppRadius.r24,
                  onChanged: onFeetChanged,
                ),
              ),
              const SizedBox(width: AppSizes.s14),
              Expanded(
                child: AppTextField(
                  labelText: 'Inches',
                  hintText: '7',
                  initialValue: form.heightInches,
                  keyboardType: TextInputType.number,
                  borderRadius: AppRadius.r24,
                  onChanged: onInchesChanged,
                ),
              ),
            ],
          ),
        if (errorText != null) ...[
          const SizedBox(height: AppSizes.s8),
          ProfileSetupFieldErrorText(message: errorText!),
        ],
      ],
    );
  }
}

class _HeightUnitSelector extends StatelessWidget {
  const _HeightUnitSelector({
    required this.selectedUnit,
    required this.onUnitChanged,
  });

  final ProfileSetupHeightUnit selectedUnit;
  final ValueChanged<ProfileSetupHeightUnit> onUnitChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HeightUnitTile(
            label: 'CM',
            selected: selectedUnit == ProfileSetupHeightUnit.centimeters,
            onTap: () => onUnitChanged(ProfileSetupHeightUnit.centimeters),
          ),
        ),
        const SizedBox(width: AppSizes.s10),
        Expanded(
          child: _HeightUnitTile(
            label: 'Feet',
            selected: selectedUnit == ProfileSetupHeightUnit.feetInches,
            onTap: () => onUnitChanged(ProfileSetupHeightUnit.feetInches),
          ),
        ),
      ],
    );
  }
}

class _HeightUnitTile extends StatelessWidget {
  const _HeightUnitTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: AppSizes.s44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.r20),
          border: Border.all(color: AppColors.secondary, width: 1.1),
        ),
        child: AppText(
          text: label,
          style: AppTextStyles.ts14(
            context,
            color: selected ? AppColors.pureWhite : AppColors.pureBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class ProfileSetupPhotosSection extends StatelessWidget {
  const ProfileSetupPhotosSection({
    super.key,
    required this.form,
    required this.onUploadPressed,
    required this.onReplaceChanged,
    required this.onRemoveLocalFile,
  });

  final ProfileSetupFormData form;
  final VoidCallback onUploadPressed;
  final ValueChanged<bool> onReplaceChanged;
  final ValueChanged<int> onRemoveLocalFile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final previewUrls = form.replaceWardrobe
        ? const <String>[]
        : form.wardrobeFileUrls;
    final totalPhotos = previewUrls.length + form.wardrobeFiles.length;
    final hasPhotos = totalPhotos > 0;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSetupUploadDropZone(onTap: onUploadPressed),
        if (hasPhotos) ...[
          const AppGap(AppSizes.s16),
          Row(
            children: [
              ProfileSetupCheckTile(
                selected: form.replaceWardrobe,
                onTap: () => onReplaceChanged(!form.replaceWardrobe),
              ),
              const SizedBox(width: AppSizes.s10),
              Expanded(
                child: AppText(
                  text: l10n.profileSetupReplacePhotosLabel,
                  style: AppTextStyles.ts12(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.94),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const AppGap(AppSizes.s20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalPhotos,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSizes.s12,
              mainAxisSpacing: AppSizes.s12,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              if (index < previewUrls.length) {
                return ProfileSetupPreviewTile.network(
                  imageUrl: previewUrls[index],
                );
              }
              final localIndex = index - previewUrls.length;
              return ProfileSetupPreviewTile.file(
                file: form.wardrobeFiles[localIndex],
                onRemove: () => onRemoveLocalFile(localIndex),
              );
            },
          ),
          const AppGap(AppSizes.s20),
          ProfileSetupStatusSummaryCard(
            savedCount: form.savedItemCount,
            wardrobeCount: totalPhotos,
          ),
        ],
      ],
    );
  }
}
