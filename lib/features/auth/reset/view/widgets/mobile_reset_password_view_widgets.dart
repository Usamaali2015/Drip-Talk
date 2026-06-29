part of '../mobile_reset_password_view.dart';

class _PinkBackButton extends StatelessWidget {
  const _PinkBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.circular),
      child: Container(
        width: AppSizes.s40,
        height: AppSizes.s40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.softPink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.pureWhite,
          size: AppSizes.s20,
        ),
      ),
    );
  }
}

class _PasswordRequirementsCard extends StatelessWidget {
  const _PasswordRequirementsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocSelector<ResetPasswordBloc, ResetPasswordState, _PasswordRules>(
      selector: (state) => _PasswordRules.fromPassword(state.password),
      builder: (context, rules) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.s18),
          decoration: BoxDecoration(
            color: AppColors.lightBg.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(AppRadius.r24),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.18),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: l10n.changePasswordRequirementsTitle,
                style: AppTextStyles.ts16(
                  context,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const AppGap(AppSizes.s12),
              _RequirementRow(
                isMet: rules.hasMinLength,
                label: l10n.changePasswordRuleMinLength,
              ),
              const AppGap(AppSizes.s8),
              _RequirementRow(
                isMet: rules.hasUppercase,
                label: l10n.changePasswordRuleUppercase,
              ),
              const AppGap(AppSizes.s8),
              _RequirementRow(
                isMet: rules.hasNumberOrSymbol,
                label: l10n.changePasswordRuleNumberOrSymbol,
              ),
              const AppGap(AppSizes.s8),
              _RequirementRow(
                isMet: rules.hasSpecialCharacter,
                label: l10n.changePasswordRuleSpecialCharacter,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PasswordRules {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasNumberOrSymbol;
  final bool hasSpecialCharacter;

  const _PasswordRules({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasNumberOrSymbol,
    required this.hasSpecialCharacter,
  });

  factory _PasswordRules.fromPassword(String password) {
    return _PasswordRules(
      hasMinLength: password.length >= 8,
      hasUppercase: RegExp(r'[A-Z]').hasMatch(password),
      hasNumberOrSymbol: RegExp(r'[\d\W_]').hasMatch(password),
      hasSpecialCharacter: RegExp(r'[^\w\s]').hasMatch(password),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.isMet, required this.label});

  final bool isMet;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = isMet ? AppColors.secondary : AppColors.materialGrey;

    return Row(
      children: [
        Icon(Icons.check_circle, size: AppSizes.s16, color: color),
        const AppGap(AppSizes.s8, axis: Axis.horizontal),
        Expanded(
          child: AppText(
            text: label,
            style: AppTextStyles.ts12(
              context,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
