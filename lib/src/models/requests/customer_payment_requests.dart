/// Body of `POST /store/payment-collections` (create-or-return for a cart).
class CustomerCreatePaymentCollectionReq {
  const CustomerCreatePaymentCollectionReq({required this.cartId});

  final String cartId;

  Map<String, dynamic> toJson() => {'cart_id': cartId};

  factory CustomerCreatePaymentCollectionReq.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerCreatePaymentCollectionReq(
      cartId: json['cart_id'] as String,
    );
  }
}

/// Body of `POST /store/payment-collections/:id/payment-sessions`.
class CustomerCreatePaymentSessionReq {
  const CustomerCreatePaymentSessionReq({required this.providerId, this.data});

  final String providerId;
  final Map<String, dynamic>? data;

  Map<String, dynamic> toJson() {
    return {
      'provider_id': providerId,
      if (data != null) 'data': data,
    };
  }

  factory CustomerCreatePaymentSessionReq.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerCreatePaymentSessionReq(
      providerId: json['provider_id'] as String,
      data: json['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['data'] as Map)
          : null,
    );
  }
}
