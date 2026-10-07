/// Query for `GET /vendor/products`.
class SellerListProductsParams {
  const SellerListProductsParams({
    this.limit,
    this.offset,
    this.order,
    this.q,
    this.fields,
    this.id,
    this.title,
    this.handle,
    this.status,
    this.collectionId,
    this.typeId,
    this.categoryId,
    this.tagId,
    this.sku,
    this.hasOffer,
  });

  final int? limit;
  final int? offset;
  final String? order;
  final String? q;
  final List<String>? fields;
  final List<String>? id;
  final String? title;
  final String? handle;
  final List<String>? status;
  final List<String>? collectionId;
  final List<String>? typeId;
  final List<String>? categoryId;
  final List<String>? tagId;
  final String? sku;
  final bool? hasOffer;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (order != null) 'order': order,
      if (q != null) 'q': q,
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
      if (title != null) 'title': title,
      if (handle != null) 'handle': handle,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (collectionId != null && collectionId!.isNotEmpty)
        'collection_id': collectionId!.join(','),
      if (typeId != null && typeId!.isNotEmpty)
        'type_id': typeId!.join(','),
      if (categoryId != null && categoryId!.isNotEmpty)
        'category_id': categoryId!.join(','),
      if (tagId != null && tagId!.isNotEmpty) 'tag_id': tagId!.join(','),
      if (sku != null) 'sku': sku,
      if (hasOffer != null) 'has_offer': hasOffer,
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}

/// Query for `GET /vendor/products/:id` and `/preview`.
class SellerRetrieveProductParams {
  const SellerRetrieveProductParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}

/// Query for `GET /vendor/products/:id/variants` and
/// `GET /vendor/product-variants`.
class SellerListVariantsParams {
  const SellerListVariantsParams({this.limit, this.offset, this.q});

  final int? limit;
  final int? offset;
  final String? q;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (q != null) 'q': q,
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}
