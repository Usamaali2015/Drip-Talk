import 'package:drip_talk/features/shop/domain/shop_filters.dart';
import 'package:equatable/equatable.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object?> get props => [];
}

class LoadShopData extends ShopEvent {
  final ShopFilters? filters;

  const LoadShopData({this.filters});

  @override
  List<Object?> get props => [filters];
}

class SelectCategory extends ShopEvent {
  final String categoryId;

  const SelectCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class ChangePage extends ShopEvent {
  final int page;

  const ChangePage(this.page);

  @override
  List<Object?> get props => [page];
}

class SearchProducts extends ShopEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class ApplyShopFilters extends ShopEvent {
  final ShopFilters filters;
  final bool resetPage;

  const ApplyShopFilters(this.filters, {this.resetPage = true});

  @override
  List<Object?> get props => [filters, resetPage];
}

class ResetShopFilters extends ShopEvent {
  const ResetShopFilters();
}

class RefreshShopData extends ShopEvent {
  const RefreshShopData();
}

class LoadAiCuratedCollections extends ShopEvent {
  final int page;
  final int? perPage;
  final String? searchQuery;

  const LoadAiCuratedCollections({
    this.page = 1,
    this.perPage,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, perPage, searchQuery];
}

class ChangeCuratedCollectionsPage extends ShopEvent {
  final int page;
  final String? searchQuery;

  const ChangeCuratedCollectionsPage(this.page, {this.searchQuery});

  @override
  List<Object?> get props => [page, searchQuery];
}
