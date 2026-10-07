/// Body of `POST /vendor/payments/:id/capture`.
class SellerCapturePaymentReq {
  const SellerCapturePaymentReq({this.amount});

  final int? amount;

  Map<String, dynamic> toJson() {
    return {if (amount != null) 'amount': amount};
  }
}

/// Body of `POST /vendor/payments/:id/refund`.
class SellerRefundPaymentReq {
  const SellerRefundPaymentReq({this.amount, this.reason});

  final int? amount;
  final String? reason;

  Map<String, dynamic> toJson() {
    return {
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
    };
  }
}

/// Body of `POST /vendor/payout-accounts` (provider-specific).
class SellerCreatePayoutAccountReq {
  const SellerCreatePayoutAccountReq({this.data, this.context});

  final Map<String, dynamic>? data;
  final Map<String, dynamic>? context;

  Map<String, dynamic> toJson() {
    return {
      if (data != null) 'data': data,
      if (context != null) 'context': context,
    };
  }
}
