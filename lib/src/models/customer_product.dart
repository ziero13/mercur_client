/// Minimal product variant as returned on the Store surface.
///
/// Pricing context (`calculated_price`, cheapest offer per variant) is only
/// computed when `variants.calculated_price` is requested in `fields` (or a
/// `region_id` is passed) — tranche 2 will add the typed price model.
class CustomerProductVariant {
  const CustomerProductVariant({
    required this.id,
    this.title,
    this.sku,
    this.thumbnail,
  });

  final String id;
  final String? title;
  final String? sku;
  final String? thumbnail;

  factory CustomerProductVariant.fromJson(Map<String, dynamic> json) {
    return CustomerProductVariant(
      id: json['id'] as String,
      title: json['title'] as String?,
      sku: json['sku'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      if (sku != null) 'sku': sku,
      if (thumbnail != null) 'thumbnail': thumbnail,
    };
  }
}

/// Published product from an open, visible seller (`GET /store/products`).
///
/// Always `published` on the Store API. Relations (collection, type, tags,
/// images, options, attributes) arrive only when requested via `fields`;
/// tranche 1 keeps the scalar core + variants.
class CustomerProduct {
  const CustomerProduct({
    required this.id,
    required this.title,
    required this.handle,
    required this.status,
    this.subtitle,
    this.description,
    this.isGiftcard,
    this.discountable,
    this.thumbnail,
    this.variants = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String handle;
  final String status;
  final String? subtitle;
  final String? description;
  final bool? isGiftcard;
  final bool? discountable;
  final String? thumbnail;
  final List<CustomerProductVariant> variants;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Note: the Store API supports `fields` replace mode, so a response may
  /// omit modelled fields. Only `id` is required; missing display fields
  /// fall back to neutral defaults rather than throwing.
  factory CustomerProduct.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(Object? raw) =>
        raw is String ? DateTime.tryParse(raw) : null;
    final rawVariants = json['variants'];
    return CustomerProduct(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      status: json['status'] as String? ?? 'published',
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      isGiftcard: json['is_giftcard'] as bool?,
      discountable: json['discountable'] as bool?,
      thumbnail: json['thumbnail'] as String?,
      variants: rawVariants is List
          ? rawVariants
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerProductVariant.fromJson)
              .toList()
          : const [],
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
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
      if (isGiftcard != null) 'is_giftcard': isGiftcard,
      if (discountable != null) 'discountable': discountable,
      if (thumbnail != null) 'thumbnail': thumbnail,
      'variants': variants.map((v) => v.toJson()).toList(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
