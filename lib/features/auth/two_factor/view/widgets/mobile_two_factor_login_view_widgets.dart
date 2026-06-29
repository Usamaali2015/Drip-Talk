part of '../mobile_two_factor_login_view.dart';

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
