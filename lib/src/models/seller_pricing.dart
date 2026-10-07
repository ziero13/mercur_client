// Vendor pricing entities (price lists, campaigns).
// Shapes follow the server zod validators in `@mercurjs/core`
// (`api/vendor/{price-lists,campaigns}`); only `id` is required.

/// A price in a price list.
class SellerPriceListPrice {
  const SellerPriceListPrice({
    this.id,
    this.currencyCode,
    this.amount,
    this.variantId,
    this.minQuantity,
    this.maxQuantity,
  });

  final String? id;
  final String? currencyCode;
  final int? amount;
  final String? variantId;
  final int? minQuantity;
  final int? maxQuantity;

  factory SellerPriceListPrice.fromJson(Map<String, dynamic> json) {
    return SellerPriceListPrice(
      id: json['id'] as String?,
      currencyCode: json['currency_code'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      variantId: json['variant_id'] as String?,
      minQuantity: (json['min_quantity'] as num?)?.toInt(),
      maxQuantity: (json['max_quantity'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (amount != null) 'amount': amount,
      if (variantId != null) 'variant_id': variantId,
      if (minQuantity != null) 'min_quantity': minQuantity,
      if (maxQuantity != null) 'max_quantity': maxQuantity,
    };
  }
}

/// A price list (`price_list` payloads).
class SellerPriceList {
  const SellerPriceList({
    required this.id,
    this.title = '',
    this.description,
    this.status,
    this.type,
    this.startsAt,
    this.endsAt,
    this.prices = const [],
  });

  final String id;
  final String title;
  final String? description;
  final String? status;
  final String? type;
  final String? startsAt;
  final String? endsAt;
  final List<SellerPriceListPrice> prices;

  factory SellerPriceList.fromJson(Map<String, dynamic> json) {
    final raw = json['prices'];
    return SellerPriceList(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
      prices: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(SellerPriceListPrice.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      'prices': prices.map((p) => p.toJson()).toList(),
    };
  }
}

/// Campaign budget (`spend` needs `currency_code`).
class SellerCampaignBudget {
  const SellerCampaignBudget({
    this.type,
    this.limit,
    this.currencyCode,
  });

  final String? type;
  final int? limit;
  final String? currencyCode;

  factory SellerCampaignBudget.fromJson(Map<String, dynamic> json) {
    return SellerCampaignBudget(
      type: json['type'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
      currencyCode: json['currency_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type,
      if (limit != null) 'limit': limit,
      if (currencyCode != null) 'currency_code': currencyCode,
    };
  }
}

/// A campaign (`campaign` payloads).
class SellerCampaign {
  const SellerCampaign({
    required this.id,
    this.name = '',
    this.campaignIdentifier,
    this.description,
    this.budget,
    this.startsAt,
    this.endsAt,
  });

  final String id;
  final String name;
  final String? campaignIdentifier;
  final String? description;
  final SellerCampaignBudget? budget;
  final String? startsAt;
  final String? endsAt;

  factory SellerCampaign.fromJson(Map<String, dynamic> json) {
    final raw = json['budget'];
    return SellerCampaign(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      campaignIdentifier: json['campaign_identifier'] as String?,
      description: json['description'] as String?,
      budget: raw is Map<String, dynamic>
          ? SellerCampaignBudget.fromJson(raw)
          : null,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (campaignIdentifier != null)
        'campaign_identifier': campaignIdentifier,
      if (description != null) 'description': description,
      if (budget != null) 'budget': budget!.toJson(),
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
    };
  }
}
