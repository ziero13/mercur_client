import '../seller_pricing.dart';

/// Response of `GET /vendor/price-lists`.
class SellerPriceListRes {
  const SellerPriceListRes({
    required this.lists,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerPriceList> lists;
  final int count;
  final int offset;
  final int limit;

  factory SellerPriceListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['price_lists'];
    return SellerPriceListRes(
      lists: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerPriceList.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price_lists': lists.map((l) => l.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `price_list`.
class SellerPriceListDetailRes {
  const SellerPriceListDetailRes({required this.list});

  final SellerPriceList list;

  factory SellerPriceListDetailRes.fromJson(Map<String, dynamic> json) {
    return SellerPriceListDetailRes(
      list: SellerPriceList.fromJson(
          json['price_list'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'price_list': list.toJson()};
}

/// Response of `GET /vendor/price-lists/:id/prices`.
class SellerPriceListPricesRes {
  const SellerPriceListPricesRes({
    required this.prices,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerPriceListPrice> prices;
  final int count;
  final int offset;
  final int limit;

  factory SellerPriceListPricesRes.fromJson(Map<String, dynamic> json) {
    final raw = json['prices'];
    return SellerPriceListPricesRes(
      prices: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(SellerPriceListPrice.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prices': prices.map((p) => p.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response of `POST …/prices/batch`.
class SellerPriceBatchRes {
  const SellerPriceBatchRes({
    required this.created,
    required this.updated,
    required this.deletedIds,
  });

  final List<SellerPriceListPrice> created;
  final List<SellerPriceListPrice> updated;
  final List<String> deletedIds;

  factory SellerPriceBatchRes.fromJson(Map<String, dynamic> json) {
    List<SellerPriceListPrice> parse(Object? raw) => raw is List
        ? raw
            .whereType<Map<String, dynamic>>()
            .map(SellerPriceListPrice.fromJson)
            .toList()
        : const [];
    final deleted = json['deleted'];
    return SellerPriceBatchRes(
      created: parse(json['created']),
      updated: parse(json['updated']),
      deletedIds: deleted is Map<String, dynamic> && deleted['id'] is List
          ? (deleted['id'] as List).whereType<String>().toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created': created.map((p) => p.toJson()).toList(),
      'updated': updated.map((p) => p.toJson()).toList(),
      'deleted': {'id': deletedIds, 'object': 'price', 'deleted': true},
    };
  }
}

/// Deletion confirmation (`{id, object, deleted}`).
class SellerPricingDeleteRes {
  const SellerPricingDeleteRes({
    required this.id,
    required this.object,
    required this.deleted,
  });

  final String id;
  final String object;
  final bool deleted;

  factory SellerPricingDeleteRes.fromJson(Map<String, dynamic> json) {
    return SellerPricingDeleteRes(
      id: json['id'] as String? ?? '',
      object: json['object'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'object': object, 'deleted': deleted};
}

/// Response of `GET /vendor/campaigns`.
class SellerCampaignListRes {
  const SellerCampaignListRes({
    required this.campaigns,
    required this.count,
    required this.offset,
    required this.limit,
  });

  final List<SellerCampaign> campaigns;
  final int count;
  final int offset;
  final int limit;

  factory SellerCampaignListRes.fromJson(Map<String, dynamic> json) {
    final raw = json['campaigns'];
    return SellerCampaignListRes(
      campaigns: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerCampaign.fromJson)
              .toList()
          : const [],
      count: (json['count'] as num?)?.toInt() ?? 0,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campaigns': campaigns.map((c) => c.toJson()).toList(),
      'count': count,
      'offset': offset,
      'limit': limit,
    };
  }
}

/// Response wrapping one `campaign`.
class SellerCampaignDetailRes {
  const SellerCampaignDetailRes({required this.campaign});

  final SellerCampaign campaign;

  factory SellerCampaignDetailRes.fromJson(Map<String, dynamic> json) {
    return SellerCampaignDetailRes(
      campaign: SellerCampaign.fromJson(
          json['campaign'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'campaign': campaign.toJson()};
}
