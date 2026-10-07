// RMA request bodies. Shapes follow the server zod validators in
// `@mercurjs/core` (`api/vendor/{order-edits,returns,claims,exchanges}`).

/// Body of `POST /vendor/order-edits`.
class OrderEditCreateReq {
  const OrderEditCreateReq({
    required this.orderId,
    this.description,
    this.internalNote,
  });

  final String orderId;
  final String? description;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      if (description != null) 'description': description,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}

/// One staged add-item entry (order edits, claim/exchange outbound).
class RmaAddItem {
  const RmaAddItem({
    this.variantId,
    this.offerId,
    required this.quantity,
    this.unitPrice,
    this.internalNote,
    this.allowBackorder,
  });

  final String? variantId;
  final String? offerId;
  final int quantity;
  final int? unitPrice;
  final String? internalNote;
  final bool? allowBackorder;

  Map<String, dynamic> toJson() {
    return {
      if (variantId != null) 'variant_id': variantId,
      if (offerId != null) 'offer_id': offerId,
      'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (internalNote != null) 'internal_note': internalNote,
      if (allowBackorder != null) 'allow_backorder': allowBackorder,
    };
  }
}

/// Body of `POST …/items` (order edits add-items).
class OrderEditAddItemsReq {
  const OrderEditAddItemsReq({required this.items});

  final List<RmaAddItem> items;

  Map<String, dynamic> toJson() => {
        'items': items.map((i) => i.toJson()).toList(),
      };
}

/// Body of `POST …/items/[action_id]` (edit staged item action).
class OrderEditUpdateItemReq {
  const OrderEditUpdateItemReq({
    this.quantity,
    this.unitPrice,
    this.internalNote,
  });

  final int? quantity;
  final int? unitPrice;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}

/// Body of `POST …/items/item/[item_id]` (set item quantity).
class OrderEditSetItemQuantityReq {
  const OrderEditSetItemQuantityReq({
    required this.quantity,
    this.unitPrice,
    this.internalNote,
  });

  final int quantity;
  final int? unitPrice;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}

/// Body of `POST …/shipping-method` (stage shipping).
class RmaShippingReq {
  const RmaShippingReq({
    required this.shippingOptionId,
    this.customAmount,
    this.description,
    this.internalNote,
  });

  final String shippingOptionId;
  final int? customAmount;
  final String? description;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      'shipping_option_id': shippingOptionId,
      if (customAmount != null) 'custom_amount': customAmount,
      if (description != null) 'description': description,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}

/// Body of `POST …/shipping-method/[action_id]` (edit staged shipping).
class RmaShippingActionReq {
  const RmaShippingActionReq({this.customAmount, this.internalNote});

  final int? customAmount;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      if (customAmount != null) 'custom_amount': customAmount,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}

/// Body of `POST /vendor/returns`.
class ReturnCreateReq {
  const ReturnCreateReq({
    required this.orderId,
    this.locationId,
    this.description,
    this.internalNote,
    this.noNotification,
  });

  final String orderId;
  final String? locationId;
  final String? description;
  final String? internalNote;
  final bool? noNotification;

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      if (locationId != null) 'location_id': locationId,
      if (description != null) 'description': description,
      if (internalNote != null) 'internal_note': internalNote,
      if (noNotification != null) 'no_notification': noNotification,
    };
  }
}

/// Body of `POST /vendor/returns/:id` (update).
class ReturnUpdateReq {
  const ReturnUpdateReq({this.locationId, this.noNotification});

  final String? locationId;
  final bool? noNotification;

  Map<String, dynamic> toJson() {
    return {
      if (locationId != null) 'location_id': locationId,
      if (noNotification != null) 'no_notification': noNotification,
    };
  }
}

/// One requested return item.
class RmaRequestItem {
  const RmaRequestItem({
    required this.id,
    required this.quantity,
    this.description,
    this.internalNote,
    this.reasonId,
  });

  final String id;
  final int quantity;
  final String? description;
  final String? internalNote;
  final String? reasonId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      if (description != null) 'description': description,
      if (internalNote != null) 'internal_note': internalNote,
      if (reasonId != null) 'reason_id': reasonId,
    };
  }
}

/// Body of `POST …/request-items` (stage return items).
class ReturnRequestItemsReq {
  const ReturnRequestItemsReq({required this.items});

  final List<RmaRequestItem> items;

  Map<String, dynamic> toJson() => {
        'items': items.map((i) => i.toJson()).toList(),
      };
}

/// Body of `POST …/request-items/[action_id]` (edit staged item).
class RmaItemActionReq {
  const RmaItemActionReq({
    this.quantity,
    this.internalNote,
    this.reasonId,
  });

  final int? quantity;
  final String? internalNote;
  final String? reasonId;

  Map<String, dynamic> toJson() {
    return {
      if (quantity != null) 'quantity': quantity,
      if (internalNote != null) 'internal_note': internalNote,
      if (reasonId != null) 'reason_id': reasonId,
    };
  }
}

/// Body of `POST …/receive` (start receiving).
class ReturnReceiveReq {
  const ReturnReceiveReq({this.internalNote, this.description});

  final String? internalNote;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      if (internalNote != null) 'internal_note': internalNote,
      if (description != null) 'description': description,
    };
  }
}

/// One received item entry.
class RmaReceiveItem {
  const RmaReceiveItem({
    required this.id,
    required this.quantity,
    this.description,
    this.internalNote,
  });

  final String id;
  final int quantity;
  final String? description;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      if (description != null) 'description': description,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}

/// Body of `POST …/receive-items` (stage received items).
class ReturnReceiveItemsReq {
  const ReturnReceiveItemsReq({required this.items});

  final List<RmaReceiveItem> items;

  Map<String, dynamic> toJson() => {
        'items': items.map((i) => i.toJson()).toList(),
      };
}

/// Body of `POST …/receive/confirm` and `POST …/cancel`.
class RmaConfirmReq {
  const RmaConfirmReq({this.noNotification});

  final bool? noNotification;

  Map<String, dynamic> toJson() {
    return {if (noNotification != null) 'no_notification': noNotification};
  }
}

/// Body of `POST /vendor/claims` (`type`: `refund` | `replace`).
class ClaimCreateReq {
  const ClaimCreateReq({
    required this.type,
    required this.orderId,
    this.description,
    this.internalNote,
    this.reasonId,
  });

  final String type;
  final String orderId;
  final String? description;
  final String? internalNote;
  final String? reasonId;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'order_id': orderId,
      if (description != null) 'description': description,
      if (internalNote != null) 'internal_note': internalNote,
      if (reasonId != null) 'reason_id': reasonId,
    };
  }
}

/// One claim item entry.
class ClaimItem {
  const ClaimItem({
    required this.id,
    required this.quantity,
    this.reason,
    this.description,
    this.internalNote,
  });

  final String id;
  final int quantity;
  final String? reason;
  final String? description;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      if (reason != null) 'reason': reason,
      if (description != null) 'description': description,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}

/// Body of `POST …/claim-items`.
class ClaimItemsReq {
  const ClaimItemsReq({required this.items});

  final List<ClaimItem> items;

  Map<String, dynamic> toJson() => {
        'items': items.map((i) => i.toJson()).toList(),
      };
}

/// Body of `POST …/claim-items/[action_id]`.
class ClaimItemsActionReq {
  const ClaimItemsActionReq({
    this.quantity,
    this.reasonId,
    this.internalNote,
  });

  final int? quantity;
  final String? reasonId;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      if (quantity != null) 'quantity': quantity,
      if (reasonId != null) 'reason_id': reasonId,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}

/// Body of claim/exchange inbound (`POST …/inbound/items`).
class RmaInboundReq {
  const RmaInboundReq({this.locationId, required this.items});

  final String? locationId;
  final List<RmaRequestItem> items;

  Map<String, dynamic> toJson() {
    return {
      if (locationId != null) 'location_id': locationId,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

/// Body of claim/exchange outbound (`POST …/outbound/items`).
class RmaOutboundReq {
  const RmaOutboundReq({required this.items});

  final List<RmaAddItem> items;

  Map<String, dynamic> toJson() => {
        'items': items.map((i) => i.toJson()).toList(),
      };
}

/// Body of `POST /vendor/exchanges`.
class ExchangeCreateReq {
  const ExchangeCreateReq({
    required this.orderId,
    this.description,
    this.internalNote,
  });

  final String orderId;
  final String? description;
  final String? internalNote;

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      if (description != null) 'description': description,
      if (internalNote != null) 'internal_note': internalNote,
    };
  }
}
