/// Query for `GET /vendor/price-lists` and `GET /vendor/campaigns`.
class SellerListPricingParams {
  const SellerListPricingParams({
    this.limit,
    this.offset,
    this.order,
    this.q,
    this.fields,
    this.id,
    this.status,
  });

  final int? limit;
  final int? offset;
  final String? order;
  final String? q;
  final List<String>? fields;
  final List<String>? id;
  final List<String>? status;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (order != null) 'order': order,
      if (q != null) 'q': q,
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
      if (status != null && status!.isNotEmpty) 'status': status,
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}

/// Query for price-list price lists (`limit`/`offset`/`q`).
class SellerListPricesParams {
  const SellerListPricesParams({this.limit, this.offset, this.q});

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
