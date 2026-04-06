import 'dart:ui';
import 'package:drip_talk/core/utils/responsive/break_points.dart';

import 'utils_barrels.dart';

enum ToastType { success, error, info }

class ToastUtils {
  ToastUtils._();

  static void show(
      BuildContext context,
      String message, {
        ToastType type = ToastType.success,
        Duration? duration,
        bool dismissOnTap = true,
        double? bottomPadding,
      }) {
    final overlay = Overlay.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    duration ??= AppDurations.threeSeconds;
    bottomPadding ??= 90;

    late OverlayEntry entry;

    final icon = switch (type) {
      ToastType.success => Icons.check_circle_rounded,
      ToastType.error => Icons.error_rounded,
      ToastType.info => Icons.info_rounded,
    };

    final (iconColor, backgroundColor) = switch (type) {
      ToastType.success => (Colors.green, Colors.green.withValues(alpha: 0.2)),
      ToastType.error => (
      colorScheme.error,
      colorScheme.error.withValues(alpha: 0.2),
      ),
      ToastType.info => (
      colorScheme.primary,
      colorScheme.primary.withValues(alpha: 0.2),
      ),
    };

    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message,
        icon: icon,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        colorScheme: colorScheme,
        bottomPadding: bottomPadding!,
        dismissOnTap: dismissOnTap,
      ),
    );

    overlay.insert(entry);

    Future.delayed(duration, entry.remove);
  }
}


class _ToastWidget extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final ColorScheme colorScheme;
  final double bottomPadding;
  final bool dismissOnTap;

  const _ToastWidget({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.colorScheme,
    required this.bottomPadding,
    required this.dismissOnTap,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slide = Tween(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scale = Tween(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _toastMaxWidth(double width) {
    if (width >= Breakpoints.desktop) return 380;
    if (width >= Breakpoints.tabletLarge) return 420;
    if (width >= Breakpoints.tablet) return width * 0.9;
    return width * 0.92;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < Breakpoints.tablet ? 20.0 : 24.0;

    return Positioned(
      bottom: widget.bottomPadding,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _toastMaxWidth(screenWidth),
          ),
          child: GestureDetector(
            onTap: widget.dismissOnTap ? _controller.reverse : null,
            child: SlideTransition(
              position: _slide,
              child: ScaleTransition(
                scale: _scale,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: widget.backgroundColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color:
                              widget.iconColor.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: widget.iconColor
                                      .withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  widget.icon,
                                  color: widget.iconColor,
                                  size: iconSize,
                                ),
                              ),
                              const AppGap(
                                AppSizes.s16,
                                axis: Axis.horizontal,
                              ),
                              Expanded(
                                child: Text(
                                  widget.message,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.ts14(
                                    context,
                                    color:widget.colorScheme.onSecondary,
                                  ).copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

