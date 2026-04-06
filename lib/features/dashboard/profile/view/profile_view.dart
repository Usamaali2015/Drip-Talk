import 'profile_barrels.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(child: ResponsiveLayout(mobile: MobileProfileView()));
  }
}
