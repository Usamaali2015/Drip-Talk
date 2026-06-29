import 'dart:convert';

class TryOnResultModel {
  const TryOnResultModel({
    this.status,
    this.message,
    this.batchId,
    this.progress,
    this.progressText,
    this.totalImages,
    this.avgTimePerImage,
    this.currentImage,
    this.generatedAt,
    this.items = const <TryOnBatchItem>[],
    this.results = const <TryOnGeneratedLook>[],
  });

  factory TryOnResultModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final data = _asMap(source?['data']);
    final items = _extractItems(
      data?['images'] ??
          data?['items'] ??
          data?['generated_images'] ??
          source?['images'] ??
          source?['items'] ??
          source?['generated_images'],
    );
    final currentImageSource =
        _asMap(data?['current_image']) ?? _asMap(source?['current_image']);
    final batchStatus =
        _asString(data?['batch_status']) ??
        _asString(data?['status']) ??
        _asString(data?['job_status']) ??
        _asString(data?['processing_status']) ??
        _asString(data?['state']) ??
        _asString(source?['batch_status']) ??
        _asString(source?['status']) ??
        _asString(source?['job_status']) ??
        _asString(source?['processing_status']) ??
        _asString(source?['state']);
    final results = _extractResults(source, data, items);

    return TryOnResultModel(
      status: batchStatus,
      message:
          _asString(source?['message']) ??
          _asString(data?['message']) ??
          _asString(source?['error_message']) ??
          _asString(data?['error_message']),
      batchId:
          _asString(data?['batch_id']) ??
          _asString(data?['batch_uuid']) ??
          _asString(data?['batchId']) ??
          _asString(source?['batch_id']) ??
          _asString(source?['batch_uuid']) ??
          _asString(source?['batchId']),
      progress:
          _asInt(data?['overall_progress']) ??
          _asInt(source?['overall_progress']) ??
          _asInt(data?['progress']) ??
          _asInt(data?['percentage']) ??
          _asInt(data?['percent']) ??
          _asInt(source?['progress']) ??
          _asInt(source?['percentage']) ??
          _asInt(source?['percent']) ??
          _deriveProgress(batchStatus, items),
      progressText:
          _asString(data?['overall_progress_text']) ??
          _asString(source?['overall_progress_text']) ??
          _asString(data?['progress_text']) ??
          _asString(source?['progress_text']),
      totalImages:
          _asInt(data?['total_images']) ??
          _asInt(source?['total_images']) ??
          _asInt(data?['total']) ??
          _asInt(source?['total']) ??
          (items.isNotEmpty ? items.length : null),
      avgTimePerImage:
          _asInt(data?['avg_time_per_image']) ??
          _asInt(source?['avg_time_per_image']),
      currentImage: currentImageSource == null
          ? null
          : TryOnBatchItem.fromJson(currentImageSource),
      generatedAt:
          _asString(data?['generated_at']) ??
          _asString(source?['generated_at']),
      items: items,
      results: results,
    );
  }

  factory TryOnResultModel.fromRawJson(String value) =>
      TryOnResultModel.fromJson(json.decode(value) as Map<String, dynamic>?);

  final String? status;
  final String? message;
  final String? batchId;
  final int? progress;
  final String? progressText;
  final int? totalImages;
  final int? avgTimePerImage;
  final TryOnBatchItem? currentImage;
  final String? generatedAt;
  final List<TryOnBatchItem> items;
  final List<TryOnGeneratedLook> results;

  bool get hasResults => results.isNotEmpty;

  bool get isFailed => _isFailedStatus(status);

  int get resolvedItemCount =>
      items.where((item) => item.isCompleted || item.isFailed).length;

  bool get hasResolvedExpectedOutputs {
    final expectedTotal = totalImages ?? (items.isNotEmpty ? items.length : 0);
    if (expectedTotal <= 0) {
      return false;
    }

    return results.length >= expectedTotal ||
        resolvedItemCount >= expectedTotal;
  }

  bool get isCompleted {
    if (isFailed) {
      return false;
    }

    return _isCompletedStatus(status) || hasResolvedExpectedOutputs;
  }

  bool get isProcessing => !isCompleted && !isFailed;
}

class TryOnBatchItem {
  const TryOnBatchItem({
    this.id,
    this.sequence,
    this.status,
    this.progress,
    this.generatedImageUrl,
    this.generatedImagePath,
    this.errorMessage,
    this.sourceType,
    this.productId,
  });

  factory TryOnBatchItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    if (source == null || source.isEmpty) {
      return const TryOnBatchItem();
    }

    return TryOnBatchItem(
      id: _asInt(source['id']),
      sequence: _asInt(source['sequence']),
      status:
          _asString(source['status']) ??
          _asString(source['processing_status']) ??
          _asString(source['state']),
      progress:
          _asInt(source['progress']) ??
          _asInt(source['percentage']) ??
          _asInt(source['percent']),
      generatedImageUrl:
          _asString(source['generated_image_url']) ??
          _asString(source['processed_image_url']) ??
          _asString(source['image_url']) ??
          _asString(source['processed_image']) ??
          _asString(source['generated_image']) ??
          _asString(source['result_url']) ??
          _asString(source['output_url']) ??
          _asString(source['final_image']) ??
          _asString(source['final_image_url']),
      generatedImagePath:
          _asString(source['generated_image_path']) ??
          _asString(source['processed_image_path']),
      errorMessage:
          _asString(source['error_message']) ?? _asString(source['error']),
      sourceType: _asString(source['source_type']),
      productId: _asInt(source['product_id']),
    );
  }

  final int? id;
  final int? sequence;
  final String? status;
  final int? progress;
  final String? generatedImageUrl;
  final String? generatedImagePath;
  final String? errorMessage;
  final String? sourceType;
  final int? productId;

  bool get hasGeneratedImage => generatedImageUrl?.trim().isNotEmpty == true;

  bool get isCompleted => hasGeneratedImage || _isCompletedStatus(status);

  bool get isFailed => _isFailedStatus(status);

  TryOnGeneratedLook? get generatedLook {
    final imageUrl = generatedImageUrl?.trim();
    if (imageUrl == null || imageUrl.isEmpty) {
      return null;
    }

    return TryOnGeneratedLook(imageUrl: imageUrl, sequence: sequence);
  }
}

class TryOnGeneratedLook {
  const TryOnGeneratedLook({
    required this.imageUrl,
    this.title,
    this.referenceImageUrl,
    this.sequence,
  });

  factory TryOnGeneratedLook.fromDynamic(dynamic value) {
    if (value is String) {
      return TryOnGeneratedLook(imageUrl: value.trim());
    }

    final source = _asMap(value);
    return TryOnGeneratedLook(
      imageUrl:
          _asString(source?['generated_image_url']) ??
          _asString(source?['processed_image_url']) ??
          _asString(source?['image_url']) ??
          _asString(source?['processed_image']) ??
          _asString(source?['image']) ??
          _asString(source?['url']) ??
          _asString(source?['generated_image']) ??
          _asString(source?['result']) ??
          _asString(source?['result_url']) ??
          _asString(source?['output']) ??
          _asString(source?['output_url']) ??
          _asString(source?['final_image']) ??
          _asString(source?['final_image_url']) ??
          '',
      title:
          _asString(source?['title']) ??
          _asString(source?['name']) ??
          _asString(source?['label']),
      referenceImageUrl:
          _asString(source?['reference_image']) ??
          _asString(source?['reference_image_url']) ??
          _asString(source?['source_image']) ??
          _asString(source?['source_image_url']),
      sequence: _asInt(source?['sequence']),
    );
  }

  final String imageUrl;
  final String? title;
  final String? referenceImageUrl;
  final int? sequence;

  bool get hasImageUrl => imageUrl.trim().isNotEmpty;
}

List<TryOnBatchItem> _extractItems(dynamic value) {
  List<dynamic>? entries;
  if (value is List) {
    entries = value;
  } else if (value is Map) {
    entries = value.values.toList(growable: false);
  }
  if (entries == null) {
    return const <TryOnBatchItem>[];
  }

  return entries
      .map((item) => item is Map ? TryOnBatchItem.fromJson(_asMap(item)) : null)
      .whereType<TryOnBatchItem>()
      .toList(growable: false);
}

List<TryOnGeneratedLook> _extractResults(
  Map<String, dynamic>? source,
  Map<String, dynamic>? data,
  List<TryOnBatchItem> items,
) {
  final collectedLooks = <TryOnGeneratedLook>[];

  void addLook(TryOnGeneratedLook? look) {
    if (look == null || !look.hasImageUrl) {
      return;
    }

    collectedLooks.add(look);
  }

  void addDynamicCandidate(dynamic candidate) {
    if (candidate == null) {
      return;
    }

    if (candidate is String) {
      if (!_looksLikeGeneratedImageReference(candidate)) {
        return;
      }
      addLook(TryOnGeneratedLook.fromDynamic(candidate));
      return;
    }

    if (candidate is List) {
      for (final entry in candidate) {
        addDynamicCandidate(entry);
      }
      return;
    }

    final source = _asMap(candidate);
    if (source == null || source.isEmpty) {
      return;
    }

    addLook(TryOnGeneratedLook.fromDynamic(source));

    final nestedCandidates = <dynamic>[
      source['results'],
      source['images'],
      source['generated_images'],
      source['processed_images'],
      source['generated_results'],
      source['processed_results'],
      source['generated_looks'],
      source['tryon_results'],
      source['try_on_results'],
      source['looks'],
      source['output'],
      source['processed_output'],
      source['result'],
      source['processed_result'],
      source['image'],
      source['processed_image'],
      source['image_url'],
      source['processed_image_url'],
      source['final_image'],
      source['final_image_url'],
      source['current_image'],
      source['current_results'],
    ];

    for (final nestedCandidate in nestedCandidates) {
      if (nestedCandidate == null) {
        continue;
      }
      addDynamicCandidate(nestedCandidate);
    }
  }

  for (final item in items) {
    addLook(item.generatedLook);
  }

  final candidates = <dynamic>[
    data?['results'],
    data?['images'],
    data?['generated_images'],
    data?['processed_images'],
    data?['generated_results'],
    data?['processed_results'],
    data?['generated_looks'],
    data?['tryon_results'],
    data?['try_on_results'],
    data?['looks'],
    data?['output'],
    data?['processed_output'],
    source?['results'],
    source?['images'],
    source?['generated_images'],
    source?['processed_images'],
    source?['generated_results'],
    source?['processed_results'],
    source?['generated_looks'],
    source?['tryon_results'],
    source?['try_on_results'],
    source?['looks'],
    source?['output'],
    source?['processed_output'],
    data?['result'],
    data?['processed_result'],
    data?['image'],
    data?['processed_image'],
    data?['generated_image'],
    data?['generated_image_url'],
    data?['generated_image_path'],
    data?['image_url'],
    data?['processed_image_url'],
    data?['processed_image_path'],
    data?['result_url'],
    data?['output_url'],
    data?['final_image'],
    data?['final_image_url'],
    data?['current_image'],
    data?['current_results'],
    source?['result'],
    source?['processed_result'],
    source?['image'],
    source?['processed_image'],
    source?['generated_image'],
    source?['generated_image_url'],
    source?['generated_image_path'],
    source?['image_url'],
    source?['processed_image_url'],
    source?['processed_image_path'],
    source?['result_url'],
    source?['output_url'],
    source?['final_image'],
    source?['final_image_url'],
    source?['current_image'],
    source?['current_results'],
  ];

  for (final candidate in candidates) {
    addDynamicCandidate(candidate);
  }

  if (collectedLooks.isEmpty) {
    return const <TryOnGeneratedLook>[];
  }

  return _deduplicateLooks(collectedLooks);
}

List<TryOnGeneratedLook> _deduplicateLooks(List<TryOnGeneratedLook> looks) {
  if (looks.isEmpty) {
    return const <TryOnGeneratedLook>[];
  }

  final sequenceCounts = <int, int>{};
  for (final look in looks) {
    final sequence = look.sequence;
    if (sequence == null) {
      continue;
    }
    sequenceCounts.update(sequence, (count) => count + 1, ifAbsent: () => 1);
  }

  final mergedLooks = <String, TryOnGeneratedLook>{};
  for (final look in looks) {
    final key = _deduplicationKeyForLook(look, sequenceCounts);
    if (key == null) {
      continue;
    }

    final previous = mergedLooks[key];
    mergedLooks[key] = _preferMoreCompleteLook(previous, look);
  }

  final sortedLooks = mergedLooks.values.toList(growable: false)
    ..sort((left, right) {
      final leftSequence = left.sequence ?? 1 << 20;
      final rightSequence = right.sequence ?? 1 << 20;
      final sequenceComparison = leftSequence.compareTo(rightSequence);
      if (sequenceComparison != 0) {
        return sequenceComparison;
      }

      return left.imageUrl.compareTo(right.imageUrl);
    });
  return sortedLooks;
}

String? _deduplicationKeyForLook(
  TryOnGeneratedLook look,
  Map<int, int> sequenceCounts,
) {
  final imageUrl = look.imageUrl.trim();
  final sequence = look.sequence;
  final hasUniqueSequence =
      sequence != null && (sequenceCounts[sequence] ?? 0) == 1;

  if (hasUniqueSequence) {
    return 'seq:$sequence';
  }

  if (imageUrl.isNotEmpty) {
    return 'img:$imageUrl';
  }

  if (sequence != null) {
    return 'seq:$sequence';
  }

  return null;
}

TryOnGeneratedLook _preferMoreCompleteLook(
  TryOnGeneratedLook? previous,
  TryOnGeneratedLook candidate,
) {
  if (previous == null) {
    return candidate;
  }

  final previousScore = _lookCompletenessScore(previous);
  final candidateScore = _lookCompletenessScore(candidate);
  if (candidateScore != previousScore) {
    return candidateScore >= previousScore ? candidate : previous;
  }

  return candidate.imageUrl.length >= previous.imageUrl.length
      ? candidate
      : previous;
}

int _lookCompletenessScore(TryOnGeneratedLook look) {
  return (look.sequence != null ? 2 : 0) +
      (look.title?.trim().isNotEmpty == true ? 1 : 0) +
      (look.referenceImageUrl?.trim().isNotEmpty == true ? 1 : 0);
}

bool _looksLikeGeneratedImageReference(String value) {
  final normalized = value.trim().toLowerCase();
  if (normalized.isEmpty) {
    return false;
  }

  return normalized.contains('/generated/') ||
      normalized.contains('/results/') ||
      normalized.endsWith('.png') ||
      normalized.endsWith('.jpg') ||
      normalized.endsWith('.jpeg') ||
      normalized.endsWith('.webp') ||
      normalized.endsWith('.gif') ||
      normalized.endsWith('.bmp') ||
      normalized.endsWith('.heic') ||
      normalized.endsWith('.heif') ||
      normalized.endsWith('.avif');
}

int _deriveProgress(String? batchStatus, List<TryOnBatchItem> items) {
  if (_isCompletedStatus(batchStatus)) {
    return 100;
  }

  if (items.isEmpty) {
    return 0;
  }

  final completedCount = items.where((item) => item.hasGeneratedImage).length;
  if (completedCount <= 0) {
    return 0;
  }

  final progress = ((completedCount / items.length) * 100).floor();
  return progress >= 100 ? 99 : progress;
}

bool _isCompletedStatus(String? value) {
  final normalized = value?.trim().toLowerCase();
  return normalized == 'completed' ||
      normalized == 'complete' ||
      normalized == 'done' ||
      normalized == 'success' ||
      normalized == 'succeeded' ||
      normalized == 'finished';
}

bool _isFailedStatus(String? value) {
  final normalized = value?.trim().toLowerCase();
  return normalized == 'failed' ||
      normalized == 'error' ||
      normalized == 'cancelled' ||
      normalized == 'canceled';
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
