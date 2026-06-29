import 'dart:convert';

class TryOnGenerateResponseModel {
  const TryOnGenerateResponseModel({
    this.status,
    this.message,
    this.batchId,
    this.channelName,
    this.progress,
  });

  factory TryOnGenerateResponseModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final data = _asMap(source?['data']);

    return TryOnGenerateResponseModel(
      status:
          _asString(data?['status']) ??
          _asString(data?['job_status']) ??
          _asString(data?['state']) ??
          _asString(source?['status']) ??
          _asString(source?['job_status']) ??
          _asString(source?['state']),
      message: _asString(source?['message']) ?? _asString(data?['message']),
      batchId:
          _asString(data?['batch_id']) ??
          _asString(data?['batch_uuid']) ??
          _asString(data?['batchId']) ??
          _asString(source?['batch_id']) ??
          _asString(source?['batch_uuid']) ??
          _asString(source?['batchId']),
      channelName:
          _asString(data?['channel_name']) ??
          _asString(data?['channel']) ??
          _asString(data?['websocket_channel']) ??
          _asString(data?['websocket_channel_name']) ??
          _asString(data?['ws_channel']) ??
          _asString(source?['channel_name']) ??
          _asString(source?['channel']) ??
          _asString(source?['websocket_channel']) ??
          _asString(source?['websocket_channel_name']) ??
          _asString(source?['ws_channel']),
      progress:
          _asInt(data?['progress']) ??
          _asInt(data?['percentage']) ??
          _asInt(source?['progress']) ??
          _asInt(source?['percentage']),
    );
  }

  factory TryOnGenerateResponseModel.fromRawJson(String value) =>
      TryOnGenerateResponseModel.fromJson(
        json.decode(value) as Map<String, dynamic>?,
      );

  final String? status;
  final String? message;
  final String? batchId;
  final String? channelName;
  final int? progress;

  bool get hasBatchId => batchId?.trim().isNotEmpty == true;

  bool get hasChannelName => channelName?.trim().isNotEmpty == true;
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

String? _asString(dynamic value) {
  final normalized = value?.toString().trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is double) {
    return value.round();
  }

  return int.tryParse(value?.toString() ?? '');
}
