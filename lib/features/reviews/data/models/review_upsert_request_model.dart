class ReviewUpsertRequestModel {
  const ReviewUpsertRequestModel({
    this.productId,
    required this.rating,
    required this.review,
  });

  final int? productId;
  final int rating;
  final String review;

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'review': review.trim(),
      if (productId != null) 'product_id': productId,
    };
  }
}
