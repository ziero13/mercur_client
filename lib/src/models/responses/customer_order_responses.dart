import '../customer_order.dart';

/// Response of `GET /store/orders`.
class CustomerOrdersRes {
  const CustomerOrdersRes({
    required this.orders,
    required this.count,
    this.offset,
    this.limit,
  });

  final List<CustomerOrder> orders;
  final int count;
  final int? offset;
  final int? limit;

  factory CustomerOrdersRes.fromJson(Map<String, dynamic> json) {
    final raw = json['orders'];
    return CustomerOrdersRes(
      orders: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerOrder.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((o) => o.toJson()).toList(),
      'count': count,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
  }
}

/// Response wrapping one order (`retrieve`, transfer actions).
class CustomerOrderRes {
  const CustomerOrderRes({required this.order});

  final CustomerOrder order;

  factory CustomerOrderRes.fromJson(Map<String, dynamic> json) {
    return CustomerOrderRes(
      order: CustomerOrder.fromJson(
        json['order'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {'order': order.toJson()};
}

/// Response of `GET /store/return-reasons`.
class CustomerReturnReasonsRes {
  const CustomerReturnReasonsRes({
    required this.returnReasons,
    required this.count,
    this.offset,
    this.limit,
  });

  final List<CustomerReturnReason> returnReasons;
  final int count;
  final int? offset;
  final int? limit;

  factory CustomerReturnReasonsRes.fromJson(Map<String, dynamic> json) {
    final raw = json['return_reasons'];
    return CustomerReturnReasonsRes(
      returnReasons: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerReturnReason.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'return_reasons': returnReasons.map((r) => r.toJson()).toList(),
      'count': count,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
  }
}

/// Response of `GET /store/return-reasons/:id`.
class CustomerReturnReasonRes {
  const CustomerReturnReasonRes({required this.returnReason});

  final CustomerReturnReason returnReason;

  factory CustomerReturnReasonRes.fromJson(Map<String, dynamic> json) {
    return CustomerReturnReasonRes(
      returnReason: CustomerReturnReason.fromJson(
        json['return_reason'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() =>
      {'return_reason': returnReason.toJson()};
}

/// Response of `POST /store/returns`.
class CustomerReturnRes {
  const CustomerReturnRes({required this.returnRecord});

  final CustomerReturn returnRecord;

  factory CustomerReturnRes.fromJson(Map<String, dynamic> json) {
    return CustomerReturnRes(
      returnRecord: CustomerReturn.fromJson(
        json['return'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {'return': returnRecord.toJson()};
}
