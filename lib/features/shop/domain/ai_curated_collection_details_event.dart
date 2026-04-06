import 'package:equatable/equatable.dart';

abstract class AiCuratedCollectionDetailsEvent extends Equatable {
  const AiCuratedCollectionDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAiCuratedCollectionDetails extends AiCuratedCollectionDetailsEvent {
  const LoadAiCuratedCollectionDetails(
    this.collectionId, {
    this.page = 1,
    this.perPage,
    this.searchQuery,
    this.showLoader = true,
  });

  final int collectionId;
  final int page;
  final int? perPage;
  final String? searchQuery;
  final bool showLoader;

  @override
  List<Object?> get props => [
    collectionId,
    page,
    perPage,
    searchQuery,
    showLoader,
  ];
}

class SearchAiCuratedCollectionProducts
    extends AiCuratedCollectionDetailsEvent {
  const SearchAiCuratedCollectionProducts(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class ChangeAiCuratedCollectionProductsPage
    extends AiCuratedCollectionDetailsEvent {
  const ChangeAiCuratedCollectionProductsPage(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}
