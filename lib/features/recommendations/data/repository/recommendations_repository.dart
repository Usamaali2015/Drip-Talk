import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_constants.dart';
import 'package:drip_talk/core/services/api/api_ends_point.dart';
import 'package:drip_talk/core/services/api/api_service.dart';
import 'package:drip_talk/features/recommendations/data/models/recommendations_model.dart';
import 'package:drip_talk/features/recommendations/data/models/recommendations_request_model.dart';
import 'package:drip_talk/features/recommendations/data/models/try_on_generate_request_model.dart';
import 'package:drip_talk/features/recommendations/data/models/try_on_generate_response_model.dart';
import 'package:drip_talk/features/recommendations/data/models/try_on_result_model.dart';
import 'package:flutter/foundation.dart';

class RecommendationsRepository {
  RecommendationsRepository(this._apiService);

  final ApiService _apiService;

  Future<RecommendationsModel> getRecommendations(
    RecommendationsRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final queryParameters = request.toQueryParameters();
    final response = await _apiService.get(
      ApiEndpoints.recommendations,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
      cancelToken: cancelToken,
    );
    final responseData = _asMap(response.data);

    _logDebug(
      'RecommendationsRepository.getRecommendations:\n${_formatResponseData(response.data)}',
    );

    final recommendations = RecommendationsModel.fromJson(responseData);
    _logDebug(
      'RecommendationsRepository.getRecommendations items: ${recommendations.items.length}',
    );

    return recommendations;
  }

  Future<TryOnGenerateResponseModel> generateTryOn(
    TryOnGenerateRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final temporaryDirectory = await Directory.systemTemp.createTemp(
      'drip_talk_try_on_',
    );

    try {
      final dressImageFiles = await _downloadDressImages(
        request.dressImageUrls,
        directory: temporaryDirectory,
        cancelToken: cancelToken,
      );
      if (dressImageFiles.isEmpty) {
        throw Exception(
          'No liked dress images could be prepared for try-on generation.',
        );
      }

      final payload = await request.toFormData(dressImageFiles);
      _logDebug(
        'RecommendationsRepository.generateTryOn payload:\n'
        '${const JsonEncoder.withIndent("  ").convert(request.toDebugMap())}',
      );

      final response = await _apiService.post(
        ApiEndpoints.tryOnGenerate,
        data: payload,
        options: Options(contentType: ApiConstants.multiPart),
        cancelToken: cancelToken,
        requiresAppAttestation: true,
      );

      _logDebug(
        'RecommendationsRepository.generateTryOn:\n'
        '${_formatResponseData(response.data)}',
      );

      return TryOnGenerateResponseModel.fromJson(_asMap(response.data));
    } finally {
      if (temporaryDirectory.existsSync()) {
        await temporaryDirectory.delete(recursive: true);
      }
    }
  }

  Future<TryOnResultModel> getTryOnResult(
    String batchId, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.tryOnResult,
      queryParameters: <String, dynamic>{'batch_id': batchId},
      cancelToken: cancelToken,
    );

    _logDebug(
      'RecommendationsRepository.getTryOnResult:\n'
      '${_formatResponseData(response.data)}',
    );

    return TryOnResultModel.fromJson(_asMap(response.data));
  }

  Future<List<File>> _downloadDressImages(
    List<String> imageUrls, {
    required Directory directory,
    CancelToken? cancelToken,
  }) async {
    final files = <File>[];

    for (var index = 0; index < imageUrls.length; index++) {
      if (cancelToken?.isCancelled == true) {
        break;
      }

      final imageUrl = imageUrls[index].trim();
      if (imageUrl.isEmpty) {
        continue;
      }

      final file = await _downloadRemoteFile(
        imageUrl,
        destinationPath:
            '${directory.path}/dress_$index${_resolveExtension(imageUrl)}',
      );
      files.add(file);
    }

    return files;
  }

  Future<File> _downloadRemoteFile(
    String url, {
    required String destinationPath,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme.toLowerCase() != 'https') {
      throw Exception('Invalid try-on dress image URL: $url');
    }

    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('Failed to download try-on dress image', uri: uri);
      }

      final bytes = await consolidateHttpClientResponseBytes(response);
      final file = File(destinationPath);
      await file.writeAsBytes(bytes, flush: true);
      return file;
    } finally {
      client.close(force: true);
    }
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

String _formatResponseData(dynamic value) {
  try {
    if (value is Map || value is List) {
      return const JsonEncoder.withIndent('  ').convert(value);
    }
  } catch (_) {}

  return value?.toString() ?? 'null';
}

String _resolveExtension(String url) {
  final uri = Uri.tryParse(url);
  final lastSegment = uri?.pathSegments.isNotEmpty == true
      ? uri!.pathSegments.last
      : '';
  final dotIndex = lastSegment.lastIndexOf('.');
  if (dotIndex <= 0 || dotIndex == lastSegment.length - 1) {
    return '.jpg';
  }

  final extension = lastSegment.substring(dotIndex);
  return extension.length > 5 ? '.jpg' : extension;
}

void _logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
