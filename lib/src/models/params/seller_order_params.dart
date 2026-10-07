/// Query for `GET /vendor/orders`.
class SellerListOrdersParams {
  const SellerListOrdersParams({
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

/// Query for `GET /vendor/orders/:id` and `/preview`.
class SellerRetrieveOrderParams {
  const SellerRetrieveOrderParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}
