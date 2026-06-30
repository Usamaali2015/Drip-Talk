import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/api/dio_client.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/auth/barrels/auth_barrels.dart';
import 'package:drip_talk/features/dashboard/barrels/dashboard_barrels.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:drip_talk/l10n/bloc/localization_bloc.dart';
import 'package:drip_talk/l10n/bloc/localization_event.dart';
import 'package:drip_talk/l10n/bloc/localization_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'widgets/mobile_profile_view_widgets.dart';

class MobileProfileView extends StatelessWidget {
  const MobileProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // ── Feature Flags ──────────────────────────────────────────────────────
    // TODO: Set these to true in milestone 2 to show additional sections
    const bool showShoppingSection = false;
    const bool showPaymentsSection = false;
    const bool showSupportSection = false;

    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, state) {
        final currentLang = state.locale.languageCode == 'ar' ? 'AR' : 'ENG';

        return Padding(
          padding: AppPadding.horizontalLarge,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppGap(AppSizes.s24),
                BlocBuilder<EditProfileBloc, EditProfileState>(
                  buildWhen: (previous, current) =>
                      previous.profile != current.profile ||
                      previous.loadStatus != current.loadStatus,
                  builder: (context, profileState) {
                    return GradientContainer(
                      borderRadius: AppRadius.r30,
                      child: Padding(
                        padding: AppPadding.allMediumLarge,
                        child: Column(
                          children: [
                            _ProfileSummarySection(state: profileState),
                            AppGap(AppSizes.s18),
                            AppButton(
                              text: l10n.editProfile,
                              onPressed: () async {
                                final didUpdate = await context.pushNamed(
                                  AppRoutes.editProfile,
                                );
                                if (!context.mounted || didUpdate != true) {
                                  return;
                                }

                                context.read<EditProfileBloc>().add(
                                  const LoadEditProfileRequested(
                                    showLoader: false,
                                  ),
                                );
                              },
                              fontSize: AppSizes.s12,
                              iconGap: AppSizes.s4,
                              leadingIcon: AppAssetImage(
                                assetPath: Assets.iconsEdit,
                              ),
                              borderColor: AppColors.pureWhite,
                              fontWeight: FontWeight.w700,
                              backgroundColor: AppColors.secondary,
                              borderRadius: AppRadius.circular,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                AppGap(AppSizes.s24),
                // ── Shopping Section (Hidden for Milestone 1) ───────────────────
                if (showShoppingSection)
                  GradientContainer(
                    showListTile: true,
                    listAssetPath: Assets.shopping,
                    listTitle: l10n.shopping,
                    items: [
                      GradientListItem(
                        subtitle: l10n.myOrder,
                        iconPath: Assets.myOrder,
                        onTap: () {},
                      ),
                      GradientListItem(
                        subtitle: l10n.trackOrder,
                        iconPath: Assets.iconsLocation,
                        onTap: () {},
                      ),
                      GradientListItem(
                        subtitle: l10n.savedItems,
                        iconPath: Assets.saved,
                        onTap: () => context.pushNamed(AppRoutes.savedItems),
                      ),
                      GradientListItem(
                        subtitle: l10n.myReviews,
                        iconPath: Assets.stars,
                        onTap: () => context.pushNamed(AppRoutes.reviews),
                      ),
                    ],
                  ),
                if (showShoppingSection) AppGap(AppSizes.s24),
                // ── Payments & Address Section (Hidden for Milestone 1) ──────────
                if (showPaymentsSection)
                  GradientContainer(
                    showListTile: true,
                    listAssetPath: Assets.payments,
                    listTitle: l10n.paymentsAndAddress,
                    items: [
                      GradientListItem(
                        subtitle: l10n.saveAddress,
                        iconPath: Assets.iconsLocation,
                        onTap: () => context.pushNamed(AppRoutes.myAddresses),
                      ),
                      GradientListItem(
                        subtitle: l10n.paymentMethods,
                        iconPath: Assets.payments,
                        onTap: () =>
                            context.pushNamed(AppRoutes.paymentMethods),
                      ),
                    ],
                  ),
                if (showPaymentsSection) AppGap(AppSizes.s24),
                // ── Settings Section ──────────────────────────────────────────────
                GradientContainer(
                  showListTile: true,
                  listAssetPath: Assets.settings,
                  listTitle: l10n.settings,
                  items: [
                    GradientListItem(
                      subtitle: l10n.privacyPolicy,
                      iconPath: Assets.password,
                      onTap: () => context.pushNamed(AppRoutes.privacyPolicy),
                    ),

                    GradientListItem(
                      subtitle: l10n.changeLanguage,
                      iconPath: Assets.language,
                      trailingType: TrailingType.language,
                      selectedLanguage: currentLang,
                      onLanguageChange: (lang) {
                        final newLocale = lang == 'AR'
                            ? const Locale('ar')
                            : const Locale('en');
                        if (newLocale == state.locale) {
                          return;
                        }

                        getIt<DioClient>().setLanguageCode(
                          newLocale.languageCode,
                        );
                        context.read<LocalizationBloc>().add(
                          SetLocaleEvent(newLocale),
                        );
                        context.read<EditProfileBloc>().add(
                          const LoadEditProfileRequested(showLoader: false),
                        );
                      },
                    ),
                    GradientListItem(
                      subtitle: l10n.deleteAccount,
                      iconPath: Assets.delete,
                      onTap: () => DeleteAccountSheet.show(context),
                    ),
                  ],
                ),
                AppGap(AppSizes.s24),
                // ── Support Section (Hidden for Milestone 1) ──────────────────
                if (showSupportSection)
                  GradientContainer(
                    showListTile: true,
                    listAssetPath: Assets.support,
                    listTitle: l10n.support,
                    items: [
                      GradientListItem(
                        subtitle: l10n.helpCenter,
                        iconPath: Assets.help,
                        onTap: () => context.pushNamed(AppRoutes.helpCenter),
                      ),
                      GradientListItem(
                        subtitle: l10n.contactSupport,
                        iconPath: Assets.iconsContact,
                        onTap: () =>
                            context.pushNamed(AppRoutes.contactSupport),
                      ),

                      GradientListItem(
                        subtitle: l10n.returnPolicy,
                        iconPath: Assets.returnPolicy,
                        onTap: () => context.pushNamed(AppRoutes.returnPolicy),
                      ),
                      GradientListItem(
                        subtitle: l10n.termsAndConditions,
                        iconPath: Assets.terms,
                        onTap: () =>
                            context.pushNamed(AppRoutes.termsAndConditions),
                      ),
                    ],
                  ),
                if (showSupportSection) AppGap(AppSizes.s24),
                // ── Logout Button ─────────────────────────────────────────────────
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, loginState) {
                    if (loginState is LogoutSuccess) {
                      context.goNamed(
                        AppRoutes.login,
                        queryParameters:
                            loginState.message?.trim().isNotEmpty == true
                            ? {'message': loginState.message!.trim()}
                            : <String, String>{},
                      );
                      return;
                    }

                    if (loginState is LoginError) {
                      ToastUtils.show(
                        context,
                        loginState.message,
                        type: ToastType.error,
                      );
                    }
                  },
                  child: AppButton(
                    height: AppSizes.s56,
                    iconGap: AppSizes.s4,
                    text: l10n.logout,
                    isLoading: context.watch<LoginBloc>().state is LoginLoading,
                    onPressed: () {
                      context.read<LoginBloc>().add(LogoutRequested());
                    },
                    leadingIcon: AppAssetImage(assetPath: Assets.logout),
                    borderColor: AppColors.secondary,
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
                    borderRadius: AppRadius.circular,
                  ),
                ),
                AppGap(AppSizes.s100),
              ],
            ),
          ),
        );
      },
    );
  }
}
