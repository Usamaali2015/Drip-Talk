import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSizes.s8),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s12,
          ),
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              3,
              (index) => _TypingDot(controller: _controller, index: index),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  const _TypingDot({required this.controller, required this.index});

  final AnimationController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final start = index * 0.18;
    final end = (start + 0.45).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value;
        final scale = 0.7 + (value * 0.55);
        final translateY = -3 * value;

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Transform.scale(
            scale: scale,
            child: Opacity(opacity: 0.35 + (value * 0.65), child: child),
          ),
        );
      },
      child: Container(
        width: AppSizes.s8,
        height: AppSizes.s8,
        margin: EdgeInsets.only(
          left: index == 0 ? 0 : AppSizes.s4,
          right: index == 2 ? 0 : AppSizes.s4,
        ),
        decoration: const BoxDecoration(
          color: AppColors.pureWhite,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
