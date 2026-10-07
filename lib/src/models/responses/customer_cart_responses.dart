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

/// Response of `DELETE /store/carts/:id/line-items/:line_id`:
/// deletion marker plus the refreshed parent [cart].
class CustomerDeleteLineItemRes {
  const CustomerDeleteLineItemRes({
    required this.id,
    required this.deleted,
    this.cart,
  });

  final String id;
  final bool deleted;
  final CustomerCart? cart;

  factory CustomerDeleteLineItemRes.fromJson(Map<String, dynamic> json) {
    final rawParent = json['parent'];
    return CustomerDeleteLineItemRes(
      id: json['id'] as String,
      deleted: json['deleted'] as bool? ?? false,
      cart: rawParent is Map<String, dynamic>
          ? CustomerCart.fromJson(rawParent)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deleted': deleted,
      if (cart != null) 'parent': cart!.toJson(),
    };
  }
}
