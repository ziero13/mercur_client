/// Body of `POST /store/shipping-options/:id/calculate`.
class CustomerCalculateShippingOptionReq {
  const CustomerCalculateShippingOptionReq({required this.cartId});

  final String cartId;

  Map<String, dynamic> toJson() => {'cart_id': cartId};

  factory CustomerCalculateShippingOptionReq.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerCalculateShippingOptionReq(
      cartId: json['cart_id'] as String,
    );
  }
}
