import 'seller_details.dart';

/// Inventory level at one location (list key is `inventory_levels`).
class SellerInventoryLevel {
  const SellerInventoryLevel({
    this.id,
    this.locationId,
    this.stockedQuantity,
    this.reservedQuantity,
    this.incomingQuantity,
  });

  final String? id;
  final String? locationId;
  final int? stockedQuantity;
  final int? reservedQuantity;
  final int? incomingQuantity;

  factory SellerInventoryLevel.fromJson(Map<String, dynamic> json) {
    int? n(Object? v) => (v as num?)?.toInt();
    return SellerInventoryLevel(
      id: json['id'] as String?,
      locationId: json['location_id'] as String?,
      stockedQuantity: n(json['stocked_quantity']),
      reservedQuantity: n(json['reserved_quantity']),
      incomingQuantity: n(json['incoming_quantity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (stockedQuantity != null) 'stocked_quantity': stockedQuantity,
      if (reservedQuantity != null) 'reserved_quantity': reservedQuantity,
      if (incomingQuantity != null) 'incoming_quantity': incomingQuantity,
    };
  }
}

/// Inventory item (vendor view).
class SellerInventoryItem {
  const SellerInventoryItem({
    required this.id,
    this.sku,
    this.title,
    this.description,
    this.thumbnail,
    this.requiresShipping,
    this.reservedQuantity,
    this.stockedQuantity,
    this.locationLevels = const [],
  });

  final String id;
  final String? sku;
  final String? title;
  final String? description;
  final String? thumbnail;
  final bool? requiresShipping;
  final int? reservedQuantity;
  final int? stockedQuantity;
  final List<SellerInventoryLevel> locationLevels;

  factory SellerInventoryItem.fromJson(Map<String, dynamic> json) {
    int? n(Object? v) => (v as num?)?.toInt();
    final raw = json['location_levels'];
    return SellerInventoryItem(
      id: json['id'] as String,
      sku: json['sku'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      requiresShipping: json['requires_shipping'] as bool?,
      reservedQuantity: n(json['reserved_quantity']),
      stockedQuantity: n(json['stocked_quantity']),
      locationLevels: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(SellerInventoryLevel.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (sku != null) 'sku': sku,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (requiresShipping != null) 'requires_shipping': requiresShipping,
      if (reservedQuantity != null) 'reserved_quantity': reservedQuantity,
      if (stockedQuantity != null) 'stocked_quantity': stockedQuantity,
      'location_levels': locationLevels.map((l) => l.toJson()).toList(),
    };
  }
}

/// Stock location (vendor view).
class SellerStockLocation {
  const SellerStockLocation({required this.id, this.name, this.address});

  final String id;
  final String? name;
  final SellerAddress? address;

  factory SellerStockLocation.fromJson(Map<String, dynamic> json) {
    final raw = json['address'];
    return SellerStockLocation(
      id: json['id'] as String,
      name: json['name'] as String?,
      address: raw is Map<String, dynamic>
          ? SellerAddress.fromJson(raw)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address!.toJson(),
    };
  }
}

/// Inventory reservation (vendor view).
class SellerReservation {
  const SellerReservation({
    required this.id,
    this.inventoryItemId,
    this.locationId,
    this.quantity,
  });

  final String id;
  final String? inventoryItemId;
  final String? locationId;
  final int? quantity;

  factory SellerReservation.fromJson(Map<String, dynamic> json) {
    return SellerReservation(
      id: json['id'] as String,
      inventoryItemId: json['inventory_item_id'] as String?,
      locationId: json['location_id'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (inventoryItemId != null) 'inventory_item_id': inventoryItemId,
      if (locationId != null) 'location_id': locationId,
      if (quantity != null) 'quantity': quantity,
    };
  }
}

/// Shipping option (vendor view; prices/rules stay untyped lists).
class SellerShippingOption {
  const SellerShippingOption({
    required this.id,
    this.name = '',
    this.priceType,
    this.providerId,
    this.serviceZoneId,
    this.shippingProfileId,
    this.type,
  });

  final String id;
  final String name;
  final String? priceType;
  final String? providerId;
  final String? serviceZoneId;
  final String? shippingProfileId;
  final String? type;

  factory SellerShippingOption.fromJson(Map<String, dynamic> json) {
    String? str(Object? v) {
      if (v is String) return v;
      if (v is Map<String, dynamic>) return v['id'] as String?;
      return null;
    }

    return SellerShippingOption(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      priceType: json['price_type'] as String?,
      providerId: str(json['provider_id']) ?? str(json['provider']),
      serviceZoneId:
          str(json['service_zone_id']) ?? str(json['service_zone']),
      shippingProfileId: str(json['shipping_profile_id']) ??
          str(json['shipping_profile']),
      type: json['type'] is String
          ? json['type'] as String
          : (json['type'] as Map<String, dynamic>?)?['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (priceType != null) 'price_type': priceType,
      if (providerId != null) 'provider_id': providerId,
      if (serviceZoneId != null) 'service_zone_id': serviceZoneId,
      if (shippingProfileId != null)
        'shipping_profile_id': shippingProfileId,
      if (type != null) 'type': type,
    };
  }
}

/// Shipping profile / option type refs (`id`, `name`).
class SellerShippingProfile {
  const SellerShippingProfile({required this.id, this.name, this.type});

  final String id;
  final String? name;
  final String? type;

  factory SellerShippingProfile.fromJson(Map<String, dynamic> json) {
    return SellerShippingProfile(
      id: json['id'] as String,
      name: json['name'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
    };
  }
}
