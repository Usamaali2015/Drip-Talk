class ReturnPolicyModel {
  const ReturnPolicyModel({this.success, this.data, this.message});

  factory ReturnPolicyModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return ReturnPolicyModel(
      success: _asBool(source?['success']),
      data: source?['data'] == null
          ? null
          : ReturnPolicyData.fromJson(_asMap(source?['data'])),
      message: _asString(source?['message']),
    );
  }

  final bool? success;
  final ReturnPolicyData? data;
  final String? message;

  bool get isSuccessful => success ?? true;

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson(), 'message': message};
  }
}

class ReturnPolicyData {
  const ReturnPolicyData({
    this.id,
    this.title,
    this.subtitle,
    this.heading,
    this.sections = const <ReturnPolicySection>[],
  });

  factory ReturnPolicyData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final sections = _asListOfMaps(source?['sections'])
        .map(ReturnPolicySection.fromJson)
        .where((section) {
          return section.hasVisibleContent;
        })
        .toList();

    return ReturnPolicyData(
      id: _asString(source?['id']),
      title: _asString(source?['title']),
      subtitle: _asString(source?['subtitle']),
      heading: _asString(source?['heading']),
      sections: sections,
    );
  }

  final String? id;
  final String? title;
  final String? subtitle;
  final String? heading;
  final List<ReturnPolicySection> sections;

  bool get hasSections => sections.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'heading': heading,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}

class ReturnPolicySection {
  const ReturnPolicySection({
    this.heading,
    this.icon,
    this.items = const <ReturnPolicyItem>[],
  });

  factory ReturnPolicySection.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final items = _asListOfMaps(source?['items'])
        .map(ReturnPolicyItem.fromJson)
        .where((item) {
          return item.hasVisibleContent;
        })
        .toList();

    return ReturnPolicySection(
      heading: _asString(source?['heading']),
      icon: _asString(source?['icon']),
      items: items,
    );
  }

  final String? heading;
  final String? icon;
  final List<ReturnPolicyItem> items;

  bool get hasVisibleContent {
    return (heading?.trim().isNotEmpty ?? false) || items.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'icon': icon,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ReturnPolicyItem {
  const ReturnPolicyItem({this.icon, this.heading, this.subheading});

  factory ReturnPolicyItem.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);

    return ReturnPolicyItem(
      icon: _asString(source?['icon']),
      heading: _asString(source?['heading']),
      subheading: _asString(source?['subheading']),
    );
  }

  final String? icon;
  final String? heading;
  final String? subheading;

  bool get hasVisibleContent {
    return (heading?.trim().isNotEmpty ?? false) ||
        (subheading?.trim().isNotEmpty ?? false);
  }

  Map<String, dynamic> toJson() {
    return {'icon': icon, 'heading': heading, 'subheading': subheading};
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
