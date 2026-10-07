import '../seller_product.dart';

/// Response of `GET /vendor/products`.
class SellerProductListRes {
  const SellerProductListRes({
    required this.products,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerProduct> products;
  final int count;
  final int offset;
  final int limit;

  factory SellerProductListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['products'];
    return SellerProductListRes(
      products: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerProduct.fromJson)
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

/// Response wrapping one `product`
/// (`POST /vendor/products`, `GET /vendor/products/:id`).
class SellerProductRes {
  const SellerProductRes({required this.product});

  final SellerProduct product;

  factory SellerProductRes.fromJson(Map<String, dynamic> json) {
    return SellerProductRes(
      product: SellerProduct.fromJson(json['product'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'product': product.toJson()};
}

/// Response wrapping one `product_change` (update/delete/variant/
/// attribute staging, preview, cancel).
///
/// `preview` returns `product_change: null` when no pending change
/// exists — hence nullable.
class SellerProductChangeRes {
  const SellerProductChangeRes({this.change});

  final ProductChange? change;

  factory SellerProductChangeRes.fromJson(Map<String, dynamic> json) {
    final raw = json['product_change'];
    return SellerProductChangeRes(
      change: raw is Map<String, dynamic> && raw['id'] is String
          ? ProductChange.fromJson(raw)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (change != null) 'product_change': change!.toJson(),
      };
}

/// Response of variant lists (`…/variants`, `/vendor/product-variants`).
class SellerVariantListRes {
  const SellerVariantListRes({
    required this.variants,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerProductVariant> variants;
  final int count;
  final int offset;
  final int limit;

  factory SellerVariantListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['variants'];
    return SellerVariantListRes(
      variants: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerProductVariant.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variants': variants.map((v) => v.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `variant`.
class SellerVariantRes {
  const SellerVariantRes({required this.variant});

  final SellerProductVariant variant;

  factory SellerVariantRes.fromJson(Map<String, dynamic> json) {
    return SellerVariantRes(
      variant: SellerProductVariant.fromJson(
          json['variant'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'variant': variant.toJson()};
}
