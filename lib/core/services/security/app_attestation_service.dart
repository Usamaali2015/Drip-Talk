import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppAttestationProof {
  const AppAttestationProof({
    required this.provider,
    required this.assertion,
    this.keyId,
  });

  factory AppAttestationProof.fromMap(Map<Object?, Object?> source) {
    return AppAttestationProof(
      provider: source['provider']?.toString().trim() ?? 'unknown',
      assertion: source['assertion']?.toString().trim() ?? '',
      keyId: source['keyId']?.toString().trim(),
    );
  }

  final String provider;
  final String assertion;
  final String? keyId;
}

abstract class AppAttestationService {
  String createNonce();

  String createRequestBinding({
    required String method,
    required Uri uri,
    Object? data,
  });

  Future<AppAttestationProof?> generateProof({
    required String nonce,
    required String requestBinding,
  });
}

class MethodChannelAppAttestationService implements AppAttestationService {
  MethodChannelAppAttestationService();

  static const MethodChannel _channel = MethodChannel(
    'drip_talk/security/app_attestation',
  );

  final Random _random = Random.secure();
  bool _channelUnavailable = false;

  @override
  String createNonce() {
    final bytes = List<int>.generate(18, (_) => _random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  @override
  String createRequestBinding({
    required String method,
    required Uri uri,
    Object? data,
  }) {
    final binding = <String, Object?>{
      'method': method.trim().toUpperCase(),
      'scheme': uri.scheme,
      'host': uri.host,
      'port': uri.hasPort ? uri.port : null,
      'path': uri.path,
      'query': _normalizeQuery(uri.queryParametersAll),
      'body': _normalizeData(data),
    };

    return base64UrlEncode(utf8.encode(jsonEncode(binding))).replaceAll(
      '=',
      '',
    );
  }

  @override
  Future<AppAttestationProof?> generateProof({
    required String nonce,
    required String requestBinding,
  }) async {
    if (_channelUnavailable || kIsWeb) {
      return null;
    }

    try {
      final response = await _channel.invokeMapMethod<Object?, Object?>(
        'generateAssertion',
        <String, Object?>{
          'nonce': nonce,
          'requestBinding': requestBinding,
        },
      );

      if (response == null || response.isEmpty) {
        return null;
      }

      final proof = AppAttestationProof.fromMap(response);
      if (proof.assertion.isEmpty) {
        return null;
      }

      return proof;
    } on MissingPluginException {
      _channelUnavailable = true;
      return null;
    } on PlatformException {
      return null;
    }
  }

  Map<String, Object?> _normalizeQuery(Map<String, List<String>> query) {
    final entries = query.entries.toList()
      ..sort((left, right) => left.key.compareTo(right.key));

    return <String, Object?>{
      for (final entry in entries)
        entry.key: List<String>.from(entry.value)..sort((a, b) => a.compareTo(b)),
    };
  }

  Object? _normalizeData(Object? data) {
    if (data == null) {
      return null;
    }

    if (data is FormData) {
      return <String, Object?>{
        'fields': data.fields
            .map((entry) => <String, String>{
              'key': entry.key,
              'value': entry.value,
            })
            .toList(),
        'files': data.files
            .map((entry) => <String, String?>{
              'key': entry.key,
              'filename': entry.value.filename,
              'contentType': entry.value.contentType?.toString(),
            })
            .toList(),
      };
    }

    if (data is Map) {
      final entries = data.entries.toList()
        ..sort(
          (left, right) => left.key.toString().compareTo(right.key.toString()),
        );

      return <String, Object?>{
        for (final entry in entries)
          entry.key.toString(): _normalizeData(entry.value),
      };
    }

    if (data is Iterable) {
      return data.map<Object?>((item) => _normalizeData(item)).toList();
    }

    if (data is num || data is bool || data is String) {
      return data;
    }

    return data.toString();
  }
}
