part of '../edit_profile_view.dart';

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({
    required this.twoFactorEnabled,
    required this.isTwoFactorLoading,
    required this.onToggleTwoFactor,
    required this.biometricEnabled,
    required this.onToggleBiometric,
    required this.onChangePassword,
  });

  final bool twoFactorEnabled;
  final bool isTwoFactorLoading;
  final ValueChanged<bool> onToggleTwoFactor;
  final bool biometricEnabled;
  final ValueChanged<bool> onToggleBiometric;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s18),
      decoration: BoxDecoration(
        color: AppColors.lightBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAssetImage(
                assetPath: Assets.security,
                width: AppSizes.s18,
                height: AppSizes.s18,
              ),
              const AppGap(AppSizes.s8, axis: Axis.horizontal),
              AppText(
                text: l10n.security.toUpperCase(),
                style: AppTextStyles.ts20(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const AppGap(AppSizes.s16),
          _SecurityTile(
            icon: Icons.lock_reset_rounded,
            title: l10n.changePassword,
            onTap: onChangePassword,
          ),
          const AppGap(AppSizes.s12),
          _SecurityToggleTile(
            icon: Icons.verified_user_outlined,
            title: l10n.editProfileTwoFactorTitle,
            value: twoFactorEnabled,
            isLoading: isTwoFactorLoading,
            onChanged: onToggleTwoFactor,
          ),
          const AppGap(AppSizes.s12),
          _SecurityToggleTile(
            icon: Icons.fingerprint_rounded,
            title: l10n.editProfileBiometricTitle,
            value: biometricEnabled,
            onChanged: onToggleBiometric,
          ),
        ],
      ),
    );
  }
}

class _SecurityTile extends StatelessWidget {
  const _SecurityTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16,
          vertical: AppSizes.s14,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondary, size: AppSizes.s18),
            const AppGap(AppSizes.s10, axis: Axis.horizontal),
            Expanded(
              child: AppText(
                text: title,
                style: AppTextStyles.ts12(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.secondary,
              size: AppSizes.s24,
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityToggleTile extends StatelessWidget {
  const _SecurityToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s16,
        vertical: AppSizes.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: AppSizes.s18),
          const AppGap(AppSizes.s10, axis: Axis.horizontal),
          Expanded(
            child: AppText(
              text: title,
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          isLoading
              ? const SizedBox(
                  width: AppSizes.s20,
                  height: AppSizes.s20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.secondary,
                  ),
                )
              : Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: AppColors.pureWhite,
                  activeTrackColor: AppColors.secondary,
                  inactiveThumbColor: AppColors.pureWhite,
                  inactiveTrackColor: AppColors.pureWhite.withValues(
                    alpha: 0.26,
                  ),
                  trackOutlineColor: const WidgetStatePropertyAll(
                    AppColors.transparent,
                  ),
                ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GradientBorder(
              padding: const EdgeInsets.all(AppSizes.s8),
              onTap: onBack,
              enableShadow: false,
              backgroundColor: AppColors.lightBg,
              borderRadius: AppRadius.r12,
              colors: const [AppColors.primary, AppColors.secondary],
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.surface,
                size: AppSizes.s20,
              ),
            ),
            const AppGap(AppSizes.s12, axis: Axis.horizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    style: AppTextStyles.ts20(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppText(
                    text: subtitle,
                    style: AppTextStyles.ts12(
                      context,
                      color: AppColors.pureWhite.withValues(alpha: 0.74),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const AppGap(AppSizes.s18),
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.secondary.withValues(alpha: 0.35),
        ),
      ],
    );
  }
}

class _ProfileImagePicker extends StatelessWidget {
  const _ProfileImagePicker({
    required this.imageFile,
    required this.imageUrl,
    required this.initials,
    required this.onTap,
  });

  final File? imageFile;
  final String? imageUrl;
  final String initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl?.trim();
    final networkImageUrl =
        normalizedUrl != null &&
            normalizedUrl.isNotEmpty &&
            Uri.tryParse(normalizedUrl)?.hasScheme == true
        ? normalizedUrl
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: AppSizes.s128,
            height: AppSizes.s128,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.lightBg,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: imageFile != null
                    ? Image.file(imageFile!, fit: BoxFit.cover)
                    : networkImageUrl != null
                    ? AppCachedNetworkImage(
                        imageUrl: networkImageUrl,
                        fit: BoxFit.cover,
                        placeholder: const ProfileAvatarShimmer(),
                        errorWidget: _AvatarFallback(initials: initials),
                      )
                    : _AvatarFallback(initials: initials),
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 6,
            child: Container(
              width: AppSizes.s36,
              height: AppSizes.s36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pureWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pureBlack.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: AppAssetImage(
                  assetPath: Assets.iconsCamera,
                  width: AppSizes.s18,
                  height: AppSizes.s18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.18),
      alignment: Alignment.center,
      child: AppText(
        text: initials,
        style: AppTextStyles.ts28(
          context,
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: AppSizes.s18),
        const AppGap(AppSizes.s8, axis: Axis.horizontal),
        AppText(
          text: title,
          style: AppTextStyles.ts20(
            context,
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SelectionField extends StatelessWidget {
  const _SelectionField({
    required this.label,
    required this.value,
    required this.hintText,
    required this.trailing,
    required this.onTap,
  });

  final String label;
  final String value;
  final String hintText;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          style: AppTextStyles.ts16(
            context,
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
        const AppGap(AppSizes.s8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.r24),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s16,
              vertical: AppSizes.s14,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: AppColors.secondary),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    text: hasValue ? value : hintText,
                    style: AppTextStyles.ts14(
                      context,
                      color: hasValue
                          ? AppColors.pureBlack
                          : AppColors.materialGrey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DefaultAddressCard extends StatelessWidget {
  const _DefaultAddressCard({required this.address, required this.country});

  final AddressListItem? address;
  final String? country;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final addressLine = address?.addressLine?.trim();
    final cityValue = address?.city?.trim();
    final resolvedCountry = country?.trim().isNotEmpty == true
        ? country?.trim() ?? ''
        : l10n.editProfileFieldNotSet;
    final resolvedStreet = addressLine?.isNotEmpty == true
        ? addressLine ?? ''
        : l10n.editProfileNoDefaultAddress;
    final resolvedCity = cityValue?.isNotEmpty == true
        ? cityValue ?? ''
        : l10n.editProfileFieldNotSet;
    final resolvedState = [
      address?.stateProvince?.trim(),
      address?.postalCode?.trim(),
    ].whereType<String>().where((value) => value.isNotEmpty).join(' ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s18),
      decoration: BoxDecoration(
        color: AppColors.lightBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Column(
        children: [
          _InfoRow(label: l10n.editProfileAddressStreet, value: resolvedStreet),
          const AppGap(AppSizes.s12),
          _InfoRow(label: l10n.addAddressCityLabel, value: resolvedCity),
          const AppGap(AppSizes.s12),
          _InfoRow(
            label: l10n.editProfileAddressState,
            value: resolvedState.isEmpty
                ? l10n.editProfileFieldNotSet
                : resolvedState,
          ),
          const AppGap(AppSizes.s12),
          _InfoRow(
            label: l10n.editProfileAddressCountry,
            value: resolvedCountry,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            text: label.toUpperCase(),
            style: AppTextStyles.ts16(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const AppGap(AppSizes.s12, axis: Axis.horizontal),
        Expanded(
          child: AppText(
            text: value,
            textAlign: TextAlign.end,
            maxLines: 2,

            style: AppTextStyles.ts12(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.88),
            ),
          ),
        ),
      ],
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: title,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts24(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
            const AppGap(AppSizes.s10),
            AppText(
              text: message,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.78),
              ),
            ),
            const AppGap(AppSizes.s20),
            AppButton(
              text: AppLocalizations.of(context)!.retry,
              onPressed: onRetry,
              width: 180,
              height: AppSizes.s50,
              borderRadius: AppRadius.circular,
              gradientColors: const [AppColors.secondary, AppColors.primary],
            ),
          ],
        ),
      ),
    );
  }
}
