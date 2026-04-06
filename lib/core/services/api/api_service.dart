import 'dart:io';
import 'package:dio/dio.dart';
import 'api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  CancelToken createCancelToken() => CancelToken();

  void cancelRequest(CancelToken token) {
    if (!token.isCancelled) {
      token.cancel();
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> uploadFile<T>(
    String path, {
    required Map<String, dynamic> fields,
    required List<File> files,
    String fileKey = 'files',
    CancelToken? cancelToken,
    void Function(int sentBytes, int totalBytes)? onProgress,
  }) async {
    final formData = FormData();

    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    for (final file in files) {
      formData.files.add(
        MapEntry(fileKey, await MultipartFile.fromFile(file.path)),
      );
    }

    return _dio.post<T>(
      path,
      data: formData,
      options: Options(contentType: ApiConstants.multiPart),
      cancelToken: cancelToken,
      onSendProgress: onProgress,
    );
  }
}
