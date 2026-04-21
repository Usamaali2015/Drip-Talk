import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';

class CartCheckoutBar extends StatelessWidget {
  const CartCheckoutBar({
    super.key,
    required this.label,
    this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsive(
      16.0,
      tablet: 24.0,
      tabletLarge: 32.0,
      desktop: 40.0,
    );

    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsive(
            430.0,
            tablet: 720.0,
            tabletLarge: 840.0,
            desktop: 920.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSizes.s12,
            horizontalPadding,
            AppSizes.s16,
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: BorderRadius.circular(AppRadius.circular),
              child: Ink(
                height: AppSizes.s56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  gradient: LinearGradient(
                    colors: enabled
                        ? const [AppColors.secondary, AppColors.primary]
                        : [
                            AppColors.pureWhite.withValues(alpha: 0.16),
                            AppColors.pureWhite.withValues(alpha: 0.12),
                          ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Center(
                  child: AppText(
                    text: label,
                    style: AppTextStyles.ts18(
                      context,
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ).copyWith(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
