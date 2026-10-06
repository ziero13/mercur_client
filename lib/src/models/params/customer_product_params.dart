import '../pagination_params.dart';

/// Query for `GET /store/products` (verified against bundled docs).
class CustomerListProductsParams extends PaginationParams {
  const CustomerListProductsParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
    this.id,
    this.title,
    this.handle,
    this.collectionId,
    this.typeId,
    this.categoryId,
    this.tagId,
    this.isGiftcard,
    this.regionId,
    this.currencyCode,
  });

  final List<String>? id;
  final String? title;
  final String? handle;
  final List<String>? collectionId;
  final List<String>? typeId;
  final List<String>? categoryId;
  final List<String>? tagId;
  final bool? isGiftcard;

  /// Region for the `variants.calculated_price` pricing context.
  final String? regionId;
  final String? currencyCode;

  @override
  Map<String, dynamic> toQuery() {
    return {
      ...super.toQuery(),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
      if (title != null) 'title': title,
      if (handle != null) 'handle': handle,
      if (collectionId != null && collectionId!.isNotEmpty)
        'collection_id': collectionId!.join(','),
      if (typeId != null && typeId!.isNotEmpty) 'type_id': typeId!.join(','),
      if (categoryId != null && categoryId!.isNotEmpty)
        'category_id': categoryId!.join(','),
      if (tagId != null && tagId!.isNotEmpty) 'tag_id': tagId!.join(','),
      if (isGiftcard != null) 'is_giftcard': isGiftcard,
      if (regionId != null) 'region_id': regionId,
      if (currencyCode != null) 'currency_code': currencyCode,
    };
  }

  @override
  Map<String, dynamic> toJson() => toQuery();

  factory CustomerListProductsParams.fromJson(Map<String, dynamic> json) {
    List<String>? splitList(Object? raw) => switch (raw) {
          null => null,
          final String s => s.split(','),
          final List l => l.cast<String>(),
          _ => null,
        };
    final base = PaginationParams.fromJson(json);
    return CustomerListProductsParams(
      limit: base.limit,
      offset: base.offset,
      order: base.order,
      q: base.q,
      fields: base.fields,
      id: splitList(json['id']),
      title: json['title'] as String?,
      handle: json['handle'] as String?,
      collectionId: splitList(json['collection_id']),
      typeId: splitList(json['type_id']),
      categoryId: splitList(json['category_id']),
      tagId: splitList(json['tag_id']),
      isGiftcard: json['is_giftcard'] as bool?,
      regionId: json['region_id'] as String?,
      currencyCode: json['currency_code'] as String?,
    );
  }
}

/// Query for `GET /store/products/:id`.
class CustomerRetrieveProductParams {
  const CustomerRetrieveProductParams({
    this.fields,
    this.regionId,
    this.currencyCode,
  });

  final List<String>? fields;
  final String? regionId;
  final String? currencyCode;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
      if (regionId != null) 'region_id': regionId,
      if (currencyCode != null) 'currency_code': currencyCode,
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveProductParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerRetrieveProductParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
      regionId: json['region_id'] as String?,
      currencyCode: json['currency_code'] as String?,
    );
  }
}
