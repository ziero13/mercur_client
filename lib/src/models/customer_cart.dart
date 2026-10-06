import 'order_group.dart';

/// Cart line item. Mercur stamps the `offer_id` into the item `metadata`
/// at the Dio boundary — exposed here as a typed nullable field.
class CustomerCartLineItem {
  const CustomerCartLineItem({
    required this.id,
    required this.quantity,
    this.title,
    this.productTitle,
    this.unitPrice,
    this.offerId,
  });

  final String id;
  final int quantity;
  final String? title;
  final String? productTitle;
  final int? unitPrice;

  /// The offer this line was built from (`metadata.offer_id`).
  final String? offerId;

  factory CustomerCartLineItem.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'];
    return CustomerCartLineItem(
      id: json['id'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      productTitle: json['product_title'] as String?,
      unitPrice: (json['unit_price'] as num?)?.toInt(),
      offerId: metadata is Map<String, dynamic>
          ? metadata['offer_id'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      if (title != null) 'title': title,
      if (productTitle != null) 'product_title': productTitle,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (offerId != null) 'metadata': {'offer_id': offerId},
    };
  }
}

/// Store cart (`POST /store/carts`, line-items, complete).
///
/// Only `id` is required — partial `fields` selections fall back to
/// neutral defaults (see AGENTS.md).
class CustomerCart {
  const CustomerCart({
    required this.id,
    this.currencyCode,
    this.regionId,
    this.email,
    this.items = const [],
    this.total,
    this.subtotal,
    this.taxTotal,
    this.discountTotal,
    this.shippingTotal,
  });

  final String id;
  final String? currencyCode;
  final String? regionId;
  final String? email;
  final List<CustomerCartLineItem> items;
  final int? total;
  final int? subtotal;
  final int? taxTotal;
  final int? discountTotal;
  final int? shippingTotal;

  factory CustomerCart.fromJson(Map<String, dynamic> json) {
    int? toInt(Object? raw) => (raw as num?)?.toInt();
    final rawItems = json['items'];
    return CustomerCart(
      id: json['id'] as String,
      currencyCode: json['currency_code'] as String?,
      regionId: json['region_id'] as String?,
      email: json['email'] as String?,
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .where((m) => m['id'] is String)
              .map(CustomerCartLineItem.fromJson)
              .toList()
          : const [],
      total: toInt(json['total']),
      subtotal: toInt(json['subtotal']),
      taxTotal: toInt(json['tax_total']),
      discountTotal: toInt(json['discount_total']),
      shippingTotal: toInt(json['shipping_total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (regionId != null) 'region_id': regionId,
      if (email != null) 'email': email,
      'items': items.map((i) => i.toJson()).toList(),
      if (total != null) 'total': total,
      if (subtotal != null) 'subtotal': subtotal,
      if (taxTotal != null) 'tax_total': taxTotal,
      if (discountTotal != null) 'discount_total': discountTotal,
      if (shippingTotal != null) 'shipping_total': shippingTotal,
    };
  }
}

/// Payment-action error returned with `type: cart` on completion.
class CompleteCartPaymentError {
  const CompleteCartPaymentError({this.message, this.name, this.type});

  final String? message;
  final String? name;
  final String? type;

  factory CompleteCartPaymentError.fromJson(Map<String, dynamic> json) {
    return CompleteCartPaymentError(
      message: json['message'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (message != null) 'message': message,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
    };
  }
}

/// Outcome of `POST /store/carts/:id/complete`.
enum CompleteCartType {
  orderGroup,
  cart;

  static CompleteCartType fromWire(String raw) {
    return switch (raw) {
      'order_group' => CompleteCartType.orderGroup,
      _ => CompleteCartType.cart,
    };
  }

  String toWire() {
    return switch (this) {
      CompleteCartType.orderGroup => 'order_group',
      CompleteCartType.cart => 'cart',
    };
  }
}

/// Response of `POST /store/carts/:id/complete`: either the created
/// [orderGroup] (split per-seller orders) or the refreshed [cart] when
/// payment needs further customer action, plus [error] in that case.
class CustomerCompleteCartRes {
  const CustomerCompleteCartRes({
    required this.type,
    this.orderGroup,
    this.cart,
    this.error,
  });

  final CompleteCartType type;
  final OrderGroup? orderGroup;
  final CustomerCart? cart;
  final CompleteCartPaymentError? error;

  factory CustomerCompleteCartRes.fromJson(Map<String, dynamic> json) {
    final rawGroup = json['order_group'];
    final rawCart = json['cart'];
    final rawError = json['error'];
    return CustomerCompleteCartRes(
      type: CompleteCartType.fromWire(json['type'] as String? ?? 'cart'),
      orderGroup:
          rawGroup is Map<String, dynamic> ? OrderGroup.fromJson(rawGroup) : null,
      cart: rawCart is Map<String, dynamic>
          ? CustomerCart.fromJson(rawCart)
          : null,
      error: rawError is Map<String, dynamic>
          ? CompleteCartPaymentError.fromJson(rawError)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toWire(),
      if (orderGroup != null) 'order_group': orderGroup!.toJson(),
      if (cart != null) 'cart': cart!.toJson(),
      if (error != null) 'error': error!.toJson(),
    };
  }
}
