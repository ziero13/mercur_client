/// Query for `GET /vendor/payments` and `GET /vendor/payouts`.
class SellerListMoneyParams {
  const SellerListMoneyParams({this.limit, this.offset, this.order});

  final int? limit;
  final int? offset;
  final String? order;

  Map<String, dynamic> toQuery() {
    return {
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (order != null) 'order': order,
    };
  }

  Map<String, dynamic> toJson() => toQuery();
}
