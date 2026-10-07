import '../seller_pricing.dart';

/// One price entry in price-list create/batch bodies.
class SellerPriceListPriceReq {
  const SellerPriceListPriceReq({
    this.id,
    this.currencyCode,
    this.amount,
    this.variantId,
    this.minQuantity,
    this.maxQuantity,
    this.rules,
  });

  final String? id;
  final String? currencyCode;
  final int? amount;
  final String? variantId;
  final int? minQuantity;
  final int? maxQuantity;
  final Map<String, String>? rules;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (amount != null) 'amount': amount,
      if (variantId != null) 'variant_id': variantId,
      if (minQuantity != null) 'min_quantity': minQuantity,
      if (maxQuantity != null) 'max_quantity': maxQuantity,
      if (rules != null) 'rules': rules,
    };
  }
}

/// Body of `POST /vendor/price-lists`.
class SellerCreatePriceListReq {
  const SellerCreatePriceListReq({
    required this.title,
    required this.description,
    this.startsAt,
    this.endsAt,
    this.status,
    this.type,
    this.prices = const [],
  });

  final String title;
  final String description;
  final String? startsAt;
  final String? endsAt;
  final String? status;
  final String? type;
  final List<SellerPriceListPriceReq> prices;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (prices.isNotEmpty)
        'prices': prices.map((p) => p.toJson()).toList(),
    };
  }
}

/// Body of `POST /vendor/price-lists/:id`.
class SellerUpdatePriceListReq {
  const SellerUpdatePriceListReq({
    this.title,
    this.description,
    this.startsAt,
    this.endsAt,
    this.status,
    this.type,
  });

  final String? title;
  final String? description;
  final String? startsAt;
  final String? endsAt;
  final String? status;
  final String? type;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
    };
  }
}

/// Body of `POST /vendor/price-lists/:id/prices/batch`.
class SellerPriceBatchReq {
  const SellerPriceBatchReq({
    this.create = const [],
    this.update = const [],
    this.delete = const [],
  });

  final List<SellerPriceListPriceReq> create;
  final List<SellerPriceListPriceReq> update;
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

/// Body of `POST /vendor/price-lists/:id/products` (removes the
/// products' prices from the list).
class SellerPriceListProductsReq {
  const SellerPriceListProductsReq({this.remove = const []});

  final List<String> remove;

  Map<String, dynamic> toJson() => {'remove': remove};
}

/// Body of `POST /vendor/campaigns`.
class SellerCreateCampaignReq {
  const SellerCreateCampaignReq({
    required this.name,
    required this.campaignIdentifier,
    this.description,
    this.budget,
    this.startsAt,
    this.endsAt,
  });

  final String name;
  final String campaignIdentifier;
  final String? description;
  final SellerCampaignBudget? budget;
  final String? startsAt;
  final String? endsAt;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'campaign_identifier': campaignIdentifier,
      if (description != null) 'description': description,
      if (budget != null) 'budget': budget!.toJson(),
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
    };
  }
}

/// Body of `POST /vendor/campaigns/:id`.
class SellerUpdateCampaignReq {
  const SellerUpdateCampaignReq({
    this.name,
    this.campaignIdentifier,
    this.description,
    this.budget,
    this.startsAt,
    this.endsAt,
  });

  final String? name;
  final String? campaignIdentifier;
  final String? description;
  final SellerCampaignBudget? budget;
  final String? startsAt;
  final String? endsAt;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (campaignIdentifier != null)
        'campaign_identifier': campaignIdentifier,
      if (description != null) 'description': description,
      if (budget != null) 'budget': budget!.toJson(),
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
    };
  }
}

/// Body of `POST /vendor/campaigns/:id/promotions`.
class SellerCampaignPromotionsReq {
  const SellerCampaignPromotionsReq({
    this.add = const [],
    this.remove = const [],
  });

  final List<String> add;
  final List<String> remove;

  Map<String, dynamic> toJson() => {'add': add, 'remove': remove};
}
