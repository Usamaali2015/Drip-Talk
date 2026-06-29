part of '../my_addresses_view.dart';

class _FailureState extends StatelessWidget {
  const _FailureState({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s40),
      child: Column(
        children: [
          AppText(
            text: title,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts20(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          const AppGap(AppSizes.s8),
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
            height: AppSizes.s48,
            width: 180,
            borderRadius: AppRadius.circular,
            gradientColors: const [AppColors.secondary, AppColors.primary],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s32),
      child: Column(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: AppColors.secondary.withValues(alpha: 0.92),
            size: AppSizes.s40,
          ),
          const AppGap(AppSizes.s12),
          AppText(
            text: title,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts20(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          const AppGap(AppSizes.s8),
          AppText(
            text: message,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}
