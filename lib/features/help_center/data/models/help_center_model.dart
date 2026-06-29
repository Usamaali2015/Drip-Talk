class HelpCenterModel {
  const HelpCenterModel({this.status, this.message, this.data, this.errors});

  factory HelpCenterModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return HelpCenterModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      data: HelpCenterData.fromJson(_asMap(source?['data'])),
      errors: source?['errors'],
    );
  }

  final String? status;
  final String? message;
  final HelpCenterData? data;
  final dynamic errors;

  bool get isSuccessful {
    final normalizedStatus = status?.trim().toLowerCase();
    return normalizedStatus == null ||
        normalizedStatus.isEmpty ||
        normalizedStatus == 'success' ||
        normalizedStatus == 'ok';
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}

class HelpCenterData {
  const HelpCenterData({
    this.items = const <HelpCenterItem>[],
    this.pagination,
  });

  factory HelpCenterData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final items = _asListOfMaps(
      source?['items'],
    ).map(HelpCenterItem.fromJson).toList();
    items.sort(
      (left, right) =>
          left.resolvedSortOrder.compareTo(right.resolvedSortOrder),
    );

    return HelpCenterData(
      items: items,
      pagination: HelpCenterPagination.fromJson(_asMap(source?['pagination'])),
    );
  }

  final List<HelpCenterItem> items;
  final HelpCenterPagination? pagination;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class HelpCenterItem {
  const HelpCenterItem({
    this.id,
    this.slug,
    this.name,
    this.description,
    this.content,
    this.status,
    this.type,
    this.sortOrder,
    this.icon,
    this.image,
    this.faqs = const <HelpCenterFaq>[],
    this.createdAt,
    this.updatedAt,
  });

  factory HelpCenterItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final faqs = _asListOfMaps(
      source?['faqs'],
    ).map(HelpCenterFaq.fromJson).toList();
    faqs.sort(
      (left, right) =>
          left.resolvedSortOrder.compareTo(right.resolvedSortOrder),
    );

    return HelpCenterItem(
      id: _asInt(source?['id']),
      slug: _asString(source?['slug']),
      name: _asString(source?['name']),
      description: _asString(source?['description']),
      content: _asString(source?['content']),
      status: _asString(source?['status']),
      type: _asString(source?['type']),
      sortOrder: _asInt(source?['sort_order']),
      icon: _asString(source?['icon']),
      image: _asString(source?['image']),
      faqs: faqs,
      createdAt: _asDateTime(source?['created_at']),
      updatedAt: _asDateTime(source?['updated_at']),
    );
  }

  final int? id;
  final String? slug;
  final String? name;
  final String? description;
  final String? content;
  final String? status;
  final String? type;
  final int? sortOrder;
  final String? icon;
  final String? image;
  final List<HelpCenterFaq> faqs;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  int get resolvedSortOrder => sortOrder ?? 1 << 20;

  String get displayName {
    final normalizedName = name?.trim();
    if (normalizedName != null && normalizedName.isNotEmpty) {
      return normalizedName;
    }

    final normalizedSlug = slug
        ?.trim()
        .replaceAll('-', ' ')
        .replaceAll('_', ' ');
    if (normalizedSlug != null && normalizedSlug.isNotEmpty) {
      return normalizedSlug
          .split(RegExp(r'\s+'))
          .where((segment) => segment.isNotEmpty)
          .map(
            (segment) => '${segment[0].toUpperCase()}${segment.substring(1)}',
          )
          .join(' ');
    }

    return '';
  }

  String? get illustrationUrl {
    final candidates = [image, icon];
    for (final value in candidates) {
      final normalized = value?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'description': description,
      'content': content,
      'status': status,
      'type': type,
      'sort_order': sortOrder,
      'icon': icon,
      'image': image,
      'faqs': faqs.map((faq) => faq.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class HelpCenterFaq {
  const HelpCenterFaq({this.id, this.question, this.answer, this.sortOrder});

  factory HelpCenterFaq.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return HelpCenterFaq(
      id: _asInt(source?['id']),
      question: _asString(source?['question']),
      answer: _asString(source?['answer']),
      sortOrder: _asInt(source?['sort_order']),
    );
  }

  final int? id;
  final String? question;
  final String? answer;
  final int? sortOrder;

  int get resolvedSortOrder => sortOrder ?? 1 << 20;

  bool get isMeaningful {
    return (question?.trim().isNotEmpty ?? false) &&
        (answer?.trim().isNotEmpty ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'sort_order': sortOrder,
    };
  }
}

class HelpCenterPagination {
  const HelpCenterPagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  factory HelpCenterPagination.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return HelpCenterPagination(
      currentPage: _asInt(source?['current_page']),
      lastPage: _asInt(source?['last_page']),
      perPage: _asInt(source?['per_page']),
      total: _asInt(source?['total']),
      from: _asInt(source?['from']),
      to: _asInt(source?['to']),
    );
  }

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'from': from,
      'to': to,
    };
  }
}

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalized = value.toString().trim();
  return normalized.isEmpty || normalized.toLowerCase() == 'null'
      ? null
      : normalized;
}

int? _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '');
}

DateTime? _asDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  final raw = value?.toString();
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }

  return DateTime.tryParse(raw);
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

List<Map<String, dynamic>> _asListOfMaps(dynamic value) {
  if (value is! List) {
    return const <Map<String, dynamic>>[];
  }

  return value.map(_asMap).whereType<Map<String, dynamic>>().toList();
}
