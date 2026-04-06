import 'dart:async';
import 'package:dio/dio.dart';
import 'package:drip_talk/core/common/constants/app_durations.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = AppDurations.oneSecond,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      final requestOptions = err.requestOptions;
      final retryCount = (requestOptions.extra['retry_count'] ?? 0) as int;

      if (retryCount < maxRetries) {
        requestOptions.extra['retry_count'] = retryCount + 1;

        await Future.delayed(retryDelay);

        try {
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.reject(err);
        }
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    if (CancelToken.isCancel(err)) return false;

    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
