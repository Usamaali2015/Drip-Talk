import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/utils/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'responsive_view/mobile_product_view.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(child: ResponsiveLayout(mobile: MobileProductView()));
  }
}
