class LegalPageModel {
  const LegalPageModel({this.success, this.status, this.data, this.message});

  factory LegalPageModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final dataSource = _asMap(source?['data']) ?? source;

    return LegalPageModel(
      success: _asBool(source?['success']),
      status: _asString(source?['status']),
      data: dataSource == null ? null : LegalPageData.fromJson(dataSource),
      message: _asString(source?['message']),
    );
  }

  final bool? success;
  final String? status;
  final LegalPageData? data;
  final String? message;

  bool get isSuccessful {
    if (success != null) {
      return success!;
    }

    final normalizedStatus = status?.trim().toLowerCase();
    return normalizedStatus == null ||
        normalizedStatus.isEmpty ||
        normalizedStatus == 'success' ||
        normalizedStatus == 'ok' ||
        normalizedStatus == 'true' ||
        normalizedStatus == '1';
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class LegalPageData {
  const LegalPageData({
    this.id,
    this.title,
    this.subtitle,
    this.sections = const <LegalPageSection>[],
  });

  factory LegalPageData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final sectionsSource =
        source?['sections'] ??
        source?['items'] ??
        source?['blocks'] ??
        source?['content_items'];
    final sections =
        _asListOfMaps(sectionsSource)
            .map(LegalPageSection.fromJson)
            .where((section) => section.hasVisibleContent)
            .toList()
          ..sort(
            (left, right) =>
                left.resolvedSortOrder.compareTo(right.resolvedSortOrder),
          );

    final standaloneContent = _normalizeHtml(
      _firstString([
        source?['content'],
        source?['description'],
        source?['body'],
        source?['text'],
        source?['html'],
      ]),
    );

    if (sections.isEmpty && standaloneContent != null) {
      sections.add(
        LegalPageSection(
          title: _firstString([
            source?['heading'],
            source?['section_title'],
            source?['title'],
            source?['name'],
          ]),
          icon: _firstString([
            source?['icon'],
            source?['icon_name'],
            source?['iconName'],
          ]),
          htmlContent: standaloneContent,
          sortOrder: 0,
        ),
      );
    }

    return LegalPageData(
      id: _asString(source?['id']),
      title: _firstString([source?['title'], source?['name']]),
      subtitle: _asString(source?['subtitle']),
      sections: sections,
    );
  }

  final String? id;
  final String? title;
  final String? subtitle;
  final List<LegalPageSection> sections;

  bool get hasSections => sections.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}

class LegalPageSection {
  const LegalPageSection({
    this.title,
    this.icon,
    this.htmlContent,
    this.sortOrder,
  });

  factory LegalPageSection.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final nestedContent = _buildHtmlFromNestedMaps(
      _asListOfMaps(
        source?['items'] ??
            source?['points'] ??
            source?['content_items'] ??
            source?['children'],
      ),
    );

    return LegalPageSection(
      title: _firstString([
        source?['heading'],
        source?['title'],
        source?['name'],
        source?['label'],
      ]),
      icon: _firstString([
        source?['icon'],
        source?['icon_name'],
        source?['iconName'],
      ]),
      htmlContent:
          _normalizeHtml(
            _firstString([
              source?['description'],
              source?['content'],
              source?['body'],
              source?['text'],
              source?['html'],
              source?['subheading'],
            ]),
          ) ??
          nestedContent,
      sortOrder: _asInt(
        source?['sort_order'] ?? source?['order'] ?? source?['sequence'],
      ),
    );
  }

  final String? title;
  final String? icon;
  final String? htmlContent;
  final int? sortOrder;

  bool get hasVisibleContent {
    return (title?.trim().isNotEmpty ?? false) ||
        (htmlContent?.trim().isNotEmpty ?? false);
  }

  int get resolvedSortOrder => sortOrder ?? 1 << 20;

  String get resolvedIconName {
    final iconValue = icon?.trim();
    if (iconValue != null && iconValue.isNotEmpty) {
      return iconValue;
    }

    return title?.trim() ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'html_content': htmlContent,
      'sort_order': sortOrder,
    };
  }
}

String? _firstString(List<dynamic> values) {
  for (final value in values) {
    final normalized = _asString(value);
    if (normalized != null) {
      return normalized;
    }
  }

  return null;
}

String? _normalizeHtml(String? value) {
  if (value == null) {
    return null;
  }

  final normalized = value.trim();
  if (normalized.isEmpty) {
    return null;
  }

  if (_looksLikeHtml(normalized)) {
    return normalized;
  }

  final paragraphs = normalized
      .split(RegExp(r'\n\s*\n'))
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .map((part) => '<p>${_escapeHtml(part).replaceAll('\n', '<br/>')}</p>')
      .join();

  return paragraphs.isEmpty ? null : paragraphs;
}

String? _buildHtmlFromNestedMaps(List<Map<String, dynamic>> items) {
  if (items.isEmpty) {
    return null;
  }

  final buffer = StringBuffer();

  for (final item in items) {
    final title = _firstString([
      item['heading'],
      item['title'],
      item['name'],
      item['label'],
    ]);
    final content = _normalizeHtml(
      _firstString([
        item['description'],
        item['content'],
        item['body'],
        item['text'],
        item['subheading'],
        item['html'],
      ]),
    );

    if (title == null && content == null) {
      continue;
    }

    if (title != null) {
      buffer.write('<p><strong>${_escapeHtml(title)}</strong></p>');
    }
    if (content != null) {
      buffer.write(content);
    }
  }

  final result = buffer.toString().trim();
  return result.isEmpty ? null : result;
}

bool _looksLikeHtml(String value) {
  return RegExp(r'<[^>]+>').hasMatch(value);
}

String _escapeHtml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
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

  return int.tryParse(value?.toString() ?? '');
}

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  if (normalized == 'true' || normalized == '1') {
    return true;
  }

  if (normalized == 'false' || normalized == '0') {
    return false;
  }

  return null;
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
