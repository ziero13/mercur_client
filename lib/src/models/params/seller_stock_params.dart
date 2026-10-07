/// Query for inventory / stock-location / shipping lists.
class SellerListStockParams {
  const SellerListStockParams({this.limit, this.offset, this.q, this.order});

  final int? limit;
  final int? offset;
  final String? q;
  final String? order;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (q != null) 'q': q,
      if (order != null) 'order': order,
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}
