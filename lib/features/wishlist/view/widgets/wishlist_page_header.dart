import 'package:flutter/material.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class WishlistPageHeader extends StatelessWidget {
  const WishlistPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppPageHeader(title: title, subtitle: subtitle, onBack: onBack);
  }
}
