import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/features/cart/barrels/cart_barrels.dart';
import 'package:drip_talk/features/product/barrels/product_barrels.dart';
import 'package:drip_talk/features/reviews/barrels/reviews_barrels.dart';
import 'package:drip_talk/features/wishlist/barrels/wishlist_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
part 'widgets/mobile_product_view_widgets.dart';

class MobileProductView extends StatelessWidget {
  const MobileProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductReviewBloc, ProductReviewState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus &&
          (current.isSuccess || current.isFailure),
      listener: (context, reviewState) {
        final message = reviewState.feedbackMessage?.trim();
        if (message == null || message.isEmpty) {
          return;
        }

        ToastUtils.show(
          context,
          message,
          type: reviewState.isFailure ? ToastType.error : ToastType.success,
        );

        if (!reviewState.isSuccess) {
          context.read<ProductReviewBloc>().add(
            const ResetProductReviewStatusRequested(),
          );
          return;
        }

        final productId = context.read<ProductBloc>().state.productId;
        if (productId == null) {
          return;
        }

        context.read<ProductBloc>().add(
          LoadProductDetails(productId, showLoader: false),
        );
        context.read<ProductReviewBloc>().add(
          const ResetProductReviewStatusRequested(),
        );
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (previous, current) =>
            previous.productId != current.productId ||
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.transparent,
            appBar: const ProductAppBar(),
            bottomNavigationBar: state.productId == null
                ? null
                : const _ProductBottomBarSection(),
            body: const _ProductBodySection(),
          );
        },
      ),
    );
  }
}
