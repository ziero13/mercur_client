import 'seller_details.dart';

/// Order line item (vendor view; variant/product/offer refs by id).
class SellerOrderItem {
  const SellerOrderItem({
    required this.id,
    this.title,
    this.quantity,
    this.variantId,
    this.productId,
    this.unitPrice,
    this.subtotal,
  });

  final String id;
  final String? title;
  final int? quantity;
  final String? variantId;
  final String? productId;
  final int? unitPrice;
  final int? subtotal;

  factory SellerOrderItem.fromJson(Map<String, dynamic> json) {
    return SellerOrderItem(
      id: json['id'] as String,
      title: json['title'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      variantId: json['variant_id'] as String?,
      productId: json['product_id'] as String?,
      unitPrice: (json['unit_price'] as num?)?.toInt(),
      subtotal: (json['subtotal'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      if (quantity != null) 'quantity': quantity,
      if (variantId != null) 'variant_id': variantId,
      if (productId != null) 'product_id': productId,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (subtotal != null) 'subtotal': subtotal,
    };
  }
}

/// Order totals summary (all totals nullable — shape varies by fields).
class SellerOrderSummary {
  const SellerOrderSummary({
    this.subtotal,
    this.shippingSubtotal,
    this.taxTotal,
    this.discountTotal,
    this.total,
    this.paidTotal,
  });

  final int? subtotal;
  final int? shippingSubtotal;
  final int? taxTotal;
  final int? discountTotal;
  final int? total;
  final int? paidTotal;

  factory SellerOrderSummary.fromJson(Map<String, dynamic> json) {
    int? n(Object? v) => (v as num?)?.toInt();
    return SellerOrderSummary(
      subtotal: n(json['subtotal']),
      shippingSubtotal: n(json['shipping_subtotal']),
      taxTotal: n(json['tax_total']),
      discountTotal: n(json['discount_total']),
      total: n(json['total']),
      paidTotal: n(json['paid_total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (subtotal != null) 'subtotal': subtotal,
      if (shippingSubtotal != null) 'shipping_subtotal': shippingSubtotal,
      if (taxTotal != null) 'tax_total': taxTotal,
      if (discountTotal != null) 'discount_total': discountTotal,
      if (total != null) 'total': total,
      if (paidTotal != null) 'paid_total': paidTotal,
    };
  }
}

/// Order as exposed on the Vendor surface.
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults. No orders exist in the dev seed yet, so detail
/// shapes follow the bundled docs and will be re-probed live on the
/// first real order.
class SellerOrder {
  const SellerOrder({
    required this.id,
    this.displayId,
    this.status = '',
    this.email,
    this.currencyCode,
    this.regionId,
    this.customerId,
    this.salesChannelId,
    this.items = const [],
    this.shippingAddress,
    this.billingAddress,
    this.summary,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.canceledAt,
  });

  final String id;
  final int? displayId;
  final String status;
  final String? email;
  final String? currencyCode;
  final String? regionId;
  final String? customerId;
  final String? salesChannelId;
  final List<SellerOrderItem> items;
  final SellerAddress? shippingAddress;
  final SellerAddress? billingAddress;
  final SellerOrderSummary? summary;
  final Map<String, dynamic>? metadata;
  final String? createdAt;
  final String? updatedAt;
  final String? canceledAt;

  factory SellerOrder.fromJson(Map<String, dynamic> json) {
    SellerAddress? addr(Object? raw) =>
        raw is Map<String, dynamic> ? SellerAddress.fromJson(raw) : null;
    final rawItems = json['items'];
    return SellerOrder(
      id: json['id'] as String,
      displayId: (json['display_id'] as num?)?.toInt(),
      status: json['status'] as String? ?? '',
      email: json['email'] as String?,
      currencyCode: json['currency_code'] as String?,
      regionId: json['region_id'] as String?,
      customerId: json['customer_id'] as String?,
      salesChannelId: json['sales_channel_id'] as String?,
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(SellerOrderItem.fromJson)
              .toList()
          : const [],
      shippingAddress: addr(json['shipping_address']),
      billingAddress: addr(json['billing_address']),
      summary: json['summary'] is Map<String, dynamic>
          ? SellerOrderSummary.fromJson(
              json['summary'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      canceledAt: json['canceled_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (displayId != null) 'display_id': displayId,
      'status': status,
      if (email != null) 'email': email,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (regionId != null) 'region_id': regionId,
      if (customerId != null) 'customer_id': customerId,
      if (salesChannelId != null) 'sales_channel_id': salesChannelId,
      'items': items.map((i) => i.toJson()).toList(),
      if (shippingAddress != null)
        'shipping_address': shippingAddress!.toJson(),
      if (billingAddress != null) 'billing_address': billingAddress!.toJson(),
      if (summary != null) 'summary': summary!.toJson(),
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (canceledAt != null) 'canceled_at': canceledAt,
    };
  }
}

/// Fulfillment on a vendor order.
class SellerFulfillment {
  const SellerFulfillment({
    required this.id,
    this.locationId,
    this.requiresShipping,
    this.packedAt,
    this.shippedAt,
    this.deliveredAt,
    this.canceledAt,
  });

  final String id;
  final String? locationId;
  final bool? requiresShipping;
  final String? packedAt;
  final String? shippedAt;
  final String? deliveredAt;
  final String? canceledAt;

  factory SellerFulfillment.fromJson(Map<String, dynamic> json) {
    return SellerFulfillment(
      id: json['id'] as String,
      locationId: json['location_id'] as String?,
      requiresShipping: json['requires_shipping'] as bool?,
      packedAt: json['packed_at'] as String?,
      shippedAt: json['shipped_at'] as String?,
      deliveredAt: json['delivered_at'] as String?,
      canceledAt: json['canceled_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (locationId != null) 'location_id': locationId,
      if (requiresShipping != null) 'requires_shipping': requiresShipping,
      if (packedAt != null) 'packed_at': packedAt,
      if (shippedAt != null) 'shipped_at': shippedAt,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (canceledAt != null) 'canceled_at': canceledAt,
    };
  }
}

/// Commission line charged on a vendor order.
class SellerCommissionLine {
  const SellerCommissionLine({
    required this.id,
    this.itemId,
    this.shippingMethodId,
    this.commissionRateId,
    this.code,
    this.rate,
    this.amount,
    this.description,
  });

  final String id;
  final String? itemId;
  final String? shippingMethodId;
  final String? commissionRateId;
  final String? code;
  final double? rate;
  final int? amount;
  final String? description;

  factory SellerCommissionLine.fromJson(Map<String, dynamic> json) {
    return SellerCommissionLine(
      id: json['id'] as String,
      itemId: json['item_id'] as String?,
      shippingMethodId: json['shipping_method_id'] as String?,
      commissionRateId: json['commission_rate_id'] as String?,
      code: json['code'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toInt(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (itemId != null) 'item_id': itemId,
      if (shippingMethodId != null) 'shipping_method_id': shippingMethodId,
      if (commissionRateId != null) 'commission_rate_id': commissionRateId,
      if (code != null) 'code': code,
      if (rate != null) 'rate': rate,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
    };
  }
}

/// Order change record (edit/return/exchange/claim history).
class SellerOrderChange {
  const SellerOrderChange({
    required this.id,
    this.orderId,
    this.version,
    this.changeType,
    this.status,
  });

  final String id;
  final String? orderId;
  final int? version;
  final String? changeType;
  final String? status;

  factory SellerOrderChange.fromJson(Map<String, dynamic> json) {
    return SellerOrderChange(
      id: json['id'] as String,
      orderId: json['order_id'] as String?,
      version: (json['version'] as num?)?.toInt(),
      changeType: json['change_type'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (orderId != null) 'order_id': orderId,
      if (version != null) 'version': version,
      if (changeType != null) 'change_type': changeType,
      if (status != null) 'status': status,
    };
  }
}
