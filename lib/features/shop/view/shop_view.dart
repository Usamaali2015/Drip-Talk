import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:drip_talk/features/shop/view/widgets/widgets_barrels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<ShopBloc, ShopState>(
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
