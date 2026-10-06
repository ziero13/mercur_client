import '../pagination_params.dart';

/// Query for `GET /store/offers` (verified against bundled docs).
///
/// Pricing context: pass `region_id` (or `country_code` / `cart_id`) plus
/// `fields: ['+calculated_price']` for per-offer prices. Requesting
/// `inventory_quantity` / `in_stock` needs a single sales channel — either
/// configured on the publishable key or via [salesChannelId].
class CustomerListOffersParams extends PaginationParams {
  const CustomerListOffersParams({
    super.limit,
    super.offset,
    super.order,
    super.q,
    super.fields,
    this.id,
    this.productId,
    this.variantId,
    this.sellerId,
    this.sku,
    this.regionId,
    this.countryCode,
    this.province,
    this.cartId,
    this.salesChannelId,
  });

  final List<String>? id;
  final List<String>? productId;
  final List<String>? variantId;
  final List<String>? sellerId;
  final List<String>? sku;
  final String? regionId;
  final String? countryCode;
  final String? province;
  final String? cartId;
  final String? salesChannelId;

  @override
  Map<String, dynamic> toQuery() {
    return {
      ...super.toQuery(),
      if (id != null && id!.isNotEmpty) 'id': id!.join(','),
      if (productId != null && productId!.isNotEmpty)
        'product_id': productId!.join(','),
      if (variantId != null && variantId!.isNotEmpty)
        'variant_id': variantId!.join(','),
      if (sellerId != null && sellerId!.isNotEmpty)
        'seller_id': sellerId!.join(','),
      if (sku != null && sku!.isNotEmpty) 'sku': sku!.join(','),
      if (regionId != null) 'region_id': regionId,
      if (countryCode != null) 'country_code': countryCode,
      if (province != null) 'province': province,
      if (cartId != null) 'cart_id': cartId,
      if (salesChannelId != null) 'sales_channel_id': salesChannelId,
    };
  }

  @override
  Map<String, dynamic> toJson() => toQuery();

  factory CustomerListOffersParams.fromJson(Map<String, dynamic> json) {
    List<String>? splitList(Object? raw) => switch (raw) {
          null => null,
          final String s => s.split(','),
          final List l => l.cast<String>(),
          _ => null,
        };
    final base = PaginationParams.fromJson(json);
    return CustomerListOffersParams(
      limit: base.limit,
      offset: base.offset,
      order: base.order,
      q: base.q,
      fields: base.fields,
      id: splitList(json['id']),
      productId: splitList(json['product_id']),
      variantId: splitList(json['variant_id']),
      sellerId: splitList(json['seller_id']),
      sku: splitList(json['sku']),
      regionId: json['region_id'] as String?,
      countryCode: json['country_code'] as String?,
      province: json['province'] as String?,
      cartId: json['cart_id'] as String?,
      salesChannelId: json['sales_channel_id'] as String?,
    );
  }
}

/// Query for `GET /store/offers/:id`.
class CustomerRetrieveOfferParams {
  const CustomerRetrieveOfferParams({
    this.fields,
    this.regionId,
    this.countryCode,
    this.province,
    this.cartId,
  });

  final List<String>? fields;
  final String? regionId;
  final String? countryCode;
  final String? province;
  final String? cartId;

  Map<String, dynamic> toQuery() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields!.join(','),
      if (regionId != null) 'region_id': regionId,
      if (countryCode != null) 'country_code': countryCode,
      if (province != null) 'province': province,
      if (cartId != null) 'cart_id': cartId,
    };
  }

  Map<String, dynamic> toJson() => toQuery();

  factory CustomerRetrieveOfferParams.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return CustomerRetrieveOfferParams(
      fields: switch (rawFields) {
        null => null,
        final String s => s.split(','),
        final List l => l.cast<String>(),
        _ => null,
      },
      regionId: json['region_id'] as String?,
      countryCode: json['country_code'] as String?,
      province: json['province'] as String?,
      cartId: json['cart_id'] as String?,
    );
  }
}
