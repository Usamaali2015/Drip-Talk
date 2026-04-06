import 'package:drip_talk/core/common/widgets/app_gradient_background.dart';
import 'package:drip_talk/core/utils/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'responsive_view/mobile_otp_view.dart';

class OtpVerificationView extends StatelessWidget {
  final String email;
  final String type;
  const OtpVerificationView({super.key, required this.email, required this.type});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ResponsiveLayout(mobile:  MobileOtpView(email: email, type: type,)),
    );
  }
}
