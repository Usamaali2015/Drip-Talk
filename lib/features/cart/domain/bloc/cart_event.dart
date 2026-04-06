import 'package:drip_talk/features/cart/data/models/cart_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => const [];
}

class LoadCart extends CartEvent {
  const LoadCart({this.showLoader = true, this.silent = false});

  final bool showLoader;
  final bool silent;

  @override
  List<Object?> get props => [showLoader, silent];
}

class AddCartItem extends CartEvent {
  const AddCartItem({
    required this.productVariantId,
    this.quantity = 1,
    this.optimisticItem,
  });

  final int productVariantId;
  final int quantity;
  final CartItem? optimisticItem;

  @override
  List<Object?> get props => [productVariantId, quantity, optimisticItem];
}

class UpdateCartItemQuantity extends CartEvent {
  const UpdateCartItemQuantity({
    required this.cartItemId,
    required this.quantity,
  });

  final int cartItemId;
  final int quantity;

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class RemoveCartItem extends CartEvent {
  const RemoveCartItem({required this.cartItemId});

  final int cartItemId;

  @override
  List<Object?> get props => [cartItemId];
}

class ClearCartFeedback extends CartEvent {
  const ClearCartFeedback();
}

class ClearCartSession extends CartEvent {
  const ClearCartSession();
}
