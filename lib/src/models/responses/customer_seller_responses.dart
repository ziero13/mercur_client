import '../seller.dart';

/// Response of `GET /store/sellers`.
class CustomerSellerListRes {
  const CustomerSellerListRes({
    required this.sellers,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<Seller> sellers;
  final int count;
  final int offset;
  final int limit;

  factory CustomerSellerListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['sellers'];
    return CustomerSellerListRes(
      sellers: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(Seller.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellers': sellers.map((s) => s.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response of `GET /store/sellers/:id`.
class CustomerSellerRes {
  const CustomerSellerRes({required this.seller});

  final Seller seller;

  factory CustomerSellerRes.fromJson(Map<String, dynamic> json) {
    return CustomerSellerRes(
      seller: Seller.fromJson(json['seller'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'seller': seller.toJson()};
}
