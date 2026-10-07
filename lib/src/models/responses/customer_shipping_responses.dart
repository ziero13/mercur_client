import '../customer_shipping.dart';

/// Response of `GET /store/shipping-options`: options grouped by seller id.
///
/// Mercur returns a MAP (`{seller_id: [...]}`), not a flat list — an
/// empty cart yields an empty map, not a 404.
class CustomerShippingOptionsRes {
  const CustomerShippingOptionsRes({required this.optionsBySeller});

  final Map<String, List<CustomerShippingOption>> optionsBySeller;

  /// Flat view across all sellers.
  List<CustomerShippingOption> get options =>
      optionsBySeller.values.expand((l) => l).toList();

  factory CustomerShippingOptionsRes.fromJson(Map<String, dynamic> json) {
    final raw = json['shipping_options'];
    final grouped = <String, List<CustomerShippingOption>>{};
    if (raw is Map<String, dynamic>) {
      for (final entry in raw.entries) {
        final rows = entry.value;
        grouped[entry.key] = rows is List
            ? rows
                .whereType<Map<String, dynamic>>()
                .where((m) => m['id'] is String)
                .map(CustomerShippingOption.fromJson)
                .toList()
            : const [];
      }
    }
    return CustomerShippingOptionsRes(optionsBySeller: grouped);
  }

  Map<String, dynamic> toJson() {
    return {
      'shipping_options': optionsBySeller.map(
        (k, v) => MapEntry(k, v.map((o) => o.toJson()).toList()),
      ),
    };
  }
}

/// Response of `POST /store/shipping-options/:id/calculate`.
class CustomerShippingOptionRes {
  const CustomerShippingOptionRes({required this.shippingOption});

  final CustomerShippingOption shippingOption;

  factory CustomerShippingOptionRes.fromJson(Map<String, dynamic> json) {
    return CustomerShippingOptionRes(
      shippingOption: CustomerShippingOption.fromJson(
        json['shipping_option'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() =>
      {'shipping_option': shippingOption.toJson()};
}

/// Response of `GET /store/regions`.
class CustomerRegionsRes {
  const CustomerRegionsRes({
    required this.regions,
    required this.count,
    this.offset,
    this.limit,
  });

  final List<CustomerRegion> regions;
  final int count;
  final int? offset;
  final int? limit;

  factory CustomerRegionsRes.fromJson(Map<String, dynamic> json) {
    final raw = json['regions'];
    return CustomerRegionsRes(
      regions: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerRegion.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regions': regions.map((r) => r.toJson()).toList(),
      'count': count,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
  }
}

/// Response of `GET /store/regions/:id`.
class CustomerRegionRes {
  const CustomerRegionRes({required this.region});

  final CustomerRegion region;

  factory CustomerRegionRes.fromJson(Map<String, dynamic> json) {
    return CustomerRegionRes(
      region: CustomerRegion.fromJson(
        json['region'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {'region': region.toJson()};
}
