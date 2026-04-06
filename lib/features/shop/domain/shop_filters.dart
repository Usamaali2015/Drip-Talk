import 'package:equatable/equatable.dart';

class ShopFilters extends Equatable {
  static const String allCategoryValue = '-1';
  static const Object _unset = Object();

  final String? lang;
  final String? gender;
  final double? minPrice;
  final double? maxPrice;
  final String? color;
  final String? size;
  final String? search;
  final String? sort;
  final int page;
  final int? perPage;
  final String? category;
  final String? brand;

  const ShopFilters({
    this.lang,
    this.gender,
    this.minPrice,
    this.maxPrice,
    this.color,
    this.size,
    this.search,
    this.sort,
    this.page = 1,
    this.perPage,
    this.category,
    this.brand,
  });

  ShopFilters copyWith({
    Object? lang = _unset,
    Object? gender = _unset,
    Object? minPrice = _unset,
    Object? maxPrice = _unset,
    Object? color = _unset,
    Object? size = _unset,
    Object? search = _unset,
    Object? sort = _unset,
    Object? page = _unset,
    Object? perPage = _unset,
    Object? category = _unset,
    Object? brand = _unset,
  }) {
    return ShopFilters(
      lang: identical(lang, _unset) ? this.lang : lang as String?,
      gender: identical(gender, _unset) ? this.gender : gender as String?,
      minPrice: identical(minPrice, _unset)
          ? this.minPrice
          : minPrice as double?,
      maxPrice: identical(maxPrice, _unset)
          ? this.maxPrice
          : maxPrice as double?,
      color: identical(color, _unset) ? this.color : color as String?,
      size: identical(size, _unset) ? this.size : size as String?,
      search: identical(search, _unset) ? this.search : search as String?,
      sort: identical(sort, _unset) ? this.sort : sort as String?,
      page: identical(page, _unset) ? this.page : page as int,
      perPage: identical(perPage, _unset) ? this.perPage : perPage as int?,
      category: identical(category, _unset)
          ? this.category
          : category as String?,
      brand: identical(brand, _unset) ? this.brand : brand as String?,
    );
  }

  ShopFilters normalized() {
    return ShopFilters(
      lang: _normalizeString(lang),
      gender: _normalizeString(gender),
      minPrice: minPrice,
      maxPrice: maxPrice,
      color: _normalizeString(color),
      size: _normalizeString(size),
      search: _normalizeString(search),
      sort: _normalizeString(sort),
      page: page < 1 ? 1 : page,
      perPage: perPage == null || perPage! < 1 ? null : perPage,
      category: _normalizeCategory(category),
      brand: _normalizeString(brand),
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final normalizedFilters = normalized();

    return {
      'page': normalizedFilters.page,
      if (normalizedFilters.perPage != null)
        'per_page': normalizedFilters.perPage,
      if (normalizedFilters.lang != null) 'lang': normalizedFilters.lang,
      if (normalizedFilters.gender != null) 'gender': normalizedFilters.gender,
      if (normalizedFilters.minPrice != null)
        'min_price': normalizedFilters.minPrice,
      if (normalizedFilters.maxPrice != null)
        'max_price': normalizedFilters.maxPrice,
      if (normalizedFilters.color != null) 'color': normalizedFilters.color,
      if (normalizedFilters.size != null) 'size': normalizedFilters.size,
      if (normalizedFilters.search != null) 'search': normalizedFilters.search,
      if (normalizedFilters.sort != null) 'sort': normalizedFilters.sort,
      if (normalizedFilters.category != null)
        'category': normalizedFilters.category,
      if (normalizedFilters.brand != null) 'brand': normalizedFilters.brand,
    };
  }

  ShopFilters clearedAdvanced({int page = 1}) {
    return copyWith(
      gender: null,
      minPrice: null,
      maxPrice: null,
      color: null,
      size: null,
      sort: null,
      category: null,
      brand: null,
      page: page,
    );
  }

  int get advancedSelectionCount {
    var count = 0;

    if (_normalizeString(gender) != null) {
      count++;
    }

    if (minPrice != null || maxPrice != null) {
      count++;
    }

    if (_normalizeString(color) != null) {
      count++;
    }

    if (_normalizeString(size) != null) {
      count++;
    }

    if (_normalizeString(sort) != null) {
      count++;
    }

    if (_normalizeCategory(category) != null) {
      count++;
    }

    if (_normalizeString(brand) != null) {
      count++;
    }

    return count;
  }

  bool get hasAdvancedSelections => advancedSelectionCount > 0;

  static String? _normalizeString(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String? _normalizeCategory(String? value) {
    final normalizedValue = _normalizeString(value);
    if (normalizedValue == null || normalizedValue == allCategoryValue) {
      return null;
    }
    return normalizedValue;
  }

  @override
  List<Object?> get props => [
    lang,
    gender,
    minPrice,
    maxPrice,
    color,
    size,
    search,
    sort,
    page,
    perPage,
    category,
    brand,
  ];
}
