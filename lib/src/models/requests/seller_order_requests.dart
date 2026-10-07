/// One line-item quantity in fulfillment/shipment bodies.
class SellerFulfillmentItem {
  const SellerFulfillmentItem({required this.id, required this.quantity});

  final String id;
  final int quantity;

  Map<String, dynamic> toJson() => {'id': id, 'quantity': quantity};
}

/// Body of `POST /vendor/orders/:id/fulfillments`.
class SellerCreateFulfillmentReq {
  const SellerCreateFulfillmentReq({
    required this.items,
    required this.requiresShipping,
    required this.locationId,
  });

  final List<SellerFulfillmentItem> items;
  final bool requiresShipping;
  final String locationId;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((i) => i.toJson()).toList(),
      'requires_shipping': requiresShipping,
      'location_id': locationId,
    };
  }
}

/// One tracking label in `POST …/shipments`.
class SellerShipmentLabel {
  const SellerShipmentLabel({required this.trackingNumber});

  final String trackingNumber;

  Map<String, dynamic> toJson() => {'tracking_number': trackingNumber};
}

/// Body of `POST /vendor/orders/:id/fulfillments/:fulfillment_id/shipments`.
class SellerCreateShipmentReq {
  const SellerCreateShipmentReq({required this.items, this.labels = const []});

  final List<SellerFulfillmentItem> items;
  final List<SellerShipmentLabel> labels;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((i) => i.toJson()).toList(),
      if (labels.isNotEmpty)
        'labels': labels.map((l) => l.toJson()).toList(),
    };
  }
}
