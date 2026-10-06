import '../customer_product.dart';

/// Response of `GET /store/products`.
class CustomerProductListRes {
  const CustomerProductListRes({
    required this.products,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<CustomerProduct> products;
  final int count;
  final int offset;
  final int limit;

  factory CustomerProductListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['products'];
    return CustomerProductListRes(
      products: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(CustomerProduct.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((p) => p.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response of `GET /store/products/:id`.
class CustomerProductRes {
  const CustomerProductRes({required this.product});

  final CustomerProduct product;

  factory CustomerProductRes.fromJson(Map<String, dynamic> json) {
    return CustomerProductRes(
      product: CustomerProduct.fromJson(json['product'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'product': product.toJson()};
}
