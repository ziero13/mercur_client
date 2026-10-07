/// Body of `POST /vendor/inventory-items` and `POST …/:id`.
class SellerInventoryItemReq {
  const SellerInventoryItemReq({
    this.sku,
    this.title,
    this.description,
    this.thumbnail,
    this.requiresShipping,
  });

  final String? sku;
  final String? title;
  final String? description;
  final String? thumbnail;
  final bool? requiresShipping;

  Map<String, dynamic> toJson() {
    return {
      if (sku != null) 'sku': sku,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (requiresShipping != null) 'requires_shipping': requiresShipping,
    };
  }
}

/// Body of location-level create/update.
class SellerLocationLevelReq {
  const SellerLocationLevelReq({
    this.locationId,
    this.stockedQuantity,
    this.incomingQuantity,
  });

  final String? locationId;
  final int? stockedQuantity;
  final int? incomingQuantity;

  Map<String, dynamic> toJson() {
    return {
      if (locationId != null) 'location_id': locationId,
      if (stockedQuantity != null) 'stocked_quantity': stockedQuantity,
      if (incomingQuantity != null) 'incoming_quantity': incomingQuantity,
    };
  }
}

/// Body of `POST /vendor/inventory-items/location-levels/batch`.
class SellerLocationLevelBatchReq {
  const SellerLocationLevelBatchReq({
    this.create = const [],
    this.update = const [],
    this.delete = const [],
  });

  final List<SellerLocationLevelReq> create;
  final List<SellerLocationLevelReq> update;
  final List<String> delete;

  Map<String, dynamic> toJson() {
    return {
      if (create.isNotEmpty)
        'create': create.map((c) => c.toJson()).toList(),
      if (update.isNotEmpty)
        'update': update.map((u) => u.toJson()).toList(),
      if (delete.isNotEmpty) 'delete': delete,
    };
  }
}

/// Body of `POST /vendor/reservations` and `POST …/:id`.
class SellerReservationReq {
  const SellerReservationReq({
    this.inventoryItemId,
    this.locationId,
    this.quantity,
  });

  final String? inventoryItemId;
  final String? locationId;
  final int? quantity;

  Map<String, dynamic> toJson() {
    return {
      if (inventoryItemId != null) 'inventory_item_id': inventoryItemId,
      if (locationId != null) 'location_id': locationId,
      if (quantity != null) 'quantity': quantity,
    };
  }
}

/// Body of `POST /vendor/stock-locations` and `POST …/:id`.
class SellerStockLocationReq {
  const SellerStockLocationReq({this.name});

  final String? name;

  Map<String, dynamic> toJson() {
    return {if (name != null) 'name': name};
  }
}

/// Body of `POST /vendor/shipping-options` and `POST …/:id`.
class SellerShippingOptionReq {
  const SellerShippingOptionReq({
    this.name,
    this.priceType,
    this.providerId,
    this.serviceZoneId,
    this.shippingProfileId,
    this.typeCode,
    this.amount,
  });

  final String? name;
  final String? priceType;
  final String? providerId;
  final String? serviceZoneId;
  final String? shippingProfileId;
  final String? typeCode;
  final int? amount;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (priceType != null) 'price_type': priceType,
      if (providerId != null) 'provider_id': providerId,
      if (serviceZoneId != null) 'service_zone_id': serviceZoneId,
      if (shippingProfileId != null)
        'shipping_profile_id': shippingProfileId,
      if (typeCode != null) 'type': {'code': typeCode},
      if (amount != null) 'amount': amount,
    };
  }
}

/// One rule op for `POST …/shipping-options/:id/rules/batch`.
class SellerShippingRuleReq {
  const SellerShippingRuleReq({
    this.id,
    this.attribute,
    this.operator,
    this.value,
  });

  final String? id;
  final String? attribute;
  final String? operator;
  final Object? value;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (attribute != null) 'attribute': attribute,
      if (operator != null) 'operator': operator,
      if (value != null) 'value': value,
    };
  }
}

/// Body of `POST /vendor/shipping-options/:id/rules/batch`.
class SellerShippingRulesBatchReq {
  const SellerShippingRulesBatchReq({
    this.create = const [],
    this.update = const [],
    this.delete = const [],
  });

  final List<SellerShippingRuleReq> create;
  final List<SellerShippingRuleReq> update;
  final List<String> delete;

  Map<String, dynamic> toJson() {
    return {
      if (create.isNotEmpty)
        'create': create.map((c) => c.toJson()).toList(),
      if (update.isNotEmpty)
        'update': update.map((u) => u.toJson()).toList(),
      if (delete.isNotEmpty) 'delete': delete,
    };
  }
}

/// Body of `POST /vendor/fulfillment-sets/:id/service-zones`.
class SellerServiceZoneReq {
  const SellerServiceZoneReq({this.name});

  final String? name;

  Map<String, dynamic> toJson() {
    return {if (name != null) 'name': name};
  }
}
