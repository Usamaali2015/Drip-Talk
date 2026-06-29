import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/route_paths.dart';
import 'package:drip_talk/features/auth/barrels/two_factor_barrels.dart';
import 'package:drip_talk/features/cart/barrels/cart_barrels.dart';
import 'package:drip_talk/features/wishlist/barrels/wishlist_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'widgets/mobile_two_factor_login_view_widgets.dart';

class MobileTwoFactorLoginView extends StatefulWidget {
  const MobileTwoFactorLoginView({super.key, required this.challenge});

  final LoginTwoFactorChallenge challenge;

  @override
  State<MobileTwoFactorLoginView> createState() =>
      _MobileTwoFactorLoginViewState();
}

class _MobileTwoFactorLoginViewState extends State<MobileTwoFactorLoginView> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      6,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(6, (_) => FocusNode());

    for (final controller in _controllers) {
      controller.addListener(_onCodeChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller
        ..removeListener(_onCodeChanged)
        ..dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged() {
    context.read<TwoFactorLoginBloc>().add(
      TwoFactorLoginCodeChanged(
        _controllers.map((controller) => controller.text).join(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<TwoFactorLoginBloc, TwoFactorLoginState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus ||
          previous.feedbackMessage != current.feedbackMessage,
      listener: (context, state) {
        final message = state.feedbackMessage?.trim();
        if (state.isFailure && message != null && message.isNotEmpty) {
          ToastUtils.show(context, message, type: ToastType.error);
          return;
        }

        if (state.isSuccess) {
          if (message != null && message.isNotEmpty) {
            ToastUtils.show(context, message, type: ToastType.success);
          }
          context.read<CartBloc>().add(
            const LoadCart(showLoader: false, silent: true),
          );
          context.read<WishlistBloc>().add(
            const LoadWishlist(showLoader: false, silent: true),
          );
          context.go(RoutePaths.wardrobes);
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.s24,
            AppSizes.s28,
            AppSizes.s24,
            AppSizes.s32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PinkBackButton(onPressed: () => context.pop()),
              const AppGap(AppSizes.s40),
              AppText(
                text: l10n.loginTwoFactorTitle,
                style: AppTextStyles.ts20(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const AppGap(AppSizes.s48),
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
              const AppGap(AppSizes.s20),
              AppText(
                text: l10n.loginTwoFactorScreenTitle,
                style: AppTextStyles.ts24(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
              ),
              const AppGap(AppSizes.s12),
              AppText(
                text: l10n.loginTwoFactorScreenSubtitle,
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.pureWhite.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 3,
              ),
              const AppGap(AppSizes.s32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.ltr,
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
              const AppGap(AppSizes.s36),
              BlocBuilder<TwoFactorLoginBloc, TwoFactorLoginState>(
                builder: (context, state) {
                  return AppButton(
                    text: l10n.loginTwoFactorAction,
                    isLoading: state.isLoading,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            context.read<TwoFactorLoginBloc>().add(
                              TwoFactorLoginSubmitted(widget.challenge),
                            );
                          },
                    height: AppSizes.s56,
                    borderRadius: AppRadius.r20,
                    gradientColors: const [
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                    fontSize: AppSizes.s16,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
