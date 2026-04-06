
import 'api_barrels.dart';
class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await InternetConnectivity.instance.checkConnection();

    if (!isConnected) {
      AppLogger.log('❌ Offline → ${options.uri}');

      final context = AppKeys.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        ToastUtils.show(
          context,
          'No internet connection',
          type: ToastType.error,
        );
      }

      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No Internet Connection',
        ),
        true,
      );
    }

    handler.next(options);
  }
}
