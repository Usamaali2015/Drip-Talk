class MyReviewsResponseModel {
  const MyReviewsResponseModel({
    this.status,
    this.message,
    this.data = const MyReviewsData(),
    this.errors,
  });

  factory MyReviewsResponseModel.fromJson(Map<String, dynamic>? json) {
    final safeJson = json ?? const <String, dynamic>{};

    return MyReviewsResponseModel(
      status: _asString(safeJson['status']),
      message: _asString(safeJson['message']),
      data: MyReviewsData.fromJson(_asMap(safeJson['data'])),
      errors: safeJson['errors'],
    );
  }

  final String? status;
  final String? message;
  final MyReviewsData data;
  final dynamic errors;

  List<MyReviewItemData> get reviews => data.items;
  MyReviewsPaginationData get pagination => data.pagination;
  ReviewSummaryData get summary => ReviewSummaryData.fromDynamic(
    data.summarySource,
    fallbackReviews: reviews,
    pagination: pagination,
  );

  bool get isSuccessful => (status?.toLowerCase() ?? 'success') == 'success';

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
      'errors': errors,
    };
  }
}

class MyReviewsData {
  const MyReviewsData({
    this.items = const <MyReviewItemData>[],
    this.pagination = const MyReviewsPaginationData(),
    this.summarySource,
  });

  factory MyReviewsData.fromJson(Map<String, dynamic>? json) {
    final safeJson = json ?? const <String, dynamic>{};
    final items = _extractReviewItems(safeJson);

    return MyReviewsData(
      items: items,
      pagination: MyReviewsPaginationData.fromJson(
        _asMap(safeJson['pagination']),
        fallbackCount: items.length,
      ),
      summarySource:
          safeJson['summary'] ?? safeJson['stats'] ?? safeJson['meta'],
    );
  }

  final List<MyReviewItemData> items;
  final MyReviewsPaginationData pagination;
  final dynamic summarySource;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(growable: false),
      'pagination': pagination.toJson(),
      if (summarySource != null) 'summary': summarySource,
    };
  }
}

class MyReviewsPaginationData {
  const MyReviewsPaginationData({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 8,
    this.total = 0,
  });

  factory MyReviewsPaginationData.fromJson(
    Map<String, dynamic>? json, {
    int fallbackCount = 0,
  }) {
    final safeJson = json ?? const <String, dynamic>{};
    final total = _asInt(safeJson['total']) ?? fallbackCount;
    final perPage =
        _asInt(safeJson['per_page']) ?? (fallbackCount > 0 ? fallbackCount : 8);
    final derivedLastPage = perPage > 0
        ? ((total + perPage - 1) ~/ perPage)
        : 1;
    final normalizedLastPage = derivedLastPage < 1 ? 1 : derivedLastPage;
    final resolvedLastPage =
        _asInt(safeJson['last_page']) ?? normalizedLastPage;
    final resolvedCurrentPage = _asInt(safeJson['current_page']) ?? 1;

    return MyReviewsPaginationData(
      currentPage: resolvedCurrentPage < 1
          ? 1
          : (resolvedCurrentPage > resolvedLastPage
                ? resolvedLastPage
                : resolvedCurrentPage),
      lastPage: resolvedLastPage < 1 ? 1 : resolvedLastPage,
      perPage: perPage,
      total: total,
    );
  }

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  bool get hasMultiplePages => lastPage > 1;

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}

class ReviewSummaryData {
  const ReviewSummaryData({
    this.totalCount = 0,
    this.pendingCount = 0,
    this.averageRating = 0,
  });

  factory ReviewSummaryData.fromDynamic(
    dynamic value, {
    List<MyReviewItemData> fallbackReviews = const <MyReviewItemData>[],
    MyReviewsPaginationData? pagination,
  }) {
    final fallback = ReviewSummaryData.fromReviews(
      fallbackReviews,
      totalCountOverride: pagination?.total,
    );
    final source = _asMap(value);
    if (source == null) {
      return fallback;
    }

    return ReviewSummaryData(
      totalCount:
          _asInt(
            source['total'] ??
                source['count'] ??
                source['total_reviews'] ??
                source['total_count'],
          ) ??
          pagination?.total ??
          fallback.totalCount,
      pendingCount:
          _asInt(
            source['pending'] ??
                source['pending_reviews'] ??
                source['pending_count'],
          ) ??
          fallback.pendingCount,
      averageRating:
          _asDouble(
            source['average'] ??
                source['average_rating'] ??
                source['avg_rating'] ??
                source['rating_average'],
          ) ??
          fallback.averageRating,
    );
  }

  factory ReviewSummaryData.fromReviews(
    List<MyReviewItemData> reviews, {
    int? totalCountOverride,
  }) {
    final ratedReviews = reviews
        .where((review) => (review.rating ?? 0) > 0)
        .toList(growable: false);
    final ratingTotal = ratedReviews.fold<int>(
      0,
      (sum, review) => sum + (review.rating ?? 0),
    );

    return ReviewSummaryData(
      totalCount: totalCountOverride ?? reviews.length,
      pendingCount: reviews.where((review) => review.isPending).length,
      averageRating: ratedReviews.isEmpty
          ? 0
          : ratingTotal / ratedReviews.length,
    );
  }

  final int totalCount;
  final int pendingCount;
  final double averageRating;
}

class MyReviewItemData {
  const MyReviewItemData({
    this.reviewId,
    this.productId,
    this.productName,
    this.productImageUrl,
    this.rating,
    this.reviewText,
    this.status,
    this.pendingFlag,
    this.createdAt,
  });

  factory MyReviewItemData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyReviewItemData();
    }

    final productSource =
        _asMap(json['product']) ??
        _asMap(json['item']) ??
        _asMap(json['product_data']);
    final mediaSource =
        _asMap(productSource?['media']) ??
        _asMap(json['media']) ??
        _asMap(json['product_media']);
    final explicitReviewId = _asInt(json['review_id']);
    final explicitProductId = _asInt(json['product_id']);
    final fallbackId = _asInt(json['id']);
    final hasReviewMetadata =
        explicitReviewId != null ||
        json['user'] != null ||
        json['rating'] != null ||
        json['stars'] != null ||
        json['score'] != null ||
        json['review'] != null ||
        json['comment'] != null ||
        json['content'] != null ||
        json['feedback'] != null ||
        json['review_status'] != null;

    return MyReviewItemData(
      reviewId: explicitReviewId ?? (hasReviewMetadata ? fallbackId : null),
      productId:
          explicitProductId ??
          _asInt(productSource?['id']) ??
          (!hasReviewMetadata ? fallbackId : null),
      productName:
          _asString(json['product_name']) ??
          _asString(json['title']) ??
          _asString(json['name']) ??
          _asString(productSource?['title']) ??
          _asString(productSource?['name']),
      productImageUrl:
          _asString(json['image']) ??
          _asString(json['thumbnail']) ??
          _asString(productSource?['image']) ??
          _asString(productSource?['thumbnail']) ??
          _asString(mediaSource?['thumbnail']) ??
          _firstGalleryImageUrl(mediaSource?['gallery']),
      rating: _asInt(json['rating'] ?? json['stars'] ?? json['score']),
      reviewText:
          _asString(json['review']) ??
          _asString(json['comment']) ??
          _asString(json['content']) ??
          _asString(json['description']) ??
          _asString(json['feedback']),
      status:
          _asString(json['status']) ??
          _asString(json['review_status']) ??
          _asString(json['state']),
      pendingFlag:
          _asBool(json['is_pending']) ??
          _asBool(json['pending']) ??
          _asBool(json['can_review']) ??
          (_asBool(json['can_review']) == true &&
                  _asInt(json['id'] ?? json['review_id']) == null
              ? true
              : null),
      createdAt: _asDateTime(
        json['created_at'] ??
            json['date'] ??
            json['delivered_at'] ??
            json['reviewed_at'] ??
            json['updated_at'],
      ),
    );
  }

  final int? reviewId;
  final int? productId;
  final String? productName;
  final String? productImageUrl;
  final int? rating;
  final String? reviewText;
  final String? status;
  final bool? pendingFlag;
  final DateTime? createdAt;

  bool get hasReviewContent =>
      (rating ?? 0) > 0 || (reviewText?.trim().isNotEmpty ?? false);

  bool get isPending {
    if (pendingFlag != null) {
      return pendingFlag!;
    }

    final normalizedStatus = status?.trim().toLowerCase();
    if (normalizedStatus != null &&
        (normalizedStatus.contains('pending') ||
            normalizedStatus.contains('draft') ||
            normalizedStatus.contains('await'))) {
      return true;
    }

    return !hasReviewContent;
  }

  bool get canWriteReview =>
      productId != null && (!hasReviewContent || isPending);
  bool get canEditReview => reviewId != null && hasReviewContent;
  bool get canDeleteReview => reviewId != null;

  bool get isEmpty =>
      reviewId == null &&
      productId == null &&
      (productName?.trim().isNotEmpty != true) &&
      (reviewText?.trim().isNotEmpty != true) &&
      rating == null;

  String get identityKey {
    if (reviewId != null) {
      return 'review:$reviewId';
    }

    if (productId != null) {
      return 'product:$productId';
    }

    return 'name:${productName ?? ''}:${rating ?? 0}:${reviewText ?? ''}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': reviewId,
      'product_id': productId,
      'product_name': productName,
      'image': productImageUrl,
      'rating': rating,
      'review': reviewText,
      'status': status,
      'is_pending': pendingFlag,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

List<MyReviewItemData> _extractReviewItems(Map<String, dynamic>? dataSource) {
  final items = <MyReviewItemData>[];
  final seenKeys = <String>{};

  final sources = [
    dataSource?['items'],
    dataSource?['reviews'],
    dataSource?['list'],
    dataSource?['data'],
    dataSource?['pending_reviews'],
    dataSource?['pending'],
    dataSource?['products_to_review'],
  ];

  for (final source in sources) {
    _appendReviewItems(source, items, seenKeys);
  }

  return items;
}

void _appendReviewItems(
  dynamic source,
  List<MyReviewItemData> items,
  Set<String> seenKeys,
) {
  if (source is! List) {
    return;
  }

  for (final item in source) {
    final map = _asMap(item);
    if (map == null) {
      continue;
    }

    final review = MyReviewItemData.fromJson(map);
    if (review.isEmpty || !seenKeys.add(review.identityKey)) {
      continue;
    }

    items.add(review);
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
    return null;
  }

  return normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '');
}

double? _asDouble(dynamic value) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '');
}

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == null || normalized.isEmpty || normalized == 'null') {
    return null;
  }

  if (normalized == '1' || normalized == 'true') {
    return true;
  }

  if (normalized == '0' || normalized == 'false') {
    return false;
  }

  return null;
}

DateTime? _asDateTime(dynamic value) {
  final source = _asString(value);
  if (source == null) {
    return null;
  }

  return DateTime.tryParse(source)?.toLocal();
}

String? _firstGalleryImageUrl(dynamic value) {
  if (value is! List) {
    return null;
  }

  for (final item in value) {
    final map = _asMap(item);
    final imageUrl =
        _asString(map?['image']) ??
        _asString(map?['url']) ??
        _asString(map?['src']);
    if (imageUrl != null) {
      return imageUrl;
    }
  }

  return null;
}
