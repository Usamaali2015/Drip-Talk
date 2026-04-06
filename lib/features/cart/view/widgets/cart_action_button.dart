import 'package:drip_talk/core/common/widgets/app_action_icon.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_state.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartActionButton extends StatelessWidget {
  const CartActionButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, int>(
      selector: (state) => state.totalQuantity,
      builder: (context, totalQuantity) {
        return AppActionIcon(
          icon: Assets.cartIcon,
          badge: totalQuantity > 0 ? '$totalQuantity' : null,
          onTap: onTap,
        );
      },
    );
  }
}
