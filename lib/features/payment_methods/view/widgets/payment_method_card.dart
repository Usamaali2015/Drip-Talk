import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.badgeLabel,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
    required this.onPrimaryAction,
  });

  final String title;
  final String description;
  final String actionLabel;
  final String badgeLabel;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onPrimaryAction;

  static const Color _selectionColor = AppColors.paymentSelection;
  static const Color _borderColor = AppColors.paymentBorderAccent;
  static const Color _cardColor = AppColors.paymentPanelBackground;
  static const Color _selectedCardColor = AppColors.paymentSelectedBackground;
  static const Color _badgeColor = AppColors.paymentBadgeBackground;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.r24);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: isSelected ? const EdgeInsets.all(AppSizes.s4) : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r24 + AppSizes.s2),
        border: isSelected
            ? Border.all(
                color: _selectionColor.withValues(alpha: 0.85),
                width: 1.5,
              )
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: _selectionColor.withValues(alpha: 0.12),
                  blurRadius: AppSizes.s24,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            padding: const EdgeInsets.all(AppSizes.s18),
            decoration: BoxDecoration(
              color: isSelected ? _selectedCardColor : _cardColor,
              borderRadius: radius,
              border: Border.all(
                color: _borderColor.withValues(alpha: 0.95),
                width: 1.15,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DashedOutline(
                  enabled: isSelected,
                  borderRadius: AppRadius.r15,
                  color: _selectionColor.withValues(alpha: 0.82),
                  child: Padding(
                    padding: EdgeInsets.all(isSelected ? AppSizes.s4 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _MethodIcon(assetPath: assetPath),
                            const AppGap(AppSizes.s10, axis: Axis.horizontal),
                            Expanded(
                              child: AppText(
                                text: title,
                                maxLines: 1,
                                style: AppTextStyles.ts20(
                                  context,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const AppGap(AppSizes.s8, axis: Axis.horizontal),
                            _Badge(label: badgeLabel),
                          ],
                        ),
                        const AppGap(AppSizes.s18),
                        AppText(
                          text: description,
                          maxLines: 3,
                          style: AppTextStyles.ts14(
                            context,
                            color: AppColors.pureWhite.withValues(
                              alpha: 0.92,
                            ),
                            fontWeight: FontWeight.w400,
                          ).copyWith(height: 1.45),
                        ),
                      ],
                    ),
                  ),
                ),
                const AppGap(AppSizes.s18),
                _DashedOutline(
                  enabled: isSelected,
                  borderRadius: AppRadius.r16,
                  color: _selectionColor.withValues(alpha: 0.82),
                  child: _ActionButton(
                    label: actionLabel,
                    onPressed: onPrimaryAction,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MethodIcon extends StatelessWidget {
  const _MethodIcon({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.s32,
      height: AppSizes.s32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pureWhite,
      ),
      alignment: Alignment.center,
      child: AppAssetImage(
        assetPath: assetPath,
        width: AppSizes.s20,
        height: AppSizes.s20,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s10,
        vertical: AppSizes.s6,
      ),
      decoration: BoxDecoration(
        color: PaymentMethodCard._badgeColor.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadius.circular),
      ),
      child: AppText(
        text: label,
        style: AppTextStyles.ts10(
          context,
          color: AppColors.paymentBadgeText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Container(
          height: AppSizes.s56,
          decoration: BoxDecoration(
            color: AppColors.paymentActionBackground,
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(
              color: PaymentMethodCard._borderColor.withValues(alpha: 0.95),
              width: 1.1,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.s20,
                height: AppSizes.s20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.pureWhite.withValues(alpha: 0.74),
                    width: 1.1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.pureWhite,
                  size: AppSizes.s14,
                ),
              ),
              const AppGap(AppSizes.s10, axis: Axis.horizontal),
              Flexible(
                child: AppText(
                  text: label,
                  maxLines: 1,
                  style: AppTextStyles.ts16(
                    context,
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedOutline extends StatelessWidget {
  const _DashedOutline({
    required this.enabled,
    required this.borderRadius,
    required this.color,
    required this.child,
  });

  final bool enabled;
  final double borderRadius;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: color,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.borderRadius});

  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(borderRadius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final nextDistance = math.min(distance + 5, metric.length);
        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
