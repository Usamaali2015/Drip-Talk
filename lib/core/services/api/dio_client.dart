import 'api_barrels.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(
            milliseconds: ApiConstants.connectTimeout,
          ),
          receiveTimeout: const Duration(
            milliseconds: ApiConstants.receiveTimeout,
          ),
          headers: ApiConstants.defaultHeaders,
        ),
      ) {
    dio.interceptors.addAll([
      DioInterceptors(),
      RetryInterceptor(dio: dio),
      NetworkInterceptor(),
    ]);
  }

  void setAuthToken(String token) {
    dio.options.headers[ApiConstants.authorization] =
        '${ApiConstants.bearer} $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove(ApiConstants.authorization);
  }
}
