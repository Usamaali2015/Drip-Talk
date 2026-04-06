class ApiEndpoints {
  static const String version = 'api';
  static const String login = '$version/auth/login';
  static const String logout = '$version/auth/logout';
  static const String signup = '$version/auth/register';
  static const String verifyOtp = '$version/auth/email/otp/verify';

  static const String resendOtp = '$version/auth/email/otp/resend';
  static const String deleteAccountWithCredentials =
      '$version/account/delete-with-credentials';

  static const String sendForgotPasswordOtp = '$version/auth/password/otp/send';

  static const String forgotPasswordVerifyOtp =
      '$version/auth/password/otp/verify';

  static const String resetPassword = '$version/auth/password/reset';

  static const String products = '$version/fashion-ai/products';
  static const String collections = '$version/fashion-ai/collections';
  static const String chat = '$version/fashion-ai/chat';
  static const String cart = '$version/fashion-ai/cart';
  static const String cartAdd = '$cart/add';
  static const String cartUpdate = '$cart/update';
  static const String cartRemove = '$cart/remove';
  static const String wishlist = '$version/fashion-ai/wishlist';
  static const String wishlistToggle = '$wishlist/toggle';

  static String productDetails(int productId) => '$products/$productId';
  static String collectionDetails(int collectionId) =>
      '$collections/$collectionId';
}
