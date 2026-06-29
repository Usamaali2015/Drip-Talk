import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/utils/routes/routes_barrels.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r10),

          gradient: AppColors.buttonGradient,
        ),
        child: Container(
          height: AppSizes.s40,
          width: AppSizes.s40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r10),

            color: AppColors.supportCardBackground,
          ),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.white,
            size: AppSizes.s20,
          ),
        ),
      ),
    );
  }
}
