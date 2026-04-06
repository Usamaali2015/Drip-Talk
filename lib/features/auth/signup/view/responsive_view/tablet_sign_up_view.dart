// import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
//
// import 'sign_up_barrels.dart';
//
// class TabletSignUpView extends StatelessWidget {
//   const TabletSignUpView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         const AppVideoPlayer(asset: AppAssets.signupBg),
//         Container(color: Colors.black.withValues(alpha: 0.65)),
//
//         SafeArea(
//           child: Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 420),
//               child: SingleChildScrollView(
//                 padding: AppPadding.horizontalLarge,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText(
//                       text: AppLocalizations.of(context)!.signup,
//                       style: AppTextStyles.ts24(
//                         context,
//                         Theme.of(context).colorScheme.onSecondaryContainer,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//
//                     const AppGap(AppSizes.s16),
//
//                     AppText(
//                       text: AppLocalizations.of(context)!.signupDescription,
//                       style: AppTextStyles.ts14(
//                         context,
//                         Theme.of(context).colorScheme.onSecondaryContainer,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       maxLines: 3,
//                     ),
//
//                     const AppGap(AppSizes.s40),
//
//                     SignUpForm(),
//
//                     const AppGap(AppSizes.s48),
//
//                     AppButton(
//                       height: AppSizes.s48,
//                       text: AppLocalizations.of(context)!.signup,
//                       onPressed: () {
//                         ToastUtils.show(
//                           context,
//                           AppLocalizations.of(context)!.success,
//                           type: ToastType.success,
//                           duration: Duration(seconds: 2),
//                           dismissOnTap: true,
//                           bottomPadding: 20,
//                         );
//                       },
//                     ),
//
//                     const AppGap(AppSizes.s28),
//
//                     AppAuthSwitchText(
//                       leadingText: AppLocalizations.of(
//                         context,
//                       )!.alreadyHaveAccount,
//                       actionText: AppLocalizations.of(context)!.login,
//                       onTap: () {
//                         context.goNamed(AppRoutes.login);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
