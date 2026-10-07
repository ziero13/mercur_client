/// Payment as exposed on the Vendor surface (Medusa standard shape).
class SellerPayment {
  const SellerPayment({
    required this.id,
    this.amount,
    this.currencyCode,
    this.providerId,
    this.paymentCollectionId,
    this.capturedAt,
    this.canceledAt,
    this.createdAt,
  });

  final String id;
  final int? amount;
  final String? currencyCode;
  final String? providerId;
  final String? paymentCollectionId;
  final String? capturedAt;
  final String? canceledAt;
  final String? createdAt;

  factory SellerPayment.fromJson(Map<String, dynamic> json) {
    return SellerPayment(
      id: json['id'] as String,
      amount: (json['amount'] as num?)?.toInt(),
      currencyCode: json['currency_code'] as String?,
      providerId: json['provider_id'] as String?,
      paymentCollectionId: json['payment_collection_id'] as String?,
      capturedAt: json['captured_at'] as String?,
      canceledAt: json['canceled_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (providerId != null) 'provider_id': providerId,
      if (paymentCollectionId != null)
        'payment_collection_id': paymentCollectionId,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (canceledAt != null) 'canceled_at': canceledAt,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}

/// Payment provider ref (`payment-providers` list).
class SellerPaymentProvider {
  const SellerPaymentProvider({required this.id, this.isEnabled});

  final String id;
  final bool? isEnabled;

  factory SellerPaymentProvider.fromJson(Map<String, dynamic> json) {
    return SellerPaymentProvider(
      id: json['id'] as String,
      isEnabled: json['is_enabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (isEnabled != null) 'is_enabled': isEnabled,
    };
  }
}

/// Payout to a seller.
class SellerPayout {
  const SellerPayout({
    required this.id,
    this.displayId,
    this.amount,
    this.currencyCode,
    this.status = '',
  });

  final String id;
  final int? displayId;
  final int? amount;
  final String? currencyCode;
  final String status;

  factory SellerPayout.fromJson(Map<String, dynamic> json) {
    return SellerPayout(
      id: json['id'] as String,
      displayId: (json['display_id'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
      currencyCode: json['currency_code'] as String?,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (displayId != null) 'display_id': displayId,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      'status': status,
    };
  }
}

/// Seller payout account with its provider onboarding record.
class SellerPayoutAccount {
  const SellerPayoutAccount({required this.id, this.status = ''});

  final String id;
  final String status;

  factory SellerPayoutAccount.fromJson(Map<String, dynamic> json) {
    return SellerPayoutAccount(
      id: json['id'] as String,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'status': status};
}

/// Provider onboarding record (`{onboarding}` envelope).
class SellerOnboarding {
  const SellerOnboarding({required this.id, this.data});

  final String id;
  final Map<String, dynamic>? data;

  factory SellerOnboarding.fromJson(Map<String, dynamic> json) {
    return SellerOnboarding(
      id: json['id'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (data != null) 'data': data,
    };
  }
}
