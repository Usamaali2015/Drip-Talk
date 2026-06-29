class BrandsModel {
  const BrandsModel({
    this.status,
    this.message,
    this.data = const <BrandData>[],
    this.errors,
  });

  factory BrandsModel.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    final dataSource = source?['data'];
    final brands = <BrandData>[];

    if (dataSource is List) {
      for (final item in dataSource) {
        brands.add(BrandData.fromJson(_asMap(item)));
      }
    }

    return BrandsModel(
      status: _asString(source?['status']),
      message: _asString(source?['message']),
      data: brands,
      errors: source?['errors'],
    );
  }

  final String? status;
  final String? message;
  final List<BrandData> data;
  final dynamic errors;
}

class BrandData {
  const BrandData({this.id, this.name, this.logo, this.isFeatured = false});

  factory BrandData.fromJson(Map<String, dynamic>? json) {
    final source = _asMap(json);
    return BrandData(
      id: _asInt(source?['id']),
      name: _asString(source?['name']),
      logo: _asString(source?['logo']),
      isFeatured: _asBool(source?['is_featured']) ?? false,
    );
  }

  final int? id;
  final String? name;
  final String? logo;
  final bool isFeatured;

  bool get hasDisplayName => (name?.trim().isNotEmpty ?? false);
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

bool? _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == 'true' || normalized == '1') {
    return true;
  }
  if (normalized == 'false' || normalized == '0') {
    return false;
  }
  return null;
}
