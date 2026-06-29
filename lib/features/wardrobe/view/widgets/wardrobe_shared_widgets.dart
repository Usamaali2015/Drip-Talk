import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/app_cached_network_image.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/common/widgets/app_text.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class WardrobeScreenScaffold extends StatelessWidget {
  const WardrobeScreenScaffold({
    super.key,
    required this.child,
    this.wrapWithScaffold = true,
    this.useSafeArea = true,
    this.bottomSafeArea = false,
  });

  final Widget child;
  final bool wrapWithScaffold;
  final bool useSafeArea;
  final bool bottomSafeArea;

  @override
  Widget build(BuildContext context) {
    Widget content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsive(
            430.0,
            tablet: 560.0,
            tabletLarge: 640.0,
            desktop: 720.0,
          ),
        ),
        child: child,
      ),
    );

    if (useSafeArea) {
      content = SafeArea(bottom: bottomSafeArea, child: content);
    }

    if (!wrapWithScaffold) {
      return content;
    }

    return CustomScaffold(child: content);
  }
}

class WardrobeModuleIcon extends StatelessWidget {
  const WardrobeModuleIcon({
    super.key,
    this.size = AppSizes.s24,
    this.color = AppColors.pureWhite,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.wadrobe,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class WardrobeHeader extends StatelessWidget {
  const WardrobeHeader({
    super.key,
    required this.titleLeading,
    required this.titleAccent,
    required this.subtitle,
    this.onBack,
    this.trailing,
    this.showBackButton = true,
  });

  final String titleLeading;
  final String titleAccent;
  final String subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBackButton) ...[
          WardrobeCircleButton(
            onTap: onBack,
            icon: Icons.arrow_back_rounded,
            size: AppSizes.s46,
          ),
          const AppGap(AppSizes.s14, axis: Axis.horizontal),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WardrobeTitleText(
                leadingText: titleLeading,
                accentText: titleAccent,
              ),
              const AppGap(AppSizes.s2),
              AppText(
                text: subtitle,
                style: AppTextStyles.ts14(
                  context,
                  color: AppColors.pureWhite.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const AppGap(AppSizes.s12, axis: Axis.horizontal),
          trailing!,
        ],
      ],
    );
  }
}

class WardrobeTitleText extends StatelessWidget {
  const WardrobeTitleText({
    super.key,
    required this.leadingText,
    required this.accentText,
    this.fontSize = AppSizes.s20,
  });

  final String leadingText;
  final String accentText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final leadingStyle = AppTextStyles.ts24(
      context,
      color: AppColors.pureWhite,
      fontWeight: FontWeight.w800,
    ).copyWith(fontSize: fontSize);
    final accentStyle = AppTextStyles.ts24(
      context,
      color: AppColors.secondary,
      fontWeight: FontWeight.w800,
    ).copyWith(fontSize: fontSize);

    return RichText(
      text: TextSpan(
        text: leadingText.trim(),
        style: leadingStyle,
        children: [
          if (leadingText.trim().isNotEmpty) const TextSpan(text: ' '),
          TextSpan(text: accentText.trim(), style: accentStyle),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class WardrobeCircleButton extends StatelessWidget {
  const WardrobeCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = AppSizes.s44,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.circular),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.softPink, AppColors.secondary],
            ),
          ),
          child: Icon(icon, color: AppColors.pureWhite, size: size * 0.42),
        ),
      ),
    );
  }
}

class WardrobeFloatingActionButton extends StatelessWidget {
  const WardrobeFloatingActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon = Icons.add_rounded,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null && !isLoading;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadius.circular),
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s20,
              vertical: AppSizes.s14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.circular),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.softPink, AppColors.secondary],
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey<String>('loading'),
                      width: AppSizes.s20,
                      height: AppSizes.s20,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.s2,
                        color: AppColors.pureWhite,
                      ),
                    )
                  : Row(
                      key: const ValueKey<String>('content'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: AppColors.pureWhite,
                          size: AppSizes.s20,
                        ),
                        const AppGap(AppSizes.s8, axis: Axis.horizontal),
                        AppText(
                          text: label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.ts14(
                            context,
                            color: AppColors.pureWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class WardrobeCardSkeleton extends StatelessWidget {
  const WardrobeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: AppSizes.s86,
        padding: const EdgeInsets.all(AppSizes.s14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          color: AppColors.pureWhite.withValues(alpha: 0.06),
          border: Border.all(
            color: AppColors.pureWhite.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            _WardrobeSkeletonBox(
              width: AppSizes.s56,
              height: AppSizes.s56,
              borderRadius: AppRadius.r16,
            ),
            const AppGap(AppSizes.s14, axis: Axis.horizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _WardrobeSkeletonBox(width: 128, height: 16),
                  const AppGap(AppSizes.s8),
                  Wrap(
                    spacing: AppSizes.s10,
                    runSpacing: AppSizes.s6,
                    children: const [
                      _WardrobeSkeletonLine(width: 88),
                      _WardrobeSkeletonLine(width: 104),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WardrobeRefreshProgressIndicator extends StatelessWidget {
  const WardrobeRefreshProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppSizes.s24,
      height: AppSizes.s24,
      child: RefreshProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
        backgroundColor: AppColors.lightBg,
        strokeWidth: 2.2,
      ),
    );
  }
}

class _WardrobeSkeletonBox extends StatelessWidget {
  const _WardrobeSkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.r12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.pureWhite.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _WardrobeSkeletonLine extends StatelessWidget {
  const _WardrobeSkeletonLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return _WardrobeSkeletonBox(
      width: width,
      height: 10,
      borderRadius: AppRadius.r10,
    );
  }
}

class WardrobeNetworkImageTile extends StatelessWidget {
  const WardrobeNetworkImageTile({
    super.key,
    this.imageUrl,
    this.borderRadius = AppRadius.r20,
    this.size,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.checkroom_rounded,
  });

  final String? imageUrl;
  final double borderRadius;
  final double? size;
  final BoxFit fit;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl?.trim();

    if (normalizedUrl == null || normalizedUrl.isEmpty) {
      return _WardrobePlaceholderTile(
        size: size,
        borderRadius: borderRadius,
        icon: placeholderIcon,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AppCachedNetworkImage(
        imageUrl: normalizedUrl,
        width: size,
        height: size,
        fit: fit,
        borderRadius: BorderRadius.circular(borderRadius),
        errorWidget: _WardrobePlaceholderTile(
          size: size,
          borderRadius: borderRadius,
          icon: placeholderIcon,
        ),
      ),
    );
  }
}

class _WardrobePlaceholderTile extends StatelessWidget {
  const _WardrobePlaceholderTile({
    required this.size,
    required this.borderRadius,
    required this.icon,
  });

  final double? size;
  final double borderRadius;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fallbackSize = constraints.biggest.shortestSide;
        final resolvedIconSize = size != null
            ? size! * 0.28
            : (fallbackSize.isFinite && fallbackSize > 0
                  ? fallbackSize * 0.28
                  : AppSizes.s28);

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.pureWhite.withValues(alpha: 0.12),
                AppColors.pureWhite.withValues(alpha: 0.06),
              ],
            ),
            border: Border.all(
              color: AppColors.pureWhite.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.pureWhite.withValues(alpha: 0.74),
            size: resolvedIconSize,
          ),
        );
      },
    );
  }
}
