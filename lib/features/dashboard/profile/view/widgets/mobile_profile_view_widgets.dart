part of '../mobile_profile_view.dart';

class _ProfileSummarySection extends StatelessWidget {
  const _ProfileSummarySection({required this.state});

  final EditProfileState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = state.profile;
    final details = _buildDetailLines(profile, l10n);
    final displayName = _buildDisplayName(profile, l10n);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileAvatar(
          profile: profile,
          isLoading: state.isInitialLoading,
          fallbackInitials: _buildInitials(profile, l10n),
        ),
        AppGap(AppSizes.s10, axis: Axis.horizontal),
        Expanded(
          child: state.isInitialLoading
              ? const _ProfileTextSkeleton()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.ts18(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ...details.map(
                      (detail) => Padding(
                        padding: const EdgeInsets.only(top: AppSizes.s2),
                        child: AppText(
                          text: detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.ts12(
                            context,
                            color: AppColors.pureWhite.withValues(alpha: 0.88),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  List<String> _buildDetailLines(ProfileData? profile, AppLocalizations l10n) {
    if (profile == null) {
      return [l10n.editProfileFieldNotSet, l10n.editProfileFieldNotSet];
    }

    final primaryDetail = profile.email?.trim().isNotEmpty == true
        ? profile.email!.trim()
        : profile.name?.trim().isNotEmpty == true
        ? profile.usernameHandle
        : l10n.editProfileFieldNotSet;
    final secondaryDetail = profile.phone?.trim().isNotEmpty == true
        ? profile.phone!.trim()
        : profile.createdAt != null
        ? l10n.memberSince(profile.createdAt!.year.toString())
        : l10n.editProfileFieldNotSet;

    return [primaryDetail, secondaryDetail];
  }

  String _buildDisplayName(ProfileData? profile, AppLocalizations l10n) {
    if (profile == null) {
      return l10n.profileGuestName;
    }

    final normalizedName = profile.name?.trim();
    if (normalizedName != null && normalizedName.isNotEmpty) {
      return normalizedName;
    }

    final normalizedEmail = profile.email?.trim();
    if (normalizedEmail != null && normalizedEmail.isNotEmpty) {
      return normalizedEmail.split('@').first;
    }

    return l10n.profileGuestName;
  }

  String _buildInitials(ProfileData? profile, AppLocalizations l10n) {
    final hasIdentity =
        profile?.name?.trim().isNotEmpty == true ||
        profile?.email?.trim().isNotEmpty == true;
    if (!hasIdentity) {
      return l10n.profileGuestInitials;
    }

    return profile?.initials ?? l10n.profileGuestInitials;
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.profile,
    required this.isLoading,
    required this.fallbackInitials,
  });

  final ProfileData? profile;
  final bool isLoading;
  final String fallbackInitials;

  String get _resolvedInitials {
    final hasIdentity =
        profile?.name?.trim().isNotEmpty == true ||
        profile?.email?.trim().isNotEmpty == true;
    if (!hasIdentity) {
      return fallbackInitials;
    }

    return profile?.initials ?? fallbackInitials;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolvedNetworkImage(profile?.profileImage);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppSizes.s64,
          height: AppSizes.s64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
          ),
          padding: const EdgeInsets.all(1.4),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.lightBg.withValues(alpha: 0.86),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: isLoading
                  ? const ProfileAvatarShimmer()
                  : imageUrl != null
                  ? AppCachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: const ProfileAvatarShimmer(),
                      errorWidget: _AvatarFallback(initials: _resolvedInitials),
                    )
                  : _AvatarFallback(initials: _resolvedInitials),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -2,
          child: Container(
            width: AppSizes.s18,
            height: AppSizes.s18,
            decoration: const BoxDecoration(
              color: AppColors.lightBg,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(3),
            child: AppAssetImage(
              assetPath: Assets.iconsCamera,
              width: AppSizes.s12,
              height: AppSizes.s12,
            ),
          ),
        ),
      ],
    );
  }

  String? _resolvedNetworkImage(String? rawValue) {
    final normalized = rawValue?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(normalized);
    return uri?.hasScheme == true ? normalized : null;
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
        style: AppTextStyles.ts20(
          context,
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProfileTextSkeleton extends StatelessWidget {
  const _ProfileTextSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonBar(width: 120, height: AppSizes.s18),
        AppGap(AppSizes.s6),
        _SkeletonBar(width: 150, height: AppSizes.s12),
        AppGap(AppSizes.s6),
        _SkeletonBar(width: 104, height: AppSizes.s12),
      ],
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
    );
  }
}
