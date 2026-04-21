import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class LoadProductDetails extends ProductEvent {
  const LoadProductDetails(this.productId, {this.showLoader = true});

  final int productId;
  final bool showLoader;

  @override
  List<Object> get props => [productId, showLoader];
}

class ProductPageChanged extends ProductEvent {
  const ProductPageChanged(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

class SelectProductSize extends ProductEvent {
  const SelectProductSize(this.sizeId);

  final int sizeId;

  @override
  List<Object> get props => [sizeId];
}

class SelectProductColor extends ProductEvent {
  const SelectProductColor(this.colorId);

  final int colorId;

  @override
  List<Object> get props => [colorId];
}
