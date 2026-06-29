import 'package:drip_talk/features/dashboard/profile/domain/bloc/edit_profile_bloc.dart';
import 'package:drip_talk/features/dashboard/profile/domain/bloc/edit_profile_event.dart';
import 'package:drip_talk/features/dashboard/profile/domain/bloc/edit_profile_state.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

enum TwoFactorVerifySheetResult { verified, cancelled, rescan }

class TwoFactorVerifySheet extends StatefulWidget {
  const TwoFactorVerifySheet({super.key});

  static Future<TwoFactorVerifySheetResult?> show(BuildContext context) {
    return showModalBottomSheet<TwoFactorVerifySheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<EditProfileBloc>(),
        child: const TwoFactorVerifySheet(),
      ),
    );
  }

  @override
  State<TwoFactorVerifySheet> createState() => _TwoFactorVerifySheetState();
}

class _TwoFactorVerifySheetState extends State<TwoFactorVerifySheet> {
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode>.generate(6, (_) => FocusNode());
    _controllers = List<TextEditingController>.generate(
      6,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FractionallySizedBox(
      heightFactor: 0.96,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.modalGradientStart, AppColors.modalGradientEnd],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.r30),
          ),
        ),
        child: BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) =>
              previous.twoFactorVerificationStatus !=
                  current.twoFactorVerificationStatus ||
              previous.feedbackMessage != current.feedbackMessage,
          listener: (context, state) {
            if (state.twoFactorVerificationStatus ==
                EditProfileTwoFactorVerificationStatus.success) {
              Navigator.of(context).pop(TwoFactorVerifySheetResult.verified);
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s20,
              AppSizes.s20,
              AppSizes.s20,
              AppSizes.s32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BackButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(TwoFactorVerifySheetResult.cancelled),
                ),
                const Spacer(),
                Container(
                  width: AppSizes.s48,
                  height: AppSizes.s48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: AppColors.secondary,
                    size: AppSizes.s20,
                  ),
                ),
                const AppGap(AppSizes.s18),
                AppText(
                  text: l10n.twoFactorVerifyTitle,
                  style: AppTextStyles.ts32(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                ),
                const AppGap(AppSizes.s12),
                AppText(
                  text: l10n.twoFactorVerifySubtitle,
                  style: AppTextStyles.ts18(
                    context,
                    color: AppColors.pureWhite.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 3,
                ),
                const AppGap(AppSizes.s28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(_controllers.length, (index) {
                    return GradientOtpInput(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      nextFocus: index < _focusNodes.length - 1
                          ? _focusNodes[index + 1]
                          : null,
                      previousFocus: index > 0 ? _focusNodes[index - 1] : null,
                    );
                  }),
                ),
                const AppGap(AppSizes.s32),
                BlocBuilder<EditProfileBloc, EditProfileState>(
                  buildWhen: (previous, current) =>
                      previous.twoFactorVerificationStatus !=
                      current.twoFactorVerificationStatus,
                  builder: (context, state) {
                    return AppButton(
                      text: l10n.twoFactorVerifyAction,
                      isLoading: state.isTwoFactorVerifying,
                      onPressed: state.isTwoFactorVerifying
                          ? null
                          : () {
                              final code = _controllers
                                  .map((controller) => controller.text)
                                  .join();
                              context.read<EditProfileBloc>().add(
                                VerifyEditProfileTwoFactorRequested(code),
                              );
                            },
                      height: AppSizes.s56,
                      borderRadius: AppRadius.r16,
                      gradientColors: const [
                        AppColors.secondary,
                        AppColors.primary,
                      ],
                      fontSize: AppSizes.s16,
                    );
                  },
                ),
                const AppGap(AppSizes.s18),
                Center(
                  child: InkWell(
                    onTap: () => Navigator.of(
                      context,
                    ).pop(TwoFactorVerifySheetResult.rescan),
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s8,
                        vertical: AppSizes.s6,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: l10n.twoFactorDidNotGetCode,
                          style: AppTextStyles.ts16(
                            context,
                            color: AppColors.pureWhite.withValues(
                              alpha: 0.76,
                            ),
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: l10n.twoFactorRescanQr,
                              style: AppTextStyles.ts16(
                                context,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.circular),
      child: Container(
        width: AppSizes.s36,
        height: AppSizes.s36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.secondary,
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.pureWhite,
          size: AppSizes.s18,
        ),
      ),
    );
  }
}
