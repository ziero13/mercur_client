/// Raw offer price tier (`amount`, `currency_code`, quantity bounds).
class OfferPrice {
  const OfferPrice({
    required this.amount,
    required this.currencyCode,
    this.minQuantity,
    this.maxQuantity,
  });

  final int amount;
  final String currencyCode;
  final int? minQuantity;
  final int? maxQuantity;

  factory OfferPrice.fromJson(Map<String, dynamic> json) {
    return OfferPrice(
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      currencyCode: json['currency_code'] as String? ?? '',
      minQuantity: (json['min_quantity'] as num?)?.toInt(),
      maxQuantity: (json['max_quantity'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency_code': currencyCode,
      if (minQuantity != null) 'min_quantity': minQuantity,
      if (maxQuantity != null) 'max_quantity': maxQuantity,
    };
  }
}

/// Seller ref embedded on an offer (`id`, `name`, `handle`).
class OfferSellerRef {
  const OfferSellerRef({required this.id, this.name, this.handle});

  final String id;
  final String? name;
  final String? handle;

  factory OfferSellerRef.fromJson(Map<String, dynamic> json) {
    return OfferSellerRef(
      id: json['id'] as String,
      name: json['name'] as String?,
      handle: json['handle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (handle != null) 'handle': handle,
    };
  }
}

/// Variant ref embedded on an offer (`id`, `title`, `sku`).
class OfferVariantRef {
  const OfferVariantRef({required this.id, this.title, this.sku});

  final String id;
  final String? title;
  final String? sku;

  factory OfferVariantRef.fromJson(Map<String, dynamic> json) {
    return OfferVariantRef(
      id: json['id'] as String,
      title: json['title'] as String?,
      sku: json['sku'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      if (sku != null) 'sku': sku,
    };
  }
}

/// Shipping-profile ref embedded on an offer (`id`, `name`).
class OfferShippingProfileRef {
  const OfferShippingProfileRef({required this.id, this.name});

  final String id;
  final String? name;

  factory OfferShippingProfileRef.fromJson(Map<String, dynamic> json) {
    return OfferShippingProfileRef(
      id: json['id'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
    };
  }
}

/// Per-offer calculated price (only present when `calculated_price` is
/// requested in `fields` and a pricing context resolves).
class CalculatedPrice {
  const CalculatedPrice({
    this.calculatedAmount,
    this.calculatedAmountWithTax,
    this.calculatedAmountWithoutTax,
    this.originalAmount,
    this.originalAmountWithTax,
    this.originalAmountWithoutTax,
    this.currencyCode,
  });

  final int? calculatedAmount;
  final int? calculatedAmountWithTax;
  final int? calculatedAmountWithoutTax;
  final int? originalAmount;
  final int? originalAmountWithTax;
  final int? originalAmountWithoutTax;
  final String? currencyCode;

  factory CalculatedPrice.fromJson(Map<String, dynamic> json) {
    int? toIntOrNull(Object? raw) => (raw as num?)?.toInt();
    return CalculatedPrice(
      calculatedAmount: toIntOrNull(json['calculated_amount']),
      calculatedAmountWithTax: toIntOrNull(json['calculated_amount_with_tax']),
      calculatedAmountWithoutTax: toIntOrNull(json['calculated_amount_without_tax']),
      originalAmount: toIntOrNull(json['original_amount']),
      originalAmountWithTax: toIntOrNull(json['original_amount_with_tax']),
      originalAmountWithoutTax: toIntOrNull(json['original_amount_without_tax']),
      currencyCode: json['currency_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (calculatedAmount != null) 'calculated_amount': calculatedAmount,
      if (calculatedAmountWithTax != null)
        'calculated_amount_with_tax': calculatedAmountWithTax,
      if (calculatedAmountWithoutTax != null)
        'calculated_amount_without_tax': calculatedAmountWithoutTax,
      if (originalAmount != null) 'original_amount': originalAmount,
      if (originalAmountWithTax != null)
        'original_amount_with_tax': originalAmountWithTax,
      if (originalAmountWithoutTax != null)
        'original_amount_without_tax': originalAmountWithoutTax,
      if (currencyCode != null) 'currency_code': currencyCode,
    };
  }
}

/// Seller offer — a seller's sellable listing against a master product.
///
/// Shared entity (same `id` key on all surfaces; surface-specific computed
/// fields stay nullable). Only `id` is required in `fromJson` — partial
/// `fields` selections fall back to neutral defaults (see AGENTS.md).
class Offer {
  const Offer({
    required this.id,
    this.sellerId,
    this.variantId,
    this.productId,
    this.shippingProfileId,
    this.sku,
    this.ean,
    this.upc,
    this.seller,
    this.productVariant,
    this.shippingProfile,
    this.prices = const [],
    this.calculatedPrice,
    this.inventoryQuantity,
    this.inStock,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? sellerId;
  final String? variantId;
  final String? productId;
  final String? shippingProfileId;
  final String? sku;
  final String? ean;
  final String? upc;
  final OfferSellerRef? seller;
  final OfferVariantRef? productVariant;
  final OfferShippingProfileRef? shippingProfile;
  final List<OfferPrice> prices;
  final CalculatedPrice? calculatedPrice;
  final int? inventoryQuantity;
  final bool? inStock;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Offer.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(Object? raw) =>
        raw is String ? DateTime.tryParse(raw) : null;
    T? parseRef<T>(
      Object? raw,
      T Function(Map<String, dynamic>) parse,
    ) {
      if (raw is Map<String, dynamic> && raw['id'] is String) {
        return parse(raw);
      }
      return null;
    }

    final rawPrices = json['prices'];
    final rawCalc = json['calculated_price'];
    return Offer(
      id: json['id'] as String,
      sellerId: json['seller_id'] as String?,
      variantId: json['variant_id'] as String?,
      productId: json['product_id'] as String?,
      shippingProfileId: json['shipping_profile_id'] as String?,
      sku: json['sku'] as String?,
      ean: json['ean'] as String?,
      upc: json['upc'] as String?,
      seller: parseRef(json['seller'], OfferSellerRef.fromJson),
      productVariant: parseRef(json['product_variant'], OfferVariantRef.fromJson),
      shippingProfile:
          parseRef(json['shipping_profile'], OfferShippingProfileRef.fromJson),
      prices: rawPrices is List
          ? rawPrices
              .whereType<Map<String, dynamic>>()
              .map(OfferPrice.fromJson)
              .toList()
          : const [],
      calculatedPrice:
          rawCalc is Map<String, dynamic> ? CalculatedPrice.fromJson(rawCalc) : null,
      inventoryQuantity: (json['inventory_quantity'] as num?)?.toInt(),
      inStock: json['in_stock'] as bool?,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (sellerId != null) 'seller_id': sellerId,
      if (variantId != null) 'variant_id': variantId,
      if (productId != null) 'product_id': productId,
      if (shippingProfileId != null) 'shipping_profile_id': shippingProfileId,
      if (sku != null) 'sku': sku,
      if (ean != null) 'ean': ean,
      if (upc != null) 'upc': upc,
      if (seller != null) 'seller': seller!.toJson(),
      if (productVariant != null) 'product_variant': productVariant!.toJson(),
      if (shippingProfile != null)
        'shipping_profile': shippingProfile!.toJson(),
      'prices': prices.map((p) => p.toJson()).toList(),
      if (calculatedPrice != null)
        'calculated_price': calculatedPrice!.toJson(),
      if (inventoryQuantity != null)
        'inventory_quantity': inventoryQuantity,
      if (inStock != null) 'in_stock': inStock,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
