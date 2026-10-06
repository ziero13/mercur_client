/// Child order line within an order group (minimal Store shape).
class OrderGroupOrderItem {
  const OrderGroupOrderItem({required this.id, this.title, this.quantity});

  final String id;
  final String? title;
  final int? quantity;

  factory OrderGroupOrderItem.fromJson(Map<String, dynamic> json) {
    return OrderGroupOrderItem(
      id: json['id'] as String,
      title: json['title'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      if (quantity != null) 'quantity': quantity,
    };
  }
}

/// Per-seller child order inside an order group.
class OrderGroupOrder {
  const OrderGroupOrder({required this.id, this.sellerId, this.items = const []});

  final String id;
  final String? sellerId;
  final List<OrderGroupOrderItem> items;

  factory OrderGroupOrder.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return OrderGroupOrder(
      id: json['id'] as String,
      sellerId: json['seller_id'] as String?,
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(OrderGroupOrderItem.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (sellerId != null) 'seller_id': sellerId,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

/// Order group — the multi-seller wrapper created at cart completion.
///
/// Shared entity: the cart-completion branch returns a slimmer shape
/// (`cart_id`, no `orders`), the listing endpoints the full one. Only
/// `id` is required — partial `fields` selections fall back to neutral
/// defaults (see AGENTS.md).
class OrderGroup {
  const OrderGroup({
    required this.id,
    this.customerId,
    this.cartId,
    this.sellerCount,
    this.total,
    this.orders = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? customerId;

  /// Only present on the cart-completion branch.
  final String? cartId;
  final int? sellerCount;
  final int? total;
  final List<OrderGroupOrder> orders;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory OrderGroup.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(Object? raw) =>
        raw is String ? DateTime.tryParse(raw) : null;
    final rawOrders = json['orders'];
    return OrderGroup(
      id: json['id'] as String,
      customerId: json['customer_id'] as String?,
      cartId: json['cart_id'] as String?,
      sellerCount: (json['seller_count'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      orders: rawOrders is List
          ? rawOrders
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(OrderGroupOrder.fromJson)
              .toList()
          : const [],
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (cartId != null) 'cart_id': cartId,
      if (sellerCount != null) 'seller_count': sellerCount,
      if (total != null) 'total': total,
      'orders': orders.map((o) => o.toJson()).toList(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
