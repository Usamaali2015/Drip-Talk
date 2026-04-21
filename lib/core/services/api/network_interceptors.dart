import 'api_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await InternetConnectivity.instance.checkConnection();

    if (!isConnected) {
      AppLogger.log('❌ Offline → ${options.uri}');
      final noInternetMessage = localizedString(
        fallback: 'No internet connection',
        select: (l10n) => l10n.noInternet,
      );

      final context = AppKeys.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        ToastUtils.show(context, noInternetMessage, type: ToastType.error);
      }

      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: noInternetMessage,
          error: ApiException(message: noInternetMessage),
        ),
        true,
      );
    }

    handler.next(options);
  }
}
