import '../order_group.dart';

/// Response of `GET /store/order-groups`.
class CustomerOrderGroupListRes {
  const CustomerOrderGroupListRes({
    required this.orderGroups,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<OrderGroup> orderGroups;
  final int count;
  final int offset;
  final int limit;

  factory CustomerOrderGroupListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['order_groups'];
    return CustomerOrderGroupListRes(
      orderGroups: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(OrderGroup.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_groups': orderGroups.map((o) => o.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response of `GET /store/order-groups/:id`.
class CustomerOrderGroupRes {
  const CustomerOrderGroupRes({required this.orderGroup});

  final OrderGroup orderGroup;

  factory CustomerOrderGroupRes.fromJson(Map<String, dynamic> json) {
    return CustomerOrderGroupRes(
      orderGroup:
          OrderGroup.fromJson(json['order_group'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'order_group': orderGroup.toJson()};
}
