class ShopModel {
  ShopModel({this.status, this.message, this.data, this.errors});

  ShopModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'];
  }
  String? status;
  String? message;
  Data? data;
  dynamic errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['errors'] = errors;
    return map;
  }
}

class Data {
  Data({this.items, this.pagination});

  Data.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
  List<Items>? items;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }
}

class Pagination {
  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  Pagination.fromJson(dynamic json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    from = json['from'];
    to = json['to'];
  }
  num? currentPage;
  num? lastPage;
  num? perPage;
  num? total;
  num? from;
  num? to;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    map['last_page'] = lastPage;
    map['per_page'] = perPage;
    map['total'] = total;
    map['from'] = from;
    map['to'] = to;
    return map;
  }
}

class Items {
  Items({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.shortDescription,
    this.price,
    this.salePrice,
    this.currency,
    this.thumbnail,
    this.gender,
    this.status,
    this.category,
    this.brand,
    this.gallery,
    this.variants,
  });

  Items.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    shortDescription = json['short_description'];
    price = json['price'];
    salePrice = json['sale_price'];
    currency = json['currency'];
    thumbnail = json['thumbnail'];
    gender = json['gender'];
    status = json['status'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    if (json['gallery'] != null) {
      gallery = [];
      json['gallery'].forEach((v) {
        gallery?.add(Gallery.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = [];
      json['variants'].forEach((v) {
        variants?.add(Variants.fromJson(v));
      });
    }
  }
  num? id;
  String? title;
  String? slug;
  String? description;
  String? shortDescription;
  String? price;
  String? salePrice;
  String? currency;
  String? thumbnail;
  String? gender;
  bool? status;
  Category? category;
  Brand? brand;
  List<Gallery>? gallery;
  List<Variants>? variants;

  Variants? get primaryVariant {
    final resolvedVariants = variants ?? const <Variants>[];
    for (final variant in resolvedVariants) {
      if ((variant.stock ?? 0) > 0) {
        return variant;
      }
    }
    if (resolvedVariants.isEmpty) {
      return null;
    }
    return resolvedVariants.first;
  }

  int? get primaryVariantId => primaryVariant?.id?.toInt();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['slug'] = slug;
    map['description'] = description;
    map['short_description'] = shortDescription;
    map['price'] = price;
    map['sale_price'] = salePrice;
    map['currency'] = currency;
    map['thumbnail'] = thumbnail;
    map['gender'] = gender;
    map['status'] = status;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    if (brand != null) {
      map['brand'] = brand?.toJson();
    }
    if (gallery != null) {
      map['gallery'] = gallery?.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      map['variants'] = variants?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Variants {
  Variants({
    this.id,
    this.image,
    this.sku,
    this.price,
    this.stock,
    this.color,
    this.size,
  });

  Variants.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    sku = json['sku'];
    price = json['price'];
    stock = json['stock'];
    color = json['color'];
    size = json['size'];
  }
  num? id;
  String? image;
  String? sku;
  String? price;
  num? stock;
  String? color;
  String? size;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    map['sku'] = sku;
    map['price'] = price;
    map['stock'] = stock;
    map['color'] = color;
    map['size'] = size;
    return map;
  }
}

class Gallery {
  Gallery({this.image, this.sortOrder});

  Gallery.fromJson(dynamic json) {
    image = json['image'];
    sortOrder = json['sort_order'];
  }
  String? image;
  num? sortOrder;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = image;
    map['sort_order'] = sortOrder;
    return map;
  }
}

class Brand {
  Brand({this.id, this.name});

  Brand.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  num? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

class Category {
  Category({
    this.id,
    this.parentId,
    this.name,
    this.icon,
    this.image,
    this.isFeatured,
    this.status,
  });

  Category.fromJson(dynamic json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    icon = json['icon'];
    image = json['image'];
    isFeatured = json['is_featured'];
    status = json['status'];
  }
  num? id;
  num? parentId;
  String? name;
  String? icon;
  String? image;
  bool? isFeatured;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['parent_id'] = parentId;
    map['name'] = name;
    map['icon'] = icon;
    map['image'] = image;
    map['is_featured'] = isFeatured;
    map['status'] = status;
    return map;
  }
}
