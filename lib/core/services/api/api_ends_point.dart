class ApiEndpoints {
  static const String version = 'api';
  static const String login = '$version/auth/login';
  static const String logout = '$version/auth/logout';
  static const String refreshToken = '$version/auth/refresh-token';
  static const String signup = '$version/auth/register';
  static const String verifyOtp = '$version/auth/email/otp/verify';
  static const String resendOtp = '$version/auth/email/otp/resend';
  static const String deleteAccountWithCredentials =
      '$version/account/delete-with-credentials';
  static const String sendForgotPasswordOtp = '$version/auth/password/otp/send';
  static const String forgotPasswordVerifyOtp =
      '$version/auth/password/otp/verify';
  static const String resetPassword = '$version/auth/password/reset';
  static const String products = '$version/products';
  static const String collections = '$version/collections';
  static const String chat = '$version/chat';
  static const String contactSupport = '$version/support';
  static const String addresses = '$version/addresses';
  static const String profile = '$version/profile';
  static const String accountUpdate = '$version/profile/update';
  static const String brands = '$version/brands';
  static const String verifyTwoFactor = '$version/auth/verify-2fa';
  static const String cart = '$version/cart';
  static const String cartAdd = '$cart/add';
  static const String cartUpdate = '$cart/update';
  static const String cartRemove = '$cart/remove';
  static const String wishlist = '$version/wishlist';
  static const String wishlistToggle = '$wishlist/toggle';
  static const String reviews = '$version/reviews';
  static const String pages = '$version/pages';
  static const String recommendations = '$version/recommendations';
  static const String wardrobes = '$version/wardrobes';
  static const String wardrobeItems = '$version/wardrobe-items';
  static const String tryOnGenerate = '$version/try-on/generate';
  static const String tryOnResult = '$version/tryon/result';
  static const String chatSessions = '$chat/sessions';
  static const String privacyPolicyPage = '$pages/privacy-policy';
  static const String termsAndConditionsPage = '$pages/terms-and-conditions';
  static const String returnPolicyPage = '$pages/return-policy';

  static String productDetails(int productId) => '$products/$productId';
  static String addProductReview(int productId) =>
      '$version/products/$productId/review';
  static String collectionDetails(int collectionId) =>
      '$collections/$collectionId';
  static String updateAddress(int addressId) => '$addresses/$addressId/update';
  static String deleteAddress(int addressId) => '$addresses/$addressId';
  static String updateReview(int reviewId) => '$reviews/$reviewId/update';
  static String deleteReview(int reviewId) => '$reviews/$reviewId';
  static String wardrobe(int wardrobeId) => '$wardrobes/$wardrobeId';
  static String chatSessionMessages(int sessionId) =>
      '$chat/sessions/$sessionId/messages';
  static String chatSession(int sessionId) => '$chat/sessions/$sessionId';
}
