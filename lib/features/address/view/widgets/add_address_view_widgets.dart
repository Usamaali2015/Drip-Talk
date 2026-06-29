part of '../add_address_view.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSizes.s20,
          height: AppSizes.s20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(AppRadius.r6),
          ),
          child: const Icon(
            Icons.add,
            color: AppColors.pureWhite,
            size: AppSizes.s16,
          ),
        ),
        const AppGap(AppSizes.s8, axis: Axis.horizontal),
        AppText(
          text: title,
          style: AppTextStyles.ts22(
            context,
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AddressLabelChip extends StatelessWidget {
  const _AddressLabelChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          height: AppSizes.s50,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s12,
            vertical: AppSizes.s10,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.secondary
                : AppColors.lightBg.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondary
                  : AppColors.secondary.withValues(alpha: 0.72),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.24),
                      blurRadius: AppSizes.s18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: AppText(
            text: label,
            textAlign: TextAlign.center,
            style: AppTextStyles.ts15(
              context,
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressLabelOption {
  const _AddressLabelOption({required this.label, required this.value});

  final String label;
  final AddressLabel value;
}
