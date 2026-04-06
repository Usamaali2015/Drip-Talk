import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/auth/forgot/view/domain/bloc/forgot_password_bloc.dart';
import 'package:drip_talk/features/auth/login/bloc/login_bloc.dart';
import 'package:drip_talk/features/auth/otp/domain/bloc/otp_bloc.dart';
import 'package:drip_talk/features/auth/reset/bloc/reset_password_bloc.dart';
import 'package:drip_talk/features/auth/signup/domain/bloc/sign_up_bloc.dart';
import 'package:drip_talk/features/cart/data/repository/cart_repository.dart';
import 'package:drip_talk/features/cart/domain/bloc/cart_bloc.dart';
import 'package:drip_talk/features/chat/data/chat_repository.dart';
import 'package:drip_talk/features/chat/domain/chat_bloc.dart';
import 'package:drip_talk/features/product/data/repository/product_preferences_repository.dart';
import 'package:drip_talk/features/product/data/repository/product_repository.dart';
import 'package:drip_talk/features/product/domain/bloc/product_bloc.dart';
import 'package:drip_talk/features/shop/data/repository/shop_repository.dart';
import 'package:drip_talk/features/shop/domain/ai_curated_collection_details_bloc.dart';
import 'package:drip_talk/features/shop/domain/shop_bloc.dart';
import 'package:drip_talk/features/wishlist/data/repository/wishlist_repository.dart';
import 'package:drip_talk/features/wishlist/domain/bloc/wishlist_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:drip_talk/l10n/bloc/localization_bloc.dart';
import 'package:drip_talk/core/services/storage/secure_storage.dart';
import '../api/dio_client.dart';
import '../api/api_service.dart';

final getIt = GetIt.instance;

Future<void> setupServices() async {
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AuthSessionRepository>(
    () => AuthSessionRepository(SecureStorage.instance),
  );

  final authToken = await getIt<AuthSessionRepository>().getAuthToken();
  if (authToken != null && authToken.isNotEmpty) {
    getIt<DioClient>().setAuthToken(authToken);
  }

  getIt.registerFactory<LocalizationBloc>(() => LocalizationBloc());

  getIt.registerFactory<ResetPasswordBloc>(
    () => ResetPasswordBloc(getIt<AuthRepository>()),
  );
  getIt.registerFactory<SignUpBloc>(
    () => SignUpBloc(getIt<AuthRepository>(), getIt<AuthSessionRepository>()),
  );
  getIt.registerFactory<OtpBloc>(
    () => OtpBloc(getIt<AuthRepository>(), getIt<AuthSessionRepository>()),
  );
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      getIt<AuthRepository>(),
      getIt<AuthSessionRepository>(),
      getIt<DioClient>(),
    ),
  );
  getIt.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(getIt<AuthRepository>()),
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

  getIt.registerFactory<ShopBloc>(() => ShopBloc(getIt<ShopRepository>()));
  getIt.registerFactory<AiCuratedCollectionDetailsBloc>(
    () => AiCuratedCollectionDetailsBloc(getIt<ShopRepository>()),
  );
  getIt.registerFactory<ChatBloc>(() => ChatBloc(getIt<ChatRepository>()));
  getIt.registerLazySingleton<CartBloc>(
    () => CartBloc(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<WishlistBloc>(
    () => WishlistBloc(getIt<WishlistRepository>()),
  );
}
