import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/shop/barrels/shop_barrels.dart';


class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppResponsivePageLayout(
      wrapWithScaffold: false,
      useSafeArea: false,
      showHeaderDivider: false,
      mobileMaxWidth: 430,
      tabletMaxWidth: 760,
      tabletLargeMaxWidth: 940,
      desktopMaxWidth: 1120,
      backgroundGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.transparent],
      ),
      pageBuilder: (context, _) => BlocBuilder<ShopBloc, ShopState>(
        buildWhen: (previous, current) =>
            previous.isInitialLoading != current.isInitialLoading,
        builder: (context, state) {
          if (state.isInitialLoading) {
            return const ShopInitialShimmer();
          }

          return const ShopContent();
        },
      ),
    );
  }
}
