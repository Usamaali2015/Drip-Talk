  // import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
  //
  // import 'sign_up_barrels.dart';
  //
  // class DesktopSignUpView extends StatelessWidget {
  //   const DesktopSignUpView({super.key});
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     final colorScheme = Theme.of(context).colorScheme;
  //
  //     return Row(
  //       children: [
  //         /// LEFT – Background Video + Branding Text
  //         Expanded(
  //           child: Stack(
  //             children: [
  //               /// Video Background
  //               const AppVideoPlayer(asset: AppAssets.signupBg),
  //               Container(color: AppColors.black.withValues(alpha: 0.7)),
  //
  //               /// Branding Text over the video
  //               Padding(
  //                 padding: const EdgeInsets.all(AppSizes.s64),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const AppGap(AppSizes.s16),
  //
  //                     AppText(
  //                       text: AppLocalizations.of(context)!.signupSubtitle,
  //                       maxLines: 2,
  //                       style: AppTextStyles.ts32(
  //                         context,
  //                         Theme.of(context).colorScheme.onSecondaryContainer,
  //                         fontWeight: FontWeight.w800,
  //                       ),
  //                     ),
  //                     const AppGap(AppSizes.s24),
  //                     AppText(
  //                       text: AppLocalizations.of(context)!.appName,
  //                       style: AppTextStyles.ts32(
  //                         context,
  //                         colorScheme.onSecondary,
  //                         fontWeight: FontWeight.w800,
  //                       ),
  //                     ),
  //                     const AppGap(AppSizes.s24),
  //                     SizedBox(
  //                       width: AppSizes.s400,
  //                       child: AppText(
  //                         text: AppLocalizations.of(context)!.signupDescription,
  //                         style: AppTextStyles.ts18(
  //                           context,
  //                           colorScheme.onSecondaryContainer,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                         maxLines: 3,
  //                       ),
  //                     ),
  //                     const AppGap(AppSizes.s24),
  //                     AppText(
  //                       text: AppLocalizations.of(context)!.secureReliable,
  //                       style: AppTextStyles.ts18(
  //                         context,
  //                         colorScheme.onSecondaryContainer,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                       maxLines: 3,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         /// RIGHT – Glass Form (Sign-Up Form)
  //         Expanded(
  //           child: Center(
  //             child: ConstrainedBox(
  //               constraints: const BoxConstraints(maxWidth: 440),
  //               child: Container(
  //                 padding: const EdgeInsets.all(AppSizes.s40),
  //                 decoration: BoxDecoration(
  //                   color: Colors.black.withValues(alpha: 0.35),
  //                   borderRadius: BorderRadius.circular(28),
  //                   border: Border.all(
  //                     color: Colors.white.withValues(alpha: 0.15),
  //                   ),
  //                 ),
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       AppText(
  //                         text: AppLocalizations.of(context)!.signup,
  //                         style: AppTextStyles.ts24(
  //                           context,
  //                           colorScheme.onSecondary,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //
  //                       const AppGap(AppSizes.s32),
  //
  //                       SignUpForm(),
  //
  //                       const AppGap(AppSizes.s40),
  //
  //                       AppButton(
  //                         height: AppSizes.s48,
  //                         text: AppLocalizations.of(context)!.signup,
  //                         onPressed: () {
  //                           ToastUtils.show(
  //                             context,
  //                             AppLocalizations.of(context)!.success,
  //                             type: ToastType.success,
  //                             duration: Duration(seconds: 2),
  //                             dismissOnTap: true,
  //                             bottomPadding: 20,
  //                           );
  //                         },
  //                       ),
  //
  //                       const AppGap(AppSizes.s28),
  //
  //                       AppAuthSwitchText(
  //                         leadingText: AppLocalizations.of(
  //                           context,
  //                         )!.alreadyHaveAccount,
  //                         actionText: AppLocalizations.of(context)!.login,
  //                         onTap: () {
  //                           context.goNamed(AppRoutes.login);
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  // }
