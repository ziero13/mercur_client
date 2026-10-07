import '../customer_payment.dart';

/// Response of both `POST /store/payment-collections` and
/// `POST /store/payment-collections/:id/payment-sessions`.
class CustomerPaymentCollectionRes {
  const CustomerPaymentCollectionRes({required this.paymentCollection});

  final CustomerPaymentCollection paymentCollection;

  factory CustomerPaymentCollectionRes.fromJson(Map<String, dynamic> json) {
    return CustomerPaymentCollectionRes(
      paymentCollection: CustomerPaymentCollection.fromJson(
        json['payment_collection'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'payment_collection': paymentCollection.toJson(),
  };
}
