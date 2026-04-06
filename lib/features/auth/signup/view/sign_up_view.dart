
import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:drip_talk/core/utils/responsive/responsive_layout.dart';

import 'responsive_view/mobile_sign_up_view.dart';


class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ResponsiveLayout(
        mobile: const MobileSignUpView(),

      ),
    );
  }
}
