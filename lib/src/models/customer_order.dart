/// Store order line item (light view).
class CustomerOrderLineItem {
  const CustomerOrderLineItem({
    required this.id,
    required this.quantity,
    this.title,
  });

  final String id;
  final int quantity;
  final String? title;

  factory CustomerOrderLineItem.fromJson(Map<String, dynamic> json) {
    return CustomerOrderLineItem(
      id: json['id'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      if (title != null) 'title': title,
    };
  }
}

/// Store order (`GET /store/orders*`, transfer flows).
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults (see AGENTS.md).
class CustomerOrder {
  const CustomerOrder({
    required this.id,
    this.displayId,
    this.status,
    this.email,
    this.currencyCode,
    this.total,
    this.subtotal,
    this.taxTotal,
    this.shippingTotal,
    this.items = const [],
  });

  final String id;
  final int? displayId;
  final String? status;
  final String? email;
  final String? currencyCode;
  final int? total;
  final int? subtotal;
  final int? taxTotal;
  final int? shippingTotal;
  final List<CustomerOrderLineItem> items;

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    int? toInt(Object? raw) => (raw as num?)?.toInt();
    final rawItems = json['items'];
    return CustomerOrder(
      id: json['id'] as String,
      displayId: toInt(json['display_id']),
      status: json['status'] as String?,
      email: json['email'] as String?,
      currencyCode: json['currency_code'] as String?,
      total: toInt(json['total']),
      subtotal: toInt(json['subtotal']),
      taxTotal: toInt(json['tax_total']),
      shippingTotal: toInt(json['shipping_total']),
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerOrderLineItem.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (displayId != null) 'display_id': displayId,
      if (status != null) 'status': status,
      if (email != null) 'email': email,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (total != null) 'total': total,
      if (subtotal != null) 'subtotal': subtotal,
      if (taxTotal != null) 'tax_total': taxTotal,
      if (shippingTotal != null) 'shipping_total': shippingTotal,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

/// Store return reason (`GET /store/return-reasons*`).
class CustomerReturnReason {
  const CustomerReturnReason({
    required this.id,
    this.label,
    this.value,
  });

  final String id;
  final String? label;
  final String? value;

  factory CustomerReturnReason.fromJson(Map<String, dynamic> json) {
    return CustomerReturnReason(
      id: json['id'] as String,
      label: json['label'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
    };
  }
}

/// Store return (`POST /store/returns`).
class CustomerReturn {
  const CustomerReturn({
    required this.id,
    this.orderId,
    this.status,
  });

  final String id;
  final String? orderId;
  final String? status;

  factory CustomerReturn.fromJson(Map<String, dynamic> json) {
    return CustomerReturn(
      id: json['id'] as String,
      orderId: json['order_id'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (orderId != null) 'order_id': orderId,
      if (status != null) 'status': status,
    };
  }
}
