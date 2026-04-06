import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/auth/login/bloc/login_bloc.dart';
import 'package:drip_talk/features/auth/login/bloc/login_event.dart';
import 'package:drip_talk/features/auth/login/bloc/login_state.dart';
import 'package:go_router/go_router.dart';
import 'reponsive_barrels.dart';

class MobileProfileView extends StatelessWidget {
  const MobileProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, state) {
        final currentLang = state.locale.languageCode == 'ar' ? 'AR' : 'ENG';

        return Padding(
          padding: AppPadding.horizontalLarge,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppGap(AppSizes.s24),
                GradientContainer(
                  borderRadius: AppRadius.r30,
                  child: Padding(
                    padding: AppPadding.allMediumLarge,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: AppRadius.r30,
                                  backgroundColor: AppColors.secondary,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: AppAssetImage(
                                    assetPath: Assets.iconsCamera,
                                    width: AppSizes.s16,
                                    height: AppSizes.s16,
                                  ),
                                ),
                              ],
                            ),
                            AppGap(AppSizes.s10, axis: Axis.horizontal),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: "Dianne Russell",
                                  style: AppTextStyles.ts18(
                                    context,
                                    color: AppColors.white,
                                  ),
                                ),
                                AppText(
                                  text: "@Dianne_russell",
                                  style: AppTextStyles.ts12(
                                    context,
                                    color: AppColors.white,
                                  ),
                                ),
                                AppText(
                                  text: l10n.memberSince("2025"),
                                  style: AppTextStyles.ts12(
                                    context,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        AppGap(AppSizes.s18),
                        AppButton(
                          text: l10n.editProfile,
                          onPressed: () {},
                          fontSize: AppSizes.s12,
                          iconGap: AppSizes.s4,
                          leadingIcon: AppAssetImage(
                            assetPath: Assets.iconsEdit,
                          ),
                          borderColor: AppColors.white,
                          fontWeight: FontWeight.w700,
                          backgroundColor: AppColors.secondary,
                          borderRadius: AppRadius.circular,
                        ),
                      ],
                    ),
                  ),
                ),
                AppGap(AppSizes.s24),
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
                      subtitle: l10n.myFavorites,
                      iconPath: Assets.stars,
                      onTap: () {},
                    ),
                  ],
                ),
                AppGap(AppSizes.s24),
                GradientContainer(
                  showListTile: true,
                  listAssetPath: Assets.payments,
                  listTitle: l10n.paymentsAndAddress,
                  items: [
                    GradientListItem(
                      subtitle: l10n.saveAddress,
                      iconPath: Assets.iconsLocation,
                      onTap: () {},
                    ),
                    GradientListItem(
                      subtitle: l10n.paymentMethods,
                      iconPath: Assets.payments,
                      onTap: () {},
                    ),
                  ],
                ),
                AppGap(AppSizes.s24),
                GradientContainer(
                  showListTile: true,
                  listAssetPath: Assets.settings,
                  listTitle: l10n.settings,
                  items: [
                    GradientListItem(
                      subtitle: l10n.notifications,
                      iconPath: Assets.notification,
                      trailingType: TrailingType.toggle,
                      switchValue: true,
                      onToggle: (val) {},
                    ),
                    GradientListItem(
                      subtitle: l10n.privacyPolicy,
                      iconPath: Assets.password,
                      onTap: () {},
                    ),
                    GradientListItem(
                      subtitle: l10n.security,
                      iconPath: Assets.security,
                      onTap: () {},
                    ),
                    GradientListItem(
                      subtitle: l10n.changePassword,
                      iconPath: Assets.changePassword,
                      onTap: () {},
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
                        context.read<LocalizationBloc>().add(
                          SetLocaleEvent(newLocale),
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
                GradientContainer(
                  showListTile: true,
                  listAssetPath: Assets.support,
                  listTitle: l10n.support,
                  items: [
                    GradientListItem(
                      subtitle: l10n.helpCenter,
                      iconPath: Assets.help,
                      onTap: () {},
                    ),
                    GradientListItem(
                      subtitle: l10n.contactSupport,
                      iconPath: Assets.iconsContact,
                      onTap: () {},
                    ),
                    GradientListItem(
                      subtitle: l10n.faqs,
                      iconPath: Assets.iconsFaq,
                      onTap: () {},
                    ),
                    GradientListItem(
                      subtitle: l10n.returnPolicy,
                      iconPath: Assets.returnPolicy,
                      onTap: () {},
                    ),
                    GradientListItem(
                      subtitle: l10n.termsAndConditions,
                      iconPath: Assets.terms,
                      onTap: () {},
                    ),
                  ],
                ),
                AppGap(AppSizes.s24),
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LogoutSuccess) {
                      context.goNamed(
                        AppRoutes.login,
                        queryParameters:
                            state.message?.trim().isNotEmpty == true
                            ? {'message': state.message!.trim()}
                            : <String, String>{},
                      );
                      return;
                    }

                    if (state is LoginError) {
                      ToastUtils.show(
                        context,
                        state.message,
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
