import 'package:drip_talk/core/common/constants/app_colors.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';
import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_border.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/cart/view/widgets/cart_action_button.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsetsGeometry.only(left: AppSizes.s10, top: AppSizes.s10),
        child: GradientBorder(
          onTap: () => context.pop(),
          enableShadow: false,
          backgroundColor: AppColors.lightBg,
          borderRadius: AppRadius.r12,
          colors: [AppColors.primary, AppColors.secondary],
          child: Icon(
            Icons.arrow_back,
            color: AppColors.surface,
            size: AppSizes.s20,
          ),
        ),
      ),
      title: AppText(
        text: l10n.productDetailsTitle,
        variant: AppTextVariant.ts16,
        fontWeight: FontWeight.w900,
        textColor: AppColors.white,
      ),
      actions: [
        CartActionButton(onTap: () => context.pushNamed(AppRoutes.cart)),
        AppGap(AppSizes.s10, axis: Axis.horizontal),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
