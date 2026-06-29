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
    bool requiresAppAttestation = false,
    bool enforceAppAttestation = false,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: _mergeSecurityOptions(
        options,
        requiresAppAttestation: requiresAppAttestation,
        enforceAppAttestation: enforceAppAttestation,
      ),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAppAttestation = false,
    bool enforceAppAttestation = false,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      options: _mergeSecurityOptions(
        options,
        requiresAppAttestation: requiresAppAttestation,
        enforceAppAttestation: enforceAppAttestation,
      ),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAppAttestation = false,
    bool enforceAppAttestation = false,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      options: _mergeSecurityOptions(
        options,
        requiresAppAttestation: requiresAppAttestation,
        enforceAppAttestation: enforceAppAttestation,
      ),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAppAttestation = false,
    bool enforceAppAttestation = false,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      options: _mergeSecurityOptions(
        options,
        requiresAppAttestation: requiresAppAttestation,
        enforceAppAttestation: enforceAppAttestation,
      ),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> uploadFile<T>(
    String path, {
    required Map<String, dynamic> fields,
    required List<File> files,
    String fileKey = 'files',
    Options? options,
    CancelToken? cancelToken,
    void Function(int sentBytes, int totalBytes)? onProgress,
    bool requiresAppAttestation = false,
    bool enforceAppAttestation = false,
  }) async {
    final formData = FormData();

    fields.forEach((key, value) {
      if (value is Iterable) {
        for (final item in value) {
          formData.fields.add(MapEntry(key, item.toString()));
        }
        return;
      }

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
      options: _mergeSecurityOptions(
        (options ?? Options()).copyWith(contentType: ApiConstants.multiPart),
        requiresAppAttestation: requiresAppAttestation,
        enforceAppAttestation: enforceAppAttestation,
      ),
      cancelToken: cancelToken,
      onSendProgress: onProgress,
    );
  }

  Options _mergeSecurityOptions(
    Options? options, {
    required bool requiresAppAttestation,
    required bool enforceAppAttestation,
  }) {
    if (!requiresAppAttestation && !enforceAppAttestation) {
      return options ?? Options();
    }

    final extra = <String, dynamic>{...?options?.extra};
    if (requiresAppAttestation) {
      extra[ApiConstants.requiresAppAttestationExtra] = true;
    }
    if (enforceAppAttestation) {
      extra[ApiConstants.enforceAppAttestationExtra] = true;
    }

    return (options ?? Options()).copyWith(extra: extra);
  }
}
