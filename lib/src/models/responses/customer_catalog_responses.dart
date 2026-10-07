import '../customer_catalog.dart';
import '../customer_product.dart';

/// Generic list envelope `{<key>, count, offset, limit}` shared by the
/// store catalog reads.
class CustomerCatalogListRes<T> {
  const CustomerCatalogListRes({
    required this.records,
    required this.count,
    this.offset,
    this.limit,
  });

  final List<T> records;
  final int count;
  final int? offset;
  final int? limit;
}

/// Response of `GET /store/collections` / `:id`.
class CustomerCollectionsRes
    extends CustomerCatalogListRes<CustomerCollection> {
  const CustomerCollectionsRes({
    required super.records,
    required super.count,
    super.offset,
    super.limit,
  });

  factory CustomerCollectionsRes.fromJson(Map<String, dynamic> json) {
    return CustomerCollectionsRes(
      records: _list(json['collections'], CustomerCollection.fromJson),
      count: _count(json),
      offset: _offset(json),
      limit: _limit(json),
    );
  }
}

class CustomerCollectionRes {
  const CustomerCollectionRes({required this.collection});

  final CustomerCollection collection;

  factory CustomerCollectionRes.fromJson(Map<String, dynamic> json) {
    return CustomerCollectionRes(
      collection: CustomerCollection.fromJson(
        json['collection'] as Map<String, dynamic>,
      ),
    );
  }
}

/// Response of `GET /store/product-categories` / `:id`.
class CustomerCategoriesRes
    extends CustomerCatalogListRes<CustomerCategory> {
  const CustomerCategoriesRes({
    required super.records,
    required super.count,
    super.offset,
    super.limit,
  });

  factory CustomerCategoriesRes.fromJson(Map<String, dynamic> json) {
    return CustomerCategoriesRes(
      records:
          _list(json['product_categories'], CustomerCategory.fromJson),
      count: _count(json),
      offset: _offset(json),
      limit: _limit(json),
    );
  }
}

class CustomerCategoryRes {
  const CustomerCategoryRes({required this.category});

  final CustomerCategory category;

  factory CustomerCategoryRes.fromJson(Map<String, dynamic> json) {
    return CustomerCategoryRes(
      category: CustomerCategory.fromJson(
        json['product_category'] as Map<String, dynamic>,
      ),
    );
  }
}

/// Response of `GET /store/product-tags` / `:id`.
class CustomerProductTagsRes
    extends CustomerCatalogListRes<CustomerProductTag> {
  const CustomerProductTagsRes({
    required super.records,
    required super.count,
    super.offset,
    super.limit,
  });

  factory CustomerProductTagsRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductTagsRes(
      records: _list(json['product_tags'], CustomerProductTag.fromJson),
      count: _count(json),
      offset: _offset(json),
      limit: _limit(json),
    );
  }
}

class CustomerProductTagRes {
  const CustomerProductTagRes({required this.tag});

  final CustomerProductTag tag;

  factory CustomerProductTagRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductTagRes(
      tag: CustomerProductTag.fromJson(
        json['product_tag'] as Map<String, dynamic>,
      ),
    );
  }
}

/// Response of `GET /store/product-types` / `:id`.
class CustomerProductTypesRes
    extends CustomerCatalogListRes<CustomerProductType> {
  const CustomerProductTypesRes({
    required super.records,
    required super.count,
    super.offset,
    super.limit,
  });

  factory CustomerProductTypesRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductTypesRes(
      records:
          _list(json['product_types'], CustomerProductType.fromJson),
      count: _count(json),
      offset: _offset(json),
      limit: _limit(json),
    );
  }
}

class CustomerProductTypeRes {
  const CustomerProductTypeRes({required this.type});

  final CustomerProductType type;

  factory CustomerProductTypeRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductTypeRes(
      type: CustomerProductType.fromJson(
        json['product_type'] as Map<String, dynamic>,
      ),
    );
  }
}

/// Response of `GET /store/product-attributes` / `:id`.
class CustomerProductAttributesRes
    extends CustomerCatalogListRes<CustomerProductAttribute> {
  const CustomerProductAttributesRes({
    required super.records,
    required super.count,
    super.offset,
    super.limit,
  });

  factory CustomerProductAttributesRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductAttributesRes(
      records: _list(
        json['product_attributes'],
        CustomerProductAttribute.fromJson,
      ),
      count: _count(json),
      offset: _offset(json),
      limit: _limit(json),
    );
  }
}

class CustomerProductAttributeRes {
  const CustomerProductAttributeRes({required this.attribute});

  final CustomerProductAttribute attribute;

  factory CustomerProductAttributeRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductAttributeRes(
      attribute: CustomerProductAttribute.fromJson(
        json['product_attribute'] as Map<String, dynamic>,
      ),
    );
  }
}

/// Response of `GET /store/product-options` / `:id`.
class CustomerProductOptionsRes
    extends CustomerCatalogListRes<CustomerProductOption> {
  const CustomerProductOptionsRes({
    required super.records,
    required super.count,
    super.offset,
    super.limit,
  });

  factory CustomerProductOptionsRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductOptionsRes(
      records:
          _list(json['product_options'], CustomerProductOption.fromJson),
      count: _count(json),
      offset: _offset(json),
      limit: _limit(json),
    );
  }
}

class CustomerProductOptionRes {
  const CustomerProductOptionRes({required this.option});

  final CustomerProductOption option;

  factory CustomerProductOptionRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductOptionRes(
      option: CustomerProductOption.fromJson(
        json['product_option'] as Map<String, dynamic>,
      ),
    );
  }
}

/// Response of `GET /store/product-variants` / `:id`.
///
/// NOTE: the list route requires a sales-channel-configured publishable
/// key (`invalid_data` 400 otherwise) — a key quirk, not a client shape.
class CustomerProductVariantsRes
    extends CustomerCatalogListRes<CustomerProductVariant> {
  const CustomerProductVariantsRes({
    required super.records,
    required super.count,
    super.offset,
    super.limit,
  });

  factory CustomerProductVariantsRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductVariantsRes(
      records:
          _list(json['product_variants'], CustomerProductVariant.fromJson),
      count: _count(json),
      offset: _offset(json),
      limit: _limit(json),
    );
  }
}

class CustomerProductVariantRes {
  const CustomerProductVariantRes({required this.variant});

  final CustomerProductVariant variant;

  factory CustomerProductVariantRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductVariantRes(
      variant: CustomerProductVariant.fromJson(
        json['product_variant'] as Map<String, dynamic>,
      ),
    );
  }
}

List<T> _list<T>(
  Object? raw,
  T Function(Map<String, dynamic>) parse,
) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map<String, dynamic>>()
      .where((m) => m['id'] is String)
      .map(parse)
      .toList();
}

int _count(Map<String, dynamic> json) =>
    (json['count'] as num?)?.toInt() ?? 0;

int? _offset(Map<String, dynamic> json) =>
    (json['offset'] as num?)?.toInt();

int? _limit(Map<String, dynamic> json) =>
    (json['limit'] as num?)?.toInt();
