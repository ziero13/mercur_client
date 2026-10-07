/// One price tier in offer create/update bodies.
class SellerOfferPriceReq {
  const SellerOfferPriceReq({
    this.id,
    required this.amount,
    required this.currencyCode,
    this.minQuantity,
    this.maxQuantity,
    this.rules,
  });

  final String? id;
  final int amount;
  final String currencyCode;
  final int? minQuantity;
  final int? maxQuantity;
  final Map<String, dynamic>? rules;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'currency_code': currencyCode,
      if (minQuantity != null) 'min_quantity': minQuantity,
      if (maxQuantity != null) 'max_quantity': maxQuantity,
      if (rules != null) 'rules': rules,
    };
  }
}

/// Stock level for a created inventory item.
class SellerOfferStockLevel {
  const SellerOfferStockLevel({
    required this.locationId,
    required this.stockedQuantity,
  });

  final String locationId;
  final int stockedQuantity;

  Map<String, dynamic> toJson() => {
        'location_id': locationId,
        'stocked_quantity': stockedQuantity,
      };
}

/// One inventory item in `POST /vendor/offers` (creates the item).
class SellerOfferInventoryReq {
  const SellerOfferInventoryReq({
    this.title,
    this.sku,
    this.requiredQuantity,
    this.stockLevels = const [],
  });

  final String? title;
  final String? sku;
  final int? requiredQuantity;
  final List<SellerOfferStockLevel> stockLevels;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (sku != null) 'sku': sku,
      if (requiredQuantity != null) 'required_quantity': requiredQuantity,
      if (stockLevels.isNotEmpty)
        'stock_levels': stockLevels.map((s) => s.toJson()).toList(),
    };
  }
}

/// Body of `POST /vendor/offers`.
class SellerCreateOfferReq {
  const SellerCreateOfferReq({
    required this.sku,
    required this.variantId,
    required this.shippingProfileId,
    required this.inventoryItems,
    required this.prices,
    this.ean,
    this.upc,
    this.manageInventory,
    this.allowBackorder,
  });

  final String sku;
  final String variantId;
  final String shippingProfileId;
  final List<SellerOfferInventoryReq> inventoryItems;
  final List<SellerOfferPriceReq> prices;
  final String? ean;
  final String? upc;
  final bool? manageInventory;
  final bool? allowBackorder;

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'variant_id': variantId,
      'shipping_profile_id': shippingProfileId,
      'inventory_items': inventoryItems.map((i) => i.toJson()).toList(),
      'prices': prices.map((p) => p.toJson()).toList(),
      if (ean != null) 'ean': ean,
      if (upc != null) 'upc': upc,
      if (manageInventory != null) 'manage_inventory': manageInventory,
      if (allowBackorder != null) 'allow_backorder': allowBackorder,
    };
  }
}

/// Body of `POST /vendor/offers/:id`.
class SellerUpdateOfferReq {
  const SellerUpdateOfferReq({
    this.sku,
    this.shippingProfileId,
    this.manageInventory,
    this.allowBackorder,
    this.prices,
    this.metadata,
  });

  final String? sku;
  final String? shippingProfileId;
  final bool? manageInventory;
  final bool? allowBackorder;
  final List<SellerOfferPriceReq>? prices;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      if (sku != null) 'sku': sku,
      if (shippingProfileId != null)
        'shipping_profile_id': shippingProfileId,
      if (manageInventory != null) 'manage_inventory': manageInventory,
      if (allowBackorder != null) 'allow_backorder': allowBackorder,
      if (prices != null) 'prices': prices!.map((p) => p.toJson()).toList(),
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Link entry for `POST /vendor/offers/:id/inventory-items/batch`.
class SellerOfferInventoryLinkReq {
  const SellerOfferInventoryLinkReq({this.inventoryItemId, this.requiredQuantity});

  final String? inventoryItemId;
  final int? requiredQuantity;

  Map<String, dynamic> toJson() {
    return {
      if (inventoryItemId != null) 'inventory_item_id': inventoryItemId,
      if (requiredQuantity != null) 'required_quantity': requiredQuantity,
    };
  }
}

/// Body of `POST /vendor/offers/:id/inventory-items/batch`.
class SellerOfferInventoryBatchReq {
  const SellerOfferInventoryBatchReq({
    this.create = const [],
    this.update = const [],
    this.delete = const [],
  });

  final List<SellerOfferInventoryLinkReq> create;
  final List<SellerOfferInventoryLinkReq> update;
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
