import '../seller_stock.dart';

/// Response of `GET /vendor/inventory-items`.
class SellerInventoryListRes {
  const SellerInventoryListRes({
    required this.items,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerInventoryItem> items;
  final int count;
  final int offset;
  final int limit;

  factory SellerInventoryListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['inventory_items'];
    return SellerInventoryListRes(
      items: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerInventoryItem.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventory_items': items.map((i) => i.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `inventory_item`.
class SellerInventoryItemRes {
  const SellerInventoryItemRes({required this.item});

  final SellerInventoryItem item;

  factory SellerInventoryItemRes.fromJson(Map<String, dynamic> json) {
    return SellerInventoryItemRes(
      item: SellerInventoryItem.fromJson(
          json['inventory_item'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'inventory_item': item.toJson()};
}

/// Deletion confirmation (`{id, object, deleted}`).
class SellerStockDeleteRes {
  const SellerStockDeleteRes({
    required this.id,
    required this.object,
    required this.deleted,
  });

  final String id;
  final String object;
  final bool deleted;

  factory SellerStockDeleteRes.fromJson(Map<String, dynamic> json) {
    return SellerStockDeleteRes(
      id: json['id'] as String? ?? '',
      object: json['object'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'object': object, 'deleted': deleted};
}

/// Response of `GET …/location-levels` (wire key: `inventory_levels`).
class SellerInventoryLevelListRes {
  const SellerInventoryLevelListRes({
    required this.levels,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerInventoryLevel> levels;
  final int count;
  final int offset;
  final int limit;

  factory SellerInventoryLevelListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['inventory_levels'];
    return SellerInventoryLevelListRes(
      levels: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(SellerInventoryLevel.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventory_levels': levels.map((l) => l.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response of `GET /vendor/reservations`.
class SellerReservationListRes {
  const SellerReservationListRes({
    required this.reservations,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerReservation> reservations;
  final int count;
  final int offset;
  final int limit;

  factory SellerReservationListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['reservations'];
    return SellerReservationListRes(
      reservations: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerReservation.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservations': reservations.map((r) => r.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `reservation`.
class SellerReservationRes {
  const SellerReservationRes({required this.reservation});

  final SellerReservation reservation;

  factory SellerReservationRes.fromJson(Map<String, dynamic> json) {
    return SellerReservationRes(
      reservation: SellerReservation.fromJson(
          json['reservation'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'reservation': reservation.toJson()};
}

/// Response of `GET /vendor/stock-locations`.
class SellerStockLocationListRes {
  const SellerStockLocationListRes({
    required this.locations,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerStockLocation> locations;
  final int count;
  final int offset;
  final int limit;

  factory SellerStockLocationListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['stock_locations'];
    return SellerStockLocationListRes(
      locations: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerStockLocation.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stock_locations': locations.map((l) => l.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `stock_location`.
class SellerStockLocationRes {
  const SellerStockLocationRes({required this.location});

  final SellerStockLocation location;

  factory SellerStockLocationRes.fromJson(Map<String, dynamic> json) {
    return SellerStockLocationRes(
      location: SellerStockLocation.fromJson(
          json['stock_location'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'stock_location': location.toJson()};
}

/// Response of `GET /vendor/shipping-options`.
class SellerShippingOptionListRes {
  const SellerShippingOptionListRes({
    required this.options,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerShippingOption> options;
  final int count;
  final int offset;
  final int limit;

  factory SellerShippingOptionListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['shipping_options'];
    return SellerShippingOptionListRes(
      options: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerShippingOption.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipping_options': options.map((o) => o.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `shipping_option`.
class SellerShippingOptionRes {
  const SellerShippingOptionRes({required this.option});

  final SellerShippingOption option;

  factory SellerShippingOptionRes.fromJson(Map<String, dynamic> json) {
    return SellerShippingOptionRes(
      option: SellerShippingOption.fromJson(
          json['shipping_option'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'shipping_option': option.toJson()};
}

/// Response of profile / option-type lists.
class SellerShippingProfileListRes {
  const SellerShippingProfileListRes({
    required this.profiles,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerShippingProfile> profiles;
  final int count;
  final int offset;
  final int limit;

  factory SellerShippingProfileListRes.fromJson(
    Map<String, dynamic> json, [
    String key = 'shipping_profiles',
  ]) {
    final raw = json[key];
    return SellerShippingProfileListRes(
      profiles: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerShippingProfile.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipping_profiles': profiles.map((p) => p.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}
