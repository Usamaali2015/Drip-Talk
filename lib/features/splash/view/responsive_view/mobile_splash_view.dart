import 'splash_barrels.dart';

class MobileSplashView extends StatelessWidget {
  const MobileSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: .center,
        children: [AppAssetImage(assetPath: Assets.iconsLogo)],
      ),
    );
  }
}
