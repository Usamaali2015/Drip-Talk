import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class DioInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (CancelToken.isCancel(err)) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const ApiException(message: 'Request canceled'),
        ),
      );
      return;
    }

    final statusCode = err.response?.statusCode;
    String message = 'Something went wrong';

    if (err.response?.data is Map) {
      final data = err.response!.data;

      if (data['errors'] != null && data['errors'] is Map) {
        final Map<String, dynamic> errors = data['errors'];
        message = errors.values.first[0].toString();
      } else {
        message = data['message'] ?? 'Validation failed';
      }
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ApiException(message: message, statusCode: statusCode),
      ),
    );
  }
}
