import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => const [];
}

class LoadWishlist extends WishlistEvent {
  const LoadWishlist({
    this.page = 1,
    this.perPage = 20,
    this.sort,
    this.showLoader = true,
    this.silent = false,
  });

  final int page;
  final int perPage;
  final String? sort;
  final bool showLoader;
  final bool silent;

  @override
  List<Object?> get props => [page, perPage, sort, showLoader, silent];
}

class ChangeWishlistPage extends WishlistEvent {
  const ChangeWishlistPage(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

class ChangeWishlistSort extends WishlistEvent {
  const ChangeWishlistSort(this.sort);

  final String? sort;

  @override
  List<Object?> get props => [sort];
}

class ToggleWishlistProduct extends WishlistEvent {
  const ToggleWishlistProduct({required this.productId});

  final int productId;

  @override
  List<Object?> get props => [productId];
}

class ClearWishlistFeedback extends WishlistEvent {
  const ClearWishlistFeedback();
}

class ClearWishlistSession extends WishlistEvent {
  const ClearWishlistSession();
}
