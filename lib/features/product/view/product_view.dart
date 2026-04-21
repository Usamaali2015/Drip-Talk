import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:flutter/material.dart';
import 'mobile_product_view.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      showHeaderDivider: false,
      useSafeArea: false,
      mobileMaxWidth: 430,
      tabletMaxWidth: 720,
      tabletLargeMaxWidth: 840,
      desktopMaxWidth: 920,
      pageBuilder: (context, _) => const MobileProductView(),
    );
  }
}
