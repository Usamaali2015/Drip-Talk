import 'package:drip_talk/core/services/security/app_attestation_service.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/biometric/data/repository/biometric_auth_repository.dart';
import 'package:drip_talk/features/auth/biometric/domain/bloc/biometric_auth_bloc.dart';
import 'package:drip_talk/features/auth/forgot/view/domain/bloc/forgot_password_bloc.dart';
import 'package:drip_talk/features/auth/login/bloc/login_bloc.dart';
import 'package:drip_talk/features/auth/profile_setup/domain/bloc/profile_setup_bloc.dart';
import 'package:drip_talk/features/auth/profile_setup/data/repository/profile_setup_brands_repository.dart';
import 'package:drip_talk/features/auth/otp/domain/bloc/otp_bloc.dart';
import 'package:drip_talk/features/auth/reset/bloc/reset_password_bloc.dart';
import 'package:drip_talk/features/auth/signup/domain/bloc/sign_up_bloc.dart';
import 'package:drip_talk/features/auth/two_factor/domain/bloc/two_factor_login_bloc.dart';
import 'package:drip_talk/features/address/data/repository/address_repository.dart';
import 'package:drip_talk/features/address/domain/bloc/add_address_bloc.dart';
import 'package:drip_talk/features/address/domain/bloc/my_addresses_bloc.dart';
import 'package:drip_talk/features/cart/data/repository/cart_repository.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/chat/data/chat_repository.dart';
import 'package:drip_talk/features/chat/data/chat_session_repository.dart';
import 'package:drip_talk/features/chat/data/services/chat_generation_realtime_service.dart';
import 'package:drip_talk/features/chat/domain/chat_bloc.dart';
import 'package:drip_talk/features/contact_support/data/repository/contact_support_repository.dart';
import 'package:drip_talk/features/contact_support/domain/bloc/contact_support_bloc.dart';
import 'package:drip_talk/features/dashboard/profile/data/repository/profile_repository.dart';
import 'package:drip_talk/features/dashboard/profile/domain/bloc/edit_profile_bloc.dart';
import 'package:drip_talk/features/help_center/data/repository/help_center_repository.dart';
import 'package:drip_talk/features/help_center/domain/bloc/help_center_bloc.dart';
import 'package:drip_talk/features/legal_pages/data/repository/legal_pages_repository.dart';
import 'package:drip_talk/features/payment_methods/data/repository/payment_methods_repository.dart';
import 'package:drip_talk/features/payment_methods/domain/bloc/payment_methods_bloc.dart';
import 'package:drip_talk/features/product/data/repository/product_preferences_repository.dart';
import 'package:drip_talk/features/product/data/repository/product_repository.dart';
import 'package:drip_talk/features/product/domain/bloc/product_bloc.dart';
import 'package:drip_talk/features/recommendations/data/repository/recommendations_repository.dart';
import 'package:drip_talk/features/recommendations/data/services/try_on_realtime_service.dart';
import 'package:drip_talk/features/recommendations/domain/bloc/recommendations_bloc.dart';
import 'package:drip_talk/features/recommendations/domain/services/recommendations_photo_validator.dart';
import 'package:drip_talk/features/return_policy/data/repository/return_policy_repository.dart';
import 'package:drip_talk/features/return_policy/domain/bloc/return_policy_bloc.dart';
import 'package:drip_talk/features/reviews/data/repository/review_repository.dart';
import 'package:drip_talk/features/reviews/domain/bloc/my_reviews_bloc.dart';
import 'package:drip_talk/features/reviews/domain/bloc/product_review_bloc.dart';
import 'package:drip_talk/features/shop/data/repository/shop_repository.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/wardrobe/data/repository/wardrobe_repository.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/create_wardrobe_bloc.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_details_bloc.dart';
import 'package:drip_talk/features/wardrobe/domain/bloc/wardrobe_list_bloc.dart';
import 'package:drip_talk/features/wardrobe/domain/wardrobe_sync_notifier.dart';
import 'package:drip_talk/features/wishlist/data/repository/wishlist_repository.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_bloc.dart';
import 'package:drip_talk/features/permission/domain/bloc/permission_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:drip_talk/l10n/bloc/localization_bloc.dart';
import 'package:drip_talk/core/services/storage/secure_storage.dart';
import '../api/dio_client.dart';
import '../api/api_service.dart';

final getIt = GetIt.instance;
Future<void>? _startupAuthSessionRestoreFuture;

Future<void> setupServices() async {
  getIt.registerLazySingleton<AuthSessionRepository>(
    () => AuthSessionRepository(SecureStorage.instance),
  );
  getIt.registerLazySingleton<BiometricAuthRepository>(
    () => BiometricAuthRepository(SecureStorage.instance),
  );
  getIt.registerLazySingleton<AppAttestationService>(
    () => MethodChannelAppAttestationService(),
  );
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      getIt<AuthSessionRepository>(),
      getIt<BiometricAuthRepository>(),
      getIt<AppAttestationService>(),
    ),
  );
  await getIt<DioClient>().restoreLanguageCode();

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiService>()),
  );

  getIt.registerFactory<LocalizationBloc>(() => LocalizationBloc());

  getIt.registerFactory<ResetPasswordBloc>(
    () => ResetPasswordBloc(
      getIt<AuthRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
    ),
  );
  getIt.registerFactory<SignUpBloc>(
    () => SignUpBloc(
      getIt<AuthRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
    ),
  );
  getIt.registerFactory<OtpBloc>(
    () => OtpBloc(
      getIt<AuthRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
    ),
  );
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      getIt<AuthRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
      getIt<BiometricAuthRepository>(),
    ),
  );
  getIt.registerFactory<BiometricAuthBloc>(
    () => BiometricAuthBloc(
      getIt<BiometricAuthRepository>(),
      getIt<AuthRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
      getIt<ProfileRepository>(),
    ),
  );
  getIt.registerFactory<TwoFactorLoginBloc>(
    () => TwoFactorLoginBloc(
      getIt<AuthRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
      getIt<ProfileRepository>(),
      getIt<BiometricAuthRepository>(),
    ),
  );
  getIt.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(getIt<AuthRepository>()),
  );
  getIt.registerFactory<ContactSupportBloc>(
    () => ContactSupportBloc(
      getIt<ContactSupportRepository>(),
      getIt<AuthSessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProductPreferencesRepository>(
    () => ProductPreferencesRepository(SecureStorage.instance),
  );
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(
      getIt<ProductRepository>(),
      getIt<ProductPreferencesRepository>(),
    ),
  );

  getIt.registerLazySingleton<ShopRepository>(
    () => ShopRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<WishlistRepository>(
    () => WishlistRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChatGenerationRealtimeService>(
    () => ChatGenerationRealtimeService(
      getIt<DioClient>(),
      getIt<AuthSessionRepository>(),
    ),
  );
  getIt.registerLazySingleton<ContactSupportRepository>(
    () => ContactSupportRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProfileSetupBrandsRepository>(
    () => ProfileSetupBrandsRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RecommendationsRepository>(
    () => RecommendationsRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<TryOnRealtimeService>(
    () => TryOnRealtimeService(
      getIt<DioClient>(),
      getIt<AuthSessionRepository>(),
    ),
  );
  getIt.registerLazySingleton<ReviewRepository>(
    () => ReviewRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<HelpCenterRepository>(
    () => HelpCenterRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<LegalPagesRepository>(
    () => LegalPagesRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<PaymentMethodsRepository>(
    () => PaymentMethodsRepository(),
  );
  getIt.registerLazySingleton<ReturnPolicyRepository>(
    () => ReturnPolicyRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChatSessionRepository>(
    () => ChatSessionRepository(SecureStorage.instance),
  );
  getIt.registerLazySingleton<WardrobeRepository>(
    () => WardrobeRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<WardrobeSyncNotifier>(
    () => WardrobeSyncNotifier(),
  );

  getIt.registerFactory<ShopBloc>(() => ShopBloc(getIt<ShopRepository>()));
  getIt.registerFactory<AiCuratedCollectionDetailsBloc>(
    () => AiCuratedCollectionDetailsBloc(getIt<ShopRepository>()),
  );
  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(
      getIt<ChatRepository>(),
      getIt<ChatSessionRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<ChatGenerationRealtimeService>(),
    ),
  );
  getIt.registerFactory<AddAddressBloc>(
    () => AddAddressBloc(getIt<AddressRepository>()),
  );
  getIt.registerFactory<MyAddressesBloc>(
    () => MyAddressesBloc(getIt<AddressRepository>()),
  );
  getIt.registerFactory<EditProfileBloc>(
    () => EditProfileBloc(
      getIt<ProfileRepository>(),
      getIt<AddressRepository>(),
      getIt<BiometricAuthRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
    ),
  );
  getIt.registerFactory<ProfileSetupBloc>(
    () => ProfileSetupBloc(
      getIt<ProfileRepository>(),
      getIt<ProfileSetupBrandsRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
    ),
  );
  getIt.registerFactory<RecommendationsBloc>(
    () => RecommendationsBloc(
      getIt<RecommendationsRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
      getIt<TryOnRealtimeService>(),
      RecommendationsPhotoValidator(),
    ),
  );
  getIt.registerFactory<MyReviewsBloc>(
    () => MyReviewsBloc(getIt<ReviewRepository>()),
  );
  getIt.registerFactory<WardrobeListBloc>(
    () => WardrobeListBloc(getIt<WardrobeRepository>()),
  );
  getIt.registerFactory<WardrobeDetailsBloc>(
    () => WardrobeDetailsBloc(
      getIt<WardrobeRepository>(),
      getIt<WardrobeSyncNotifier>(),
    ),
  );
  getIt.registerFactory<CreateWardrobeBloc>(
    () => CreateWardrobeBloc(getIt<WardrobeRepository>()),
  );
  getIt.registerFactory<ProductReviewBloc>(
    () => ProductReviewBloc(getIt<ReviewRepository>()),
  );
  getIt.registerFactory<HelpCenterBloc>(
    () => HelpCenterBloc(getIt<HelpCenterRepository>()),
  );
  getIt.registerFactory<PaymentMethodsBloc>(
    () => PaymentMethodsBloc(getIt<PaymentMethodsRepository>()),
  );
  getIt.registerFactory<ReturnPolicyBloc>(
    () => ReturnPolicyBloc(getIt<ReturnPolicyRepository>()),
  );
  getIt.registerLazySingleton<CartBloc>(
    () => CartBloc(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<WishlistBloc>(
    () => WishlistBloc(getIt<WishlistRepository>()),
  );
  getIt.registerFactory<PermissionBloc>(() => PermissionBloc());
}

Future<void> restoreStartupAuthSession() {
  final existingFuture = _startupAuthSessionRestoreFuture;
  if (existingFuture != null) {
    return existingFuture;
  }

  final future = _restoreStartupAuthSession();
  _startupAuthSessionRestoreFuture = future;
  return future;
}

Future<void> _restoreStartupAuthSession() async {
  final authSessionRepository = getIt<AuthSessionRepository>();
  final dioClient = getIt<DioClient>();

  final authToken = await authSessionRepository.getAuthToken();
  if (authToken != null && authToken.isNotEmpty) {
    dioClient.setAuthToken(authToken);
  }
}
