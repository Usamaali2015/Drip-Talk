import 'dart:io';

import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/routes_barrels.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/profile_setup/data/services/profile_setup_location_service.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_bloc.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_event.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_state.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_models.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_view_widgets.dart';
import 'package:drip_talk/features/recommendations/view/widgets/recommendations_flow_sheet.dart';
import 'package:drip_talk/features/recommendations/view/widgets/recommendations_photo_upload_sheet.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileProfileSetupView extends StatelessWidget {
  const MobileProfileSetupView({super.key, this.isEditMode = false});

  final bool isEditMode;

  ProfileSetupLocationService get _locationService =>
      ProfileSetupLocationService.instance;

  Future<void> get _locationLoadFuture => _locationService.ensureLoaded();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage ||
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        final feedback = state.feedbackMessage?.trim();

        if (state.submitStatus == ProfileSetupSubmitStatus.failure &&
            feedback != null &&
            feedback.isNotEmpty) {
          ToastUtils.show(context, feedback, type: ToastType.error);
        }

        if (state.submitStatus == ProfileSetupSubmitStatus.success) {
          if (isEditMode) {
            Navigator.of(context).pop(true);
          } else {
            _showPostSetupRecommendationsFlow(context);
          }
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        if (state.isInitialLoading) {
          return const SafeArea(child: ProfileSetupLoadingView());
        }

        if (state.loadStatus == ProfileSetupLoadStatus.failure &&
            state.profile == null) {
          return SafeArea(
            child: ProfileSetupFailureView(
              message: state.errorMessage ?? l10n.profileSetupLoadFailedMessage,
              onRetry: () {
                context.read<ProfileSetupBloc>().add(
                  const ProfileSetupInitialized(),
                );
              },
            ),
          );
        }

        return FutureBuilder<void>(
          future: _locationLoadFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done &&
                !_locationService.hasCachedData) {
              return const SafeArea(child: ProfileSetupLoadingView());
            }

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) {
                  _handleBack(context, state);
                }
              },
              child: SafeArea(child: _buildContent(context, state)),
            );
          },
        );
      },
    );
  }

  Future<void> _showPostSetupRecommendationsFlow(BuildContext context) async {
    final authSessionRepository = getIt<AuthSessionRepository>();
    await authSessionRepository.setRecommendationsFlowRequired(true);
    if (!context.mounted) {
      return;
    }
    AuthGuard.requireRecommendationsFlow();

    final action = await showRecommendationsFlowSheet(
      context,
      showCompletionStep: true,
    );
    if (!context.mounted || action != RecommendationsFlowAction.openChat) {
      return;
    }

    await authSessionRepository.setRecommendationsFlowRequired(false);
    AuthGuard.completeRecommendationsFlow();
    if (!context.mounted) {
      return;
    }

    context.goNamed(AppRoutes.chat);
  }

  Widget _buildContent(BuildContext context, ProfileSetupState state) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final horizontalPadding = context.responsive(
      AppSizes.s20,
      tablet: 28.0,
      tabletLarge: 32.0,
      desktop: 36.0,
    );
    final topPadding = context.responsive(
      AppSizes.s18,
      tablet: 22.0,
      tabletLarge: 26.0,
      desktop: 30.0,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                AppSizes.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileSetupHeader(onBack: () => _handleBack(context, state)),
                  const AppGap(AppSizes.s24),
                  ProfileSetupStepper(
                    currentStep: state.currentStep,
                    completedSteps: state.completedSteps,
                    onStepSelected: (step) {
                      context.read<ProfileSetupBloc>().add(
                        ProfileSetupStepSelected(step),
                      );
                    },
                  ),
                  const AppGap(AppSizes.s28),
                  ProfileSetupStepIntro(step: state.currentStep),
                  const AppGap(AppSizes.s24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _buildStepContent(
                      context,
                      state,
                      key: ValueKey<ProfileSetupStep>(state.currentStep),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppSizes.s12,
              horizontalPadding,
              keyboardInset > 0 ? keyboardInset + AppSizes.s12 : AppSizes.s24,
            ),
            child: ProfileSetupFooterActions(
              isLastStep: state.currentStep.isLast,
              isSubmitting: state.isSubmitting,
              isSkipEnabled: state.canSkipCurrentStep,
              isContinueEnabled: state.canContinueCurrentStep,
              onSkip: () {
                context.read<ProfileSetupBloc>().add(
                  const ProfileSetupSkipRequested(),
                );
              },
              onContinue: () {
                context.read<ProfileSetupBloc>().add(
                  const ProfileSetupContinueRequested(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    ProfileSetupState state, {
    Key? key,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final genderOptions = ProfileSetupLocalizedContent.genderOptions(l10n);
    final countryOptions = _resolveCountryOptions(l10n, isArabic: isArabic);
    final cityOptions = _resolveCityOptions(
      l10n,
      isArabic: isArabic,
      countryValue: state.form.country,
    );
    final bodyTypeOptions = ProfileSetupLocalizedContent.bodyTypeOptions(l10n);
    final skinToneOptions = ProfileSetupLocalizedContent.skinToneOptions(l10n);
    final styleOptions = ProfileSetupLocalizedContent.styleOptions(l10n);
    final avoidStyleOptions = ProfileSetupLocalizedContent.avoidStyleOptions(
      l10n,
    );
    final selectedColorOptions =
        ProfileSetupLocalizedContent.selectedColorOptions(
          l10n,
          state.form.favoriteColors,
        );

    switch (state.currentStep) {
      case ProfileSetupStep.basics:
        return ProfileSetupBasicsSection(
          key: key,
          form: state.form,
          errors: state.validationErrors,
          genderOptions: genderOptions,
          countryOptions: countryOptions,
          cityOptions: cityOptions,
          onPhoneChanged: (value) => _updateForm(
            context,
            state,
            (form) => form.copyWith(phone: value),
          ),
          onGenderPressed: () => _showSingleChoiceSheet(
            context,
            title: l10n.profileSetupSelectGenderTitle,
            options: genderOptions,
            selected: state.form.gender,
            onSelected: (value) => _updateForm(
              context,
              state,
              (form) => form.copyWith(gender: value),
            ),
          ),
          onDatePressed: () => _pickDate(context, state),
          onCountryPressed: () => _showSingleChoiceSheet(
            context,
            title: l10n.profileSetupSelectCountryTitle,
            options: countryOptions,
            selected: state.form.country,
            searchHintText: l10n.profileSetupSearchCountryHint,
            onSelected: (value) {
              final nextCityOptions = _resolveCityOptions(
                l10n,
                isArabic: isArabic,
                countryValue: value,
              );
              final nextCity =
                  nextCityOptions.any(
                    (option) => ProfileSetupLocalizedContent.matchesValue(
                      option.value,
                      state.form.city,
                    ),
                  )
                  ? state.form.city
                  : '';
              _updateForm(
                context,
                state,
                (form) => form.copyWith(country: value, city: nextCity),
              );
            },
          ),
          onCityPressed: () {
            if (state.form.country.trim().isEmpty) {
              ToastUtils.show(
                context,
                l10n.profileSetupSelectCountryFirst,
                type: ToastType.info,
              );
              return;
            }

            _showSingleChoiceSheet(
              context,
              title: l10n.profileSetupSelectCityTitle,
              options: cityOptions,
              selected: state.form.city,
              searchHintText: l10n.profileSetupSearchCityHint,
              onSelected: (value) => _updateForm(
                context,
                state,
                (form) => form.copyWith(city: value),
              ),
            );
          },
        );
      case ProfileSetupStep.body:
        return ProfileSetupBodyTypeSection(
          key: key,
          errors: state.validationErrors,
          options: bodyTypeOptions,
          selectedValue: state.form.bodyType,
          onSelected: (value) => _updateForm(
            context,
            state,
            (form) => form.copyWith(bodyType: value),
          ),
        );
      case ProfileSetupStep.skin:
        return ProfileSetupSkinSection(
          key: key,
          form: state.form,
          errors: state.validationErrors,
          skinToneOptions: skinToneOptions,
          onSkinToneSelected: (option) => _updateForm(
            context,
            state,
            (form) => form.copyWith(skinTone: option.value),
          ),
        );
      case ProfileSetupStep.style:
        return ProfileSetupStyleSection(
          key: key,
          form: state.form,
          errors: state.validationErrors,
          styleOptions: styleOptions,
          onStyleToggled: (value) => _toggleMultiValue(
            context,
            state,
            currentValues: state.form.stylePreferences,
            value: value,
            updater: (form, values) => form.copyWith(stylePreferences: values),
          ),
          onMinBudgetChanged: (value) => _updateForm(
            context,
            state,
            (form) => form.copyWith(budgetMin: value),
          ),
          onMaxBudgetChanged: (value) => _updateForm(
            context,
            state,
            (form) => form.copyWith(budgetMax: value),
          ),
          currencySymbol: l10n.profileSetupBudgetCurrencySymbol,
        );
      case ProfileSetupStep.height:
        return ProfileSetupHeightSection(
          key: key,
          form: state.form,
          isInteracted: state.interactedSteps.contains(ProfileSetupStep.height),
          errors: state.validationErrors,
          onInteractionStarted: () {
            context.read<ProfileSetupBloc>().add(
              const ProfileSetupStepInteracted(ProfileSetupStep.height),
            );
          },
          onUnitChanged: (value) => _updateForm(
            context,
            state,
            (form) => _changeHeightUnit(form, value),
          ),
          onTotalInchesChanged: (value) => _updateForm(
            context,
            state,
            (form) => _formWithHeightInches(form, value),
          ),
          onCentimetersChanged: (value) => _updateForm(
            context,
            state,
            (form) => _formWithHeightCentimeters(form, value),
          ),
        );
      case ProfileSetupStep.weight:
        return ProfileSetupWeightSection(
          key: key,
          form: state.form,
          isInteracted: state.interactedSteps.contains(ProfileSetupStep.weight),
          errors: state.validationErrors,
          onInteractionStarted: () {
            context.read<ProfileSetupBloc>().add(
              const ProfileSetupStepInteracted(ProfileSetupStep.weight),
            );
          },
          onUnitChanged: (value) => _updateForm(
            context,
            state,
            (form) => _changeWeightUnit(form, value),
          ),
          onWeightChanged: (value) => _updateForm(
            context,
            state,
            (form) => _formWithWeightValue(form, value),
          ),
        );
      case ProfileSetupStep.brands:
        return ProfileSetupBrandsSection(
          key: key,
          form: state.form,
          errors: state.validationErrors,
          availableBrands: state.availableBrands,
          brandLoadStatus: state.brandLoadStatus,
          brandErrorMessage: state.brandErrorMessage,
          onBrandToggled: (value) => _toggleMultiValue(
            context,
            state,
            currentValues: state.form.preferredBrands,
            value: value,
            updater: (form, values) => form.copyWith(preferredBrands: values),
          ),
          onSeeMoreBrandsPressed: () => _showBrandPickerSheet(context, state),
          onRetryBrandsPressed: () {
            context.read<ProfileSetupBloc>().add(
              const ProfileSetupBrandsRequested(),
            );
          },
        );
      case ProfileSetupStep.colors:
        return ProfileSetupColorsSection(
          key: key,
          errors: state.validationErrors,
          selectedColorOptions: selectedColorOptions,
          onPickColorsPressed: () => _showColorPickerSheet(context, state),
        );
      case ProfileSetupStep.avoids:
        return ProfileSetupAvoidsSection(
          key: key,
          form: state.form,
          errors: state.validationErrors,
          options: avoidStyleOptions,
          onStyleToggled: (value) => _toggleMultiValue(
            context,
            state,
            currentValues: state.form.avoidStylesList,
            value: value,
            updater: (form, values) =>
                form.copyWith(avoidStyles: values.join(', ')),
          ),
        );
      case ProfileSetupStep.photo:
        return ProfileSetupPhotosSection(
          key: key,
          form: state.form,
          onUploadPressed: () => _showUploadSheet(context, state),
          onReplaceChanged: (value) => _updateForm(
            context,
            state,
            (form) => form.copyWith(replaceWardrobe: value),
          ),
          onRemoveLocalFile: (index) => _updateForm(context, state, (form) {
            final nextFiles = [...form.wardrobeFiles]..removeAt(index);
            return form.copyWith(wardrobeFiles: nextFiles);
          }),
        );
    }
  }

  Future<void> _pickDate(BuildContext context, ProfileSetupState state) async {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final firstDate = DateTime(1940);
    final lastDate = DateTime(now.year - 10, now.month, now.day);
    final initialDate = _clampDate(
      state.form.dateOfBirth ?? DateTime(now.year - 22, now.month, now.day),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ProfileSetupDatePickerSheet(
          title: l10n.profileSetupDateOfBirthLabel,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );
      },
    );

    if (selectedDate == null || !context.mounted) {
      return;
    }

    _updateForm(
      context,
      state,
      (form) => form.copyWith(dateOfBirth: selectedDate),
    );
  }

  Future<void> _showColorPickerSheet(
    BuildContext context,
    ProfileSetupState state,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.76,
          child: ProfileSetupColorPickerSheet(
            title: l10n.profileSetupPreferredColorsLabel,
            selectedValues: state.form.favoriteColors,
            onApplied: (values) {
              _updateForm(
                context,
                state,
                (form) => form.copyWith(favoriteColors: values),
              );
              Navigator.of(sheetContext).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> _showBrandPickerSheet(
    BuildContext context,
    ProfileSetupState state,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    if (state.brandLoadStatus == ProfileSetupBrandLoadStatus.loading &&
        state.availableBrands.isEmpty) {
      ToastUtils.show(
        context,
        l10n.profileSetupPreparing,
        type: ToastType.info,
      );
      return;
    }

    if (state.availableBrands.isEmpty) {
      ToastUtils.show(
        context,
        state.brandErrorMessage ?? l10n.profileSetupNoOptionsAvailable,
        type: ToastType.info,
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.88,
          child: ProfileSetupBrandPickerSheet(
            title: l10n.profileSetupPreferredBrandsLabel,
            brands: state.availableBrands,
            initialSelectedValues: state.form.preferredBrands,
            onApplied: (values) {
              _updateForm(
                context,
                state,
                (form) => form.copyWith(preferredBrands: values),
              );
              Navigator.of(sheetContext).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> _showSingleChoiceSheet(
    BuildContext context, {
    required String title,
    required List<ProfileSetupOption> options,
    required String? selected,
    required ValueChanged<String> onSelected,
    String? searchHintText,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    if (options.isEmpty) {
      ToastUtils.show(
        context,
        l10n.profileSetupNoOptionsAvailable,
        type: ToastType.info,
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return ProfileSetupOptionSheet(
          title: title,
          options: options,
          selectedValue: selected,
          searchHintText: searchHintText,
          onSelected: (value) {
            onSelected(value);
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  Future<void> _showUploadSheet(
    BuildContext context,
    ProfileSetupState state,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (_) {
        return ProfileSetupUploadPickerSheet(
          onPicked: (files) {
            final nextFiles = _mergeFiles(state.form.wardrobeFiles, files);
            context.read<ProfileSetupBloc>().add(
              ProfileSetupDraftUpdated(
                state.form.copyWith(wardrobeFiles: nextFiles),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleMultiValue(
    BuildContext context,
    ProfileSetupState state, {
    required List<String> currentValues,
    required String value,
    required ProfileSetupFormData Function(
      ProfileSetupFormData form,
      List<String> nextValues,
    )
    updater,
  }) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      return;
    }

    final nextValues = [...currentValues];
    if (ProfileSetupLocalizedContent.containsValue(
      nextValues,
      normalizedValue,
    )) {
      nextValues.removeWhere(
        (selectedValue) => ProfileSetupLocalizedContent.matchesValue(
          selectedValue,
          normalizedValue,
        ),
      );
    } else {
      nextValues.add(normalizedValue);
    }

    context.read<ProfileSetupBloc>().add(
      ProfileSetupDraftUpdated(updater(state.form, nextValues)),
    );
  }

  void _updateForm(
    BuildContext context,
    ProfileSetupState state,
    ProfileSetupFormData Function(ProfileSetupFormData form) updater,
  ) {
    context.read<ProfileSetupBloc>().add(
      ProfileSetupDraftUpdated(updater(state.form)),
    );
  }

  void _handleExit(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(RoutePaths.wardrobes);
  }

  void _handleBack(BuildContext context, ProfileSetupState state) {
    if (state.currentStep != ProfileSetupStep.basics) {
      context.read<ProfileSetupBloc>().add(const ProfileSetupBackRequested());
      return;
    }

    _handleExit(context);
  }

  List<File> _mergeFiles(List<File> currentFiles, List<File> newFiles) {
    final merged = <String, File>{};
    for (final file in [...currentFiles, ...newFiles]) {
      merged[file.path] = file;
    }
    return merged.values.toList(growable: false);
  }

  ProfileSetupFormData _changeHeightUnit(
    ProfileSetupFormData form,
    ProfileSetupHeightUnit unit,
  ) {
    if (form.heightUnit == unit) {
      return form;
    }

    if (!form.hasValidHeight) {
      return form.copyWith(
        heightUnit: unit,
        heightCm: '',
        heightFeet: '',
        heightInches: '',
      );
    }

    if (unit == ProfileSetupHeightUnit.centimeters) {
      final inches = form.resolvedHeightInches();
      final centimeters = (inches * 2.54).round();
      return _formWithHeightCentimeters(form, centimeters);
    }

    final centimeters = form.resolvedHeightCentimeters();
    final totalInches = (centimeters / 2.54).round();
    return _formWithHeightInches(form, totalInches);
  }

  ProfileSetupFormData _formWithHeightInches(
    ProfileSetupFormData form,
    int totalInches,
  ) {
    final clampedInches = totalInches.clamp(48, 84);
    final feet = clampedInches ~/ 12;
    final inches = clampedInches % 12;
    return form.copyWith(
      heightUnit: ProfileSetupHeightUnit.feetInches,
      heightFeet: feet.toString(),
      heightInches: inches.toString(),
      heightCm: '',
    );
  }

  ProfileSetupFormData _formWithHeightCentimeters(
    ProfileSetupFormData form,
    int centimeters,
  ) {
    final clampedCentimeters = centimeters.clamp(120, 220);
    return form.copyWith(
      heightUnit: ProfileSetupHeightUnit.centimeters,
      heightCm: clampedCentimeters.toString(),
      heightFeet: '',
      heightInches: '',
    );
  }

  ProfileSetupFormData _changeWeightUnit(
    ProfileSetupFormData form,
    ProfileSetupWeightUnit unit,
  ) {
    if (form.weightUnit == unit) {
      return form;
    }

    if (!form.hasValidWeight) {
      return form.copyWith(weightUnit: unit, weight: '');
    }

    final weight = form.resolvedWeightValue();
    final convertedWeight = unit == ProfileSetupWeightUnit.kilograms
        ? weight / 2.20462
        : weight * 2.20462;

    return _formWithWeightValue(
      form.copyWith(weightUnit: unit),
      convertedWeight.round(),
    );
  }

  ProfileSetupFormData _formWithWeightValue(
    ProfileSetupFormData form,
    num value,
  ) {
    final minimum = form.weightUnit == ProfileSetupWeightUnit.kilograms
        ? 35
        : 80;
    final maximum = form.weightUnit == ProfileSetupWeightUnit.kilograms
        ? 145
        : 320;
    final clampedValue = value.round().clamp(minimum, maximum);
    return form.copyWith(weight: clampedValue.toString());
  }

  List<ProfileSetupOption> _resolveCountryOptions(
    AppLocalizations l10n, {
    required bool isArabic,
  }) {
    final packageOptions = _locationService.countryOptions(isArabic: isArabic);
    return packageOptions.isNotEmpty
        ? packageOptions
        : ProfileSetupLocalizedContent.countryOptions(l10n);
  }

  List<ProfileSetupOption> _resolveCityOptions(
    AppLocalizations l10n, {
    required bool isArabic,
    required String countryValue,
  }) {
    if (countryValue.trim().isEmpty) {
      return const <ProfileSetupOption>[];
    }

    final packageOptions = _locationService.cityOptions(
      countryValue: countryValue,
      isArabic: isArabic,
    );
    return packageOptions.isNotEmpty
        ? packageOptions
        : ProfileSetupLocalizedContent.cityOptions(l10n, countryValue);
  }

  DateTime _clampDate(
    DateTime value, {
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    if (value.isBefore(firstDate)) {
      return firstDate;
    }
    if (value.isAfter(lastDate)) {
      return lastDate;
    }
    return value;
  }
}
