import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/constants/app_radius.dart';

class TiltedImage extends StatelessWidget {
  final String imagePath;
  final double angle;
  final double height;
  final double width;

  const TiltedImage({
    super.key,
    required this.imagePath,
    required this.angle,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r8),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          height: height,
          width: width,
        ),
      ),
    );
  }
}
