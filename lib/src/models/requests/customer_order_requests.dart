/// Body of `POST /store/orders/:id/transfer/request`.
class CustomerRequestOrderTransferReq {
  const CustomerRequestOrderTransferReq({
    this.description,
    this.updateOrderEmail,
  });

  final String? description;
  final bool? updateOrderEmail;

  Map<String, dynamic> toJson() {
    return {
      if (description != null) 'description': description,
      if (updateOrderEmail != null)
        'update_order_email': updateOrderEmail,
    };
  }

  factory CustomerRequestOrderTransferReq.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerRequestOrderTransferReq(
      description: json['description'] as String?,
      updateOrderEmail: json['update_order_email'] as bool?,
    );
  }
}

/// Body of `POST /store/orders/:id/transfer/accept`.
class CustomerAcceptOrderTransferReq {
  const CustomerAcceptOrderTransferReq({required this.token});

  final String token;

  Map<String, dynamic> toJson() => {'token': token};

  factory CustomerAcceptOrderTransferReq.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerAcceptOrderTransferReq(token: json['token'] as String);
  }
}

/// Body of `POST /store/orders/:id/transfer/decline`.
class CustomerDeclineOrderTransferReq {
  const CustomerDeclineOrderTransferReq({required this.token});

  final String token;

  Map<String, dynamic> toJson() => {'token': token};

  factory CustomerDeclineOrderTransferReq.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerDeclineOrderTransferReq(token: json['token'] as String);
  }
}

/// One return line in `POST /store/returns`.
class CustomerReturnItemReq {
  const CustomerReturnItemReq({
    required this.id,
    required this.quantity,
    this.reasonId,
    this.note,
  });

  final String id;
  final int quantity;
  final String? reasonId;
  final String? note;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      if (reasonId != null) 'reason_id': reasonId,
      if (note != null) 'note': note,
    };
  }

  factory CustomerReturnItemReq.fromJson(Map<String, dynamic> json) {
    return CustomerReturnItemReq(
      id: json['id'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      reasonId: json['reason_id'] as String?,
      note: json['note'] as String?,
    );
  }
}

/// Body of `POST /store/returns` (intentionally unauthenticated server-side:
/// the order id acts as the access token).
class CustomerCreateReturnReq {
  const CustomerCreateReturnReq({
    required this.orderId,
    required this.items,
    this.optionId,
    this.locationId,
    this.note,
    this.receiveNow,
  });

  final String orderId;
  final List<CustomerReturnItemReq> items;
  final String? optionId;
  final String? locationId;
  final String? note;
  final bool? receiveNow;

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'items': items.map((i) => i.toJson()).toList(),
      if (optionId != null) 'return_shipping': {'option_id': optionId},
      if (locationId != null) 'location_id': locationId,
      if (note != null) 'note': note,
      if (receiveNow != null) 'receive_now': receiveNow,
    };
  }

  factory CustomerCreateReturnReq.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final rawShipping = json['return_shipping'];
    return CustomerCreateReturnReq(
      orderId: json['order_id'] as String,
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerReturnItemReq.fromJson)
              .toList()
          : const [],
      optionId: rawShipping is Map<String, dynamic>
          ? rawShipping['option_id'] as String?
          : null,
      locationId: json['location_id'] as String?,
      note: json['note'] as String?,
      receiveNow: json['receive_now'] as bool?,
    );
  }
}
