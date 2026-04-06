import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssetImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;

  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool isSvg = assetPath.endsWith('.svg');

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: isSvg
          ? SvgPicture.asset(
              assetPath,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (_, _, _) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: const Icon(Icons.image_not_supported_outlined),
                );
              },
            )
          : Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: fit,
              color: color,
              errorBuilder: (_, _, _) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: const Icon(Icons.image_not_supported_outlined),
                );
              },
            ),
    );
  }
}
