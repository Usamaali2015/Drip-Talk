import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_models.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_localized_content.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfileSetupHeader extends StatelessWidget {
  const ProfileSetupHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final headingStyle = AppTextStyles.ts20(
      context,
      color: AppColors.pureWhite,
      fontWeight: FontWeight.w800,
    );
    final headerParts = l10n.profileSetupHeaderTitle.split('DripTalk');
    final leadingTitle = headerParts.first;
    final trailingTitle = headerParts.length > 1 ? headerParts.last : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSetupGradientBackButton(onPressed: onBack),
        const SizedBox(width: AppSizes.s14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: headingStyle,
                  children: [
                    TextSpan(text: leadingTitle),
                    TextSpan(
                      text: 'DripTalk',
                      style: headingStyle.copyWith(color: AppColors.secondary),
                    ),
                    TextSpan(text: trailingTitle),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.s4),
              AppText(
                text: l10n.profileSetupHeaderSubtitle,
                style: AppTextStyles.ts12(
                  context,
                  color: AppColors.pureWhite.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileSetupGradientBackButton extends StatelessWidget {
  const ProfileSetupGradientBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: AppSizes.s44,
        height: AppSizes.s44,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondary, AppColors.secondary],
          ),
        ),
        child: const Icon(Icons.arrow_back_rounded, color: AppColors.pureWhite),
      ),
    );
  }
}

class ProfileSetupStepper extends StatefulWidget {
  const ProfileSetupStepper({
    super.key,
    required this.currentStep,
    required this.completedSteps,
    required this.onStepSelected,
  });

  final ProfileSetupStep currentStep;
  final List<ProfileSetupStep> completedSteps;
  final ValueChanged<ProfileSetupStep> onStepSelected;

  @override
  State<ProfileSetupStepper> createState() => _ProfileSetupStepperState();
}

class _ProfileSetupStepperState extends State<ProfileSetupStepper> {
  static const double _stepWidth = 50;
  static const double _connectorWidth = 18;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _ensureCurrentStepVisible(double viewportWidth) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      final itemWidth = _stepWidth + _connectorWidth;
      final targetCenter =
          (widget.currentStep.index * itemWidth) + (_stepWidth / 2);
      final targetOffset = (targetCenter - (viewportWidth / 2)).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      if ((_scrollController.offset - targetOffset).abs() < 4) {
        return;
      }

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        _ensureCurrentStepVisible(constraints.maxWidth);
        final steps = ProfileSetupStep.values;

        return SizedBox(
          height: 68,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < steps.length; index++) ...[
                  SizedBox(
                    width: _stepWidth,
                    child: Column(
                      children: [
                        _ProfileSetupStepBadge(
                          step: steps[index],
                          currentStep: widget.currentStep,
                          isCompleted: widget.completedSteps.contains(
                            steps[index],
                          ),
                          onTap: () => widget.onStepSelected(steps[index]),
                        ),
                        const SizedBox(height: AppSizes.s6),
                        AppText(
                          text: ProfileSetupLocalizedContent.stepLabel(
                            steps[index],
                            l10n,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: AppTextStyles.ts10(
                            context,
                            color: AppColors.pureWhite.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < steps.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Container(
                        width: _connectorWidth,
                        height: 3,
                        decoration: BoxDecoration(
                          color: index < widget.currentStep.index
                              ? AppColors.secondary
                              : AppColors.secondary.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(
                            AppRadius.circular,
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileSetupStepBadge extends StatelessWidget {
  const _ProfileSetupStepBadge({
    required this.step,
    required this.currentStep,
    required this.isCompleted,
    required this.onTap,
  });

  final ProfileSetupStep step;
  final ProfileSetupStep currentStep;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCurrent = step == currentStep;
    final isActive = isCompleted || isCurrent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: AppSizes.s40,
        height: AppSizes.s40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? AppColors.secondary : AppColors.lightBg,
          border: Border.all(
            color: isActive
                ? AppColors.transparent
                : AppColors.secondary.withValues(alpha: 0.72),
            width: isCurrent ? 1.4 : 1.2,
          ),
          boxShadow: isActive
              ? const [
                  BoxShadow(
                    color: Color(0x33FF499E),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: isCompleted
            ? const Icon(
                Icons.check_rounded,
                color: AppColors.pureWhite,
                size: AppSizes.s20,
              )
            : AppText(
                text: '${step.index + 1}',
                style: AppTextStyles.ts18(
                  context,
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

class ProfileSetupStepIntro extends StatelessWidget {
  const ProfileSetupStepIntro({super.key, required this.step});

  final ProfileSetupStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titleStyle = step == ProfileSetupStep.colors
        ? AppTextStyles.ts22(
            context,
            color: AppColors.secondary,
            fontWeight: FontWeight.w800,
          )
        : AppTextStyles.ts24(
            context,
            color: AppColors.secondary,
            fontWeight: FontWeight.w800,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: ProfileSetupLocalizedContent.stepTitle(step, l10n),
          style: titleStyle,
        ),
        const SizedBox(height: AppSizes.s4),
        AppText(
          text: ProfileSetupLocalizedContent.stepSubtitle(step, l10n),
          maxLines: 3,
          style: AppTextStyles.ts12(
            context,
            color: AppColors.pureWhite.withValues(alpha: 0.78),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ProfileSetupLoadingView extends StatelessWidget {
  const ProfileSetupLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.secondary),
          const SizedBox(height: AppSizes.s16),
          AppText(
            text: l10n.profileSetupPreparing,
            style: AppTextStyles.ts16(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSetupFailureView extends StatelessWidget {
  const ProfileSetupFailureView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.secondary,
              size: AppSizes.s56,
            ),
            const SizedBox(height: AppSizes.s16),
            AppText(
              text: l10n.profileSetupLoadFailureTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts24(
                context,
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSizes.s8),
            AppText(
              text: message,
              textAlign: TextAlign.center,
              style: AppTextStyles.ts16(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSizes.s20),
            AppButton(
              text: l10n.retry,
              width: 180,
              borderRadius: AppRadius.circular,
              gradientColors: const [AppColors.secondary, AppColors.primary],
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSetupFooterActions extends StatelessWidget {
  const ProfileSetupFooterActions({
    super.key,
    required this.isLastStep,
    required this.isSubmitting,
    required this.isSkipEnabled,
    required this.isContinueEnabled,
    required this.onSkip,
    required this.onContinue,
  });

  final bool isLastStep;
  final bool isSubmitting;
  final bool isSkipEnabled;
  final bool isContinueEnabled;
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: l10n.skip,
            fontSize: 16,
            width: double.infinity,
            borderRadius: AppRadius.circular,
            backgroundColor: AppColors.lightBg.withValues(alpha: 0.5),
            borderColor: AppColors.secondary,
            borderWidth: 1.2,
            onPressed: isSubmitting || !isSkipEnabled ? null : onSkip,
          ),
        ),
        const SizedBox(width: AppSizes.s14),
        Expanded(
          child: AppButton(
            text: isLastStep
                ? l10n.profileSetupCompleteAction
                : l10n.continueText,
            fontSize: 16,
            width: double.infinity,
            borderRadius: AppRadius.circular,
            gradientColors: const [AppColors.secondary, AppColors.primary],
            isLoading: isSubmitting,
            onPressed: isSubmitting || !isContinueEnabled ? null : onContinue,
          ),
        ),
      ],
    );
  }
}
