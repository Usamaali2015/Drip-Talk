import 'package:dio/dio.dart';
import 'package:drip_talk/core/services/api/api_exceptions.dart';

String resolveApiErrorMessage(
  Object error, {
  String fallback = 'Something went wrong',
}) {
  if (error is ApiException) {
    final message = _sanitizeErrorMessage(error.message);
    return message.isEmpty ? fallback : message;
  }

  if (error is DioException) {
    final nestedError = error.error;
    if (nestedError is ApiException) {
      final message = _sanitizeErrorMessage(nestedError.message);
      if (message.isNotEmpty) {
        return message;
      }
    }

    final responseMessage = _extractResponseMessage(error.response?.data);
    if (responseMessage.isNotEmpty) {
      return responseMessage;
    }

    final dioMessage = _sanitizeErrorMessage(error.message);
    if (dioMessage.isNotEmpty) {
      return dioMessage;
    }

    final nestedMessage = _sanitizeErrorMessage(nestedError?.toString());
    if (nestedMessage.isNotEmpty) {
      return nestedMessage;
    }
  }

  final message = _sanitizeErrorMessage(error.toString());
  return message.isEmpty ? fallback : message;
}

String _extractResponseMessage(dynamic data) {
  if (data is! Map) {
    return '';
  }

  final errors = data['errors'];
  if (errors is Map && errors.isNotEmpty) {
    final firstValue = errors.values.first;
    if (firstValue is List && firstValue.isNotEmpty) {
      final message = _sanitizeErrorMessage(firstValue.first?.toString());
      if (message.isNotEmpty) {
        return message;
      }
    }

    final message = _sanitizeErrorMessage(firstValue?.toString());
    if (message.isNotEmpty) {
      return message;
    }
  }

  return _sanitizeErrorMessage(data['message']?.toString());
}

String _sanitizeErrorMessage(String? value) {
  if (value == null) {
    return '';
  }

  var message = value.trim();
  if (message.isEmpty || message.toLowerCase() == 'null') {
    return '';
  }

  message = message.replaceFirst(
    RegExp(r'^DioException \[[^\]]+\]:\s*', caseSensitive: false),
    '',
  );

  if (message.toLowerCase() == 'null') {
    return '';
  }

  return message.trim();
}
