import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_event.dart';
import 'package:drip_talk/features/shop/domain/shop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'shop_pagination_controls.dart';

class ShopPaginationSection extends StatelessWidget {
  const ShopPaginationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (previous, current) =>
          previous.currentPage != current.currentPage ||
          previous.totalPages != current.totalPages,
      builder: (context, state) {
        return ShopPaginationControls(
          currentPage: state.currentPage,
          totalPages: state.totalPages,
          onPageSelected: (page) {
            context.read<ShopBloc>().add(ChangePage(page));
          },
        );
      },
    );
  }
}
