/// Query for RMA lists (`limit`/`offset`/`order`/`fields` + filters).
class SellerRmaListParams {
  const SellerRmaListParams({
    this.limit,
    this.offset,
    this.order,
    this.fields,
    this.id,
    this.orderId,
    this.status,
  });

  final int? limit;
  final int? offset;
  final String? order;
  final List<String>? fields;
  final List<String>? id;
  final List<String>? orderId;
  final List<String>? status;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (order != null) 'order': order,
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
      if (orderId != null && orderId!.isNotEmpty)
        'order_id': orderId!.join(','),
      if (status != null && status!.isNotEmpty) 'status': status,
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}

/// Query for RMA detail retrieves (`fields` only).
class SellerRmaRetrieveParams {
  const SellerRmaRetrieveParams({this.fields});

  final List<String>? fields;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}
