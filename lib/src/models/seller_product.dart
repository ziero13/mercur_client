import 'seller_catalog.dart';

/// Product image (`images` in product payloads).
class SellerProductImage {
  const SellerProductImage({this.id, this.url, this.rank});

  final String? id;
  final String? url;
  final int? rank;

  factory SellerProductImage.fromJson(Map<String, dynamic> json) {
    return SellerProductImage(
      id: json['id'] as String?,
      url: json['url'] as String?,
      rank: (json['rank'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (rank != null) 'rank': rank,
    };
  }
}

/// Product variant as exposed on the Vendor surface.
class SellerProductVariant {
  const SellerProductVariant({
    required this.id,
    this.title,
    this.sku,
    this.ean,
    this.upc,
    this.barcode,
    this.isbn,
    this.asin,
    this.gtin,
    this.thumbnail,
    this.productId,
    this.manageInventory,
    this.allowBackorder,
    this.variantRank,
    this.weight,
  });

  final String id;
  final String? title;
  final String? sku;
  final String? ean;
  final String? upc;
  final String? barcode;
  final String? isbn;
  final String? asin;
  final String? gtin;
  final String? thumbnail;
  final String? productId;
  final bool? manageInventory;
  final bool? allowBackorder;
  final int? variantRank;
  final num? weight;

  factory SellerProductVariant.fromJson(Map<String, dynamic> json) {
    return SellerProductVariant(
      id: json['id'] as String,
      title: json['title'] as String?,
      sku: json['sku'] as String?,
      ean: json['ean'] as String?,
      upc: json['upc'] as String?,
      barcode: json['barcode'] as String?,
      isbn: json['isbn'] as String?,
      asin: json['asin'] as String?,
      gtin: json['gtin'] as String?,
      thumbnail: json['thumbnail'] as String?,
      productId: json['product_id'] as String?,
      manageInventory: json['manage_inventory'] as bool?,
      allowBackorder: json['allow_backorder'] as bool?,
      variantRank: (json['variant_rank'] as num?)?.toInt(),
      weight: json['weight'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      if (sku != null) 'sku': sku,
      if (ean != null) 'ean': ean,
      if (upc != null) 'upc': upc,
      if (barcode != null) 'barcode': barcode,
      if (isbn != null) 'isbn': isbn,
      if (asin != null) 'asin': asin,
      if (gtin != null) 'gtin': gtin,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (productId != null) 'product_id': productId,
      if (manageInventory != null) 'manage_inventory': manageInventory,
      if (allowBackorder != null) 'allow_backorder': allowBackorder,
      if (variantRank != null) 'variant_rank': variantRank,
      if (weight != null) 'weight': weight,
    };
  }
}

/// Attribut calculé d'un produit (`product.attributes`, vérifié :
/// `wrapProductWithProductAttributes`).
class SellerProductAttribute {
  const SellerProductAttribute({
    required this.id,
    this.name,
    this.handle,
    this.type,
    this.isVariantAxis,
    this.isRequired,
    this.rank,
    this.isScoped,
    this.values = const [],
    this.allValues = const [],
  });

  final String id;
  final String? name;
  final String? handle;
  final String? type;
  final bool? isVariantAxis;
  final bool? isRequired;
  final int? rank;
  final bool? isScoped;
  final List<SellerAttributeValue> values;
  final List<SellerAttributeValue> allValues;

  static List<SellerAttributeValue> _valuesOf(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(SellerAttributeValue.fromJson)
        .toList();
  }

  factory SellerProductAttribute.fromJson(Map<String, dynamic> json) {
    return SellerProductAttribute(
      id: json['id'] as String,
      name: json['name'] as String?,
      handle: json['handle'] as String?,
      type: json['type'] as String?,
      isVariantAxis: json['is_variant_axis'] as bool?,
      isRequired: json['is_required'] as bool?,
      rank: (json['rank'] as num?)?.toInt(),
      isScoped: json['is_scoped'] as bool?,
      values: _valuesOf(json['values']),
      allValues: _valuesOf(json['all_values']),
    );
  }
}

/// Product as exposed on the Vendor surface (own + visible catalog).
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults.
class SellerProduct {
  const SellerProduct({
    required this.id,
    this.title = '',
    this.handle = '',
    this.status = '',
    this.subtitle,
    this.description,
    this.thumbnail,
    this.isGiftcard,
    this.discountable,
    this.typeId,
    this.collectionId,
    this.collectionTitle,
    this.weight,
    this.length,
    this.height,
    this.width,
    this.hsCode,
    this.midCode,
    this.originCountry,
    this.material,
    this.images = const [],
    this.variants = const [],
    this.categories = const [],
    this.attributes = const [],
  });

  final String id;
  final String title;
  final String handle;
  final String status;
  final String? subtitle;
  final String? description;
  final String? thumbnail;
  final bool? isGiftcard;
  final bool? discountable;
  final String? typeId;
  final String? collectionId;
  final String? collectionTitle;
  final num? weight;
  final num? length;
  final num? height;
  final num? width;
  final String? hsCode;
  final String? midCode;
  final String? originCountry;
  final String? material;
  final List<SellerProductImage> images;
  final List<SellerProductVariant> variants;

  /// `categories[]` par défaut du détail (id/name/handle).
  final List<SellerCategory> categories;

  /// `attributes[]` calculés (`enrichProductAttributes`).
  final List<SellerProductAttribute> attributes;

  factory SellerProduct.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final rawVariants = json['variants'];
    final rawCategories = json['categories'];
    final rawAttributes = json['attributes'];
    final rawCollection = json['collection'];
    return SellerProduct(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      status: json['status'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      isGiftcard: json['is_giftcard'] as bool?,
      discountable: json['discountable'] as bool?,
      typeId:
          json['type_id'] as String? ??
          (json['type'] is Map<String, dynamic>
              ? (json['type'] as Map<String, dynamic>)['id'] as String?
              : null),
      collectionId:
          json['collection_id'] as String? ??
          (rawCollection is Map<String, dynamic>
              ? rawCollection['id'] as String?
              : null),
      collectionTitle: rawCollection is Map<String, dynamic>
          ? rawCollection['title'] as String?
          : null,
      weight: json['weight'] as num?,
      length: json['length'] as num?,
      height: json['height'] as num?,
      width: json['width'] as num?,
      hsCode: json['hs_code'] as String?,
      midCode: json['mid_code'] as String?,
      originCountry: json['origin_country'] as String?,
      material: json['material'] as String?,
      images: rawImages is List
          ? rawImages
                .whereType<Map<String, dynamic>>()
                .map(SellerProductImage.fromJson)
                .toList()
          : const [],
      variants: rawVariants is List
          ? rawVariants
                .whereType<Map<String, dynamic>>()
                .where((m) => m['id'] is String)
                .map(SellerProductVariant.fromJson)
                .toList()
          : const [],
      categories: rawCategories is List
          ? rawCategories
                .whereType<Map<String, dynamic>>()
                .where((m) => m['id'] is String)
                .map(SellerCategory.fromJson)
                .toList()
          : const [],
      attributes: rawAttributes is List
          ? rawAttributes
                .whereType<Map<String, dynamic>>()
                .where((m) => m['id'] is String)
                .map(SellerProductAttribute.fromJson)
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'handle': handle,
      'status': status,
      if (subtitle != null) 'subtitle': subtitle,
      if (description != null) 'description': description,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (isGiftcard != null) 'is_giftcard': isGiftcard,
      if (discountable != null) 'discountable': discountable,
      'images': images.map((i) => i.toJson()).toList(),
      'variants': variants.map((v) => v.toJson()).toList(),
    };
  }
}

/// A staged product change request (`product_change` payloads).
class ProductChange {
  const ProductChange({required this.id, this.productId, this.status});

  final String id;
  final String? productId;
  final String? status;

  factory ProductChange.fromJson(Map<String, dynamic> json) {
    return ProductChange(
      id: json['id'] as String,
      productId: json['product_id'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (productId != null) 'product_id': productId,
      if (status != null) 'status': status,
    };
  }
}
