import 'dart:io';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/app_picker_utils.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/address/barrels/address_barrels.dart';
import 'package:drip_talk/features/auth/barrels/auth_barrels.dart';
import 'package:drip_talk/features/dashboard/barrels/dashboard_barrels.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
part 'widgets/edit_profile_view_widgets.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) =>
              previous.saveStatus != current.saveStatus ||
              previous.feedbackMessage != current.feedbackMessage,
          listener: (context, state) {
            final feedbackMessage = state.feedbackMessage?.trim();
            if (feedbackMessage != null && feedbackMessage.isNotEmpty) {
              final toastType =
                  state.saveStatus == EditProfileSaveStatus.failure ||
                      state.twoFactorVerificationStatus ==
                          EditProfileTwoFactorVerificationStatus.failure
                  ? ToastType.error
                  : state.saveStatus == EditProfileSaveStatus.success ||
                        state.twoFactorVerificationStatus ==
                            EditProfileTwoFactorVerificationStatus.success
                  ? ToastType.success
                  : ToastType.info;
              ToastUtils.show(context, feedbackMessage, type: toastType);
            }

            if (state.saveStatus == EditProfileSaveStatus.success &&
                state.twoFactorSetup == null) {
              context.pop(true);
            }
          },
        ),
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) =>
              previous.twoFactorSetup != current.twoFactorSetup &&
              current.twoFactorSetup != null,
          listener: (context, state) async {
            if (state.twoFactorSetup == null) {
              return;
            }
            await _runTwoFactorFlow(context, state.twoFactorSetup!);
          },
        ),
      ],
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          return AppResponsivePageLayout(
            mobileMaxWidth: 430,
            tabletMaxWidth: 560,
            tabletLargeMaxWidth: 640,
            desktopMaxWidth: 720,
            showHeaderDivider: false,
            pageBuilder: (context, _) => GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: state.isInitialLoading
                  ? const EditProfileLoadingView()
                  : state.loadStatus == EditProfileLoadStatus.failure &&
                        state.profile == null
                  ? _FailureView(
                      title: l10n.editProfileLoadFailed,
                      message: state.loadErrorMessage?.trim().isNotEmpty == true
                          ? state.loadErrorMessage!.trim()
                          : l10n.somethingWentWrong,
                      onRetry: () {
                        context.read<EditProfileBloc>().add(
                          const LoadEditProfileRequested(),
                        );
                      },
                    )
                  : _buildContent(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, EditProfileState state) {
    final l10n = AppLocalizations.of(context)!;
    final profile = state.profile;
    final hasProfileIdentity =
        profile?.name?.trim().isNotEmpty == true ||
        profile?.email?.trim().isNotEmpty == true;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final horizontalPadding = context.responsive(
      AppSizes.s20.toDouble(),
      tablet: 24.0,
      tabletLarge: 28.0,
      desktop: 32.0,
    );
    final topPadding = context.responsive(
      AppSizes.s12.toDouble(),
      tablet: 16.0,
      tabletLarge: 18.0,
      desktop: 20.0,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        keyboardInset + AppSizes.s24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(
            title: l10n.editProfileScreenTitle,
            subtitle: l10n.editProfileScreenSubtitle,
            onBack: () => context.pop(),
          ),
          const AppGap(AppSizes.s24),
          Center(
            child: Column(
              children: [
                _ProfileImagePicker(
                  imageFile: state.selectedProfileImageFile,
                  imageUrl: profile?.profileImage,
                  initials: hasProfileIdentity
                      ? (profile?.initials ??
                            AppLocalizations.of(context)!.profileGuestInitials)
                      : AppLocalizations.of(context)!.profileGuestInitials,
                  onTap: () => _showImageSourceSheet(context),
                ),
                const AppGap(AppSizes.s14),
                AppText(
                  text: l10n.editProfileUploadPhotoLabel,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.ts16(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const AppGap(AppSizes.s28),
          _ProfileSectionTitle(
            icon: Icons.person_rounded,
            title: l10n.editProfilePersonalInformation,
          ),
          const AppGap(AppSizes.s18),
          AppTextField(
            initialValue: state.name,
            labelText: l10n.editProfileFullNameLabel,
            hintText: l10n.editProfileFullNameHint,
            isRequired: true,
            borderRadius: AppRadius.r24,
            errorText:
                state.nameValidationError ==
                    EditProfileNameValidationError.empty
                ? l10n.editProfileNameRequired
                : null,
            onChanged: (value) => context.read<EditProfileBloc>().add(
              EditProfileNameChanged(value),
            ),
          ),
          const AppGap(AppSizes.s16),
          // TODO: Username field - hidden for future implementation
          // AppTextField(
          //   initialValue: state.username,
          //   labelText: l10n.editProfileUsernameLabel,
          //   hintText: l10n.editProfileUsernameHint,
          //   borderRadius: AppRadius.r24,
          //   onChanged: (value) => context.read<EditProfileBloc>().add(
          //     EditProfileUsernameChanged(value),
          //   ),
          // ),
          // const AppGap(AppSizes.s6),
          // AppText(
          //   text: l10n.editProfileUsernameNote,
          //   style: AppTextStyles.ts12(
          //     context,
          //     color: AppColors.pureWhite.withValues(alpha: 0.7),
          //   ),
          // ),
          // const AppGap(AppSizes.s16),
          AppTextField(
            initialValue: state.phone,
            labelText: l10n.editProfilePhoneLabel,
            hintText: l10n.editProfilePhoneHint,
            isPhone: true,
            countryDialCode: state.countryDialCode,
            keyboardType: TextInputType.phone,
            borderRadius: AppRadius.r24,
            errorText:
                state.phoneValidationError ==
                    EditProfilePhoneValidationError.invalid
                ? l10n.editProfilePhoneInvalid
                : null,
            onCountryChanged: (code) => context.read<EditProfileBloc>().add(
              EditProfileCountryDialCodeChanged(
                code.dialCode ?? state.countryDialCode,
              ),
            ),
            onChanged: (value) => context.read<EditProfileBloc>().add(
              EditProfilePhoneChanged(value),
            ),
          ),
          const AppGap(AppSizes.s16),
          _SelectionField(
            label: l10n.editProfileDateOfBirthLabel,
            value: state.selectedDateOfBirth == null
                ? ''
                : DateFormat('MM/dd/yyyy').format(state.selectedDateOfBirth!),
            hintText: l10n.editProfileDateOfBirthHint,
            trailing: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.pureBlack,
              size: AppSizes.s18,
            ),
            onTap: () => _selectDateOfBirth(context, state.selectedDateOfBirth),
          ),
          const AppGap(AppSizes.s16),
          _SelectionField(
            label: l10n.editProfileGenderLabel,
            value: _resolvedGenderLabel(l10n, state.selectedGender),
            hintText: l10n.editProfileGenderHint,
            trailing: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.pureBlack,
              size: AppSizes.s24,
            ),
            onTap: () => _showGenderSheet(context, state.selectedGender),
          ),
          const AppGap(AppSizes.s28),
          _ProfileSectionTitle(
            icon: Icons.location_on_rounded,
            title: l10n.editProfileDefaultAddressTitle,
          ),
          const AppGap(AppSizes.s16),
          _DefaultAddressCard(
            address: state.defaultAddress,
            country: profile?.country,
          ),

          const AppGap(AppSizes.s28),
          _ProfileSectionTitle(
            icon: Icons.style_rounded,
            title: l10n.editProfileInterestsTitle,
          ),
          const AppGap(AppSizes.s16),
          AppButton(
            text: l10n.editProfileEditInterestsAction,
            onPressed: () => _openEditInterests(context),
            height: AppSizes.s50,
            borderRadius: AppRadius.circular,
            backgroundColor: AppColors.infoCardBackground,
            borderColor: AppColors.infoCardBorder,
            leadingIcon: const Icon(
              Icons.style_rounded,
              size: AppSizes.s16,
              color: AppColors.pureWhite,
            ),
            fontSize: AppSizes.s14,
          ),
          const AppGap(AppSizes.s14),
          AppButton(
            text: l10n.editProfileManageAddresses,
            onPressed: () => _openManageAddresses(context),
            height: AppSizes.s50,
            borderRadius: AppRadius.circular,
            backgroundColor: AppColors.infoCardBackground,
            borderColor: AppColors.infoCardBorder,
            leadingIcon: const Icon(
              Icons.location_on_rounded,
              size: AppSizes.s16,
              color: AppColors.pureWhite,
            ),
            fontSize: AppSizes.s14,
          ),
          const AppGap(AppSizes.s28),
          _SecuritySection(
            twoFactorEnabled: state.twoFactorEnabled,
            isTwoFactorLoading: state.isTwoFactorBusy,
            onToggleTwoFactor: (value) => context.read<EditProfileBloc>().add(
              EditProfileTwoFactorChanged(value),
            ),
            biometricEnabled: state.biometricEnabled,
            onToggleBiometric: (value) => context.read<EditProfileBloc>().add(
              EditProfileBiometricChanged(value),
            ),
            onChangePassword: () =>
                _openChangePasswordFlow(context, profile?.email ?? ''),
          ),
          const AppGap(AppSizes.s28),
          AppButton(
            text: l10n.editProfileSaveAction,
            isLoading: state.isSaving,
            onPressed: state.isTwoFactorBusy
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    context.read<EditProfileBloc>().add(
                      const SaveEditProfileRequested(),
                    );
                  },
            height: AppSizes.s56,
            borderRadius: AppRadius.circular,
            gradientColors: const [AppColors.secondary, AppColors.primary],
          ),
        ],
      ),
    );
  }

  Future<void> _runTwoFactorFlow(
    BuildContext context,
    TwoFactorSetupData setup,
  ) async {
    while (context.mounted) {
      final setupResult = await TwoFactorSetupSheet.show(context, setup: setup);

      if (!context.mounted) {
        return;
      }

      if (setupResult != TwoFactorSetupSheetResult.next) {
        context.read<EditProfileBloc>().add(
          const DismissEditProfileTwoFactorSetupRequested(),
        );
        return;
      }

      final verifyResult = await TwoFactorVerifySheet.show(context);
      if (!context.mounted) {
        return;
      }

      if (verifyResult == TwoFactorVerifySheetResult.verified) {
        return;
      }

      if (verifyResult == TwoFactorVerifySheetResult.rescan) {
        continue;
      }

      context.read<EditProfileBloc>().add(
        const DismissEditProfileTwoFactorSetupRequested(),
      );
      return;
    }
  }

  Future<void> _openEditInterests(BuildContext context) async {
    final didUpdate = await context.pushNamed(
      AppRoutes.profileSetup,
      extra: true,
    );
    if (!context.mounted || didUpdate != true) {
      return;
    }

    context.read<EditProfileBloc>().add(
      const LoadEditProfileRequested(
        showLoader: false,
        preserveFormValues: true,
      ),
    );
  }

  Future<void> _openManageAddresses(BuildContext context) async {
    await context.pushNamed(AppRoutes.myAddresses);
    if (!context.mounted) {
      return;
    }

    context.read<EditProfileBloc>().add(
      const LoadEditProfileRequested(
        showLoader: false,
        preserveFormValues: true,
      ),
    );
  }

  Future<void> _openChangePasswordFlow(
    BuildContext context,
    String email,
  ) async {
    final didChangePassword = await context.pushNamed(
      AppRoutes.forgotPassword,
      queryParameters: {
        'email': email,
        'source': PasswordResetSource.profile.queryValue,
      },
    );
    if (!context.mounted || didChangePassword != true) {
      return;
    }

    context.read<EditProfileBloc>().add(
      const LoadEditProfileRequested(
        showLoader: false,
        preserveFormValues: true,
      ),
    );
  }

  Future<void> _showImageSourceSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.only(top: 1.2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.r30),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s24,
              AppSizes.s18,
              AppSizes.s24,
              AppSizes.s24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.r30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppSizes.s56,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                ),
                const AppGap(AppSizes.s20),
                AppText(
                  text: l10n.editProfilePhotoSourceTitle,
                  style: AppTextStyles.ts20(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const AppGap(AppSizes.s20),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: l10n.editProfilePhotoCameraAction,
                        onPressed: () => _pickProfileImage(
                          context,
                          ImageSource.camera,
                          sheetContext,
                        ),
                        height: AppSizes.s50,
                        borderRadius: AppRadius.r16,
                        backgroundColor: AppColors.lightBg.withValues(
                          alpha: 0.72,
                        ),
                        borderColor: AppColors.pureWhite.withValues(
                          alpha: 0.16,
                        ),
                        leadingIcon: const Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.pureWhite,
                          size: AppSizes.s18,
                        ),
                        fontSize: AppSizes.s14,
                      ),
                    ),
                    const AppGap(AppSizes.s12, axis: Axis.horizontal),
                    Expanded(
                      child: AppButton(
                        text: l10n.editProfilePhotoGalleryAction,
                        onPressed: () => _pickProfileImage(
                          context,
                          ImageSource.gallery,
                          sheetContext,
                        ),
                        height: AppSizes.s50,
                        borderRadius: AppRadius.r16,
                        gradientColors: const [
                          AppColors.secondary,
                          AppColors.primary,
                        ],
                        leadingIcon: const Icon(
                          Icons.photo_library_outlined,
                          color: AppColors.pureWhite,
                          size: AppSizes.s18,
                        ),
                        fontSize: AppSizes.s14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickProfileImage(
    BuildContext context,
    ImageSource source,
    BuildContext sheetContext,
  ) async {
    final navigator = Navigator.of(sheetContext);
    final files = await AppPickerUtils.pickImages(
      multiple: false,
      source: source,
      imageQuality: 85,
    );

    navigator.pop();

    if (!context.mounted || files.isEmpty) {
      return;
    }

    context.read<EditProfileBloc>().add(EditProfileImageChanged(files.first));
  }

  Future<void> _selectDateOfBirth(
    BuildContext context,
    DateTime? currentDate,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final initialDate =
        currentDate ?? DateTime(DateTime.now().year - 18, DateTime.now().month);

    DateTime tempPickedDate = initialDate;

    final pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.r30),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s24,
              AppSizes.s18,
              AppSizes.s24,
              AppSizes.s24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.r30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: AppSizes.s56,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                    ),
                  ),
                ),
                const AppGap(AppSizes.s20),
                AppText(
                  text: l10n.editProfileDateOfBirthLabel,
                  style: AppTextStyles.ts20(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const AppGap(AppSizes.s14),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.secondary,
                      onPrimary: AppColors.pureWhite,
                      surface: AppColors.lightBg,
                      onSurface: AppColors.pureWhite,
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    onDateChanged: (DateTime date) {
                      tempPickedDate = date;
                    },
                  ),
                ),
                const AppGap(AppSizes.s20),
                AppButton(
                  text: l10n.editProfileSaveAction,
                  onPressed: () =>
                      Navigator.of(sheetContext).pop(tempPickedDate),
                  height: AppSizes.s50,
                  borderRadius: AppRadius.r16,
                  gradientColors: const [
                    AppColors.secondary,
                    AppColors.primary,
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedDate == null || !context.mounted) {
      return;
    }

    context.read<EditProfileBloc>().add(
      EditProfileDateOfBirthChanged(pickedDate),
    );
  }

  Future<void> _showGenderSheet(
    BuildContext context,
    String? selectedGenderValue,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final selectedGender = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        final options = <MapEntry<String, String>>[
          MapEntry('male', l10n.chatGenderMale),
          MapEntry('female', l10n.chatGenderFemale),
          MapEntry('non-binary', l10n.chatGenderNonBinary),
          MapEntry('prefer-not-to-say', l10n.chatGenderPreferNotSay),
        ];

        return Container(
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.r30),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s24,
              AppSizes.s18,
              AppSizes.s24,
              AppSizes.s24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.r30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: AppSizes.s56,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                    ),
                  ),
                ),
                const AppGap(AppSizes.s20),
                AppText(
                  text: l10n.editProfileGenderSheetTitle,
                  style: AppTextStyles.ts20(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const AppGap(AppSizes.s14),
                ...options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.s10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      onTap: () => Navigator.of(sheetContext).pop(option.key),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s16,
                          vertical: AppSizes.s16,
                        ),
                        decoration: BoxDecoration(
                          color: selectedGenderValue == option.key
                              ? AppColors.secondary.withValues(alpha: 0.16)
                              : AppColors.secondary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                          border: Border.all(
                            color: selectedGenderValue == option.key
                                ? AppColors.secondary
                                : AppColors.secondary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: AppText(
                          text: option.value,
                          style: AppTextStyles.ts16(
                            context,
                            color: AppColors.pureWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!context.mounted || selectedGender == null) {
      return;
    }

    context.read<EditProfileBloc>().add(
      EditProfileGenderChanged(selectedGender),
    );
  }

  String _resolvedGenderLabel(AppLocalizations l10n, String? selectedGender) {
    switch (selectedGender) {
      case 'male':
        return l10n.chatGenderMale;
      case 'female':
        return l10n.chatGenderFemale;
      case 'non-binary':
        return l10n.chatGenderNonBinary;
      case 'prefer-not-to-say':
        return l10n.chatGenderPreferNotSay;
      default:
        return '';
    }
  }
}
