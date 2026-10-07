import '../seller_order.dart';
import '../seller_product.dart';
import '../seller_rma.dart';

/// Shared tolerant envelope for RMA action responses.
///
/// Routes return different key subsets (`order_change`, `order_preview`,
/// `order`, `return`, `claim`, `exchange`) — every key is optional so
/// the same class decodes them all.
class SellerRmaEnvelope {
  const SellerRmaEnvelope({
    this.orderChange,
    this.orderPreview,
    this.order,
    this.ret,
    this.claim,
    this.exchange,
  });

  final ProductChange? orderChange;
  final SellerOrder? orderPreview;
  final SellerOrder? order;
  final SellerReturn? ret;
  final SellerClaim? claim;
  final SellerExchange? exchange;

  static ProductChange? _change(Object? raw) =>
      raw is Map<String, dynamic> && raw['id'] is String
          ? ProductChange.fromJson(raw)
          : null;

  static SellerOrder? _order(Object? raw) =>
      raw is Map<String, dynamic> && raw['id'] is String
          ? SellerOrder.fromJson(raw)
          : null;

  factory SellerRmaEnvelope.fromJson(Map<String, dynamic> json) {
    return SellerRmaEnvelope(
      orderChange: _change(json['order_change']),
      orderPreview: _order(json['order_preview']),
      order: _order(json['order']),
      ret: json['return'] is Map<String, dynamic> &&
              (json['return'] as Map<String, dynamic>)['id'] is String
          ? SellerReturn.fromJson(json['return'] as Map<String, dynamic>)
          : null,
      claim: json['claim'] is Map<String, dynamic> &&
              (json['claim'] as Map<String, dynamic>)['id'] is String
          ? SellerClaim.fromJson(json['claim'] as Map<String, dynamic>)
          : null,
      exchange: json['exchange'] is Map<String, dynamic> &&
              (json['exchange'] as Map<String, dynamic>)['id'] is String
          ? SellerExchange.fromJson(json['exchange'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (orderChange != null) 'order_change': orderChange!.toJson(),
      if (orderPreview != null) 'order_preview': orderPreview!.toJson(),
      if (order != null) 'order': order!.toJson(),
      if (ret != null) 'return': ret!.toJson(),
      if (claim != null) 'claim': claim!.toJson(),
      if (exchange != null) 'exchange': exchange!.toJson(),
    };
  }
}

/// Response of `GET /vendor/returns`.
class SellerReturnListRes {
  const SellerReturnListRes({
    required this.returns,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerReturn> returns;
  final int count;
  final int offset;
  final int limit;

  factory SellerReturnListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['returns'];
    return SellerReturnListRes(
      returns: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerReturn.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'returns': returns.map((r) => r.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `return` (`GET /vendor/returns/:id`).
class SellerReturnDetailRes {
  const SellerReturnDetailRes({required this.ret});

  final SellerReturn ret;

  factory SellerReturnDetailRes.fromJson(Map<String, dynamic> json) {
    return SellerReturnDetailRes(
      ret: SellerReturn.fromJson(json['return'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'return': ret.toJson()};
}

/// Response of `GET /vendor/claims`.
class SellerClaimListRes {
  const SellerClaimListRes({
    required this.claims,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerClaim> claims;
  final int count;
  final int offset;
  final int limit;

  factory SellerClaimListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['claims'];
    return SellerClaimListRes(
      claims: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerClaim.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'claims': claims.map((c) => c.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `claim` (`GET /vendor/claims/:id`, cancel).
class SellerClaimDetailRes {
  const SellerClaimDetailRes({required this.claim});

  final SellerClaim claim;

  factory SellerClaimDetailRes.fromJson(Map<String, dynamic> json) {
    return SellerClaimDetailRes(
      claim: SellerClaim.fromJson(json['claim'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'claim': claim.toJson()};
}

/// Response of `GET /vendor/exchanges`.
class SellerExchangeListRes {
  const SellerExchangeListRes({
    required this.exchanges,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerExchange> exchanges;
  final int count;
  final int offset;
  final int limit;

  factory SellerExchangeListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['exchanges'];
    return SellerExchangeListRes(
      exchanges: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerExchange.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exchanges': exchanges.map((e) => e.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}
