import '../customer_cart.dart';

/// Response wrapping a cart (`create`, `addLineItem`).
class CustomerCartRes {
  const CustomerCartRes({required this.cart});

  final CustomerCart cart;

  factory CustomerCartRes.fromJson(Map<String, dynamic> json) {
    return CustomerCartRes(
      cart: CustomerCart.fromJson(json['cart'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'cart': cart.toJson()};
}
