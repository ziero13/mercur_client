/// Query for `GET /vendor/offers`.
class SellerListOffersParams {
  const SellerListOffersParams({
    this.limit,
    this.offset,
    this.order,
    this.q,
    this.fields,
    this.id,
    this.productId,
    this.variantId,
    this.sku,
  });

  final int? limit;
  final int? offset;
  final String? order;
  final String? q;
  final List<String>? fields;
  final List<String>? id;
  final List<String>? productId;
  final List<String>? variantId;
  final String? sku;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (order != null) 'order': order,
      if (q != null) 'q': q,
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
      if (productId != null && productId!.isNotEmpty)
        'product_id': productId!.join(','),
      if (variantId != null && variantId!.isNotEmpty)
        'variant_id': variantId!.join(','),
      if (sku != null) 'sku': sku,
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}

/// Query for `GET /vendor/offers/:id`.
class SellerRetrieveOfferParams {
  const SellerRetrieveOfferParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}
