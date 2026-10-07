import '../seller_order.dart';

/// Response of `GET /vendor/orders`.
class SellerOrderListRes {
  const SellerOrderListRes({
    required this.orders,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerOrder> orders;
  final int count;
  final int offset;
  final int limit;

  factory SellerOrderListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['orders'];
    return SellerOrderListRes(
      orders: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerOrder.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((o) => o.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `order`
/// (retrieve / preview / complete / cancel / shipment).
class SellerOrderRes {
  const SellerOrderRes({required this.order});

  final SellerOrder order;

  factory SellerOrderRes.fromJson(Map<String, dynamic> json) {
    return SellerOrderRes(
      order: SellerOrder.fromJson(json['order'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'order': order.toJson()};
}

/// Response wrapping one `fulfillment`
/// (create / cancel / mark-as-delivered).
class SellerFulfillmentRes {
  const SellerFulfillmentRes({required this.fulfillment});

  final SellerFulfillment fulfillment;

  factory SellerFulfillmentRes.fromJson(Map<String, dynamic> json) {
    return SellerFulfillmentRes(
      fulfillment: SellerFulfillment.fromJson(
          json['fulfillment'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'fulfillment': fulfillment.toJson()};
}

/// Response of `GET /vendor/orders/:id/commission-lines`.
class SellerCommissionListRes {
  const SellerCommissionListRes({
    required this.commissions,
    required this.count,
  });

  final List<SellerCommissionLine> commissions;
  final int count;

  factory SellerCommissionListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['commission_lines'];
    return SellerCommissionListRes(
      commissions: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerCommissionLine.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commission_lines': commissions.map((c) => c.toJson()).toList(),
      'count': count,
    };
  }
}

/// Response of `GET /vendor/orders/:id/changes`.
class SellerOrderChangeListRes {
  const SellerOrderChangeListRes({required this.changes});

  final List<SellerOrderChange> changes;

  factory SellerOrderChangeListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['order_changes'];
    return SellerOrderChangeListRes(
      changes: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerOrderChange.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'order_changes': changes.map((c) => c.toJson()).toList(),
      };
}
