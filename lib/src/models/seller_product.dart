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
    this.thumbnail,
    this.productId,
    this.manageInventory,
    this.allowBackorder,
    this.variantRank,
  });

  final String id;
  final String? title;
  final String? sku;
  final String? ean;
  final String? upc;
  final String? barcode;
  final String? thumbnail;
  final String? productId;
  final bool? manageInventory;
  final bool? allowBackorder;
  final int? variantRank;

  factory SellerProductVariant.fromJson(Map<String, dynamic> json) {
    return SellerProductVariant(
      id: json['id'] as String,
      title: json['title'] as String?,
      sku: json['sku'] as String?,
      ean: json['ean'] as String?,
      upc: json['upc'] as String?,
      barcode: json['barcode'] as String?,
      thumbnail: json['thumbnail'] as String?,
      productId: json['product_id'] as String?,
      manageInventory: json['manage_inventory'] as bool?,
      allowBackorder: json['allow_backorder'] as bool?,
      variantRank: (json['variant_rank'] as num?)?.toInt(),
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
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (productId != null) 'product_id': productId,
      if (manageInventory != null) 'manage_inventory': manageInventory,
      if (allowBackorder != null) 'allow_backorder': allowBackorder,
      if (variantRank != null) 'variant_rank': variantRank,
    };
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
    this.images = const [],
    this.variants = const [],
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
  final List<SellerProductImage> images;
  final List<SellerProductVariant> variants;

  factory SellerProduct.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final rawVariants = json['variants'];
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
