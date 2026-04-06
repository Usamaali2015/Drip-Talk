import 'package:drip_talk/features/shop/data/models/ai_curated_model.dart';
import 'package:drip_talk/features/shop/data/models/shop_model.dart';
import 'package:drip_talk/features/shop/domain/shop_filters.dart';
import 'package:equatable/equatable.dart';

enum ShopStatus { initial, loading, success, failure }

enum ShopCollectionsStatus { initial, loading, success, failure }

class ShopState extends Equatable {
  final ShopStatus status;
  final ShopCollectionsStatus collectionsStatus;
  final List<Items> products;
  final List<AiCuratedItem> curatedCollections;
  final int collectionsCurrentPage;
  final int collectionsTotalPages;
  final int collectionsTotalItems;
  final List<Category> categories;
  final ShopFilters filters;
  final int totalPages;
  final bool isRefreshing;
  final bool isCollectionsRefreshing;

  const ShopState({
    this.status = ShopStatus.initial,
    this.collectionsStatus = ShopCollectionsStatus.initial,
    this.products = const [],
    this.curatedCollections = const [],
    this.collectionsCurrentPage = 1,
    this.collectionsTotalPages = 1,
    this.collectionsTotalItems = 0,
    this.categories = const [],
    this.filters = const ShopFilters(),
    this.totalPages = 1,
    this.isRefreshing = false,
    this.isCollectionsRefreshing = false,
  });

  String get selectedCategoryId =>
      filters.category ?? ShopFilters.allCategoryValue;

  String get searchQuery => filters.search ?? '';

  int get currentPage => filters.page;

  int? get perPage => filters.perPage;

  List<Category> get filterCategories {
    final collectedCategories = <Category>[];
    final seenIds = <String>{};

    void addCategory(Category? category) {
      final categoryId = category?.id?.toString();
      if (category == null ||
          categoryId == null ||
          category.id == -1 ||
          !seenIds.add(categoryId)) {
        return;
      }

      collectedCategories.add(category);
    }

    for (final category in categories) {
      addCategory(category);
    }

    for (final product in products) {
      addCategory(product.category);
    }

    return collectedCategories;
  }

  List<String> get availableBrandNames {
    return _dedupeStrings([
      filters.brand,
      ...products.map((product) => product.brand?.name),
    ]);
  }

  List<String> get availableSizeValues {
    final sizeValues = _dedupeStrings([
      filters.size,
      ...products.expand(
        (product) => product.variants?.map((variant) => variant.size) ?? const [],
      ),
    ]);

    sizeValues.sort(_compareSizeLabels);
    return sizeValues;
  }

  List<String> get availableGenderValues {
    final collectedGenders = _dedupeStrings([
      'male',
      'female',
      filters.gender,
      ...products.map((product) => product.gender),
    ]);

    collectedGenders.sort((first, second) {
      const priority = <String, int>{'male': 0, 'female': 1};
      final firstPriority = priority[first.toLowerCase()] ?? 99;
      final secondPriority = priority[second.toLowerCase()] ?? 99;
      if (firstPriority != secondPriority) {
        return firstPriority.compareTo(secondPriority);
      }

      return first.toLowerCase().compareTo(second.toLowerCase());
    });

    return collectedGenders;
  }

  bool get isInitialLoading =>
      products.isEmpty &&
      (status == ShopStatus.initial || status == ShopStatus.loading);

  bool get isCollectionsInitialLoading =>
      curatedCollections.isEmpty &&
      (collectionsStatus == ShopCollectionsStatus.initial ||
          collectionsStatus == ShopCollectionsStatus.loading);

  ShopState copyWith({
    ShopStatus? status,
    ShopCollectionsStatus? collectionsStatus,
    List<Items>? products,
    List<AiCuratedItem>? curatedCollections,
    int? collectionsCurrentPage,
    int? collectionsTotalPages,
    int? collectionsTotalItems,
    List<Category>? categories,
    ShopFilters? filters,
    int? totalPages,
    bool? isRefreshing,
    bool? isCollectionsRefreshing,
  }) {
    return ShopState(
      status: status ?? this.status,
      collectionsStatus: collectionsStatus ?? this.collectionsStatus,
      products: products ?? this.products,
      curatedCollections: curatedCollections ?? this.curatedCollections,
      collectionsCurrentPage:
          collectionsCurrentPage ?? this.collectionsCurrentPage,
      collectionsTotalPages:
          collectionsTotalPages ?? this.collectionsTotalPages,
      collectionsTotalItems:
          collectionsTotalItems ?? this.collectionsTotalItems,
      categories: categories ?? this.categories,
      filters: filters ?? this.filters,
      totalPages: totalPages ?? this.totalPages,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isCollectionsRefreshing:
          isCollectionsRefreshing ?? this.isCollectionsRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    collectionsStatus,
    products,
    curatedCollections,
    collectionsCurrentPage,
    collectionsTotalPages,
    collectionsTotalItems,
    categories,
    filters,
    totalPages,
    isRefreshing,
    isCollectionsRefreshing,
  ];

  static List<String> _dedupeStrings(Iterable<String?> values) {
    final normalizedValues = <String>[];
    final seen = <String>{};

    for (final value in values) {
      final normalized = value?.trim();
      if (normalized == null || normalized.isEmpty) {
        continue;
      }

      final key = normalized.toLowerCase();
      if (!seen.add(key)) {
        continue;
      }

      normalizedValues.add(normalized);
    }

    return normalizedValues;
  }

  static int _compareSizeLabels(String first, String second) {
    const sizeOrder = <String, int>{
      'xxs': 0,
      'xs': 1,
      's': 2,
      'm': 3,
      'l': 4,
      'xl': 5,
      'xxl': 6,
      'xxxl': 7,
    };

    final firstKey = first.trim().toLowerCase();
    final secondKey = second.trim().toLowerCase();
    final firstOrder = sizeOrder[firstKey];
    final secondOrder = sizeOrder[secondKey];

    if (firstOrder != null && secondOrder != null) {
      return firstOrder.compareTo(secondOrder);
    }

    if (firstOrder != null) {
      return -1;
    }

    if (secondOrder != null) {
      return 1;
    }

    return firstKey.compareTo(secondKey);
  }
}
